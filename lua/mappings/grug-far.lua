map("n", "<leader>\\", function()
  require("grug-far").open { windowCreationCommand = "vsplit | vertical resize 50%" }
end, { desc = "Open grug-far" })
map("n", "<leader>sc", function()
  require("grug-far").open {
    windowCreationCommand = "vsplit | vertical resize 50%",
    prefills = {
      search = vim.fn.expand "<cword>",
      replacement = "",
      filesFilter = "",
      flags = "",
      paths = "",
    },
  }
end, { desc = "Open grug-far" })
