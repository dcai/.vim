local mylsputils = require('dcai.lsp.utils')

vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  on_attach = mylsputils.common_on_attach,
  capabilities = mylsputils.get_capabilities(),
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
})
vim.lsp.enable('bashls')
