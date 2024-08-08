
require "nvchad.mappings"
local function require_all()
  local path = vim.fn.expand "%:p:h"
  local files = vim.fn.glob(path .. "/*.lua", true, true)
  for _, file in ipairs(files) do
    local module = file:match "([^/\\]+)%.lua$"
    if module ~= "init" then
      -- current file's parent path name
      local current_module = vim.fn.expand "%:p:h:t"
      require(current_module .. "." .. module)
    end
  end
end
-- Load all Lua files in the mappings directory except init.lua
require_all()
require "mappings.telescope-keybinding"

local nore = { noremap = true, silent = true }
local map = vim.keymap.set
local umap = vim.keymap.del
local nmap = vim.api.nvim_set_keymap
local function opts(desc)
  return { desc = desc }
end
map("n", "<C-a>", "gg<S-v>G")
map("n", "<leader>v", "", opts "")
map("n", "<leader>n", "", opts "")
map("n", "<leader>nc", "<cmd>NvCheatsheet<CR>", opts "NvChadCheatSheet")
map("n", "<C-i>", "<S-Tab>", { remap = true })

map({ "s", "i" }, "<Tab>", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
end, opts "luasnip jump-next/expand")

map({ "s", "i" }, "<S-Tab>", function()
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
map("n", "<leader>i", "<cmd>Navbuddy<CR>", opts "Navbuddy")
nmap("n", "<leader>Y", "<leader>y$", { desc = "Osc Copy To The End" })
nmap("n", "<leader>yy", "<leader>y_", { desc = "Osc Copy Line" })

map("n", "<leader>vs", "<cmd>sp<CR>", opts "Split Horizontal")
map("n", "<leader>vv", "<cmd>vsp<CR>", opts "Split Vertical")
-- map '+m for m
nmap("n", "'m", "m", { noremap = true })
map({ "t" }, "<C-w>", "<C-\\><C-n><C-w>", { noremap = true })
map({ "n", "t" }, "<C-j>", function()
  require("nvchad.term").toggle { pos = "sp", id = "apple-toggleTerm", size = 0.3 }
end, { desc = "Terminal Toggle " })

-- map({"n", "t"}, "<C-p>", "<cmd>wincmd p<CR>", { desc = "Terminal Toggle " })
map({ "n", "t" }, "<C-p>", "", { desc = "" })
map({ "n", "t" }, "<C-p>", function()
  local win_id = require("window-picker").pick_window { hint = "floating-big-letter" }
  vim.api.nvim_set_current_win(win_id)
end, { desc = "Pick Window" })

map({ "n", "t" }, "<C-k>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "apple-vstoggleTerm", size = 0.3 }
end, { desc = "Terminal Toggle Vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal toggle Floating term" })
map("n", "<leader>db", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts "Toggle Current Line Blame")

map("n", "<leader>ld", vim.diagnostic.setloclist, opts "Lsp Loclist")
map("n", "<leader>qd", "<cmd>bdelete<CR>", opts "Delete Buffer")
map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>bdelete<CR><cmd>wqa<CR>", opts "Exit (wqa) and SessionSave")
map("n", "<leader>qt", "<cmd>tabc<CR>", opts "Close Current Tab (tabc)")

-- lsp mappings
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.reset()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    vim.cmd("LspStop")
    vim.notify("Diagnostics are now off", vim.log.levels.INFO, { title = "Diagnostics" })
  else
    vim.cmd("LspStart")
    vim.g.diagnostics_active = true
    vim.diagnostic.enable()
    vim.diagnostic.show()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = true,
    })
    vim.notify("Diagnostics are now no", vim.log.levels.INFO, { title = "Diagnostics" })
  end
end
map(
  "n",
  "<leader>td",
  ":call v:lua.toggle_diagnostics()<CR>",
  { noremap = true, silent = true, desc = "Toggle Diagnostics" }
)
map("n", "<leader>fs", require("auto-session.session-lens").search_session, opts "Search Session")
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", opts "Markdown Preview Toggle")
map("n", "<leader>mn", "<cmd>Telescope man_pages<CR>", opts "Man Page")
map("n", "<leader>mh", "<cmd>Telescope help_tags<CR>", opts "VIM Help Tags")
map("n", "gl", "'^", opts "Back to Cursor Position in Insert Mode")
map("n", "g'", "''", opts "back to cursor position")
map("v", "%", '"hy:%s/<C-r>h//g<Left><Left><Left>', opts "back to cursor position")
map("n", "<leader>cp", "<cmd>Copilot panel<CR>", opts "Copilot Panel")
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
umap("n", "<leader>h")
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
