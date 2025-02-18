return {
  {
    -- format plugin and the key is <space>fm
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    lazy = false,
    config = function()
      require "configs.conform"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "BufRead",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    opts = {
    },
    config = function()
      require("barbecue").setup()
    end,
  },
  {
    "https://github.com/junegunn/fzf.vim.git",
    event = "VeryLazy",
    ft = { "tex", "plaintex", "bib", "bibtex" },
    dependencies = {
      "junegunn/fzf",
    },
  },
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "willothy/wezterm.nvim",
    config = true,
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "nvchad/volt", -- optional, needed for theme switcher
  },
  {
    "https://github.com/powerman/vim-plugin-AnsiEsc.git",
    event = "VeryLazy",
    config = function()
      vim.keymap.del("n", "<leader>swp")
    end,
  },

  -- install with yarn or npm
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    lazy = false,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      vim.tbl_deep_extend("force", opts, {
        preset = "helix",
        triggers = {
             { "<auto>", mode = "nxsoi" },
        }
      })
      require("which-key").setup(opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    event = "VeryLazy",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    ft = "markdown",
    config = function()
      require("render-markdown").setup { enabled = false }
    end,
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    -- -@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "nvchad.configs.cmp"
      cmp.sources = vim.tbl_extend("force", cmp.sources, { { name = "vimtex" } })
      -- vim.notify("cmp sources: " .. vim.inspect(cmp.sources))
      return cmp
    end,
    config = function(_, opts)
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
      cmp.setup(opts)
    end,
    dependencies = {
      "micangl/cmp-vimtex",
    },
  },
  {
    "https://github.com/github/copilot.vim.git",
    event = "VeryLazy",
    keys = {
      -- { "<C-m>", mode = "i",  "<Plug>(copilot-suggest)", desc = "Copilot Complete" },
      -- { "<C-m>n", mode = "n",  "<Plug>(copilot-next)", desc = "Copilot Next Suggesting" },
      -- { "<C-m>p", mode = "n",  "<Plug>(copilot-previous)", desc = "Copilot Previous Suggesting" },
    },
  },

  {
    "sindrets/diffview.nvim", -- optional - Diff integration
    lazy = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    config = function()
      require("diffview").setup()
    end,
  },

  {
    "https://github.com/ojroques/vim-oscyank.git",
    evetn = "VeryLazy",
    keys = {
      { "<leader>y", mode = "n", "<Plug>OSCYankOperator", desc = "copy operator" },
      { "<leader>oc", mode = "n", "<leader>oc_", desc = "copy to system clipboard" },
      { "<leader>y", mode = "v", "<Plug>OSCYankVisual", desc = "copy to system clipboard" },
    },
  },

  {
    "https://github.com/machakann/vim-sandwich.git",
    event = "VeryLazy",
    lazy = true,
    keys = {
      { "sa", mode = { "n", "x", "o" }, "<Plug>(sandwich-add)", desc = "Sandwich add in normal mode" },
      {
        "<leader>ib",
        mode = { "v", "x", "o" },
        "<Plug>(textobj-sandwich-auto-i)",
        desc = "Sandwich insert in v/o/x mode",
      },
      {
        "<leader>ab",
        mode = { "v", "x", "o" },
        "<Plug>(textobj-sandwich-auto-a)",
        desc = "Sandwich add in v/o/x mode",
      },
      { "sd", mode = { "n", "x" }, "<Plug>(sandwich-delete)", desc = "Sandwich delete in normal mode" },
      { "sdb", mode = "n", "<Plug>(sandwich-delete-auto)", desc = "Sandwich delete-auto in normal mode" },
      { "sr", mode = { "n", "x" }, "<Plug>(sandwich-replace)", desc = "Sandwich replace in normal mode" },
      { "srb", mode = "n", "<Plug>(sandwich-replace-auto)", desc = "Sandwich replace-auto in normal mode" },
    },
    callback = function() end,
  },

  {
    "https://github.com/tpope/vim-fugitive.git",
    dependencies = { "https://github.com/tpope/vim-rhubarb.git" },
    lazy = false,
  },
  {
    "https://github.com/idanarye/vim-merginal.git",
    dependencies = { "tpope/vim-fugitive", "https://github.com/Shougo/vimproc.vim.git" },
    lazy = false,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
      {
        "https://github.com/artemave/workspace-diagnostics.nvim.git",
        lazy = true,
        config = function()
          require("workspace-diagnostics").setup {
            workspace_files = function()
              local gitPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
              local workspace_files = vim.fn.split(vim.fn.system('git ls-files -x ""' .. gitPath), "\n")
              workspace_files = vim.tbl_filter(function(file)
                return string.sub(file, 1, 1) ~= "."
              end, workspace_files)
              if #workspace_files > 1000 then
                return nil
              end
              -- workspace_files = vim.list_slice(workspace_files, 0, 1000)
              return workspace_files
            end,
          }
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "python",
        "c",
      },
    },
  },

  {
    "https://github.com/nvim-treesitter/nvim-treesitter-context.git",
    lazy = false,
    config = function()
      require("treesitter-context").setup {
        multiline_threshold = 2,
        enable = true,
      }
      vim.cmd "hi TreesitterContextLineNumber guifg='#BEB096'"
      -- vim.cmd("hi TreesitterContextBottom gui=underline guisp='#BEB096'")
    end,
  },
}
