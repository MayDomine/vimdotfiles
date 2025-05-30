-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "everforest",
  telescope = { style = "bordered" }, -- borderless / bordered
  transparency = true,
  hl_override = {
    GitSignsCurrentLineBlame = { fg = "grey" },
    TelescopeBorder = { fg = "cyan" },
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    DiffAdd = { fg = "#F9F871", bg = "#3B974A" }, -- White on green for additions
    DiffDelete = { fg = "#ffffff", bg = "#880000" }, -- White on red for deletions
    DiffText = { fg = "#F9F871", bg = "#007A7D" },
    DiffChange = { fg = "#BDBC5B", bg = "#007A7D" },
    DiffChangeDelete = { fg = "NONE", bg = "#880000" },
    CursorLine = { bg = "#1A2E3A" },
    CursorColumn = { bg = "#1A2E3A" },
  },
}
M.ui = {
  tabufline = {
    enabled= true,
    lazyload = true,
  },

  statusline = {
    enabled = true,
  },
}
M.lsp = { signature = false }
M.colorify = {
  enabled = false,
}

return M
