return {
  "https://github.com/MayDomine/arsync.nvim.git",
  build = ":UpdateRemotePlugins",
  lazy = false,
  dependencies = { "folke/snacks.nvim", "hrsh7th/nvim-cmp" },
  cmd = {
    "ARSyncShow",
    "ARSyncToggle",
    "ARSyncEnable",
    "ARSyncDisable",
    "ARSync",
    "ARSyncProj",
    "ARSyncDown",
    "ARSyncDownProj",
    "ARSyncDelete",
    "ARSyncCleanSftp",
    "ARCreate",
  },
  keys = {
    { "<leader>ar", "<cmd>ARSyncProj<CR>", desc = "ARSyncUpProj To Remote" },
    { "<leader>as", "<cmd>ARSyncShow<CR>", desc = "ARSyncShow" },
    { "<leader>ad", "<cmd>ARSyncDown<CR>", desc = "ARSyncDown From Remote" },
    { "<leader>aD", "<cmd>ARSyncDownProj<CR>", desc = "ARSyncDownProj From Remote" },
    { "<leader>ac", "<cmd>ARCreate<CR>", desc = "ARSyncUp Config Create" },
    { "<leader>aw", "<cmd>ARSync<CR>", desc = "ARSyncUp file" },
    {
      "<leader>ax",
      function()
        require("arsync").cleanup()
      end,
      desc = "ARSyncUp file",
    },
  },
  event = "BufWritePre",
  config = function()
    require("arsync").setup()
  end,
}
