return {
  "mistricky/codesnap.nvim",
  build = "make",
  lazy = true,
  enabled = vim.g.is_mac,
  cmd = { "CodeSnap", "CodeSnapSave" },
  keys = {
    { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
    { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
  },
  opts = {
    save_path = "~/Pictures",
    has_breadcrumbs = true,
    bg_theme = "sea",
    title = "Tachicoma",
    watermark = "MayDomine",
    bg_color = "#535c68",
  },
}
