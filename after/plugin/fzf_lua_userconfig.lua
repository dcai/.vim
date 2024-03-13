local loaded, fzflua = pcall(require, 'fzf-lua')
if not loaded then
  return
end

-- default:	fzf-lua defaults, uses neovim "builtin" previewer and devicons (if available) for git/files/buffers
-- fzf-native:	utilizes fzf's native previewing ability in the terminal where possible using bat for previews
-- fzf-tmux:	similar to fzf-native and opens in a tmux popup (requires tmux > 3.2)
-- fzf-vim:	closest to fzf.vim's defaults (+icons), also sets up user commands (:Files, :Rg, etc)
-- max-perf:	similar to fzf-native and disables icons globally for max performance
-- telescope:	closest match to telescope defaults in look and feel and keybinds
-- skim:	uses skim as an fzf alternative, (requires the sk binary)
local fzf_profile = 'max-pref'

fzflua.setup({
  fzf_profile,
  fzf_opts = {
    ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-history',
  },
  files = {
    fzf_opts = {
      ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-files-history',
    },
  },
  grep = {
    fzf_opts = {
      ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-grep-history',
    },
  },
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

local function live_grep()
  fzflua.live_grep({ cwd = project_root(), multiprocess = true })
end

local function grep_cword()
  fzflua.grep_cword({ cwd = project_root() })
end

local function fzfkm(key, fn, opt)
  vim.keymap.set(
    'n',
    key,
    fn,
    vim.tbl_deep_extend('force', { noremap = true, silent = true }, opt or {})
  )
end

local fzfbookmarks = function()
  local results = require('marlin').get_indexes()
  -- local harpoon = require('harpoon')
  -- local harpoon_files = harpoon:list()
  -- local results = harpoon_files.items
  local files = {}
  for _, item in ipairs(results) do
    table.insert(
      files,
      string.format('%s:%d:%d', item.filename, item.row, item.col)
    )
  end
  fzflua.fzf_exec(files, { actions = fzflua.defaults.actions.files })
end

fzfkm('<leader>ff', fzflua.git_files)
fzfkm('<leader>fc', fzflua.colorschemes)
fzfkm('<leader>fr', fzflua.oldfiles)
fzfkm('<leader>ll', fzflua.buffers)
fzfkm('<leader>fq', fzflua.quickfix)
fzfkm('<leader>/', fzflua.builtin)
fzfkm('<leader>\\', fzflua.files)
fzfkm('<leader>.', live_grep)
fzfkm('<leader>fb', fzfbookmarks)
fzfkm('K', grep_cword)
