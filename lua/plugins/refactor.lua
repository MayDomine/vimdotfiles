return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    local map = vim.keymap.set
    map("x", "<leader>re", function()
      return require("refactoring").refactor "Extract Function"
    end, {desc = "Extract Function", expr=true})
    map("x", "<leader>rf", function()
      return require("refactoring").refactor "Extract Function To File"
    end, {desc = "Extract Function To File"})
    -- Extract function supports only visual mode
    map({"n","x"}, "<leader>rv", function()
      return require("refactoring").refactor "Extract Variable"
    end, {desc = "Extract Variable"})
    -- Extract variable supports only visual mode
    map("n", "<leader>rI", function()
      return require("refactoring").refactor "Inline Function"
    end, {desc = "Inline Function"})
    -- Inline func supports only normal
    map({ "n", "x" }, "<leader>ri", function()
      require("refactoring").refactor "Inline Variable"
    end, {desc = "Inline Variable"})
    -- Inline var supports both normal and visual mode
    
    map("n", "<leader>rb", function()
      return require("refactoring").refactor "Extract Block"
    end, {desc = "Extract Block"})
    map("n", "<leader>rbf", function()
      return require("refactoring").refactor "Extract Block To File"
    end, {desc = "Extract Block To File"})
    require("refactoring").setup()
    -- Extract block supports only normal mode
  end,
}
