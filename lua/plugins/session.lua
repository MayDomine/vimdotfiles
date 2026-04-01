return {
   'rmagatti/auto-session',
  lazy = false,
  config = function()
    local function open_tree()
      require("nvim-tree.api").tree.toggle(false, true)
    end
    require("auto-session").setup {
      log_level = "error",
      auto_session_enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
      auto_session_suppress_dirs = { "~/projects", "~/.config", "/.local/share/nvim" },
      post_restore_cmds = {},
      bypass_save_filetypes = {"dap-repl", "NvTerm_sp", "NvTerm_vsp", "sidekick_terminal"},
      close_filetypes_on_save = { "NvTerm_sp", "NvTerm_vsp", "sidekick_terminal"}, -- Buffers with matching filetypes will be closed before saving
      pre_save_cmds = {
        "NvimTreeClose",
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        buftypes_to_ignore = {'terminal'},
      },
    }
  end,
}
