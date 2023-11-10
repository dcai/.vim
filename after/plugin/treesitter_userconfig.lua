local loaded, treesitter_config = pcall(require, 'nvim-treesitter.configs')

if not loaded then
  return
end

-- treesitter's yaml parser doesn't get along well with template vars like this:
--   {{BASE_URL}}
-- so disabling it
local disable_file_types = function(ft, buf)
  return contains({ 'yaml', 'yml' }, ft)
end
treesitter_config.setup({
  auto_install = true,
  sync_install = false,
  incremental_selection = { enable = true },
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    disable = disable_file_types,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  -- these are always installed, otherwise install on demand (when particular file type opens)
  ensure_installed = {
    'javascript',
    'typescript',
    'lua',
    'python',
    'vim',
  },
  indent = {
    enable = true,
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

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
