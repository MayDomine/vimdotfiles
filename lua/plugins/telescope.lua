return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" , {"nvim-telescope/telescope-live-grep-args.nvim", version="^1.0.0"}},
  cmd = "Telescope",
  opts = function()
    return require "nvchad.configs.telescope"
  end,
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "telescope")
    local telescope = require "telescope"
    local lga_actions = require "telescope-live-grep-args.actions"

    opts['extensions']['live_grep_args'] = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-n>"] = lga_actions.quote_prompt({ postfix = " --no-ignore"})
            },

          },
    telescope.setup(opts)

  }

    -- load extensions
    for _, ext in ipairs(opts.extensions_list) do
      telescope.load_extension(ext)
    end
    telescope.load_extension("live_grep_args")
    telescope.load_extension("notify")
  end,
}
