require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local function opts(desc)
  return {desc = desc }
end
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
local gs = package.loaded.gitsigns
map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
map("n", "<leader>gb", gs.blame_line, opts "Check Blame Line")

nmap("n", "'m", "m", {noremap = true})

map("n", "<leader>tt", function()
  require("nvchad.term").toggle({ pos = "sp", id ='apple-vtoggleTerm' , size = 0.3})
end, { desc = "Terminal toggle vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
map("n", "<leader>ts", "<cmd>Telescope terms<CR>", { desc = "Terminal search in Telescope" })
map('n', '<leader>gb', function() gs.blame_line{full=true} end)
map('n', '<leader>db', gs.toggle_current_line_blame, opts "Toggle Current Line Blame")
map('n', '<leader>tm', '<cmd>Telescope marks<cr>', opts "Telescope Marks")

map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts "Telescope Live Grep Args")

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor)
map("n", "<leader>fv", live_grep_args_shortcuts.grep_visual_selection)


-- local lga_actions = require("telescope-live-grep-args.actions")
-- ["<C-k>"] = lga_actions.quote_prompt(),
-- ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
 
-- map("i", "<C-k>", lga_actions.quote_prompt())
-- map("i", "<C-i>", lga_actions.quote_prompt({ postfix = "--iglob" }))
--


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
