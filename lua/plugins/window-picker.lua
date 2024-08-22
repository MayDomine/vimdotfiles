return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  lazy = false,
  version = "2.*",
  config = function()
    require("window-picker").setup({
      selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
      show_prompt = false,
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
          -- if the file type is one of following, the window will be ignored
          filetype = { "neo-tree", "neo-tree-popup", "notify", "noice" },
          -- if the buffer type is one of following, the window will be ignored
          buftype = { "terminal", "quickfix" },
        },
      },
    })
  end,
}
