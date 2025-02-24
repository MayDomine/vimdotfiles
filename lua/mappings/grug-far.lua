local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>\\", function()
  require("grug-far").open { windowCreationCommand = "vsplit | vertical resize 50%" }
end, { desc = "Open grug-far" })
