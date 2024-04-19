require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local function opts(desc)
  return {desc = desc }
end
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
local gs = package.loaded.gitsigns
map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")                                                         
map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
map("n", "<leader>gb", gs.blame_line, opts "Check Blame Line")

-- map("n", "<C-y>", function()
--   require("nvchad.term").toggle({ pos = "sp", id ='apple-vtoggleTerm' , size = 0.3})
-- end, { desc = "Terminal toggle vertical" })

map('n', '<leader>gb', function() gs.blame_line{full=true} end)
map('n', '<leader>db', gs.toggle_current_line_blame, opts "Toggle Current Line Blame")

-- map('n', '<leader>gs', gs.stage_hunk)
-- map('n', '<leader>gr', gs.reset_hunk)
-- map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
-- map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
-- map('n', '<leader>gS', gs.stage_buffer)
-- map('n', '<leader>gu', gs.undo_stage_hunk)
-- map('n', '<leader>gR', gs.reset_buffer)
-- map('n', '<leader>gp', gs.preview_hunk)
-- map('n', '<leader>gd', gs.diffthis)
-- map('n', '<leader>gD', function() gs.diffthis('~') end)
-- map('n', '<leader>dd', gs.toggle_deleted)
-- map({'o', 'x'}, 'ih', ':<C-U>gs select_hunk<CR>')
