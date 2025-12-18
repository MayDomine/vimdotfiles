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

require_all()
require "mappings.telescope-keybinding"
require "mappings.basic"
require "mappings.git"
require "mappings.smart-split"
require "mappings.gp-nvim"

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
-- map("n", "<C-i>", "<S-Tab>", { remap = true })

map({ "s" }, "<Tab>", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
end, opts "luasnip jump-next/expand")

map({ "s" }, "<S-Tab>", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
end, opts "luasnip jump-prev")

map("n", ";", ":", { desc = "CMD enter command mode" })
nmap("n", "<esc>", "<esc>", nore)
map("n", "<leader>i", function()
  require("nvim-navbuddy").open()
end, opts "Navbuddy")
nmap("n", "<leader>Y", "<leader>y$", { desc = "Osc Copy To The End" })
nmap("n", "<leader>yy", "<leader>y_", { desc = "Osc Copy Line" })

map("n", "<leader>vS", "<cmd>sp<CR>", opts "Split Horizontal")
map("n", "<leader>vs", "<cmd>vsp<CR>", opts "Split Vertical")
-- map '+m for m
nmap("n", "'m", "m", { noremap = true })
-- map({ "t" }, "<C-w>", "<C-\\><C-n><C-w>", { noremap = true })
map({ "t" }, "<C-n>", "<C-\\><C-n>", { noremap = true })

local capture_config_augroup = vim.api.nvim_create_augroup("CaptureFileConfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = capture_config_augroup,
  pattern = "capture",
  callback = function()
    vim.keymap.set('n', 'i', function()
      vim.cmd('bd!')
      require("nvchad.term").toggle {
        pos = "vsp",
        id = "remote-terminal",
        size = 0.5,
        cmd = remote_command,
      }
    end, { buffer = true, desc = "返回终端并关闭 capture" })
  end
})

map({"t"}, "<C-k>", function()
  local remote_conf = require("arsync.conf").load_conf()
  if remote_conf then
    local log_file_path = vim.fn.stdpath("data") .. "/arsync/remote_term_" .. remote_conf.remote_host .. "_capture.log"
    local socket_path = vim.fn.stdpath("data") .. "/arsync/remote_term_" .. remote_conf.remote_host
    local capture_cmd = "ssh " .. remote_conf.remote_host .. " -o ControlPath=" .. socket_path 
    capture_cmd = capture_cmd .. " \"tmux capture-pane -Jp -S - -E - -t nvim\"" 
    capture_cmd = capture_cmd .. " > " .. log_file_path
    vim.fn.system(capture_cmd)
    vim.cmd("edit " .. log_file_path)
    vim.bo.filetype = "capture"
  end
end, { desc = "Capture remote terminal output" })
map({ "n", "t" }, "<C-j>", function()
  local remote_conf = require("arsync.conf").load_conf()
  if remote_conf then
    local session_name = vim.fn.fnamemodify(remote_conf.local_path, ':t')
    local socket_path = vim.fn.stdpath("data") .. "/arsync/remote_term" .. remote_conf.remote_host
    local remote_command = "ssh -t " .. remote_conf.remote_host .. " -o ControlPath=" .. socket_path
    local option_table = {}
    option_table["status"] = "off"
    option_table["prefix"] = "C-a"
    local option = ""
    for key, value in pairs(option_table) do
      local opt_str = string.format("set-option -t %s %s %s \\; ", session_name, key, value)
      option = option .. opt_str
    end
    local tmux_command = "tmux " .. option
    local tmux_command = tmux_command ..  string.format("a -t %s || tmux new -s %s \\; %s", session_name, session_name, option)
    remote_command = remote_command .. string.format(" \"%s\" ", tmux_command)
    require("nvchad.term").toggle {
      pos = "vsp",
      id = "remote-terminal",
      size = 0.5,
      cmd = remote_command,
    }
  else 
    require("nvchad.term").toggle {
      pos = "sp",
      id = "apple-toggleTerm",
      size = 0.3,
    }
  end
end, { desc = "Terminal Toggle " })

-- map({"n", "t"}, "<C-p>", "<cmd>wincmd p<CR>", { desc = "Terminal Toggle " })
-- map({ "n", "t" }, "<C-k>", function()
--   require("nvchad.term").toggle { pos = "vsp", id = "apple-vstoggleTerm", size = 0.3,  cmd = "export WEZTERM_SHELL_SKIP_USER_VARS=1;zsh"}
-- end, { desc = "Terminal Toggle Vertical" })
map({ "n", "t" }, "<C-x>", function()
  Snacks.bufdelete()
end, { desc = "Terminal Toggle Vertical" })

map("n", "<leader>tf", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm", cmd = "export WEZTERM_SHELL_SKIP_USER_VARS=1;zsh" }
end, { desc = "Terminal toggle Floating term" })

map("n", "<leader>qa", "<cmd>SessionSave<CR><cmd>bdelete<CR><cmd>wqa<CR>", opts "Exit (wqa) and SessionSave")
map("n", "<leader>qt", "<cmd>tabc<CR>", opts "Close Current Tab (tabc)")

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
map("n", "<leader>fs", "<cmd> AutoSession search<CR>", opts "Search Session")
map({ "v", "n" }, "<leader>fm", function()
  require("conform").format()
end, opts "Format Code (ruff)")

map({ "v", "n" }, "<leader>fM", function()
  require("conform").format({formatters={"isort", "black"}})
end, opts "Format Code")

map({ "v", "n" }, "<leader>fm", function()
  require("conform").format()
end, opts "Format Code")
map("n", "gl", "'^", opts "Back to Cursor Position in Insert Mode")
map("n", "g'", "''", opts "back to cursor position")
-- map("v", "%", '"hy:%s/<C-r>h//g<Left><Left><Left>', opts "back to cursor position")
-- map("n", "<leader>cp", "<cmd>Copilot panel<CR>", opts "Copilot Panel")
map("n", "<leader>tc", function()
  require("base46").toggle_transparency()
end, opts "Toggle transparency")
umap("n", "<leader>h")
map("n", "<leader>lp", "<cmd>LspInfo<CR>", opts "Lsp Info")
