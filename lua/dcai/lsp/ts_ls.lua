local mylsputils = require('dcai.lsp.utils')
local use_tsgo = false

local root_markers = {
  'pnpm-lock.yaml',
  'package-lock.json',
  'yarn.lock',
  'bun.lock',
  '.git',
  'tsconfig.json',
  'jsconfig.json',
}
vim.lsp.config.ts_ls = {
  -- log-level: 4 = log, 3 = info, 2 = warn, 1 = error
  cmd = { 'typescript-language-server', '--stdio', '--log-level', '1' },
  filetypes = mylsputils.ts_ls_supported_filetypes,
  capabilities = mylsputils.get_capabilities(),
  on_attach = mylsputils.common_on_attach,
  root_markers = root_markers,
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
      logVerbosity = 'off',
      -- logVerbosity = 'terse',
    },
    -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#preferences-options
    preferences = {
      importModuleSpecifierPreference = 'shortest',
      includePackageJsonAutoImports = 'auto',
      quotePreference = 'auto', -- single or double or auto
    },
  },
  settings = {
    typescript = {
      preferences = {
        disableSuggestions = false,
      },
    },
  },
}
vim.lsp.enable('ts_ls', not use_tsgo)

vim.lsp.config.tsgo = {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = mylsputils.ts_ls_supported_filetypes,
  on_attach = mylsputils.common_on_attach,
  capabilities = mylsputils.get_capabilities(),
  root_markers = root_markers,
}
vim.lsp.enable('tsgo', use_tsgo)
