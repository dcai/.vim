local M = {}
M.setup = function()
  local mason = require('mason')
  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  require('dcai.lsp.bashls')
  require('dcai.lsp.biome')
  require('dcai.lsp.copilot')
  require('dcai.lsp.dgnostics')
  require('dcai.lsp.gopls')
  require('dcai.lsp.lua_ls')
  require('dcai.lsp.phpactor')
  require('dcai.lsp.pyright')
  require('dcai.lsp.sourcekit')
  require('dcai.lsp.tailwindcss')
  require('dcai.lsp.ts_ls')
  require('dcai.lsp.vimls')
end

return M
