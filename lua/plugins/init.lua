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
  { import = "nvchad.blink.lazyspec" },
  {
    "MayDomine/dict.nvim",
    lazy = false,
    config = function()
      require("dict").setup {
        dict = "wn",
      }
      vim.keymap.set("n", "<leader>dw", function()
        require("dict").lookup()
      end, { desc = "Dictionary" })
    end,
  },
  {
    "sk1418/HowMuch",
    lazy = false,
    init = function()
      vim.g.HowMuch_scale = 5
    end,
  },
  { "echasnovski/mini.pairs" },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    config = function()
      require("nvim-highlight-colors").setup {}
    end,
    opts = { -- set to setup table
    },
  },
  {
    "akinsho/git-conflict.nvim",
    enabled = true,
    version = "*",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.keymap.set("n", "<leader>cww", function()
            engage.conflict_buster()
            create_buffer_local_mappings()
          end)
        end,
      })
      require("git-conflict").setup {
        default_mappings = false, -- disable buffer local mapping created by this plugin
        default_commands = true, -- disable commands created by this plugin
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = "copen", -- command or function to open the conflicts list
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = "DiffAdd",
          current = "DiffText",
        },
      }

      vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#332c3c", fg = "#bf616a" }) -- red
      vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#2c3c2c", fg = "#a3be8c" }) -- green
      vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#3c3c2c", fg = "#ebcb8b" }) -- yellow

      vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#bf616a", fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#a3be8c", fg = "#000000", bold = true })
      vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#ebcb8b", fg = "#000000", bold = true })
      vim.keymap.set("n", "<leader>mo", "<Plug>(git-conflict-ours)")
      vim.keymap.set("n", "<leader>mt", "<Plug>(git-conflict-theirs)")
      vim.keymap.set("n", "<leader>mb", "<Plug>(git-conflict-both)")
      vim.keymap.set("n", "<leader>m0", "<Plug>(git-conflict-none)")
      vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)")
      vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)")
    end,
    event = "VeryLazy",
    cmds = { "GitConflictListQf" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup {}
    end,
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
    opts = {},
    config = function()
      require("barbecue").setup()
    end,
  },
  {
    "https://github.com/junegunn/fzf.vim.git",
    lazy = true,
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
      local opts = vim.tbl_deep_extend("force", opts, {
        preset = "modern",
        triggers = {
          { "<auto>", mode = "nxsoi" },
        },
      })
      require("which-key").setup(opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    enabled = vim.g.is_mac,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview Toggle" })
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    ft = "markdown",
    enabled = vim.g.is_mac,
    config = function()
      require("render-markdown").setup { enabled = false }
      vim.keymap.set("n", "<leader>um", function()
        require("render-markdown").toggle()
      end, { desc = "[render-markdown] Toggle" })
    end,
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    -- -@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  {
    "https://github.com/github/copilot.vim.git",
    event = "VeryLazy",
    enabled = false,
    keys = {
      -- { "<C-m>", mode = "i",  "<Plug>(copilot-suggest)", desc = "Copilot Complete" },
      -- { "<C-m>n", mode = "n",  "<Plug>(copilot-next)", desc = "Copilot Next Suggesting" },
      -- { "<C-m>p", mode = "n",  "<Plug>(copilot-previous)", desc = "Copilot Previous Suggesting" },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    lazy = false,
    config = function()
      require("supermaven-nvim").setup {
        ignore_filetypes = { "bigfile" },
        color = {
          suggestion_color = "#6c936e",
          cterm = 244,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim", -- optional - Diff integration
    lazy = true,
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    config = function()
      require("diffview").setup {
        keymaps = {
          file_panel = {
            {
              "n",
              "<c-n>",
              "<cmd>DiffviewToggleFiles<CR>",
              { desc = "Open the diff for the next file" },
            },
          },
          view = {
            {
              "n",
              "<c-n>",
              "<cmd>DiffviewToggleFiles<CR>",
              { desc = "Open the diff for the next file" },
            },
          },
        },
      }
    end,
  },

  {
    "https://github.com/machakann/vim-sandwich.git",
    lazy = false, -- disable lazy for vimtex's motion recipe
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
      -- {
      --   "https://github.com/artemave/workspace-diagnostics.nvim.git",
      --   lazy = true,
      --   config = function()
      --     require("workspace-diagnostics").setup {
      --       workspace_files = function()
      --         local gitPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      --         local workspace_files = vim.fn.split(vim.fn.system('git ls-files -x ""' .. gitPath), "\n")
      --         workspace_files = vim.tbl_filter(function(file)
      --           return string.sub(file, 1, 1) ~= "."
      --         end, workspace_files)
      --         if #workspace_files > 1000 then
      --           return nil
      --         end
      --         -- workspace_files = vim.list_slice(workspace_files, 0, 1000)
      --         return workspace_files
      --       end,
      --     }
      --   end,
      -- },
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
    "nvim-treesitter/nvim-treesitter-context",
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
