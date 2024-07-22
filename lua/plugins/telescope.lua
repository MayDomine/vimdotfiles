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
        local actions = require "telescope.actions"
        local lga_actions = require "telescope-live-grep-args.actions"
        local open_with_trouble = function(buf, sub_opts)
          sub_opts = {}
          sub_opts['focus']=true
          require("trouble.sources.telescope").open(buf, sub_opts)
        end
        local action_state = require "telescope.actions.state"
        opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
          git_commits = {
            mappings = {
              i = {
                ["<C-d>"] = function() -- show diffview for the selected commit
                  -- Open in diffview
                  local entry = action_state.get_selected_entry()
                  -- close Telescope window properly prior to switching windows
                  actions.close(vim.api.nvim_get_current_buf())
                  vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
                end,
              },
            },
          },
          git_bcommits_range = {
            mappings = {
              i = {
                ["<C-d>"] = function() -- show diffview for the selected commit of current buffer
                  -- Open in diffview
                  local entry = action_state.get_selected_entry()
                  -- close Telescope window properly prior to switching windows
                  actions.close(vim.api.nvim_get_current_buf())
                  vim.cmd(("DiffviewOpen %s^!"):format(entry.value))
                end,
              },
            },
          },
          git_branches = {
            mappings = {
              i = {
                ["<C-d>"] = function() -- show diffview comparing the selected branch with the current branch
                  -- Open in diffview
                  local entry = action_state.get_selected_entry()
                  -- close Telescope window properly prior to switching windows
                  actions.close(vim.api.nvim_get_current_buf())
                  vim.cmd(("DiffviewOpen %s.."):format(entry.value))
                end,
              },
            },
          },
        })
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
        }
        opts['defaults']['mappings'] = {
          i = { ["<c-j>"] = open_with_trouble },
          n = { ["<c-j>"] = open_with_trouble },
        }
        opts['defaults']['cache_picker'] = {
          num_pickers = 100,
        }
    telescope.setup(opts)

    -- load extensions
    for _, ext in ipairs(opts.extensions_list) do
      telescope.load_extension(ext)
    end
    telescope.load_extension("live_grep_args")
    telescope.load_extension("notify")
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = '#404040'})
  end,
}
