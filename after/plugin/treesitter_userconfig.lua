local loaded, treesitter = pcall(require, 'nvim-treesitter')
if not loaded then
  return
end
local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
local ts_textobject = require('nvim-treesitter-textobjects')

treesitter.setup({
  install_dir = vim.fn.stdpath('data') .. '/tree-sitter-parsers',
})

local ensure_installed = {
  'bash',
  'css',
  'diff',
  'fish',
  'go',
  'graphql',
  'html',
  'ini',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'python',
  'sql',
  'terraform',
  'toml',
  'typescript',
  'vim',
  'yaml',
  'zsh',
}
treesitter.install({ ensure_installed })
vim.api.nvim_create_autocmd('FileType', {
  pattern = ensure_installed,
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
  end,
})

ts_textobject.setup({
  move = {
    set_jumps = true, -- whether to set jumps in the jumplist
  },
  select = {
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    include_surrounding_whitespace = true,
  },
})

--------------------------------------------------------------------------------
-- Helper functions for textobject keymaps
--------------------------------------------------------------------------------
local function map_select(key, query, group)
  vim.keymap.set({ 'x', 'o' }, key, function()
    require('nvim-treesitter-textobjects.select').select_textobject(
      query,
      group or 'textobjects'
    )
  end)
end

local function map_move(key, method, query, group)
  vim.keymap.set({ 'n', 'x', 'o' }, key, function()
    require('nvim-treesitter-textobjects.move')[method](
      query,
      group or 'textobjects'
    )
  end)
end

local function map_move_custom(modes, key, method, query, group)
  vim.keymap.set(modes, key, function()
    require('nvim-treesitter-textobjects.move')[method](
      query,
      group or 'textobjects'
    )
  end)
end

--------------------------------------------------------------------------------
-- select keymaps
--------------------------------------------------------------------------------
-- function arguments
map_select('aa', '@parameter.outer')
map_select('ia', '@parameter.inner')
-- function/method
map_select('af', '@function.outer')
map_select('if', '@function.inner')
-- caller
map_select('ac', '@call.outer')
map_select('ic', '@call.inner')
-- comment
map_select('aC', '@comment.outer')
map_select('iC', '@comment.inner')
map_select('ab', '@block.outer')
map_select('ib', '@block.inner')

--------------------------------------------------------------------------------
--- move keymaps
--------------------------------------------------------------------------------
-- goto_next_start
map_move(']f', 'goto_next_start', '@function.outer')
map_move(']]', 'goto_next_start', '@class.outer')
-- You can also pass a list to group multiple queries.
map_move(']o', 'goto_next_start', { '@loop.inner', '@loop.outer' })
-- You can also use captures from other query groups like `locals.scm` or `folds.scm`
map_move(']s', 'goto_next_start', '@local.scope', 'locals')
map_move(']z', 'goto_next_start', '@fold', 'folds')

-- goto_next_end
map_move(']F', 'goto_next_end', '@function.outer')
map_move('][', 'goto_next_end', '@class.outer')

-- goto_previous_start
map_move('[f', 'goto_previous_start', '@function.outer')
map_move('[[', 'goto_previous_start', '@class.outer')

-- goto_previous_end
map_move('[F', 'goto_previous_end', '@function.outer')
map_move('[]', 'goto_previous_end', '@class.outer')

-- Go to either the start or the end, whichever is closer.
-- Use if you want more granular movements
map_move(']d', 'goto_next', '@conditional.outer')
map_move('[d', 'goto_previous', '@conditional.outer')

map_move(']c', 'goto_next', '@call.outer')
map_move('[c', 'goto_previous', '@call.outer')

--------------------------------------------------------------------------------
-- Repeatable move keymaps
--------------------------------------------------------------------------------

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set(
  { 'n', 'x', 'o' },
  'f',
  ts_repeat_move.builtin_f_expr,
  { expr = true }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  'F',
  ts_repeat_move.builtin_F_expr,
  { expr = true }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  't',
  ts_repeat_move.builtin_t_expr,
  { expr = true }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  'T',
  ts_repeat_move.builtin_T_expr,
  { expr = true }
)
