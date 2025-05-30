return {
  "nvim-tree/nvim-tree.lua",
  opts = function()
    return require "nvchad.configs.nvimtree"
  end,
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "nvimtree")
    opts.diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    }
    opts.select_prompts = true
    opts.filters = {
      dotfiles = false,
    }
    opts.git = {
      enable = true,
      ignore = true, -- 不忽略 .gitignore 文件中列出的文件
    }
    local map = vim.keymap.set
    local api = require "nvim-tree.api"
    opts.on_attach = function(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      map("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
      map("n", "<C-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
      map("n", "<C-k>", api.node.show_info_popup, opts "Info")
      map("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
      map("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
      map("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
      map("n", "<C-x>", api.node.open.horizontal, opts "Open: Horizontal Split")
      map("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
      map("n", "<CR>", api.node.open.edit, opts "Open")
      -- vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
      map("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
      map("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
      map("n", ".", api.node.run.cmd, opts "Run Command")
      map("n", "-", api.tree.change_root_to_parent, opts "Up")
      map("n", "a", api.fs.create, opts "Create File Or Directory")
      map("n", "bd", api.marks.bulk.delete, opts "Delete Bookmarked")
      map("n", "bt", api.marks.bulk.trash, opts "Trash Bookmarked")
      map("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
      map("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle Filter: No Buffer")
      map("n", "c", api.fs.copy.node, opts "Copy")
      map("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Filter: Git Clean")
      map("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
      map("n", "]c", api.node.navigate.git.next, opts "Next Git")
      map("n", "d", api.fs.remove, opts "Delete")
      map("n", "D", api.fs.trash, opts "Trash")
      map("n", "E", api.tree.expand_all, opts "Expand All")
      map("n", "e", api.fs.rename_basename, opts "Rename: Basename")
      map("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
      map("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
      map("n", "F", api.live_filter.clear, opts "Live Filter: Clear")
      map("n", "f", api.live_filter.start, opts "Live Filter: Start")
      map("n", "g?", api.tree.toggle_help, opts "Help")
      map("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
      map("n", "ge", api.fs.copy.basename, opts "Copy Basename")
      map("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Filter: Dotfiles")
      map("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Filter: Git Ignore")
      map("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
      map("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
      map("n", "L", api.node.open.toggle_group_empty, opts "Toggle Group Empty")
      map("n", "<c-M>", api.tree.toggle_no_bookmark_filter, opts "Toggle Filter: No Bookmark")
      map("n", "M", api.marks.toggle, opts "Toggle Bookmark")
      map("n", "o", api.node.open.edit, opts "Open")
      map("n", "O", api.node.open.no_window_picker, opts "Open: No Window Picker")
      map("n", "p", api.fs.paste, opts "Paste")
      map("n", "P", api.node.navigate.parent, opts "Parent Directory")
      map("n", "q", api.tree.close, opts "Close")
      map("n", "r", api.fs.rename, opts "Rename")
      map("n", "R", api.tree.reload, opts "Refresh")
      map("n", "s", api.node.run.system, opts "Run System")
      map("n", "S", api.tree.search_node, opts "Search")
      map("n", "u", api.fs.rename_full, opts "Rename: Full Path")
      map("n", "U", api.tree.toggle_custom_filter, opts "Toggle Filter: Hidden")
      map("n", "W", api.tree.collapse_all, opts "Collapse")
      map("n", "x", api.fs.cut, opts "Cut")
      map("n", "y", api.fs.copy.filename, opts "Copy Name")
      map("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
      map("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
      map("n", "&", api.tree.change_root_to_node, opts "CD")
    end
    local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
    vim.api.nvim_create_autocmd("User", {
      pattern = "NvimTreeSetup",
      callback = function()
        local events = require("nvim-tree.api").events
        events.subscribe(events.Event.NodeRenamed, function(data)
          if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
            data = data
            Snacks.rename.on_rename_file(data.old_name, data.new_name)
          end
        end)
      end,
    })
    require("nvim-tree").setup(opts)
  end,
  dependencies = {
    "neovim/nvim-lspconfig",
  },
}
