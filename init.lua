vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/custom/snippets/vscode"
vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/custom/snippets/snipmate"

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

vim.g.merginal_splitType=''
vim.g.merginal_showCommands=0
vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1
vim.cmd("set nu!")
vim.cmd("set rnu")
local autocmd = vim.api.nvim_create_autocmd
vim.g.hl_search = false
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
            if not vim.g.hl_search then
                vim.cmd('set nohlsearch')
            end
        end
    end
})

autocmd('CmdlineLeave', {
    pattern = '*',
    callback = function()
        if not vim.g.hl_search then
          vim.cmd('set nohlsearch')
      end
    end
})
vim.keymap.set("n", "<leader>h", "")
vim.keymap.set("n", "<leader>hl", function ()
  vim.g.hl_search = not vim.g.hl_search
  if vim.g.hl_search then
    vim.notify("Highlight Search is enabled")
    vim.cmd('set hlsearch')
  else
    vim.notify("Highlight Search is disabled")
    vim.cmd('set nohlsearch')
  end
end )
vim.cmd("set nu!")
require "flash".toggle()

vim.g.mkdp_echo_preview_url = true
