local status, fzflua = pcall(require, 'fzf-lua')

if not status then
  return
end

fzflua.setup({
  winopts = {
    width = 1,
    row = 1,
    height = 0.5,
    hl = {
      normal = 'FzfLuaNormal', -- window normal color (fg+bg)
      border = 'FloatBorder', -- border color
      help_normal = 'Normal', -- <F1> window normal
      help_border = 'FloatBorder', -- <F1> window border
      -- Only used with the builtin previewer:
      cursor = 'Cursor', -- cursor highlight (grep/LSP matches)
      cursorline = 'CursorLine', -- cursor line
      cursorlinenr = 'CursorLineNr', -- cursor line number
      search = 'IncSearch', -- search matches (ctags|help)
      title = 'FzfLuaNormal', -- preview border title (file/buffer)
      -- Only used with 'winopts.preview.scrollbar = 'float'
      scrollfloat_e = 'PmenuSbar', -- scrollbar "empty" section highlight
      scrollfloat_f = 'PmenuThumb', -- scrollbar "full" section highlight
      -- Only used with 'winopts.preview.scrollbar = 'border'
      scrollborder_e = 'FloatBorder', -- scrollbar "empty" section highlight
      scrollborder_f = 'FloatBorder', -- scrollbar "full" section highlight
    },
    preview = {
      -- default = 'cat',
      border = 'border',
      -- hidden = 'hidden',
      title = false,
      winopts = {
        number = false,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = 'both',
        cursorcolumn = false,
        signcolumn = 'no',
        list = false,
        foldenable = false,
        foldmethod = 'manual',
      },
    },
  },
})

function fzfKeymap(key, cmd)
  vim.api.nvim_set_keymap(
    'n',
    key,
    string.format('<cmd>lua require(\'fzf-lua\').%s()<CR>', cmd),
    { noremap = true, silent = true }
  )
end
fzfKeymap('<leader>ff', 'git_files')
fzfKeymap('<leader>fr', 'oldfiles')
fzfKeymap('<leader>ll', 'buffers')
fzfKeymap('<leader>.', 'live_grep')
fzfKeymap('<leader>/', 'builtin')
fzfKeymap('K', 'grep_cword')
