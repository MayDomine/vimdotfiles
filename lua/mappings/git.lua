local map = vim.keymap.set
local function opts(desc)
  return { desc = desc }
end
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", opts "Check Blame Line")
map("n", "]h", "<cmd>Gitsigns next_hunk<CR>", opts "Next hunk")
map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", opts "Prev Hunk")
map({"v", "n"}, "ss", "<cmd>Gitsigns stage_hunk<CR>", opts "Stage hunk")
map({"v", "n"}, "su", "<cmd>Gitsigns undo_stage_hunk<CR>", opts "Stage hunk")
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
