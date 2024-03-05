local loaded, fzflua = pcall(require, 'fzf-lua')
if not loaded then
  return
end

local fzf_profile = 'max-pref'

fzflua.setup({
  fzf_profile,
  winopts = {
    width = 1,
    row = 1,
    height = 0.5,
    hl = {
      normal = 'Normal', -- window normal color (fg+bg)
      border = 'FloatBorder', -- border color
      help_normal = 'Normal', -- <F1> window normal
      help_border = 'FloatBorder', -- <F1> window border
      -- Only used with the builtin previewer:
      cursor = 'Cursor', -- cursor highlight (grep/LSP matches)
      cursorline = 'CursorLine', -- cursor line
      cursorlinenr = 'CursorLineNr', -- cursor line number
      search = 'IncSearch', -- search matches (ctags|help)
      title = 'Title', -- preview border title (file/buffer)
      -- Only used with 'winopts.preview.scrollbar = 'float'
      scrollfloat_e = 'PmenuSbar', -- scrollbar "empty" section highlight
      scrollfloat_f = 'PmenuThumb', -- scrollbar "full" section highlight
      -- Only used with 'winopts.preview.scrollbar = 'border'
      scrollborder_e = 'FloatBorder', -- scrollbar "empty" section highlight
      scrollborder_f = 'FloatBorder', -- scrollbar "full" section highlight
    },
    preview_opts = 'hidden',
    preview = {
      -- default = 'cat',
      border = 'border',
      hidden = 'hidden',
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

local live_grep = function()
  local root = project_root()
  fzflua.live_grep({ cwd = root, multiprocess = true })
end

local grep_cword = function()
  local root = project_root()
  fzflua.grep_cword({ cwd = root })
end

local fzfkm = function(key, fn, opt)
  opt = opt or { noremap = true, silent = true }
  vim.keymap.set('n', key, fn, opt)
end

local fzfbookmarks = function()
  local results = require('marlin').get_indexes()
  -- local harpoon = require('harpoon')
  -- local harpoon_files = harpoon:list()
  -- local results = harpoon_files.items
  print(vim.inspect(results))
  local files = {}
  for _, item in ipairs(results) do
    table.insert(
      files,
      string.format('%s:%d:%d', item.filename, item.row, item.col)
    )
  end
  print('files: ' .. vim.inspect(files))
  fzflua.fzf_exec(files, { actions = fzflua.defaults.actions.files })
end

fzfkm('<leader>ff', fzflua.git_files)
fzfkm('<leader>fc', fzflua.colorschemes)
fzfkm('<leader>fr', fzflua.oldfiles)
fzfkm('<leader>bb', fzflua.buffers)
fzfkm('<leader>fq', fzflua.quickfix)
fzfkm('<leader>/', fzflua.builtin)
fzfkm('<leader>\\', fzflua.files)
fzfkm('<leader>.', live_grep)
fzfkm('<leader>fb', fzfbookmarks)
fzfkm('K', grep_cword)
