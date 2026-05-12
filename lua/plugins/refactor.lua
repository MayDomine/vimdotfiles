return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    local map = vim.keymap.set
    map({ "n", "x" }, "<leader>re", function()
      return require("refactoring").extract_func()
    end, { desc = "Extract Function", expr = true })
    map({ "n", "x" }, "<leader>rf", function()
      return require("refactoring").extract_func_to_file()
    end, { desc = "Extract Function To File", expr = true })
    map({ "n", "x" }, "<leader>rv", function()
      return require("refactoring").extract_var()
    end, { desc = "Extract Variable", expr = true })
    map({ "n", "x" }, "<leader>rI", function()
      return require("refactoring").inline_func()
    end, { desc = "Inline Function", expr = true })
    map({ "n", "x" }, "<leader>ri", function()
      return require("refactoring").inline_var()
    end, { desc = "Inline Variable", expr = true })
    map({ "n", "x" }, "<leader>rs", function()
      require("refactoring").select_refactor()
    end, { desc = "Select Refactor" })
    require("refactoring").setup()
  end,
}
