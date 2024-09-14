-- EXAMPLE 
local map = vim.keymap.set
local on_attach_lsp = function (_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>cA", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls"}
local navbuddy = require("nvim-navbuddy")
local navic = require("nvim-navic")
local on_attach = function (client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
        navbuddy.attach(client, bufnr)
    end
    on_attach_lsp(client, bufnr)
    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.ts_ls.setup {
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

lspconfig.ltex.setup({
  autostart = false,
  on_attach = on_attach,
  cmd = { "ltex-ls" },
  filetypes = { "markdown", "text" },
  flags = { debounce_text_changes = 300 },
})

-- local cap = capabilities
-- cap.textDocument.publishDiagnostics.tagSupport = { valueSet = { 2 } }
--
-- lspconfig.pyright.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   cmd = { "pyright-langserver", "--stdio" },
--   capabilities = cap,
--   single_file_support = false,
--   settings = {
--     disableLanguageServices = true,
--     python = {
--       analysis = {
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = false,
--         diagnosticMode = "workspace",
--         typeCheckingMode = "basic",
--       },
--     },
--   },
-- }

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
lspconfig.ruff_lsp.setup({
  on_attach = on_attach,
  on_init = on_init,
  root_dir = lspconfig.util.root_pattern(".git"),
  single_file_support=true,
  init_options = {
    settings = {
      args = {
        "--config=" .. vim.fn.stdpath "config" .. "/custom/lsp_config/ruff.toml"
      },
    }
  }
})
-- lspconfig.pylsp.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodesyle = {
--           enabled = false,
--         },
--         pydocstyle = {
--           enabled = false,
--         },
--         mccabe = {
--           enabled = false,
--         },
--         pyflakes = {
--           enabled = false,
--         },
--         pylint = {
--           enabled = true,
--         }, 
--         flake8 = {
--           enabled = false,
--         },
--         ruff = {
--           enabled = false,
--         },
--         }
--       }
--     }
--   }
