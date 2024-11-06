return {
  "mrjones2014/smart-splits.nvim",
  version = ">=1.0.0",
  lazy=false,
  keys = {
    {
      "<leader>mm",
      mode = { "n" },
      function()
        require("smart-splits").start_resize_mode()
      end,
      desc = "Start Resize mode",
    },
  },
  config = function()
    require("smart-splits").setup {
      resize_mode = {
        quit_key = "<CR>",
        silent = true,
        hooks = {
          on_enter = function()
            vim.notify "Entering resize mode"
          end,
          on_leave = function()
            vim.notify "Exiting resize mode, bye"
          end,
        },
      },
    }
  end,
}
