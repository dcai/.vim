local ts_loaded, tsconfig = pcall(require, 'nvim-treesitter.configs')

if not ts_loaded then
  return
end

tsconfig.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  auth_install = true,
  ensure_installed = {
    'bash',
    'c',
    'css',
    'diff',
    'dockerfile',
    'fish',
    'graphql',
    'html',
    'http',
    'ini',
    'javascript',
    'jq',
    'jsdoc',
    'json',
    'json5',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'org',
    'terraform',
    'toml',
    'tsx',
    'twig',
    'typescript',
    'vim',
    'yaml',
  },
})
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }
