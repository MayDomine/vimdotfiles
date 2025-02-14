local map = vim.keymap.set
local umap = vim.keymap.del

map("n", "<leader>.", function()
  Snacks.picker.smart {
    formatters = {
      file = {
        filename_first = true,
      },
    },
    layout = {
      preview = false,
      layout = {
        backdrop = false,
        width = 0.3,
        min_width = 40,
        height = 0.57,
        min_height = 3,
        box = "horizontal",
        border = "rounded",
        title = "{title}",
        title_pos = "center",
        {
          box = "vertical",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
        },
        { win = "preview", title = "{preview}", border = "rounded" },
      },
    },
  }
end, { noremap = true, silent = true, desc = "Smart Open" })
grep =  function(opts)
  -- Snacks.picker.grep 
  opts = nil or {}
  opts = vim.tbl_deep_extend("force", opts, {
    win = {
      input = {
        keys = {
          ["<c-a>"] = {
            "toggle_line",
            mode = { "n", "i" },
          },
        },
      },
    },
    actions = {
      toggle_line = function(picker)
        local pattern = picker.input.filter.search
        Snacks.picker.grep {}
        Snacks.picker.lines { search = pattern, live = true }
      end,
    },
  })
  Snacks.picker.grep(opts)
end
lines =  function(opts)
  -- Snacks.picker.grep 
  opts = nil or {}
  opts = vim.tbl_deep_extend("force", opts, {
    win = {
      input = {
        keys = {
          ["<c-a>"] = {
            "toggle_grep",
            mode = { "n", "i" },
          },
        },
      },
    },
    actions = {
      toggle_grep = function(picker)
        local pattern = picker.input.filter.search
        Snacks.picker.lines {}
        Snacks.picker.grep { search = pattern, live = true }
      end,
    },
  })
  Snacks.picker.lines(opts)
end
map("n", "[i", function()
  Snacks.scope.jump{
            min_size = 1, -- allow single line scopes
            bottom = false,
            cursor = false,
            edge = true,
            treesitter = { blocks = { enabled = false } },
            desc = "jump to top edge of scope",
  }
end, { noremap = true, silent = true, desc = "Snacks jump top" })
map("n", "]i", function()
  Snacks.scope.jump{
            min_size = 1, -- allow single line scopes
            bottom = true,
            cursor = false,
            edge = true,
            treesitter = { blocks = { enabled = false } },
            desc = "jump to bottom edge of scope",
  }
end, { noremap = true, silent = true, desc = "scope jump bottom" })
map("n", "<c-,>", function()
  Snacks.explorer()
end, { noremap = true, silent = true, desc = "Smart Open" })
map("n", "<leader>fw", function()
  grep()
end, { noremap = true, silent = true, desc = "Snacks grep" })
map({ "n", "v" }, "<leader>fc", function()
  Snacks.picker.grep_word()
end, { noremap = true, silent = true, desc = "Snacks grep" })
map("n", "<leader>sb", function()
  Snacks.picker.grep_buffers()
end, { noremap = true, silent = true, desc = "Snacks grep" })
map("n", "<leader>sG", function()
  Snacks.picker.grep { dirs = { vim.fn.fnamemodify(vim.fn.expand "%:p", ":h") } }
end, { noremap = true, silent = true, desc = "Snacks grep" })
map("n", "<leader>sW", function()
  Snacks.picker.grep_word { dirs = { vim.fn.fnamemodify(vim.fn.expand "%:p", ":h") } }
end, { noremap = true, silent = true, desc = "Snacks grep" })
map("n", "<leader>hs", function()
  Snacks.picker.highlights()
end, { noremap = true, silent = true, desc = "Search highlights" })
map("n", "<leader>zo", function()
  Snacks.picker.zoxide()
end, { noremap = true, silent = true, desc = "Search zoxide" })
map("n", "<leader>uu", function()
  Snacks.picker.undo()
end, { noremap = true, silent = true, desc = "Search undo" })
map("n", "<leader>ma", "<cmd>Telescope man_pages<cr>", { noremap = true, silent = true, desc = "Search man pages" })
map("n", "<leader>fr", function()
  Snacks.picker.command_history()
end, { noremap = true, silent = true, desc = "Search command_history" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { noremap = true, silent = true, desc = "Search help_tags" })
map("n", "<leader>sr", function()
  Snacks.picker.resume()
end, { noremap = true, silent = true, desc = "Snacks Picker resume" })
map("n", "<leader>sR", function()
  Snacks.picker.recent()
end, { noremap = true, silent = true, desc = "Snacks Picker resume" })
map("n", "<leader>fj", function()
  Snacks.picker.jumps()
end, { noremap = true, silent = true, desc = "Snacks jump" })
map("n", "<leader>sl", function()
  lines()
end, { noremap = true, silent = true, desc = "Snacks Lines" })
map("n", "<leader>fz", function()
  Snacks.picker.lines {
    layout = {
      preset = "vscode",
    },
  }
end, { noremap = true, silent = true, desc = "Snacks Lines" })
map("n", "<leader>sc", function()
  Snacks.picker.lines {
    live = false,
    support_live = true,
    search = function(picker)
      return picker:word()
    end,
  }
end, { noremap = true, silent = true, desc = "Snacks Lines" })
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#006400" })
