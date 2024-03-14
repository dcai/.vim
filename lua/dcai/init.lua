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
local shadafile = os.getenv('NVIM_SHADA')
if shadafile then
  vim.opt.shadafile = shadafile
end

source('loader.vim')
setup_colorscheme()
