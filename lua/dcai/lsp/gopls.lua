local mylsputils = require('dcai.lsp.utils')

if vim.fn.executable('go') == 1 then
  vim.lsp.config.gopls =
    vim.tbl_deep_extend('force', vim.lsp.config.gopls or {}, {
      capabilities = mylsputils.get_capabilities(),
      on_attach = mylsputils.common_on_attach,
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    })
  vim.lsp.enable('gopls')
else
  vim.lsp.enable('gopls', false)
end
