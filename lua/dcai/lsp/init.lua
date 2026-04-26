local M = {}

local servers = {
  { name = 'bashls', mason = 'bash-language-server' },
  -- { name = 'biome', mason = 'biome' },
  { name = 'copilot_language_server', mason = 'copilot-language-server' },
  { name = 'lua_ls', mason = 'lua-language-server' },
  { name = 'phpactor', mason = 'phpactor' },
  -- { name = 'pyright', mason = 'pyright' },
  { name = 'ty', mason = 'ty' },
  -- { name = 'tailwindcss', mason = 'tailwindcss-language-server' },
  { name = 'tsgo', mason = 'tsgo' },
  { name = 'ts_ls', mason = 'typescript-language-server' },
  -- { name = 'vimls', mason = 'vim-language-server' },
}

M.setup = function()
  local mason = require('mason')
  mason.setup({
    install_root_dir = vim.fs.joinpath(vim.g.data_dir, 'mason'),
  })

  vim.api.nvim_create_user_command('LspInstallAll', function()
    local packages = vim.tbl_map(function(server)
      return server.mason
    end, servers)

    vim.cmd('MasonInstall ' .. table.concat(packages, ' '))
  end, { desc = 'Install all configured LSP servers with Mason' })

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  require('dcai.lsp.bashls')
  -- require('dcai.lsp.biome')
  require('dcai.lsp.copilot')
  require('dcai.lsp.dgnostics')
  require('dcai.lsp.gopls')
  require('dcai.lsp.lua_ls')
  require('dcai.lsp.phpactor')
  require('dcai.lsp.python')
  require('dcai.lsp.sourcekit')
  -- require('dcai.lsp.tailwindcss')
  require('dcai.lsp.ts_ls')
  -- require('dcai.lsp.vimls')
end

return M
