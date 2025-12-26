local capture_config_augroup = vim.api.nvim_create_augroup("CaptureFileConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = capture_config_augroup,
  pattern = "capture",
  callback = function()
    vim.keymap.set("n", "i", function()
      vim.cmd "bd!"
      require("nvchad.term").toggle {
        pos = "vsp",
        id = "remote-terminal",
        size = 0.5,
        cmd = remote_command,
      }
    end, { buffer = true, desc = "返回终端并关闭 capture" })
  end,
})

map({ "t" }, "<C-k>", function()
  local remote_conf = require("arsync.conf").load_conf()
  if remote_conf then
    local log_file_path = vim.fn.stdpath "data" .. "/arsync/remote_term_" .. remote_conf.remote_host .. "_capture.log"
    local socket_path = vim.fn.stdpath "data" .. "/arsync/remote_term_" .. remote_conf.remote_host
    local capture_cmd = "ssh " .. remote_conf.remote_host .. " -o ControlPath=" .. socket_path
    capture_cmd = capture_cmd .. ' "tmux capture-pane -Jp -S - -E - -t nvim"'
    capture_cmd = capture_cmd .. " > " .. log_file_path
    vim.fn.system(capture_cmd)
    vim.cmd("edit " .. log_file_path)
    vim.bo.filetype = "capture"
  end
end, { desc = "Capture remote terminal output" })

function parse_filepath_and_lineno(line)
  local patterns = {}
  patterns[1] = 'File "(.-)", line (%d+)'
  patterns[2] = ">?([^%(]+)%((%d+)%)"
  local filepath, lineno
  for _, pattern in ipairs(patterns) do
    filepath, lineno = line:match(pattern)
    if filepath and lineno then
      lineno = tonumber(lineno)
      break
    end
  end
  return filepath, lineno
end
function is_in_nvterm()
  local buf_type = vim.bo[vim.api.nvim_get_current_buf()].filetype
  return string.find(buf_type, "NvTerm")
end
map({ "n", "t" }, "<C-f>", function()
  local ar_conf = require("arsync.conf").load_conf()
  local cur_buf = vim.api.nvim_get_current_buf()
  local curr_row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, curr_row - 2, curr_row, false)
  local target_line
  if is_in_nvterm() and ar_conf and ar_conf.auto_sync_up ~= 0 and ar_conf.remote_host ~= "unknown" then
    for _, line in ipairs(lines) do
      -- 去除行首空格后检查是否以 "File" 开头
      local trimmed = line:gsub("^%s+", "")
      if trimmed:find "^File" or trimmed:match ">?([^%(]+)%((%d+)%)" then
        target_line = line
        break
      end
    end
    local win2 = vim.api.nvim_get_current_win()

    -- 2. 找到上方的窗口 (窗口 1)
    -- 'k' 代表向上寻找。winnr('k') 返回上方窗口的编号
    local win1_id
    if vim.t.remote_buf_id and vim.api.nvim_win_is_valid(vim.t.remote_buf_id) then
      win1_id = vim.t.remote_buf_id
    else
      local win1_nr = vim.fn.winnr "k"
      win1_id = vim.fn.win_getid(win1_nr)
    end

    file_path, line_no = parse_filepath_and_lineno(target_line)
    file_path = file_path:gsub(ar_conf.remote_path, ar_conf.local_path)
    if win1_id ~= win2 then
      local cmd
      if vim.t.remote_buf_id ~= nil then
        cmd = "edit +" .. line_no .. " " .. file_path
      else
        cmd = "rightbelow vsplit +" .. line_no .. " " .. file_path
      end
      vim.api.nvim_set_current_win(win1_id)
      vim.cmd(cmd)
      vim.cmd "normal! zz"
      vim.t.remote_buf_id = vim.api.nvim_get_current_win()
    else
      vim.cmd("vsplit +" .. ":" .. line_no .. " " .. file_path)
      vim.cmd "normal zz"
    end
  else
    vim.cmd "normal! gf"
  end
end, { desc = "Open remote file" })

local function opts_to_id(id)
  for _, opts in pairs(g.nvchad_terms) do
    if opts.id == id then
      return opts
    end
  end
end

local function opts_to_id(id)
  for _, opts in pairs(g.nvchad_terms) do
    if opts.id == id then
      return opts
    end
  end
end

local function close_other_terms(term_id)
  if term_id then
    for _, opts in pairs(vim.g.nvchad_terms or {}) do
      if opts.id ~= term_id and vim.fn.bufwinid(opts.buf) ~= -1 then
        vim.api.nvim_win_close(opts.win, true)
      end
    end
  end
end

function toggle_terminal(opts)
  local ar_conf = require("arsync.conf").load_conf()
  if ar_conf and ar_conf.auto_sync_up ~= 0 and not opts.local_term then
    local session_name = vim.fn.fnamemodify(ar_conf.local_path, ":t")
    local socket_path = vim.fn.stdpath "data" .. "/arsync/remote_term" .. ar_conf.remote_host
    local remote_command = "ssh -t " .. ar_conf.remote_host .. " -o ControlPath=" .. socket_path
    local remote_command = remote_command .. " -o ControlMaster=auto -o ControlPersist=10m "
    local tmux_options = {}
    tmux_options["status"] = "off"
    tmux_options["prefix"] = "C-a"
    tmux_command = ""
    for key, value in pairs(tmux_options) do
      local opt = string.format("set-option -t %s %s %s ';' ", session_name, key, value)
      tmux_command = tmux_command .. opt
    end
    local tmux_command = string.format(
      "tmux %s a -t %s || tmux new -s %s -c %s ';' %s",
      tmux_command,
      session_name,
      session_name,
      ar_conf.remote_path,
      tmux_command
    )
    remote_command = remote_command .. string.format(' "%s" ', tmux_command)
    local term_id = opts.id or "remote-terminal"
    close_other_terms(term_id)
    require("nvchad.term").toggle {
      pos = opts.pos or "sp",
      id = term_id,
      size = opts.size or 0.4,
      cmd = remote_command,
      float_opts = opts.float_opts or {},
    }
    vim.g.remote_term_enable = true
  else
    local term_id = opts.id or "apple-toggleTerm"
    close_other_terms(term_id)
    require("nvchad.term").toggle {
      pos = opts.pos or "sp",
      id = term_id,
      size = opts.size or 0.3,
      float_opts = opts.float_opts or {},
    }
  end
end
function runner(opts)
  local ar_conf = require("arsync.conf").load_conf()
  local file_path = vim.fn.expand "%"
  if not vim.g.remote_term_enable then
    toggle_terminal { pos = "sp", size = 0.4 }
    toggle_terminal { pos = "sp", size = 0.4 }
  end
  local prefix_map = {
    ["sh"] = "bash",
    ["py"] = "python",
  }
  local prefix = prefix_map[vim.fn.expand "%:e"]
  if ar_conf and ar_conf.auto_sync_up ~= 0 and not opts.local_term then
    file_path = file_path:gsub(ar_conf.local_path, ar_conf.remote_path)
    require("nvchad.term").runner {
      id = "remote-terminal",
      pos = "sp",
      cmd = prefix .. " " .. file_path,
    }
  else
    require("nvchad.term").runner {
      id = "remote-terminal",
      pos = "sp",
      cmd = prefix .. " " .. file_path,
    }
  end
end
map({ "n", "t" }, "<C-l>", function()
  runner {}
end)

map({ "t" }, "<A-m>", function()
  toggle_terminal { pos = "float", id = "remote-float", float_opts = { width = 1.0, height = 1.0, row = 0.25, col = 0.5 } }
end)

map({ "n" }, "<leader>pf", function()
  local ar_conf = require("arsync.conf").load_conf()
  if ar_conf then
    close_other_terms "sftp-terminal"
    require("nvchad.term").runner {
      id = "sftp-terminal",
      pos = "sp",
      cmd = "sftp" .. " " .. ar_conf.remote_host .. ":" .. ar_conf.remote_path,
    }
  end
end)

map({ "n", "t" }, "<C-j>", function()
  toggle_terminal { pos = "sp", size = 0.4 }
end, { desc = "Terminal Toggle " })

map({ "n", "t" }, "<C-k>", function()
  toggle_terminal { pos = "sp", size = 0.4, local_term = true }
end, { desc = "Terminal Toggle" })

map({ "n", "t" }, "<C-x>", function()
  if is_in_nvterm() then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_delete(cur_buf, { force = true })
  else
    Snacks.bufdelete()
  end
end, { desc = "Terminal Toggle Vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
