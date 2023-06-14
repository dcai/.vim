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
    'kotlin',
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
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ['ic'] = {
          query = '@class.inner',
          desc = 'Select inner part of a class region',
        },
        -- You can also use captures from other query groups like `locals.scm`
        ['as'] = {
          query = '@scope',
          query_group = 'locals',
          desc = 'Select language scope',
        },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },
})
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }
