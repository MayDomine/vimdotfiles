require "nvchad.mappings"
local function require_all()
  local path = vim.fn.stdpath "config" .. "/lua/mappings"
  local files = vim.fn.glob(path .. "/*.lua", true, true)
  for _, file in ipairs(files) do
    local module = file:match "([^/\\]+)%.lua$"
    if module ~= "init" then
      -- current file's parent path name
      local current_module = "mappings"
      require(current_module .. "." .. module)
    end
  end
end
-- Load all Lua files in the mappings directory except init.lua
--

nore = { noremap = true, silent = true }
map = vim.keymap.set
umap = vim.keymap.del
nmap = vim.api.nvim_set_keymap
function desc_opts(desc)
  return { desc = desc }
end

require_all()
require "mappings.telescope-keybinding"
require "mappings.basic"
require "mappings.git"
require "mappings.smart-split"
require "mappings.gp-nvim"

map("n", "<C-a>", "gg<S-v>G")
map("n", "<leader>v", "", desc_opts "")
map("n", "<leader>n", "", desc_opts "")
map("n", "<leader>nv", "<cmd>NvCheatsheet<CR>", desc_opts "NvChadCheatSheet")
-- map("n", "<C-i>", "<S-Tab>", { remap = true })

map({ "s" }, "<Tab>", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
end, desc_opts "luasnip jump-next/expand")

map({ "s" }, "<S-Tab>", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
end, desc_opts "luasnip jump-prev")

map("n", ";", ":", { desc = "CMD enter command mode" })
nmap("n", "<esc>", "<esc>", nore)
map("n", "<leader>i", function()
  require("nvim-navbuddy").open()
end, desc_opts "Navbuddy")
nmap("n", "<leader>Y", "<leader>y$", { desc = "Osc Copy To The End" })
nmap("n", "<leader>yy", "<leader>y_", { desc = "Osc Copy Line" })

map("n", "<leader>vS", "<cmd>sp<CR>", desc_opts "Split Horizontal")
map("n", "<leader>vs", "<cmd>vsp<CR>", desc_opts "Split Vertical")
-- map '+m for m
nmap("n", "'m", "m", { noremap = true })
-- map({ "t" }, "<C-w>", "<C-\\><C-n><C-w>", { noremap = true })
map({ "t" }, "<C-n>", "<C-\\><C-n>", { noremap = true })


map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>bdelete<CR><cmd>wqa<CR>", desc_opts "Exit (wqa) and SessionSave")
map("n", "<leader>qt", "<cmd>tabc<CR>", desc_opts "Close Current Tab (tabc)")

-- lsp mappings
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.reset()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    vim.cmd "LspStop"
    vim.notify("Diagnostics are now off", vim.log.levels.INFO, { title = "Diagnostics" })
  else
    vim.cmd "LspStart"
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
  "<leader>dj",
  ":call v:lua.toggle_diagnostics()<CR>",
  { noremap = true, silent = true, desc = "Toggle Diagnostics" }
)
map("n", "<leader>fs", "<cmd> AutoSession search<CR>", desc_opts "Search Session")
map({ "v", "n" }, "<leader>fm", function()
  require("conform").format()
end, desc_opts "Format Code (ruff)")

map({ "v", "n" }, "<leader>fM", function()
  require("conform").format({formatters={"isort", "black"}})
end, desc_opts "Format Code")

map({ "v", "n" }, "<leader>fm", function()
  require("conform").format()
end, desc_opts "Format Code")
map("n", "gl", "'^", desc_opts "Back to Cursor Position in Insert Mode")
map("n", "g'", "''", desc_opts "back to cursor position")
-- map("v", "%", '"hy:%s/<C-r>h//g<Left><Left><Left>', desc_opts "back to cursor position")
-- map("n", "<leader>cp", "<cmd>Copilot panel<CR>", desc_opts "Copilot Panel")
map("n", "<leader>tc", function()
  require("base46").toggle_transparency()
end, desc_opts "Toggle transparency")
umap("n", "<leader>h")
map("n", "<leader>lp", "<cmd>LspInfo<CR>", desc_opts "Lsp Info")
