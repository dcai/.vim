require('dcai.utils')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '~/.local/share/nvim/venv/bin/python3',
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
vim.g.node_host_prog = find_executable({
  '~/.npm-packages/bin/neovim-node-host',
})

-- vim.opt.cmdheight = 0

handle_vim_event_by_callback('ColorScheme', function(ev)
  local cs = ev.match or vim.g.colors_name
  set_user_config('colorscheme.name', cs)
end)

source('loader.vim')
setup_colorscheme()