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
      keymap = {
        toggle = "<leader>bb",
        close = "q", -- close bookmarks (buf keymap)
        add = "\\z", -- Add bookmarks(global keymap)
        add_global = "\\g", -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol '󰯾'
        jump = "<CR>", -- Jump from bookmarks(buf keymap)
        delete = "dd", -- Delete bookmarks(buf keymap)
        order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
        delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
        show_desc = "\\sd", -- show bookmark desc(global keymap)
        focus_tags = "<c-j>",      -- focus tags window
        focus_bookmarks = "<c-k>", -- focus bookmarks window
        toogle_focus = "<S-Tab>", -- toggle window focus (tags-window <-> bookmarks-window)
      },
      sign_icon = "",
    }
    vim.keymap.del("n", "<leader>b")
    vim.keymap.set("n", "<leader>bn", "<cmd>vnew<CR>")
    require("telescope").load_extension "bookmarks"
    -- vim.api.nvim_set_hl(0, "bookmarks_virt_text_hl", { fg = '#495858'})
  end,
}
