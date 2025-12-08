local mylsputils = require('dcai.lsp.utils')

vim.lsp.config('vimls', {
  cmd = { 'vim-language-server', '--stdio' },
  capabilities = mylsputils.get_capabilities(),
  on_attach = mylsputils.common_on_attach,
  filetypes = { 'vim' },
  root_markers = { 'vimrc', '.git' },
  init_options = {
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = '',
    runtimepath = '',
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = {
        'runtime',
        'nvim',
        '.git',
        'autoload',
        'plugin',
      },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
})
vim.lsp.enable('vimls')
