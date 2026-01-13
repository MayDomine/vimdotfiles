-- resizing splits
-- amount defaults to 3 if not specified
-- use absolute values, no + or -
-- the functions also check for a range,
-- so for example if you bind `<A-h>` to `resize_left`,
-- then `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
local amount = 3-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
map({'n', 't'}, '<A-H>', require('smart-splits').resize_left)
map({'n', 't'}, '<A-J>', require('smart-splits').resize_down)
map({'n', 't'}, '<A-K>', require('smart-splits').resize_up)
map({'n', 't'}, '<A-L>', require('smart-splits').resize_right)
-- m{ovi, 't'}ng betWeen splits
map({'n', 't'}, '<M-h>', require('smart-splits').move_cursor_left)
map({'n', 't'}, '<M-j>', require('smart-splits').move_cursor_down)
map({'n', 't'}, '<M-k>', require('smart-splits').move_cursor_up)
map({'n', 't'}, '<M-l>', require('smart-splits').move_cursor_right)
map({'n', 't'}, '<A-\\>', require('smart-splits').move_cursor_previous)

umap('n', '<c-h>')
umap('n', '<c-l>')
map(
      { "n", "x", "o" },
      "<c-l>",
      function()
        require("flash").jump {
          search = { mode = "search", max_length = 0 },
          label = { after = {0, 0}, before = false },
          pattern = "^",
        }
      end
  )
