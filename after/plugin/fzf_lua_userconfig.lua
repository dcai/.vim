local loaded, fzflua = pcall(require, 'fzf-lua')
if not loaded then
  print('fzf-lua not loaded!')
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
    -- set to `false` to remove a flag
    -- set to `true` for a no-value flag
    -- for raw args use `fzf_args` instead
    ['--ansi'] = true,
    ['--info'] = 'inline',
    ['--height'] = '100%',
    ['--layout'] = 'reverse',
    ['--border'] = 'none',
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
  colorschemes = {
    prompt = 'Colorschemes❯ ',
    live_preview = true, -- apply the colorscheme on preview?
    winopts = { height = 1, width = 0.20 },
    -- uncomment to ignore colorschemes names (lua patterns)
    -- ignore_patterns   = { "^delek$", "^blue$" },
    -- uncomment to execute a callback on preview|close
    -- e.g. a call to reset statusline highlights
    -- cb_preview        = function() ... end,
    -- cb_exit           = function() ... end,
  },
  git = {
    files = {
      prompt = 'GitFiles❯ ',
      cmd = 'git ls-files --exclude-standard',
      multiprocess = true, -- run command in a separate process
      git_icons = true, -- show git icons?
      file_icons = false, -- show file icons?
      color_icons = true, -- colorize file|git icons
      -- force display the cwd header line regardless of your current working
      -- directory can also be used to hide the header when not wanted
      -- cwd_header = true
    },
  },
  winopts = {
    width = 1,
    row = 1,
    height = 0.5,
    -- border = false,
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
      border = 'noborder',
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

vim.keymap.set('n', 'K', function()
  fzflua.grep_cword({ cwd = project_root() })
end, { noremap = true, silent = true })
