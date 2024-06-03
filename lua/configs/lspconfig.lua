-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls"}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
lspconfig.jsonls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
lspconfig.bashls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}


local cap = capabilities
cap.textDocument.publishDiagnostics.tagSupport = { valueSet = { 2 } }

lspconfig.pyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = cap,
  single_file_support = false,
  settings = {
    disableLanguageServices = true,
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
      },
    },
  },
}


lspconfig.jedi_language_server.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
  },
}
vim.diagnostic.config(
  {
    virtual_text = false,
    underline = true,
    signs = true,
    update_in_insert = true,
  }
)

local ns = vim.api.nvim_create_namespace('CurlineDiag')
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd('LspAttach',{
  callback = function(args)
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = args.buf,
      callback = function()
        pcall(vim.api.nvim_buf_clear_namespace,args.buf,ns, 0, -1)
        local hi = { 'Error', 'Warn','Info','Hint'}
        local curline = vim.api.nvim_win_get_cursor(0)[1]
        local diagnostics = vim.diagnostic.get(args.buf, {lnum =curline - 1})
        local virt_texts = { { (' '):rep(4) } }
        if vim.g.diagnostic_active == false then
          return
        end
        for _, diag in ipairs(diagnostics) do
          virt_texts[#virt_texts + 1] = {diag.message, 'Diagnostic'..hi[diag.severity]}
        end
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0,{
          virt_text = virt_texts,
          hl_mode = 'combine'
        })
      end
    })
  end
})
lspconfig.pylsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  settings = {
    pylsp = {
      plugins = {
        mccabe = {
          enabled = true,
        },
        pyflakes = {
          enabled = false,
        },
      }
    }
  }
}
