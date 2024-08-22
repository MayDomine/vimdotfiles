local map = vim.keymap.set
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<leader>rl", ":s/\\v", { desc = "search and replace on line" })
map('n', '<leader>rc', ':%s/\\v',                            { desc = "search and replace in file" })
map('v', '<leader>rl', ':s/\\%V',                 { desc = "Search only in visual selection using %V atom" })
map('v', '<leader>rc', '"hy:%s/\\v<C-r>h//g<left><left>', { desc = "change selection" })
map("i", "<c-b>", function()
  require("telescope.builtin").registers()
end, { noremap = true, silent = true, desc = "Show registers" })

