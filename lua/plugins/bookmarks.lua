return {
  "crusj/bookmarks.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>bl",
      mode = { "n" },
      "<cmd>Telescope bookmarks<CR>",
      desc = "List Bookmarks",
    },
    {
      "<leader>bg",
      mode = { "n" },
      function()
        require("bookmarks").add_bookmarks(true)
      end,
      desc = "Create Global bookmarks",
    },
    {
      "<leader>bc",
      mode = { "n" },
      function()
        require("bookmarks").add_bookmarks(false)
      end,
      desc = "Create Local bookmarks (project level)",
    },
  },
  branch = "main",
  dependencies = { "nvim-web-devicons" },
  config = function()
    require("bookmarks").setup {
      keymaps = {},
      sign_icon = "",
    }
    vim.keymap.del("n", "<leader>b")
    vim.keymap.set("n", "<leader>bn", "<cmd>vnew<CR>")
    require("telescope").load_extension "bookmarks"
    -- vim.api.nvim_set_hl(0, "bookmarks_virt_text_hl", { fg = '#495858'})
  end,
}
