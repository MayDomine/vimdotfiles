return {
    "crusj/bookmarks.nvim",
    lazy = false,
    keys = {
      {
        "<leader>bl",
        mode = { "n" },
        "<cmd>Telescope bookmarks<CR>",
      },
      {
        "<leader>bg",
        mode = { "n" },
        function()
          require("bookmarks").add_bookmarks(true)
        end,
      },
      {
        "<leader>bc",
        mode = { "n" },
        function()
          require("bookmarks").add_bookmarks(false)
        end,
      },
    },
    branch = "main",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("bookmarks").setup {
        keymaps = {},
        sign_icon = "",
      }
      require("telescope").load_extension "bookmarks"
      -- vim.api.nvim_set_hl(0, "bookmarks_virt_text_hl", { fg = '#495858'})
    end,
}
