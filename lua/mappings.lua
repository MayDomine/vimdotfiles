require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local function opts(desc)
  return {desc = desc }
end
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>rh", "<cmd>Gitsigns reset_hunk<CR>", opts "Reset Hunk")
map("n", "<leader>ph", "<cmd>Gitsigns preview_hunk<CR>", opts "Preview Hunk")
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", opts "Check Blame Line")


nmap("n", "'m", "m", {noremap = true})

map("n", "<leader>tt", function()
  require("nvchad.term").toggle({ pos = "sp", id ='apple-vtoggleTerm' , size = 0.3})
end, { desc = "Terminal toggle vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Search Terminal" })
map('n', '<leader>db', "<cmd>Gitsigns toggle_current_line_blame<CR>", opts "Toggle Current Line Blame")
map('n', '<leader>fk', '<cmd>Telescope marks<cr>', opts "Search Marks")

map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts "Live Grep Args")

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor, opts "Live grep word")
map("n", "<leader>fv", live_grep_args_shortcuts.grep_visual_selection, opts "Live grep visual selection")

map("n", "<leader>fn", "<cmd>Telescope notify<CR>",
  opts "Search Noice history")
map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>wqa<CR>", opts "Exit (wqa) and SessionSave")

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
