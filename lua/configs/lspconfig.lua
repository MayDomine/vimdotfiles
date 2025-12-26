-- EXAMPLE
local M = {}
local map = vim.keymap.set
local on_attach_lsp = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  -- map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  -- map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  -- map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>lP", function()
    Snacks.picker.lsp_config()
  end, { noremap = true, silent = true, desc = "Lsp Config" })
  map({ "n", "v" }, "gs", function()
    Snacks.picker.lsp_workspace_symbols {
      layout = { fullscreen = true },
      search = function(picker)
        return picker:word()
      end,
    }
  end, { noremap = true, silent = true, desc = "Search workspce symbols" })
  map({ "n", "v" }, "gl", function()
    Snacks.picker.lsp_symbols {
      auto_close = false,
      layout = { preset = "ivy", preview = "man" },
    }
  end, { noremap = true, silent = true, desc = "Search lines" })
  map({ "n", "v" }, "gL", function()
    Snacks.picker.lines {
      auto_close = false,
      layout = { preset = "ivy", preview = "man" },
      pattern = function(picker)
        return picker:word()
      end,
      live = false,
    }
  end, { noremap = true, silent = true, desc = "Search lines for word" })
  map({ "n" }, "<leader>ss", function()
    Snacks.picker.lsp_symbols {}
  end, { noremap = true, silent = true, desc = "Search workspace symbols" })
  map({ "v" }, "<leader>ss", function()
    Snacks.picker.lsp_symbols {
      pattern = function(picker)
        return picker:word()
      end,
      live = true,
      supports_live = true,
      matcher = { sort_empty = false, fuzzy = false },
    }
  end, { noremap = true, silent = true, desc = "Search workspace symbols" })
  map("n", "gd", function()
  Snacks.picker.lsp_definitions {
    layout = {
      preview = "man",
      -- preset = "dropdown",
      layout = {
        backdrop = false,
        width = 0.6,
        min_width = 80,
        height = 0.8,
        border = "none",
        box = "vertical",
        { win = "preview", title = "{preview}", height = 0.7, border = "rounded" },
        {
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
      },
    },
  }
  end, { noremap = true, silent = true, desc = "Goto Definition" })
  map("n", "gD", function()
    Snacks.picker.lsp_declarations()
  end, { noremap = true, silent = true, desc = "Goto Declaration" })
  map("n", "gr", function()
    Snacks.picker.lsp_references()
  end, { noremap = true, silent = true, nowait = true, desc = "References" })
  map("n", "gi", function()
    Snacks.picker.lsp_implementations()
  end, { noremap = true, silent = true, desc = "Goto Implementation" })
  map("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
  end, { noremap = true, silent = true, desc = "Goto T[y]pe Definition" })
  map("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, {desc = "C[a]lls Incoming"} )
  map('n', "gao", function() Snacks.picker.lsp_outgoing_calls() end, {desc = "C[a]lls Outgoing"} )
  map("i", "<c-k>", vim.lsp.buf.signature_help, opts "Show signature help")
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
  map("n", "<leader>ld", function()
    local curline = vim.api.nvim_win_get_cursor(0)[1]
    local diagnostics = vim.diagnostic.get(0, { lnum = curline - 1 })
    if #diagnostics == 0 then
      vim.notify("No diagnostics on current line")
      return
    end
    if #diagnostics == 1 then
      vim.fn.setreg("+", diagnostics[1].message)
      vim.notify("Copied diagnostic to clipboard")
    else
      vim.ui.select(diagnostics, {
        prompt = "Select diagnostic to copy:",
        format_item = function(diag)
          local severity = vim.diagnostic.severity[diag.severity]
          return string.format("[%s] %s", severity, diag.message)
        end,
      }, function(selected)
        if selected then
          vim.fn.setreg("+", selected.message)
          vim.notify("Copied diagnostic to clipboard")
        end
      end)
    end
  end, opts "Copy diagnostic")
end

local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "lua_ls" }
local navbuddy = require "nvim-navbuddy"
local navic = require "nvim-navic"
M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    navbuddy.attach(client, bufnr)
  end
  on_attach_lsp(client, bufnr)
end
-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_init = on_init,
    capabilities = capabilities,
  })
end

-- typescript
vim.lsp.config("ts_ls", {
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.config("jsonls", {
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.config("bashls", {
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.config("taplo", {})

local path = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
vim.opt.spellfile = path
local words = {}

for word in io.open(path, "r"):lines() do
  table.insert(words, word)
end

vim.lsp.config("ltex", {
  autostart = false,
  capabilities = capabilities,
  settings = {
    ltex = {
      disabledRules = {
        ["en-US"] = { "PROFANITY" },
        ["en-GB"] = { "PROFANITY" },
      },
      dictionary = {
        ["en-US"] = words,
        ["en-GB"] = words,
      },
    },
  },
})

-- lspconfig.jedi_language_server.setup {
--   on_init = on_init,
--   capabilities = capabilities,
--   settings = {},
-- }

vim.diagnostic.config({
    underline = false,
    signs = true,
    virtual_text = false,
    float = true,
})
local ns = vim.api.nvim_create_namespace "CurlineDiag"
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    M.on_attach(client, args.buf)
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = args.buf,
      callback = function()
        pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
        local hi = { "Error", "Warn", "Info", "Hint" }
        local curline = vim.api.nvim_win_get_cursor(0)[1]
        local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
        local virt_texts = { { (" "):rep(4) } }
        if vim.g.diagnostic_active == false then
          return
        end
        for _, diag in ipairs(diagnostics) do
          virt_texts[#virt_texts + 1] = { diag.message, "Diagnostic" .. hi[diag.severity] }
        end
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
          virt_text = virt_texts,
          hl_mode = "combine",
        })
      end,
    })
  end,
})
vim.lsp.config("ruff", {
  on_init = on_init,
  root_dir = lspconfig.util.root_pattern ".git",
  single_file_support = true,
  init_options = {
    settings = {
      args = {
        "--config=" .. vim.fn.stdpath "config" .. "/custom/lsp_config/ruff.toml",
      },
    },
  },
})

-- lspconfig.pyright.setup {
--   {
--     on_init = on_init,
--     -- capabilities = capabilities,
--     capabilities = (function()
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 } -- Exclude TaggedHints
--       return capabilities
--     end)(),
--     capabilities = {
--       textDocument = {
--         publishDiagnostics = {
--           tagSupport = {
--             valueSet = { 2 },
--           },
--         },
--       },
--     },
--     cmd = { "pyright-langserver", "--stdio", "--options", '{"reportPossiblyUnboundVariable":"none"}' },
--     settings = {
--       python = {
--         analysis = {
--           autoSearchPaths = true,
--           useLibraryCodeForTypes = false,
--           diagnosticMode = "openFilesOnly",
--           typeCheckingMode = "basic",
--         },
--       },
--     },
--   },
-- }
vim.lsp.enable('ty')
vim.lsp.enable "clangd"
vim.lsp.config("clangd", {
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or vim.fn.getcwd()
  end,
  on_new_config = function(new_config, new_cwd)
    local status, cmake = pcall(require, "cmake-tools")
    if status then
      cmake.clangd_on_new_config(new_config)
    end
  end,
  settings = {
    clangd = {
      fallbackFlags = { "-std=c++17" },
    },
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cuda",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})
