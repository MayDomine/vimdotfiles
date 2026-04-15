local function uniq(list)
  local seen = {}
  local out = {}
  for _, x in ipairs(list) do
    if not seen[x] then
      seen[x] = true
      table.insert(out, x)
    end
  end
  return out
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "feat/stable",
  lazy = false,
  build = ":TSUpdate | TSInstallAll",
  opts = function()
    local o = require "nvchad.configs.treesitter"
    vim.list_extend(o.ensure_installed, {
      "json",
      "bash",
      "markdown",
      "html",
      "css",
      "python",
      "c",
      "cpp",
      "cuda",
      "regex",
    })
    o.ensure_installed = uniq(o.ensure_installed)
    return o
  end,
  config = function(_, opts)
    if opts.ensure_installed and #opts.ensure_installed > 0 then
      require("nvim-treesitter").install(opts.ensure_installed)
    end
  end,
}
