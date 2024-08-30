local map = vim.keymap.set
map("n", "<leader>rl", ":s/\\v", { desc = "search and replace on line" })

map("n", "<leader>rc", function()
  local cword = vim.fn.expand("<cword>")
  local cmd = ":%s/\\v" .. cword .. "/" .. cword
  vim.api.nvim_feedkeys(cmd, "n", true)
end, { desc = "Replace current buffer" })


map("v", "<leader>rl", ":s/\\%V", { desc = "Search only in visual selection using %V atom" })

map("v", "<leader>rc", '"hy:%s/\\v<C-r>h//g<left><left>', { desc = "Replace current buffer" })

map({"i"}, "<c-i>", function()
  require("telescope.builtin").registers()
end, { noremap = true, silent = true, desc = "Show registers" })

map({"n"}, "<leader>rg", function()
  require("telescope.builtin").registers()
end, { noremap = true, silent = true, desc = "Show registers" })

map("n", "<leader>rC", function()
  local cword = vim.fn.expand("<cword>")
  local cmd = ":cdo s/" .. cword .. "/" .. cword
  vim.api.nvim_feedkeys(cmd, "n", true)
end, { desc = "Replace in quickfix list" })

