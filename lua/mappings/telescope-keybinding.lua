local map = vim.keymap.set
local function opts(desc)
  return {desc = desc }
end
local previewers = require('telescope.previewers')
local themes = require('telescope.themes')

local delta = previewers.new_termopen_previewer({
  get_command = function(entry)
    if entry.status == '??' or 'A ' then
      return { 'git', 'diff', entry.value }
    end

    return { 'git', 'diff', entry.value .. '^!' }
  end
})

local builtin = require('telescope.builtin')
map('n', '<Leader>gs', function()   builtin.git_status {
    preview = {
      hide_on_startup = true,
    },
    layout_config = {
      width = 0.3,
      height = 0.4
    },
    previewer = delta,
  }
end, { desc = "Search Git status" })
map('n', '<Leader>gS', function()   builtin.git_status {
    previewer = delta,
  }
end, { desc = "Search Git status" })
map('n', '<leader>gc', function() builtin.git_commits({ previewer = delta }) end, { desc = "Search Git Commits" })
map('n', '<leader>gb', function() builtin.git_branches({ previewer = delta }) end, { desc = "Search Git Branches" })
map('n', '<leader>gf', function() builtin.git_bcommits({ previewer = delta }) end, { desc = "Search Git Branches Related Current buffer" })
map({'n', 'v'}, '<leader>gr', function()   builtin.git_bcommits_range { previewer = delta } end, { desc = "Show git commits related to the current lines" })
map("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", { desc = "Search Treesitter" })
map('n', '<leader>fl', "<cmd>Telescope resume<CR>", opts "Resume Last Telescope")
map('n', '<leader>fp', "<cmd>Telescope pickers<CR>", opts "Telescope Cache pickers")
-- map("n", "<leader>fn", "<cmd>Telescope notify<CR>", opts "Search Noice history")
map("n", "<leader>fk", "<cmd>Telescope keymaps <CR>", opts "Search Keymaps")
map("n", "<leader>fr", "<cmd>Telescope command_history<CR>", opts "Search command_history")
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts "Search command_history")
map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts "Live Grep Args")
map('n', '<leader>fj', "<cmd>Telescope jumplist<CR>", opts "Jump List")
map('n', '<leader>fg', '<cmd>Telescope gp_picker agent<cr>', { desc = 'GP Agent Picker' })

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
map("n", "<leader>fW", ":lua require('telescope').extensions.live_grep_args.live_grep_args({search_dirs={vim.fn.expand(\"%\")}})<CR>", opts "Live grep current buffer")
map("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor, opts "Live grep word")
map("v", "<leader>fc", live_grep_args_shortcuts.grep_visual_selection, opts "Live grep visual selection")
map("v", "<leader>fC", live_grep_args_shortcuts.grep_word_visual_selection_current_buffer, opts "Live grep visual selection")

local find_all_files
find_all_files = function(_opts, no_ignore)
  _opts = _opts or {}
  no_ignore = vim.F.if_nil(no_ignore, false)
  _opts.attach_mappings = function(_, _map)
    _map({ "n", "i" }, "<C-a>", function(prompt_bufnr) -- <C-h> to toggle modes
      local prompt = require("telescope.actions.state").get_current_line()
      require("telescope.actions").close(prompt_bufnr)
      no_ignore = not no_ignore
      find_all_files({ default_text = prompt }, no_ignore)
    end)
    return true
  end

  if no_ignore then
    _opts.no_ignore = true
    _opts.hidden = true
    _opts.prompt_title = "Find Files <ALL>"
    require("telescope.builtin").find_files(_opts)
  else
    _opts.prompt_title = "Find Files"
    require("telescope.builtin").find_files(_opts)
  end
end

vim.keymap.set("n", "<leader>ff", function()
  find_all_files {
    preview = {
      hide_on_startup = true,
    },
    layout_config = {
      width = 0.5,
    },
  }
end) -- you can then bind this to whatever you want
vim.keymap.set("n", "<leader>fF", function()
  find_all_files {}
end) -- you can then bind this to whatever you want
local function search_switch(func1)
    local live_grep_args = require("telescope").extensions.live_grep_args
    if func1 == nil then
        func1 = live_grep_args.live_grep_args
    end
    local function current_buffer_live_grep_args(_opts, is_current_buffer, flag)
      _opts = _opts or {}
      _opts.attach_mappings = function(_, _map)
          _map({ "n", "i" }, "<C-a>", function(prompt_bufnr) -- <C-h> to toggle modes
            local prompt = require("telescope.actions.state").get_current_line()
            require("telescope.actions").close(prompt_bufnr)
            is_current_buffer = not is_current_buffer
            current_buffer_live_grep_args({ default_text = prompt}, is_current_buffer, 1)
          end)
          return true
      end
      if is_current_buffer then
          _opts.prompt_title = "Live Grep Args (Current Buffer)"
          local curr_path = vim.fn.expand("%")
          _opts["search_dirs"] = { curr_path }
          live_grep_args.live_grep_args(_opts)
      else
          _opts.prompt_title = "Live Grep (Args)"
          if flag == 1 then
            live_grep_args.live_grep_args(_opts)
          else
            func1(_opts)
          end
      end
    end
  return current_buffer_live_grep_args
end
local normal_grep  = live_grep_args_shortcuts.grep_word_under_cursor
local v_normal_grep = live_grep_args_shortcuts.grep_visual_selection
local normal_switch = search_switch(normal_grep)
local visual_switch = search_switch(v_normal_grep)
local simple_siwtch = search_switch()
map("n", "<leader>fc", normal_switch, opts "Live grep word")
map("v", "<leader>fc", visual_switch, opts "Live grep visual selection")
map("n", "<leader>fw", simple_siwtch, opts "Live grep args")
