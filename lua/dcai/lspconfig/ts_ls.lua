local lspconfig = require('lspconfig')
local mylsputils = require('dcai.lspconfig.utils')
local root_pattern = lspconfig.util.root_pattern

lspconfig.ts_ls.setup({
  filetypes = mylsputils.ts_ls_supported_filetypes,
  root_dir = root_pattern(
    'package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git'
  ),
  cmd = { 'typescript-language-server', '--stdio' },
  commands = {
    OrganizeImports = {
      function()
        local buf = vim.api.nvim_get_current_buf()
        mylsputils.ts_ls_organize_imports(buf)
      end,
      description = 'Organize Imports',
    },
  },

  init_options = {
    hostInfo = 'neovim',
    tsserver = {
      logDirectory = vim.fn.stdpath('log') .. '/tsserver',
      logVerbosity = 'normal', -- 'off', 'terse', 'normal', 'requestTime', 'verbose'
    },
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
    preferences = {
      importModuleSpecifierPreference = 'shortest',
      includePackageJsonAutoImports = 'auto',
      quotePreference = 'auto', -- single or double or auto
    },
  },

  on_attach = mylsputils.common_on_attach,
})
