local lsp_mac_only = { "ltex-ls", "tinymist" }
local lsp_ensure_installed = {
  "lua-language-server",
  "stylua",
  "html-lsp",
  "css-lsp",
  "prettier",
  "jedi-language-server",
  "pyright",
  "bash-language-server",
  "tinymist",
  "ruff",
  "json-lsp",
  "python-lsp-server",
  "clangd",
  "taplo",
}
if vim.g.is_mac then
  lsp_ensure_installed = vim.list_extend(lsp_ensure_installed, lsp_mac_only)
end
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = lsp_ensure_installed,
  },
}
