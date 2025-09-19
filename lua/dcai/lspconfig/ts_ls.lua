local mylsputils = require('dcai.lspconfig.utils')

vim.lsp.config.ts_ls = {
  cmd = { 'typescript-language-server', '--log-level' , '1', '--stdio' },
  filetypes = mylsputils.ts_ls_supported_filetypes,
  root_markers = {
    'pnpm-lock.yaml',
    'package-lock.json',
    'yarn.lock',
    'bun.lock',
    '.git',
    'tsconfig.json',
    'jsconfig.json',
  },
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
  settings = {
    typescript = {
      preferences = {
        disableSuggestions = false,
      },
    },
  },
}
vim.lsp.enable('ts_ls')
