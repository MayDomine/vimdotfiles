return {
  "https://github.com/MayDomine/arsync.nvim.git",
  build = ":UpdateRemotePlugins",
  lazy = true,
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    "<leader>ar",
    "<leader>as",
    "<leader>ad",
    "<leader>ac",
    "<leader>aw",
  },
  event = "BufWritePre",
  config = function()
    vim.keymap.set("n", "<leader>ar", "<cmd>ARSyncProj<CR>", { desc = "ARSyncUpProj To Remote" })
    vim.keymap.set("n", "<leader>as", "<cmd>ARSyncShow<CR>", { desc = "ARSyncShow" })
    vim.keymap.set("n", "<leader>ad", "<cmd>ARSyncDownProj<CR>", { desc = "ARSyncDownProj From Remote" })
    vim.keymap.set("n", "<leader>ac", "<cmd>ARCreate<CR>", { desc = "ARSyncUp Config Create" })
    vim.keymap.set("n", "<leader>aw", "<cmd>ARSync<CR>", { desc = "ARSyncUp file" })
    require("arsync").setup()
  end,
}

