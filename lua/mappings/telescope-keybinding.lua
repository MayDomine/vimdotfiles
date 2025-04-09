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
map('n', '<Leader>gs', function()
  Snacks.picker.git_status()
end, { desc = "Search Git status" })
map('n', '<Leader>gS', function()   builtin.git_status {
    previewer = delta,
  }
end, { desc = "Search Git status" })
map('n', '<leader>gc', function() builtin.git_commits({ previewer = delta }) end, { desc = "Search Git Commits" })
map('n', '<leader>gb', function() builtin.git_branches({ previewer = delta }) end, { desc = "Search Git Branches" })
map('n', '<leader>gB', function() builtin.git_bcommits({ previewer = delta }) end, { desc = "Search Git Branches Related Current buffer" })
map({'n', 'v'}, '<leader>gr', function()   builtin.git_bcommits_range { previewer = delta } end, { desc = "Show git commits related to the current lines" })
map("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", { desc = "Search Treesitter" })
map('n', '<leader>fp', "<cmd>Telescope pickers<CR>", opts "Telescope Cache pickers")
-- map("n", "<leader>fn", "<cmd>Telescope notify<CR>", opts "Search Noice history")
map("n", "<leader>fk", function() 
  Snacks.picker.keymaps()
end, opts "Search Keymaps")

map('n', '<leader>fg', '<cmd>Telescope gp_picker agent<cr>', { desc = 'GP Agent Picker' })


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
