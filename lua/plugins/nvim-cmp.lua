return {
  "hrsh7th/nvim-cmp",
  opts = function()
    local cmp = require "nvchad.configs.cmp"
    cmp.sources = vim.tbl_extend("force", cmp.sources, {
      { name = "luasnip" },
      { name = "buffer" },
      { name = "pypi" },
      { name = "vimtex" },
      { name = "nvim_lua" },
      { name = "render-markdown" },
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp" },
    })
    cmp.snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    }
    return cmp
  end,
  config = function(_, opts)
    local priority = {
      kind_priority = {
        Field = 11,
        Property = 11,
        Constant = 10,
        Enum = 10,
        EnumMember = 10,
        Event = 10,
        Function = 10,
        Method = 10,
        Operator = 10,
        Reference = 10,
        Struct = 10,
        Variable = 9,
        File = 8,
        Folder = 8,
        Class = 5,
        Color = 5,
        Module = 5,
        Keyword = 2,
        Constructor = 1,
        Interface = 1,
        Snippet = 0,
        Text = 15,
        TypeParameter = 1,
        Unit = 1,
        Value = 1,
      },
    }
    local lspkind_comparator = function(conf)
      local lsp_types = require("cmp.types").lsp
      return function(entry1, entry2)
        if entry1.source.name ~= "nvim_lsp" then
          if entry2.source.name == "nvim_lsp" then
            return false
          else
            return nil
          end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

        local priority1 = conf.kind_priority[kind1] or 0
        local priority2 = conf.kind_priority[kind2] or 0
        if priority1 == priority2 then
          return nil
        end
        return priority2 < priority1
      end
    end

    local label_comparator = function(entry1, entry2)
      return entry1.completion_item.label < entry2.completion_item.label
    end
    local cmp = require "cmp"
    local mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<C-M>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },
    }
    opts.mapping = cmp.mapping.preset.insert(mapping)
    -- opts.sorting = {}
    -- opts.sorting.comparators = {
    --   lspkind_comparator(priority),
    --   label_comparator,
    -- }
    -- opts.sorting.priority_weight = 1000
    opts.formatting = {
      format = function(entry, vim_item)
        vim_item.menu = entry.source.name
        return vim_item
      end,
    }
    cmp.setup(opts)
    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })
  end,
  dependencies = {
    "micangl/cmp-vimtex",
    "vrslev/cmp-pypi",
  },
}
