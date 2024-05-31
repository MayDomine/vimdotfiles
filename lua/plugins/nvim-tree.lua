return {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      opts.diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      }
      require("nvim-tree").setup(opts)
    end,
      dependencies = {
       "neovim/nvim-lspconfig"
      }
}
