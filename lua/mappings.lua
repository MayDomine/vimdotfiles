require "nvchad.mappings"

-- add yours here

local nore = { noremap = true , silent = true}
local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local function opts(desc)
  return {desc = desc }
end
map("n", "<C-a>", "gg<S-v>G")


map("n", ";", ":", { desc = "CMD enter command mode" })
nmap("n", "<esc>", "<esc>", nore)
map("n", "<leader>rh", "<cmd>Gitsigns reset_hunk<CR>", opts "Reset Hunk")
map("n", "<leader>ph", "<cmd>Gitsigns preview_hunk<CR>", opts "Preview Hunk")
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", opts "Check Blame Line")
map("n", "<leader>gf", "<cmd>Git<CR>", opts "Open Fugitive")
map("n", "<leader>;", "<cmd>Git<CR>", opts "Open Fugitive")
map("n", "<leader>gd", ":DiffviewOpen <C-R><C-W>")
map("n", "<leader>gm", "<cmd>Merginal<CR>")
map("n", "<leader>gl", "<cmd>Gclog<CR>")
map("v", "<leader>do", "<cmd>'<,'>diffget<CR>")


-- map '+m for m
nmap("n", "'m", "m", {noremap = true})

map("n", "<leader>tt", function()
  require("nvchad.term").toggle({ pos = "sp", id ='apple-toggleTerm' , size = 0.3})
end, { desc = "Terminal Toggle " })

map("n", "<leader>ts", function()
  require("nvchad.term").toggle({ pos = "vsp", id ='apple-vstoggleTerm' , size = 0.3})
end, { desc = "Terminal Toggle Vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Search Terminal" })
map('n', '<leader>db', "<cmd>Gitsigns toggle_current_line_blame<CR>", opts "Toggle Current Line Blame")

map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts "Live Grep Args")

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor, opts "Live grep word")
map("n", "<leader>fv", live_grep_args_shortcuts.grep_visual_selection, opts "Live grep visual selection")

map("n", "<leader>fn", "<cmd>Telescope notify<CR>",
  opts "Search Noice history")
map("n", "<leader>ld", vim.diagnostic.setloclist, opts "Lsp Loclist")
map("n", "<leader>qd", "<cmd>bdelete<CR>", opts "Delete Buffer")
map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>bdelete<CR><cmd>wqa<CR>", opts "Exit (wqa) and SessionSave")
map("n", "<leader>qt", "<cmd>tabc<CR>", opts "Close Current Tab (tabc)")

map("n", "<leader>fd", "<cmd>Telescope command_history<CR>", opts "Close Current Tab (tabc)")
map("n", "<leader>fgs", "<cmd>Telescope git_status<CR>", opts "Search Git status")
map("n", "<leader>fgc", "<cmd>Telescope git_commits<CR>", opts "Search Git Commits")
map("n", "<leader>fgb", "<cmd>Telescope git_branches<CR>", opts "Search Git Branches")
map("n", "<leader>fgr", "<cmd>Telescope git_bcommits_range<CR>", opts "Git Commits Related Current Lines")

-- trouble mappings
map("n", "<leader>xx", function() require("trouble").toggle() end)
map("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
map("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
map("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
map("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
map("n", "gR", function() require("trouble").toggle("lsp_references") end)

-- lsp mappings
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.hide()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    vim.notify("Diagnostics are now off", vim.log.levels.INFO, { title = "Diagnostics" })
  else
    vim.g.diagnostics_active = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true,
      }
    )
    vim.notify("Diagnostics are now no", vim.log.levels.INFO, { title = "Diagnostics" })
  end
end
vim.api.nvim_set_keymap('n', '<leader>td', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})


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
