return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  keys = {
    { "<leader>;", mode = "n", "<Cmd>Oil --float<CR>", desc = "Open Oil" },
    { "<leader>oa", mode = "n", "<Cmd>Oil<CR>", desc = "Open Oil" },
  },
  command = "Oil",
  event = "VeryLazy",
  config = function()
    local opts = {
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<c-a>"] = "actions.toggle_hidden",
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-s>"] = {},
        -- Mappings can be a string
        ["~"] = "<cmd>edit $HOME<CR>",
        -- Mappings can be a function
        ["gd"] = function()
          require("oil").set_columns { "icon", "permissions", "size", "mtime" }
        end,
        -- You can pass additional opts to vim.keymap.set by using
        -- a table with the mapping as the first element.
        ["<leader>ff"] = {
          function()
            require("telescope.builtin").find_files {
              cwd = require("oil").get_current_dir(),
            }
          end,
          mode = "n",
          nowait = true,
          desc = "Find files in the current directory",
        },
        ["<leader>fw"] = {
          function()
            local live_grep_args = require("telescope").extensions.live_grep_args
            live_grep_args.live_grep_args {
              search_dirs = { require("oil").get_current_dir() },
            }
          end,
          mode = "n",
          nowait = true,
          desc = "Find files in the current directory",
        },
        -- Mappings that are a string starting with "actions." will be
        -- one of the built-in actions, documented below.
        ["&"] = "actions.tcd",
        -- Some actions have parameters. These are passed in via the `opts` key.
        ["<leader>:"] = {
          "actions.open_cmdline",
          opts = {
            shorten_path = true,
            modify = ":h",
          },
          desc = "Open the command line with the current directory as an argument",
        },
        ["<C-h>"] = {},
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 40,
        max_height = 20,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    }
    require("oil").setup(opts)
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
