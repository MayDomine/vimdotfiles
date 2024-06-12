return {
 "folke/trouble.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 },
  keys = {
        {
          "<leader>nr",
          "<cmd>Trouble lsp_references toggle foucs=true follow=false<cr>",
          desc = "LSP References (Trouble)",
        },
        {
          "<leader>nd",
          "<cmd>Trouble diagnostics toggle win.position=left<cr>",
          desc = "Diagnostics Workspace(Trouble)",
        },
        {
          "<leader>nD",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>ns",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>nl",
          "<cmd>Trouble lsp toggle focus=true<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>nL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>nQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      }
}
