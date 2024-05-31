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
    event="VeryLazy",
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function ()
      local cmp = require "nvchad.configs.cmp"
      return cmp
    end,
    config = function (_, opts)
      local cmp = require "cmp"
      local mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }
      opts.mapping = cmp.mapping.preset.insert(mapping)
      cmp.setup(opts)
    end,
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
    "sindrets/diffview.nvim",        -- optional - Diff integration
    lazy = false
  },

  {
    "https://github.com/ojroques/vim-oscyank.git",
    evetn = "VeryLazy",
    keys = {
      {"<leader>o", mode = "n", "<Plug>OSCYankOperator", desc = "copy operator"},
      {"<leader>oc", mode = "n", "<leader>oc_", desc = "copy to system clipboard"},
      {"<leader>y", mode = "v", "<Plug>OSCYankVisual", desc = "copy to system clipboard"},
    }
  },

  {
  "https://github.com/machakann/vim-sandwich.git",
  event = "VeryLazy",
  lazy = true,
  keys = {
      {"<leader>sa", mode =  {"n", "x", "o"}, "<Plug>(sandwich-add)", desc =  "add sandwich in normal mode"},
      {"<leader>sd", mode =  {"n", "x"}, "<Plug>(sandwich-delete)", desc =  "delete sandwich in normal mode"},
      {"<leader>sdb", mode =  "n", "<Plug>(sandwich-delete-auto)", desc =  "delete sandwich auto in normal mode"},
      {"<leader>sr", mode =  {"n","x"}, "<Plug>(sandwich-replace)", desc =  "replace sandwich in normal mode"},
      {"<leader>srb", mode =  "n", "<Plug>(sandwich-replace-auto)", desc =  "replace sandwich auto in normal mode"},
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
      { "m",          mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "M",          mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",          mode = { "o" },               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "<leader>ds",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<leader>df", mode = { "n" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },

  },


  {
   'rmagatti/auto-session',
    lazy=false,
    config = function()
    local function change_nvim_tree_dir()
      local nvim_tree = require("nvim-tree")
      nvim_tree.change_dir(vim.fn.getcwd())
    end

    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = {  "~/projects", "~/.config", "/.local/share/nvim"},
      post_restore_cmds = { change_nvim_tree_dir, "NvimTreeOpen", "wincmd p"},
      pre_save_cmds = { "NvimTreeClose" },
      session_lens = {
        load_on_setup = false,
        }
    })
    end,
  },

  {
  "https://github.com/tpope/vim-fugitive.git",
    lazy=false
  },
  {
    "https://github.com/idanarye/vim-merginal.git",
    dependencies = { "tpope/vim-fugitive" , "https://github.com/Shougo/vimproc.vim.git"},
    lazy=false
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier", "jedi-language-server",'pyright', 'bash-language-server','jsonls', 'mypy'
  		},
  	},
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css", "python", "c"
  		},
  	},
  },
  {
     "m4xshen/hardtime.nvim",
     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
     config = function()
       require("hardtime").setup({max_count=10})
     end,
     lazy = false,
  },
}


