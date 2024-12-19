return {
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  -- event = "VeryLazy",
  lazy = true,
  keys = {
    {
      "<leader>.",
      mode = { "n" },
      function()
        require("telescope").extensions.smart_open.smart_open({
        })
      end,
      { noremap = true, silent = true },
    },
    {
      "<leader>,",
      mode = { "n" },
      function()
        require("telescope").extensions.smart_open.smart_open({
          preview = {
            hide_on_startup = true,
          },
          layout_config = {
            width = 0.3,
          },
        })
      end,
      { noremap = true, silent = true },
    },
  },
  dependencies = {
    "kkharji/sqlite.lua",
    -- Only required if using match_algorithm fzf
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
}
