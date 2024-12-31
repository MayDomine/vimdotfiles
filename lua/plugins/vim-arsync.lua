return {
  "https://github.com/MayDomine/arsync.nvim.git",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("arsync").setup()
  end,
  lazy = false,
}

