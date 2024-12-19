return {
  "micangl/cmp-vimtex",
  event = "VeryLazy",
  opts = function()
    local cmp = require "nvchad.configs.cmp"
    cmp.sources = vim.tbl_extend("force", cmp.sources, {{ name = "vimtex"}})
  end,
  ft = {"tex", "plaintex", "bib", "bibtex"},
}