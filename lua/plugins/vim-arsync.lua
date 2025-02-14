return {
  "https://github.com/MayDomine/arsync.nvim.git",
  build = ":UpdateRemotePlugins",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>ar", "<cmd>ARSyncProj<CR>", { desc = "ARSyncUpProj To Remote" })
    vim.keymap.set("n", "<leader>as", "<cmd>ARSyncShow<CR>", { desc = "ARSyncShow" })
    vim.keymap.set("n", "<leader>ad", "<cmd>ARSyncDownProj<CR>", { desc = "ARSyncDownProj From Remote" })
    vim.keymap.set("n", "<leader>ac", "<cmd>ARCreate<CR>", { desc = "ARSyncUp Config Create" })
    require("arsync").setup()
  end,
}

