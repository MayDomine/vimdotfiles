local map = vim.keymap.set
map("n", "<leader>rl", ":s/\\v", { desc = "search and replace on line" })

map("n", "<leader>rc", function()
  local cword = vim.fn.expand("<cword>")
  local cmd = ":%s/\\v" .. cword .. "/" .. cword
  vim.api.nvim_feedkeys(cmd, "n", true)
end, { desc = "Replace current buffer" })


map("v", "<leader>rl", ":s/\\%V", { desc = "Search only in visual selection using %V atom" })
map("n", "<C-i>", "<C-i>", { noremap = true })
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

map("n", "<leader>ar",  "<cmd>ARsyncUp<CR>",{ desc = "ARsyncUp To Remote" })
map("n", "<leader>ad",  "<cmd>ARsyncDown<CR>",{ desc = "ARsyncDown From Remote" })
map("n", "<leader>as",  "<cmd>ARshowConf<CR>",{ desc = "ARsync Show Conf" })
map("n", "<leader>ac",  "<cmd>ARCreate<CR>",{ desc = "ARsyncUp Config Create" })
map("n", "<leader>ys",  function ()
  local yank_cmd = vim.fn.getreg("0")
  local search_cmd = "/" .. vim.fn.escape(yank_cmd, "/")
  vim.cmd(search_cmd)
  -- vim.api.nvim_feedkeys(search_cmd, "n", true)
end,{ desc = "Yank to search" })

map("i", "<C-o>", "<C-r>\"")




