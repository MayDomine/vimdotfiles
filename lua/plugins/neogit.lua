return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  keys = {
      { -- lazy style key map
        "<leader>gn",
        "<cmd>Neogit<cr>",
        desc = "Neogit",
      },
    },
  config = true
}
