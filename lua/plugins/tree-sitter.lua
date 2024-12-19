return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = function()
    -- return require "nvchad.configs.treesitter"
  end,
  config = function(_, opts)
    opts.ensure_installed =
      { "python", "json", "bash", "markdown", "vim", "vimdoc", "c", "cpp", "cuda", "lua", "regex" , "latex"}
    opts.highlight = { enable = true ,disable = {"latex"} }
    require("nvim-treesitter.configs").setup(opts)
  end,
}
