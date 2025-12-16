local map = vim.keymap.set
local umap = vim.keymap.del
map("n", "<leader>ww", function ()
  require("dict").lookup(nil, "wn")
end, { desc = "Dictionary" })

map("n", "<leader>ws", function ()
  require("dict").lookup(nil, "moby-thesaurus")
end, { desc = "Dictionary" })
