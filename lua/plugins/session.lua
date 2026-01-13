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
      post_restore_cmds = { },
      bypass_save_filetypes = {"dap-repl"},
      pre_save_cmds = { "NvimTreeClose" },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        buftypes_to_ignore = {},
      },
    }
  end,
}
