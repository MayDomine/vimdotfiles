local telescope = require "telescope.builtin"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local previewers = require "telescope.previewers"
local entry_display = require "telescope.pickers.entry_display"
local conf_manager = require "vim-arsync.conf"

local M = {}
local function read_json_file(file_path)
  local file = io.open(file_path, "r")
  if not file then
    print("Failed to open file: " .. file_path)
    return {}
  end
  local content = file:read "*all"
  file:close()
  return vim.fn.json_decode(content)
end

local function create_picker(json_data)
  local finder = finders.new_table {
    results = json_data,
    entry_maker = function(entry)
      local value = entry
      vim.g.test = value
      local url = vim.trim(value["remote_host"]) .. ":" .. value["remote_path"]
      return {
        value = value,
        display = url,
        ordinal = url,
      }
    end,
  }
  local mappings = {
    i = {
      ["<CR>"] = function(bufnr)
        conf_manager = require "vim-arsync.conf"
        local select = action_state.get_selected_entry()
        conf_manager.update_project_conf(select.value)
      end,
    },
    n = {
      ["<CR>"] = function(bufnr)
        conf_manager = require "vim-arsync.conf"
        local select = action_state.get_selected_entry()
        conf_manager.update_project_conf(select.value)
      end,
    },
  }
  pickers
    .new({}, {
      prompt_title = "Rsync Host Config Choose",
      finder = finder,
      sorter = sorters.get_generic_fuzzy_sorter(),
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry, status)
          local entry_str = vim.fn.json_encode(entry.value)
          local lines = vim.split(entry_str, ",")
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          if selection then
            vim.notify("Selected: " .. selection.key .. " = " .. vim.inspect(selection.value))
          else
            vim.notify "No selection made"
          end
        end)

        -- 添加一个新的映射，当按下回车键时调用 process_selected_json 函数
        map({"i", "n"}, "<CR>", function()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          if selection then
            conf_manager.update_project_conf(selection.value)
          else
            print "No selection made"
          end
        end)
        map({"i", "n"}, "<c-x>", function()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          if selection then
            conf_manager.update_project_conf(selection.value)
          else
            print "No selection made"
          end
        end)

        return true
      end,
    })
    :find()
end

local function json_picker()
  local conf_file = vim.fn.stdpath "data" .. "/vim-arsync/global_conf.json"
  local local_path = vim.loop.cwd()
  local json_data = read_json_file(conf_file)
  vim.g.json_data = json_data
  local remote_data = {}
  for _, v in pairs(json_data) do
    vim.g.json_item = v
    vim.g.local_path = local_path
    if v["local_path"]:gsub("/$", "") == local_path then
      table.insert(remote_data, v)
    end
  end
  if json_data then
    create_picker(remote_data)
  else
    print "Failed to read JSON data"
  end
end

M.json_picker = json_picker
return M
