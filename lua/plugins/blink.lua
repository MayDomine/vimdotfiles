return {
  "saghen/blink.cmp",
  lazy = false,
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
          opts = { impersonate_nvim_cmp = true },
        },
      },
    },
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      lazy = false,
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)
        require("luasnip.loaders.from_snipmate").load { paths = vim.g.snipmate_snippets_path or "" }
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
    config.keymap["<Tab>"] = { "select_and_accept", "fallback" }
    config.enabled = function()
      return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype) or vim.g.use_blink
    end
    local source_priority = {
      snippets = 4,
      lsp = 3,
      path = 2,
      buffer = 1,
    }

    config.fuzzy.sorts = {
      function(a, b)
        local a_priority = source_priority[a.source_id] or 0
        local b_priority = source_priority[b.source_id] or 0
        if a_priority ~= b_priority then
          return a_priority > b_priority
        end
      end,
      -- defaults
      "score",
      "sort_text",
    }
    table.insert(config.sources.default, "arsync")
    table.insert(config.sources.default, "vimtex")
    config.sources.providers = {
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        score_offset = 2,
      },
    }
    return config
  end,
}
-- return {}
