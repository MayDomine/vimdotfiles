return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy=false,
  },

  {
    "https://github.com/github/copilot.vim.git",
    event = "VeryLazy",
    keys = {
      -- { "<C-m>", mode = "i",  "<Plug>(copilot-suggest)", desc = "Copilot Complete" },
      -- { "<C-m>n", mode = "n",  "<Plug>(copilot-next)", desc = "Copilot Next Suggesting" },
      -- { "<C-m>p", mode = "n",  "<Plug>(copilot-previous)", desc = "Copilot Previous Suggesting" },
    }
  },

  {
    "https://github.com/ojroques/vim-oscyank.git",
    lazy=false,
    keys = {
      {"<leader>o", mode = "n", "<Plug>OSCYankOperator", desc = "copy operator"},
      {"<leader>oc", mode = "n", "<leader>oc_", desc = "copy to system clipboard"},
      {"<leader>c", mode = "v", "<Plug>OSCYankVisual", desc = "copy to system clipboard"},
    }
  },

  {
  "https://github.com/machakann/vim-sandwich.git",
  event = "VeryLazy",
  lazy = true,
  keys = {
     { "s", mode = { "n", "x", "o" }, false },
     { "s", mode = { "n", "x", "o" }, false },
     { "sa", mode = { "n", "x", "o" }, false },
     { "sd", mode = { "n", "x", "o" }, false },
      {"<leader>sa", mode =  {"n", "x", "o"}, "<Plug>(sandwich-add)", desc =  "add sandwich in normal mode"},
      {"<leader>sd", mode =  {"n", "x"}, "<Plug>(sandwich-delete)", desc =  "delete sandwich in normal mode"},
      {"<leader>sdb", mode =  "n", "<Plug>(sandwich-delete-auto)", desc =  "delete sandwich auto in normal mode"},
      {"<leader>sr", mode =  {"n","x"}, "<Plug>(sandwich-replace)", desc =  "replace sandwich in normal mode"},
      {"<leader>srb", mode =  "n", "<Plug>(sandwich-replace-auto)", desc =  "replace sandwich auto in normal mode"}
    },
  callback = function()
  end,

  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      enable = true,
    },
    keys = {
      { "m", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "M", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<leader>df", mode = { "n" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },

  },

  {
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

          }
        }
    end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        },
  },

  {
   'rmagatti/auto-session',
    lazy=false,
    config = function()
      require("auto-session").setup {
      auto_session_suppress_dirs = {  "~/projects", "~/.config", "/.local/share/nvim"},
    }
    end,
  },

  {
  "https://github.com/tpope/vim-fugitive.git",
    lazy=false
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier"
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },
}
