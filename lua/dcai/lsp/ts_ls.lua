local mylsputils = require('dcai.lsp.utils')

vim.lsp.config.ts_ls = {
  -- log-level: 4 = log, 3 = info, 2 = warn, 1 = error
  cmd = { 'typescript-language-server', '--stdio', '--log-level', '1' },
  filetypes = mylsputils.ts_ls_supported_filetypes,
  capabilities = mylsputils.get_lsp_capabilities(),
  on_attach = mylsputils.common_on_attach,
  root_markers = mylsputils.ts_root_markers,
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
