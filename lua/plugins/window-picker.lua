return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    keys = {
        {"<leader>pw", mode =  {"n", "o", "x"}, function ()
        local win_id = require("window-picker").pick_window({hint = 'floating-big-letter'})
        vim.api.nvim_set_current_win(win_id)
        end, desc =  "replace sandwich auto in normal mode",
      }
    },
    config = function()
        require'window-picker'.setup(
        {
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
      }
    )
    end,
}
