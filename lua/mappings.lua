require "nvchad.mappings"

-- add yours here

local nore = { noremap = true , silent = true}
local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local function opts(desc)
  return {desc = desc }
end
map("n", "<C-a>", "gg<S-v>G")
map("n", "<leader>v", "", opts "")
map("n", "<leader>n", "", opts "")
map("n", "<leader>nc", "<cmd>NvCheatsheet<CR>", opts "NvChadCheatSheet")
map("n", "<C-i>", "<S-Tab>", {remap=true})

map({"s","i"}, "<Tab>", function ()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
end, opts "luasnip jump-next/expand")

map({"s","i"}, "<S-Tab>", function ()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
end, opts "luasnip jump-prev")

map("n", ";", ":", { desc = "CMD enter command mode" })
nmap("n", "<esc>", "<esc>", nore)
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", opts "Check Blame Line")
map("n", "<leader>gg", "<cmd>Git<CR>", opts "Open Fugitive")
map("n", "<leader>;", "<cmd>Git<CR>", opts "Open Fugitive")
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", opts "Open Diffview for current cursor")
map("n", "<leader>go", "<cmd>DiffviewClose<CR>", opts "Open Diffview for current cursor")
map("n", "<leader>gm", "<cmd>Merginal<CR>", opts "Open Merginal")
map("v", "<leader>do", "<cmd>'<,'>diffget<CR>")
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", opts "Search Git status")
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", opts "Search Git Commits")
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", opts "Search Git Branches")
map("n", "<leader>gf", "<cmd>Telescope git_bcommits<CR>", opts "Search Git Branches Related Current buffer")
map("n", "<leader>gr", "<cmd>Telescope git_bcommits_range<CR>", opts "Git Commits Related Current Lines")
map("n", "<leader>i", "<cmd>Navbuddy<CR>", opts "Navbuddy")
nmap("n", "<leader>Y", "<leader>y$", {desc = "Osc Copy To The End"})
nmap("n", "<leader>yy", "<leader>y_", {desc = "Osc Copy Line"})

map("n", "<leader>vs", "<cmd>sp<CR>", opts "Split Horizontal")
map("n", "<leader>vv", "<cmd>vsp<CR>", opts "Split Vertical")
-- map '+m for m
nmap("n", "'m", "m", {noremap = true})
map({"t"}, "<C-w>", "<C-\\><C-n><C-w>", {noremap = true})
map({"n", "t"}, "<C-j>", function()
  require("nvchad.term").toggle({ pos = "sp", id ='apple-toggleTerm' , size = 0.3})
end, { desc = "Terminal Toggle " })

-- map({"n", "t"}, "<C-p>", "<cmd>wincmd p<CR>", { desc = "Terminal Toggle " })
map({"n", "t"}, "<C-p>", "", { desc = "" })
map({"n", "t"}, "<C-p>", function ()
        local win_id = require("window-picker").pick_window({hint = 'floating-big-letter'})
        vim.api.nvim_set_current_win(win_id)
        end, { desc = "Pick Window" })

map({"n", "t"}, "<C-k>", function()
require("nvchad.term").toggle({ pos = "vsp", id ='apple-vstoggleTerm' , size = 0.3})
end, { desc = "Terminal Toggle Vertical" })

map("n", "<leader>tf", function()
require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
map("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", { desc = "Search Treesitter" })
map('n', '<leader>db', "<cmd>Gitsigns toggle_current_line_blame<CR>", opts "Toggle Current Line Blame")

map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts "Live Grep Args")
map('n', '<leader>fl', "<cmd>Telescope resume<CR>", opts "Resume Last Telescope")

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
map("n", "<leader>fz", ":lua require('telescope').extensions.live_grep_args.live_grep_args({search_dirs={vim.fn.expand(\"%\")}})<CR>", opts "Live grep current buffer")
map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor, opts "Live grep word")
map("n", "<leader>fC", live_grep_args_shortcuts.grep_word_under_cursor_current_buffer, opts "Live grep word")
map("v", "<leader>fc", live_grep_args_shortcuts.grep_visual_selection, opts "Live grep visual selection")
map("v", "<leader>fC", live_grep_args_shortcuts.grep_word_visual_selection_current_buffer, opts "Live grep visual selection")

map("n", "<leader>fn", "<cmd>Telescope notify<CR>", opts "Search Noice history")
map("n", "<leader>fk", "<cmd>Telescope keymaps <CR>", opts "Search Keymaps")
map("n", "<leader>fh", "<cmd>Telescope command_history<CR>", opts "Search command_history")
map("n", "<leader>ld", vim.diagnostic.setloclist, opts "Lsp Loclist")
map("n", "<leader>qd", "<cmd>bdelete<CR>", opts "Delete Buffer")
map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>bdelete<CR><cmd>wqa<CR>", opts "Exit (wqa) and SessionSave")
map("n", "<leader>qt", "<cmd>tabc<CR>", opts "Close Current Tab (tabc)")

local my_find_files
my_find_files = function(opts, no_ignore)
  opts = opts or {}
  no_ignore = vim.F.if_nil(no_ignore, false)
  opts.attach_mappings = function(_, map)
    map({ "n", "i" }, "<C-a>", function(prompt_bufnr) -- <C-h> to toggle modes
      local prompt = require("telescope.actions.state").get_current_line()
      require("telescope.actions").close(prompt_bufnr)
      no_ignore = not no_ignore
      my_find_files({ default_text = prompt }, no_ignore)
    end)
    return true
  end

  if no_ignore then
    opts.no_ignore = true
    opts.hidden = true
    opts.prompt_title = "Find Files <ALL>"
    require("telescope.builtin").find_files(opts)
  else
    opts.prompt_title = "Find Files"
    require("telescope.builtin").find_files(opts)
  end
end

vim.keymap.set("n", "<leader>ff", my_find_files) -- you can then bind this to whatever you want

-- lsp mappings
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
if vim.g.diagnostics_active then
  vim.g.diagnostics_active = false
  vim.diagnostic.reset()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  vim.notify("Diagnostics are now off", vim.log.levels.INFO, { title = "Diagnostics" })
else
  vim.g.diagnostics_active = true
  vim.diagnostic.enable()
  vim.diagnostic.show()
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
map('n', '<leader>td', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true, desc = "Toggle Diagnostics"})
map('v', '<C-r>', "y<ESC><cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({search_dirs={vim.fn.expand(\"%\")}})<CR><C-R>\"", {remap=true})
-- :cdo %s//g<left

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
