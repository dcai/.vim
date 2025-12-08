local mylsputils = require('dcai.lsp.utils')
-- php
vim.lsp.config('phpactor', {
  capabilities = mylsputils.capabilities,
  on_attach = mylsputils.common_on_attach,
  init_options = {
    ['language_server_phpstan.enabled'] = false,
    ['language_server_psalm.enabled'] = false,
  },
  root_markers = {
    'composer.lock',
    '.editorconfig',
    '.phpactor.json',
    '.phpactor.yml',
  },
})
