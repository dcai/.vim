local loaded, treesitter = pcall(require, 'nvim-treesitter')
if not loaded then
  return
end
local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
local ts_textobject = require('nvim-treesitter-textobjects')

treesitter.setup({
  install_dir = vim.fn.stdpath('data') .. '/tree-sitter-parsers',
})

local parser_filetypes = {
  { parser = 'bash', filetypes = { 'sh' } },
  { parser = 'css', filetypes = { 'css' } },
  { parser = 'diff', filetypes = { 'diff' } },
  { parser = 'fish', filetypes = { 'fish' } },
  { parser = 'git_config', filetypes = { 'gitconfig' } },
  { parser = 'git_rebase', filetypes = { 'gitrebase' } },
  { parser = 'gitattributes', filetypes = { 'gitattributes' } },
  { parser = 'gitcommit', filetypes = { 'gitcommit' } },
  { parser = 'gitignore', filetypes = { 'gitignore' } },
  { parser = 'go', filetypes = { 'go' } },
  { parser = 'graphql', filetypes = { 'graphql' } },
  { parser = 'html', filetypes = { 'html' } },
  { parser = 'ini', filetypes = { 'ini' } },
  { parser = 'javascript', filetypes = { 'javascript', 'javascriptreact' } },
  { parser = 'jsdoc', filetypes = { 'jsdoc' } },
  { parser = 'json', filetypes = { 'json' } },
  { parser = 'lua', filetypes = { 'lua' } },
  { parser = 'make', filetypes = { 'make' } },
  { parser = 'markdown', filetypes = { 'markdown' } },
  { parser = 'markdown_inline', filetypes = { 'markdown' } },
  { parser = 'python', filetypes = { 'python' } },
  { parser = 'sql', filetypes = { 'sql' } },
  { parser = 'terraform', filetypes = { 'terraform' } },
  { parser = 'toml', filetypes = { 'toml' } },
  { parser = 'tsx', filetypes = { 'typescriptreact' } },
  { parser = 'typescript', filetypes = { 'typescript', 'typescriptreact' } },
  { parser = 'swift', filetypes = { 'swift' } },
  { parser = 'vim', filetypes = { 'vim' } },
  { parser = 'yaml', filetypes = { 'yaml' } },
  { parser = 'zsh', filetypes = { 'zsh' } },
}

local ensure_installed = vim.tbl_map(function(entry)
  return entry.parser
end, parser_filetypes)

local vim_filetypes = {}
local seen_filetypes = {}

for _, entry in ipairs(parser_filetypes) do
  for _, filetype in ipairs(entry.filetypes) do
    if not seen_filetypes[filetype] then
      seen_filetypes[filetype] = true
      table.insert(vim_filetypes, filetype)
    end
  end
end

treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim_filetypes,
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
local all_modes = { 'n', 'x', 'o' }
local function map_select(key, query, group)
  vim.keymap.set({ 'x', 'o' }, key, function()
    require('nvim-treesitter-textobjects.select').select_textobject(
      query,
      group or 'textobjects'
    )
  end)
end

local function map_move(key, method, query, group)
  vim.keymap.set(all_modes, key, function()
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
vim.keymap.set(all_modes, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set(all_modes, ',', ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set(all_modes, ';', ts_repeat_move.repeat_last_move)
-- vim.keymap.set(all_modes, ',', ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set(all_modes, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set(all_modes, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set(all_modes, 't', ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set(all_modes, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
