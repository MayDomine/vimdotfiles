return {
  {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    keys = {
      {
        "<leader>tr",
        mode = { "n" },
        "<cmd>Triforce profile<CR>",
        desc = "Triforce",
      },
    },
    opts = {},
  },
}
