require('global_utils')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})

vim.opt.cmdheight = 0

handle_vim_event_by_callback('ColorScheme', function(ev)
  local cs = ev.match or vim.g.colors_name
  set_user_config('colorscheme.name', cs)
end)

source('loader.vim')
apply_theme('oasis', true)
