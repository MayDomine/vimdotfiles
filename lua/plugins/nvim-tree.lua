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
      opts.filters = {
        dotfiles = false,
      }
      opts.git = {
      enable = true,
      ignore = true,  -- 不忽略 .gitignore 文件中列出的文件
      }
      require("nvim-tree").setup(opts)
    end,
      dependencies = {
       "neovim/nvim-lspconfig"
      }
}
