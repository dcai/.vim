require('lib')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})

local vim_home = vim.fn.expand('<sfile>:p:h')
vim.cmd(f('source {vim_home}/loader.vim'))

xpcall(function()
  vim.cmd('colorscheme oasis')
end, function()
  vim.cmd('colorscheme default')
end)