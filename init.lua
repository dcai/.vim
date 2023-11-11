require('global_utils')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})

vim.opt.cmdheight = 0

handle_vim_event('ColorScheme', function()
  set_config('colorscheme.name', vim.g.colors_name)
end)

source('loader.vim')
apply_theme('oasis', true)
