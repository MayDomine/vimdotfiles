return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
      size = 15 * 1024 * 1024,
    },
    indent = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = { enabled = false },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  keys = {
    {
      "<leader>zz",
      function()
        Snacks.zen.zoom {
          toggles = {
            dim = true,
            git_signs = false,
            mini_diff_signs = false,
            diagnostics = false,
            inlay_hints = false,
          },
          win = { keys = {
            q = "close"
          } },
        }
        -- Snacks.zen.zoom()
      end,
      desc = "Toggle zen mode",
    },
    {
      "<leader>zm",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>sb",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>fn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bD",
      function()
        vim.notify("Delete all buffer except current one", "info", { title = "Snacks" })
        Snacks.bufdelete.other()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>ll",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>lb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>lu",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<leader>lf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>lc",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader>rf",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "]w",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
    },
    {
      "[w",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = true,
            wrap = true,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        }
      end,
    },
  },
  init = function()
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#527a7a" })
    vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#2a4a4a" })
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
        Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
        local map = vim.keymap.set
        local umap = vim.keymap.del
        Snacks.toggle.new({
          id = "gmode",
          name = "gmode",
          get = function()
            return vim.g.gmode
          end,
          set = function(state)
            if state then
              map({"n", "o", "x"}, "j", "gj", { noremap = true, desc = "Move cursor down by display line" })
              map({"n", "o", "x"}, "k", "gk", { noremap = true, desc = "Move cursor up by display line" })
              map({"n", "o", "x"}, "dd", "g0dg$", { noremap = true, desc = "Delete line in display line mode" })
              map({"n", "o", "x"}, "0", "g0", { noremap = true, desc = "Delete line in display line mode" })
              map({"n", "o", "x"}, "$", "g$", { noremap = true, desc = "Delete line in display line mode" })
              vim.g.gmode = true
            else
              umap({"n", "o", "x"}, "j")
              umap({"n", "o", "x"}, "k")
              umap({"n", "o", "x"}, "dd")
              umap({"n", "o", "x"}, "0")
              umap({"n", "o", "x"}, "$")
              vim.g.gmode = false
            end
          end,
        }):map "<leader>ug"
        Snacks.toggle.new({
          id = "lsp",
          name = "lsp",
          get = function()
            vim.g.lsp_enabled = vim.g.lsp_enabled or false
            return vim.g.lsp_enabled
            -- local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
            -- return #clients > 0
          end,
          set = function(state)
            if state then
              vim.cmd("LspStart")
              vim.g.lsp_enabled = true
            else
              vim.cmd("LspStop")
              vim.g.lsp_enabled = false
            end
          end,
        }):map "<leader>la"
        Snacks.toggle.diagnostics():map "<leader>ud"
        Snacks.toggle.line_number():map "<leader>ul"
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map "<leader>uc"
        Snacks.toggle.treesitter():map "<leader>uT"
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
        Snacks.toggle.inlay_hints():map "<leader>uh"
        Snacks.toggle.indent():map "<leader>ui"
        Snacks.toggle.dim():map "<leader>uD"
      end,
    })
  end,
}
