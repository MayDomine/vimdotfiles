return {
  "folke/todo-comments.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
      -- TODO: test
    {"<leader>tt", ":Trouble todo<CR>"},
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
},
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
