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
    "ARSyncCMP",
  },
  keys = {
    { "<leader>ar", "<cmd>ARSyncProj<CR>", desc = "ARSyncUpProj To Remote" },
    { "<leader>ap", "<cmd>ARSyncCMP<CR>", desc = "ARSyncUpProj To Remote" },
    { "<leader>as", "<cmd>ARSyncShow<CR>", desc = "ARSyncShow" },
    { "<leader>ad", "<cmd>ARSyncDown<CR>", desc = "ARSyncDown From Remote" },
    { "<leader>aD", "<cmd>ARSyncDownProj<CR>", desc = "ARSyncDownProj From Remote" },
    { "<leader>ac", "<cmd>ARCreate<CR>", desc = "ARSyncUp Config Create" },
    { "<leader>ak", "<cmd>ARSyncCleanSftp<CR>", desc = "ARSyncUp Clear SFTP" },
    { "<leader>ae", "<cmd>AREdit<CR>", desc = "ARSyncUp Config Edit" },
    { "<leader>aw", "<cmd>ARSync<CR>", desc = "ARSyncUp file" },
    {
      "<leader>aj",
      '<cmd>lua require("arsync").search_conf()<CR>',
      { noremap = true, silent = true, desc = "ARSync search_conf" },
    },
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
    require("arsync").setup {
      completion_plugin = "blink",
    }
  end,
}
