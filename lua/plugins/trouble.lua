return {
 "folke/trouble.nvim",
 event = "VeryLazy",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 opts = {
    modes = {
      telescope_float = {
        mode = "telescope",
        preview = {
          type = "float",
          relative = "editor",
          border = "rounded",
          title = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
      lsp_float = {
        mode = "lsp",
        preview = {
          type = "float",
          relative = "editor",
          border = "rounded",
          title = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size = { width = 0.3, height = 0.3 },
          zindex = 200,
        },
      },
    },
    focus = true,
    win = {
      size = 20
    },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 },
  keys = {
        {
          "<leader>dr",
          "<cmd>Trouble lsp_references toggle foucs=true follow=false<cr>",
          desc = "LSP References (Trouble)",
        },
        {
          "<leader>dd",
          "<cmd>Trouble diagnostics toggle foucs=true<cr>",
          desc = "Diagnostics Workspace(Trouble)",
        },
        {
          "<leader>dD",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>dS",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>dl",
          "<cmd>Trouble lsp_float toggle focus=true<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>dL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>dQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      }
}
