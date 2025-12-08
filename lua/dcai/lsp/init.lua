local M = {}
M.setup = function()
  vim.lsp.set_log_level(vim.log.levels.ERROR)
  local mason = require('mason')
  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  require('dcai.lsp.lua_ls')
  require('dcai.lsp.ts_ls')
  require('dcai.lsp.vimls')
  require('dcai.lsp.biome')
  require('dcai.lsp.gopls')
  require('dcai.lsp.bashls')
  require('dcai.lsp.pyright')
  require('dcai.lsp.tailwindcss')
  require('dcai.lsp.phpactor')
  require('dcai.lsp.dgnostics')
end

return M
