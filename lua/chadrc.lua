-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "kanagawa",
	hl_override = {
    GitSignsCurrentLineBlame = {gui=none, fg="grey"},
		Comment = { italic = true },
		["@comment"] = { italic = true },
    DiffAdd = { fg="#C3E88D" , bg="#204020" },
    DiffText = { fg="#000000" , bg="#42A5F5" },
    DiffDelete = { fg="#FF869A" , bg="#400020" },
    DiffChange = { fg="#FFCB6B" , bg="#554000" },
    DiffChangeDelete = { fg="#FF869A" , bg="#400020" }

	},
}

return M
