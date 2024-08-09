return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  keys = {
    { "<leader>;", mode = "n", "<Cmd>Oil --float<CR>", desc = "Open Oil" },
  },
  command = "Oil",
  lazy = false,
  config = function()
    local opts = {
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 20,
        max_height = 20,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    }
    require("oil").setup(opts)
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
