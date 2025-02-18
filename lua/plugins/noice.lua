return {
  {
    "folke/noice.nvim",
    lazy = false,
    opts = {},
    config = function()
      require("noice").setup {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            silent = true,
            enabled = false,
          },
          signature = {
            enabled = false,
            silent = true,
          },
        },
        messages = {
          enabled = true,
        },
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup {
        stages = "slide",
        timeout = 5000,
        background_colour = "#000000",
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
        top_down = true,
      }
    end,
  },
}
