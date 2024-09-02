-- 文件: lua/telescope_myconf.lua
local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
  error('This plugins requires telescope.nvim')
end

local conf_manager = require("vim-arsync.conf")
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

local search_conf = function(opts)
  opts = opts or {}
  local conf_file = vim.fn.stdpath("data") .. "/vim-arsync/global_conf.json"
  local conf_dict = conf_manager.read_conf_file(conf_file)
  vim.g.conf_dict = conf_dict

  local results = {}
  for local_path, entry in pairs(conf_dict) do
    local prompt = string.format("%s : %s@%s (%s)", local_path, entry.remote_host, entry.remote_port, entry.remote_path)
    table.insert(results, {prompt = prompt, local_path = local_path, entry = entry})
  end

  pickers.new(opts, {
    prompt_title = "Search Configuration",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.prompt,
          ordinal = entry.prompt
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local entry = selection.value.entry
        local local_path = selection.value.local_path

        conf_manager.update_project_conf(local_path, entry.remote_host, entry.remote_port, entry.remote_path)
        print("Updated .vim-arsync with selected configuration.")
      end)
      return true
    end
  }):find()
end

return telescope.register_extension({ exports = { myconf = search_conf } })

