return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  commit = "c406fc5fb4d7ba5fce7b668637075fad6e75e9f8",
  config = function()
    require("refactoring").setup()
    local map = vim.keymap.set
    map("x", "<leader>re", function()
      require("refactoring").refactor "Extract Function"
    end, {desc = "Extract Function"})
    map("x", "<leader>rf", function()
      require("refactoring").refactor "Extract Function To File"
    end, {desc = "Extract Function To File"})
    -- Extract function supports only visual mode
    map("x", "<leader>rv", function()
      require("refactoring").refactor "Extract Variable"
    end, {desc = "Extract Variable"})
    -- Extract variable supports only visual mode
    map("n", "<leader>rI", function()
      require("refactoring").refactor "Inline Function"
    end, {desc = "Inline Function"})
    -- Inline func supports only normal
    map({ "n", "x" }, "<leader>ri", function()
      require("refactoring").refactor "Inline Variable"
    end, {desc = "Inline Variable"})
    -- Inline var supports both normal and visual mode
    
    map("n", "<leader>rb", function()
      require("refactoring").refactor "Extract Block"
    end, {desc = "Extract Block"})
    map("n", "<leader>rbf", function()
      require("refactoring").refactor "Extract Block To File"
    end, {desc = "Extract Block To File"})
    -- Extract block supports only normal mode
  end,
}
