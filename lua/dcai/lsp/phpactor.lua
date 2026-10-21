local mylsputils = require('dcai.lsp.utils')
-- php
vim.lsp.config('phpactor', {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  capabilities = mylsputils.get_lsp_capabilities(),
  on_attach = mylsputils.common_on_attach,
  init_options = {
    ['language_server_phpstan.enabled'] = false,
    ['language_server_psalm.enabled'] = false,
  },
  root_markers = {
    'composer.json',
    'composer.lock',
    '.editorconfig',
    '.phpactor.json',
    '.phpactor.yml',
  },
})
vim.lsp.enable(
  'phpactor',
  vim.fn.executable('phpactor') == 1 and vim.fn.executable('php') == 1
)
