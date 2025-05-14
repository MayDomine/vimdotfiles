local map = vim.keymap.set
local umap = vim.keymap.del
map("n", "<leader>rl", ":s@\\v@", { desc = "search and replace on line" })

map("n", "<leader>rc", function()
  local cword = vim.fn.expand("<cword>"):gsub("/", "\\/")
  local cmd = string.format(":%s@\\V%s@%s@g<left><left>", "%s", cword, cword)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", true)
end, { desc = "Replace current buffer" })

map("n", "<leader>rs", ":%s@\\V@@g<left><left><left>", { desc = "Search and replace in the entire file" })
map("v", "<leader>rs", ":s@\\v@@g<left><left><left>", { desc = "Search and replace in the visual selection" })
map("v", "<leader>rl", ":s@\\%V@", { desc = "Search only in visual selection using %V atom" })
map("n", "<C-i>", "<C-i>", { noremap = true, desc = "<C-i>" })
map("v", "gJ", "gJ", { noremap = true, desc = "Join lines without space" })
-- map("n", "<M-i>", "<M-i>", { noremap = true, desc = "Clear" })
map("v", "<leader>rc", '"hy:%s@\\v<C-r>h@\\/<C-r>h@g<left><left>', { desc = "Replace current buffer with original text, replacing '/' with '\\/'" })

map({ "i" }, "<c-y>", function()
  require("telescope.builtin").registers({ layout_config = { height = 0.9, width = 0.6 } })
end, { noremap = true, silent = true, desc = "Show registers in dropdown" })

map({ "n" }, "<leader>rg", function()
  require("telescope.builtin").registers()
end, { noremap = true, silent = true, desc = "Show registers" })

map("n", "<leader>rC", function()
  local cword = vim.fn.expand "<cword>"
  local cmd = ":cdo s@" .. cword .. "@" .. cword
  vim.api.nvim_feedkeys(cmd, "n", true)
  
end, { desc = "Replace in quickfix list" })
map("n", "B", "M", { noremap = true, desc = "Move to the middle of the screen" })

map("n", "<leader>ys", function()
  local yank_cmd = vim.fn.getreg "0"
  local search_cmd = "/" .. vim.fn.escape(yank_cmd, "/")
  vim.cmd(search_cmd)
  -- vim.api.nvim_feedkeys(search_cmd, "n", true)
end, { desc = "Yank to search" })

map("i", "<C-o>", '<C-r>"')

map("n", "<A-;>", "gT", { noremap = true, silent = true, desc = "Next tab" })
map("n", "<A-'>", "gt", { noremap = true, silent = true, desc = "Previous tab" })
map("n", "<A-:>", "<cmd>bp<CR>", { noremap = true, silent = true, desc = "Previous buf" })
map("n", '<A-">', "<cmd>bn<CR>", { noremap = true, silent = true, desc = "Next buf" })
vim.api.nvim_set_keymap(
  "n",
  "<leader>cF",
  ':let @+ = expand("%:t")<CR>',
  { noremap = true, silent = true, desc = "Copy current buffer filename" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cg",
  ':let @+ = expand("%:p")<CR>',
  { noremap = true, silent = true, desc = "Copy current buffer path" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>cG",
  ':let @+ = expand("%")<CR>',
  { noremap = true, silent = true, desc = "Copy current buffer relative path" }
)
map("n", "<leader>lz", "<cmd>Lazy<CR>", { desc = "lazy.nvim" })
map("n", "<leader>ms", "<cmd>Mason<CR>", { desc = "Mason" })
api = require("nvim-tree.api")
map("n", "<C-e>", function() api.tree.toggle({
      focus = false,
    }) end, { desc = "Toggle NvimTree" })
