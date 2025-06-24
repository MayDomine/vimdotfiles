return {
  "saghen/blink.cmp",
  version = "*",
  event = { "InsertEnter", "CmdLineEnter" },

  dependencies = {
    {
      "micangl/cmp-vimtex",
      lazy = false,
      config = function()
        local cmp = require "cmp"
        cmp.setup.filetype("tex", {
          sources = {
            { name = "vimtex" },
            -- other sources
          },
        })
      end,
      ft = { "tex", "plaintex", "bib", "bibtex" },
      dependencies = {
        {
          "saghen/blink.compat",
          version = "*",
          lazy = false,
          opts = { impersonate_nvim_cmp = true },
        },
      },
    },
    "rafamadriz/friendly-snippets",
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)
        require "nvchad.configs.luasnip"
      end,
    },

    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
    },
  },

  opts_extend = { "sources.default" },
  opts = function()
    local config = require "nvchad.blink.config"
    config.cmdline.enabled = false
    config.keymap['<Tab>'] = { 'select_and_accept', 'fallback'}
    config.enabled = function()
      return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype) or vim.g.use_blink
    end
    table.insert(config.sources.default, "arsync")
    table.insert(config.sources.default, "vimtex")
    config.sources.providers = {
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        score_offset = 1,
      },
    }
    return config
  end,
}
