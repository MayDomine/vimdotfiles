return {
  {
    "folke/noice.nvim",
    lazy = false,
    opts = {},
    config = function()
      vim.api.nvim_create_autocmd("RecordingEnter", {
        callback = function()
          local msg = string.format("Recording Mode for:  %s", vim.fn.reg_recording())
          _MACRO_RECORDING_STATUS = true
          vim.notify(msg, vim.log.levels.INFO, {
            title = "Macro Recording",
            keep = function()
              return _MACRO_RECORDING_STATUS
            end,
          })
        end,
        group = vim.api.nvim_create_augroup("NoiceMacroNotfication", { clear = true }),
      })

      vim.api.nvim_create_autocmd("RecordingLeave", {
        callback = function()
          _MACRO_RECORDING_STATUS = false
          vim.notify("Record Finished!", vim.log.levels.INFO, {
            title = "Macro Recording End",
            timeout = 2000,
          })
        end,
        group = vim.api.nvim_create_augroup("NoiceMacroNotficationDismiss", { clear = true }),
      })
      require("noice").setup {
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
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
            enabled = true,
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
