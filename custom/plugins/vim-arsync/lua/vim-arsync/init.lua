-- Lua plugin to handle async rsync synchronization between hosts
-- Title: vimarsync
-- Author: Ken Hasselmann (converted to Lua)
-- License: MIT

local M = {}
local conf_m = require "vim-arsync.conf"

M.setup = function()
  local search_conf = require("vim-arsync.tele").json_picker
  local vim_file = "" -- plugin path
  vim.api.nvim_set_keymap(
    "n",
    "<leader>jp",
    '<cmd>lua require("vim-arsync").search_conf()<CR>',
    { noremap = true, silent = true }
  )
  M.search_conf = search_conf
  M.path = vim_file
  if vim_file ~= "" then
    vim.cmd("source " .. vim_file)
  end
  vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
    group = vim.api.nvim_create_augroup("vimarsync", { clear = true }),
    callback = function()
      conf_m.check_and_update_conf()
    end,
  })
end

vim.api.nvim_create_user_command("ARClear", function(opts)
  local conf_file = vim.fn.stdpath "data" .. "/vim-arsync/global_conf.json"
  os.remove(conf_file)
  vim.notify("Delete global configuration:\n" .. conf_file, vim.log.levels.INFO, { title = "vim-arsync" })
end, { nargs = 0 })

vim.api.nvim_create_user_command("ARCreate", function(opts)
  local local_conf_path = vim.loop.cwd() .. "/.vim-arsync"
  if not vim.loop.fs_stat(local_conf_path) then
    local conf_dict = conf_m.create_project_conf({
      remote_host = "unknown",
      remote_port = 0,
      auto_sync_up = 0,
      remote_path = "unknown",
      rsync_flags = {"--max-size=100m"}
    })
    vim.notify(
      "Create local configuration\n",
      vim.log.levels.INFO,
      { title = "vim-arsync" }
    )
  end
end, { nargs = 0 })
-- if vim_file ~= "" then
--   vim.cmd("source " .. vim_file)
-- end

return M
