return{
  {
    "folke/noice.nvim",
    lazy=false,
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
  },
  {
    "rcarriga/nvim-notify",
    lazy=false,
  }
}
