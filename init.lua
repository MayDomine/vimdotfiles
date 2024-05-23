vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.splitbelow=false


local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'solarized',
  -- group = ...,
  callback = function()
    vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
      fg = '#555555',
      ctermfg = 8,
      force = true
    })
  end
})

vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1
vim.cmd("set rnu")
local autocmd = vim.api.nvim_create_autocmd
vim.keymap.set('i', '<C-;>', 'copilot#Accept("\\<CR>")', {
expr = true,
replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

autocmd('CmdlineChanged', {
    pattern = '*',
    callback = function()
        if vim.fn.getcmdtype() == '/'
            or vim.fn.getcmdtype() == '?'
            or string.sub(vim.fn.getcmdline(), 1, 2) == 'g/'
            or string.sub(vim.fn.getcmdline(), 1, 3) == 'g!/'
            or string.sub(vim.fn.getcmdline(), 1, 2) == 'v/'
        then
            vim.cmd('set hlsearch')
        else
            vim.cmd('set nohlsearch')
        end
    end
})

autocmd('CmdlineLeave', {
    pattern = '*',
    callback = function()
        vim.cmd('set nohlsearch')
    end
})

