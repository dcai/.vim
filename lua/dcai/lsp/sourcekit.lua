local mylsputils = require('dcai.lsp.utils')
vim.lsp.config('sourcekit', {
  cmd = {
    '/usr/bin/sourcekit-lsp',
  },
  on_attach = mylsputils.common_on_attach,
  capabilities = mylsputils.get_capabilities(),
  filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
})
vim.lsp.enable('sourcekit')
