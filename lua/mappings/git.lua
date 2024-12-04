local map = vim.keymap.set
local function opts(desc)
  return { desc = desc }
end
local gs = require "gitsigns"
map("n", "sn", function()
  gs.next_hunk()
end, { desc = "next hunk" })
map("n", "]h", function()
  gs.next_hunk()
end, { desc = "next hunk" })
map("n", "[h", function()
  gs.prev_hunk()
end, { desc = "previous hunk" })
map({"v", "n"}, "ss", function ()
  gs.stage_hunk()
end, opts "Stage hunk")
map({"v", "n"}, "su", function ()
  gs.undo_stage_hunk()
end, opts "Undo stage hunk")
map({"v", "n"}, "sp", function ()
  gs.preview_hunk()
end, opts "Preview hunk")
map("n", "<leader>gg", "<cmd>Git<CR>", opts "Open Fugitive")
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", opts "Open Diffview for current cursor")
map("n", "<leader>go", "<cmd>DiffviewClose<CR>", opts "Open Diffview for current cursor")
map("n", "<leader>gm", "<cmd>Merginal<CR>", opts "Open Merginal")
map("n", "<leader>gj", "<cmd>GBrowse<CR>", opts "Open GBrowse for current cursor")
map("v", "<leader>do", "<cmd>'<,'>diffget<CR>")
map("n", "<leader>db", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts "Toggle Current Line Blame")
local diff_flag = false
local diff_func = function()
  if diff_flag then
    vim.cmd "wincmd p | q"
    diff_flag = false
  else
    vim.cmd "Gitsigns diffthis"
    diff_flag = true
  end
end
map("n", "<leader>df", diff_func, opts "Diff this")
map("n", "<leader>dz", "<cmd>Gitsigns toggle_linehl<CR>", opts "Diff line")
