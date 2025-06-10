local lspconfig = require('lspconfig')
local mylsputils = require('dcai.lspconfig.utils')
local root_pattern = lspconfig.util.root_pattern

local tslsconfig = {
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
        mylsputils.ts_ls_organize_imports()
      end,
      description = 'Organize Imports',
    },
  },

  init_options = {
    hostInfo = 'neovim',
    tsserver = {
      logDirectory = vim.g.log_dir .. '/tsserver',
      ---@type string 'off'|'terse'|'normal'|'requestTime'|'verbose'
      logVerbosity = 'terse',
    },
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
    preferences = {
      importModuleSpecifierPreference = 'shortest',
      includePackageJsonAutoImports = 'auto',
      quotePreference = 'auto', -- single or double or auto
    },
  },

  on_attach = mylsputils.common_on_attach,
}

if mylsputils.support_native_lsp_config() then
  vim.lsp.enable('ts_ls')
  vim.lsp.config(tslsconfig)
else
  lspconfig.ts_ls.setup(tslsconfig)
end
