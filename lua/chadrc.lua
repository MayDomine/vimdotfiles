-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "chadtain",
	hl_override = {
    GitSignsCurrentLineBlame = {fg="grey"},
		Comment = { italic = true },
		["@comment"] = { italic = true },
    DiffAdd = { fg = "#F9F871", bg = "#3B974A" }, -- White on green for additions
    DiffDelete = { fg = "#ffffff", bg = "#880000" }, -- White on red for deletions
    DiffText = { fg= "#F9F871", bg="#007A7D" },
    DiffChange = { fg= "#BDBC5B", bg="#007A7D" },
    DiffChangeDelete = { fg= "NONE", bg="#880000"}

	},
  tabufline = {
    lazyload = false,
  },
  nvdash = {
    load_on_startup = true,
  }
}

return M
