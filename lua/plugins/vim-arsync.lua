return {
  dir = vim.fn.stdpath "config" .. '/custom/plugins/vim-arsync',
  dependencies = {
    'prabirshrestha/async.vim',
  },
  config = function ()
    require("vim-arsync").setup()
  end,
  lazy=false,
  pin=true
}
