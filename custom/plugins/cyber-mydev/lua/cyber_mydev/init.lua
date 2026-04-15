local M = {}

M.opts = {}

local NOTIFY_TITLE = "cyber-mydev"

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = NOTIFY_TITLE })
end

local function shell_join(cmd)
  local escaped = {}
  for _, arg in ipairs(cmd) do
    table.insert(escaped, vim.fn.shellescape(arg))
  end
  return table.concat(escaped, " ")
end

local function resolve_command(current_conf)
  local command = M.opts.command
  if type(command) == "function" then
    command = command(current_conf)
  end

  if command == nil then
    local cctlx_bin = vim.fn.exepath "cctlx"
    if cctlx_bin == "" then
      cctlx_bin = vim.fn.expand "~/projects/skills_sz/cctlx"
    end
    command = { cctlx_bin, "mydev", "--json" }
  end

  return command
end

local function run_command(command)
  if type(command) == "string" then
    local stdout = vim.fn.system(command)
    if vim.v.shell_error ~= 0 then
      error(stdout ~= "" and stdout or ("Command failed: " .. command))
    end
    return stdout
  end

  if type(command) ~= "table" or #command == 0 then
    error("cyber-mydev expects `command` to be a shell string or argv-style list")
  end

  if vim.fn.executable(command[1]) == 0 then
    error("Command is not executable: " .. command[1])
  end

  if vim.system then
    local result = vim.system(command, { text = true }):wait()
    if result.code ~= 0 then
      local stderr = (result.stderr or ""):gsub("%s+$", "")
      local stdout = (result.stdout or ""):gsub("%s+$", "")
      error(stderr ~= "" and stderr or stdout ~= "" and stdout or ("Command failed: " .. shell_join(command)))
    end
    return result.stdout
  end

  local stdout = vim.fn.system(shell_join(command))
  if vim.v.shell_error ~= 0 then
    error(stdout ~= "" and stdout or ("Command failed: " .. shell_join(command)))
  end
  return stdout
end

local function load_project_conf()
  local ok, conf_or_err = pcall(require("arsync.conf").load_conf)
  if not ok then
    error(conf_or_err)
  end
  if not conf_or_err then
    error("Could not locate a `.arsync` configuration file in the current project.")
  end
  return conf_or_err
end

local function fetch_devspaces(current_conf)
  local command = resolve_command(current_conf)
  local stdout = run_command(command)
  local ok, payload = pcall(vim.json.decode, stdout)
  if not ok then
    error("Failed to parse `cctlx mydev --json` output: " .. payload)
  end

  local items = payload.devspaces or payload.tasks or {}
  if type(items) ~= "table" then
    error("Unexpected payload from `cctlx mydev --json`: missing `devspaces` list")
  end

  return items
end

local function build_entries(current_conf)
  local conf_manager = require "arsync.conf"
  local execute_host = conf_manager.get_remote_execute_host(current_conf)
  local devspaces = fetch_devspaces(current_conf)
  local entries = {}

  if current_conf.remote_host and current_conf.remote_host ~= "unknown" then
    table.insert(entries, {
      id = "sync",
      project = "(sync host)",
      cluster = "-",
      gpu = "-",
      create_time = "-",
      ssh_endpoint = current_conf.remote_host,
      ssh_command = "ssh " .. current_conf.remote_host,
      description = "Use the sync host as the terminal target",
      _is_reset = true,
      _current = execute_host == current_conf.remote_host,
    })
  end

  for _, item in ipairs(devspaces) do
    item.ssh_endpoint = item.ssh_endpoint .. ".cyber"
    item._current = item.ssh_endpoint == execute_host
    table.insert(entries, item)
  end

  table.sort(entries, function(a, b)
    if a._current ~= b._current then
      return a._current
    end
    if a._is_reset ~= b._is_reset then
      return a._is_reset
    end
    return tostring(a.id or "") > tostring(b.id or "")
  end)

  return entries
end

local function apply_entry(entry, current_conf)
  local conf_manager = require "arsync.conf"
  local old_host = conf_manager.get_remote_execute_host(current_conf)
  local new_host = entry.ssh_endpoint

  conf_manager.update_project_conf {
    local_path = current_conf.local_path,
    remote_execute_host = new_host,
  }

  notify(
    string.format("remote_execute_host: %s -> %s", old_host or "nil", new_host),
    vim.log.levels.INFO
  )
end

local function truncate(text, width)
  text = tostring(text or "-")
  if #text <= width then
    return text
  end
  if width <= 3 then
    return text:sub(1, width)
  end
  return text:sub(1, width - 3) .. "..."
end

local function pad(text, width)
  return string.format("%-" .. width .. "s", truncate(text, width))
end

local function entry_preview(entry, current_conf)
  local lines = {
    "Sync host: " .. (current_conf.remote_host or "-"),
    "Current execute host: " .. (require("arsync.conf").get_remote_execute_host(current_conf) or "-"),
    "Selected execute host: " .. (entry.ssh_endpoint or "-"),
    "",
    "Project: " .. (entry.project or "-"),
    "Cluster: " .. (entry.cluster or "-"),
    "GPU: " .. (entry.gpu or "-"),
    "Created: " .. (entry.create_time or "-"),
    "SSH command: " .. (entry.ssh_command or ("tsh ssh " .. (entry.ssh_endpoint or "-"))),
  }
  if entry.description then
    table.insert(lines, 5, "Mode: " .. entry.description)
  end
  return table.concat(lines, "\n")
end

local function picker_item(entry, current_conf)
  return {
    text = table.concat({
      tostring(entry.id or "-"),
      entry.project or "-",
      entry.gpu or "-",
      entry.cluster or "-",
      entry.ssh_endpoint or "-",
      entry.description or "",
    }, " "),
    item = entry,
    preview = {
      text = entry_preview(entry, current_conf),
      ft = "markdown",
      loc = false,
    },
  }
end

local function format_item(item)
  local entry = item.item or item
  local marker_hl = entry._current and "DiagnosticOk" or "Comment"
  local project_hl = entry._is_reset and "Special" or nil
  return {
    { entry._current and "* " or "  ", marker_hl },
    { pad(entry.id or "-", 8), "Number" },
    { " " },
    { pad(entry.project or "-", 18), project_hl },
    { " " },
    { pad(entry.gpu or "-", 12), "Type" },
    { " " },
    { pad(entry.cluster or "-", 16), "Directory" },
    { " " },
    { entry.ssh_endpoint or "-", "Identifier" },
  }
end

function M.devspaces(opts)
  opts = opts or {}

  local ok, current_conf_or_err = pcall(load_project_conf)
  if not ok then
    notify(current_conf_or_err, vim.log.levels.ERROR)
    return
  end
  local current_conf = current_conf_or_err

  local ok_entries, entries_or_err = pcall(build_entries, current_conf)
  if not ok_entries then
    notify(entries_or_err, vim.log.levels.ERROR)
    return
  end

  local entries = entries_or_err
  if vim.tbl_isempty(entries) then
    notify("No running devspaces found for the current account.", vim.log.levels.INFO)
    return
  end

  local items = vim.tbl_map(function(entry)
    return picker_item(entry, current_conf)
  end, entries)

  Snacks.picker(vim.tbl_deep_extend("force", {
    title = "Cyber MyDev",
    items = items,
    finder = function()
      return items
    end,
    format = format_item,
    preview = "preview",
    pattern = opts.pattern,
    layout = {
      layout = {
        backdrop = false,
        width = 0.88,
        min_width = 90,
        height = 0.65,
        border = "rounded",
        box = "vertical",
        title = "{title}",
        title_pos = "center",
        { win = "input", height = 1, border = "bottom" },
        { win = "list", border = "none" },
        { win = "preview", title = "{preview}", height = 0.45, border = "top" },
      },
    },
    confirm = function(picker, item)
      picker:close()
      if item and item.item then
        vim.schedule(function()
          apply_entry(item.item, current_conf)
        end)
      end
    end,
  }, M.opts.picker or {}, opts.picker or {}))
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  vim.api.nvim_create_user_command("CyberMydev", function(command_opts)
    M.devspaces { pattern = command_opts.args ~= "" and command_opts.args or nil }
  end, {
    nargs = "?",
    desc = "Pick a devspace and update arsync remote_execute_host",
  })
end

return M
