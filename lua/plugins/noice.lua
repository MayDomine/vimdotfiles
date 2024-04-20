return{
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
    },
    config = function()
      require("noice").setup {
        lsp = {
          hover = {
            silent = true,
            enabled = false,
          },
          signature = {
            enabled = false,
            silent = true,
          }

        },
        messages = {
          enabled = true,
        }
      }
    end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        },
  }
