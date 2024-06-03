return {
  dir = vim.fn.stdpath "config" .. '/custom/plugins/vim-arsync',
  dependencies = {
    'prabirshrestha/async.vim',
  },
  lazy=false,
  pin=true
}
