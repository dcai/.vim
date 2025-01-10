local loaded, fzflua = pcall(require, 'fzf-lua')
if not loaded then
  print('fzf-lua not loaded!')
  return
end
local actions = require('fzf-lua.actions')
-- LOG.trace('fzf-lua loaded, setting up...')

local icons_loaded, devicons = pcall(require, 'nvim-web-devicons')
if icons_loaded then
  devicons.setup({})
end

local use_icons = icons_loaded
  and os.getenv('VIM_FZF_ENABLE_FILE_ICONS') == 'true'

-- default:	fzf-lua defaults, uses neovim "builtin" previewer and devicons (if available) for git/files/buffers
-- fzf-native:	utilizes fzf's native previewing ability in the terminal where possible using bat for previews
-- fzf-tmux:	similar to fzf-native and opens in a tmux popup (requires tmux > 3.2)
-- fzf-vim:	closest to fzf.vim's defaults (+icons), also sets up user commands (:Files, :Rg, etc)
-- max-perf:	similar to fzf-native and disables icons globally for max performance
-- telescope:	closest match to telescope defaults in look and feel and keybinds
-- skim:	uses skim as an fzf alternative, (requires the sk binary)
-- local fzf_profile = 'max-perf'
local fzf_profile = 'fzf-native'
local history_dir = vim.g.data_dir .. '/fzf-history'
-- local rg_ignore_file = vim.fn.expand('~') .. '/.rgignore'
local rg_grep_opt =
  '--column --line-number --no-heading --color=always --smart-case --max-columns=4096'

fzflua.setup({
  fzf_profile,
  winopts = {
    width = 1,
    row = 1, -- window row position (0=top, 1=bottom)
    col = 1, -- window col position (0=left, 1=right)
    height = 0.5,
    fullscreen = false, -- start fullscreen?
    border = false,
    -- border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    hls = {
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
    preview = {
      default = 'bat',
      -- border = 'noborder',
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
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      ['<F1>'] = 'toggle-help',
      ['<F2>'] = 'toggle-fullscreen',
      -- Only valid with the 'builtin' previewer
      ['<F3>'] = 'toggle-preview-wrap',
      ['<F4>'] = 'toggle-preview',
      -- Rotate preview clockwise/counter-clockwise
      ['<F5>'] = 'toggle-preview-ccw',
      ['<F6>'] = 'toggle-preview-cw',
      ['<S-down>'] = 'preview-page-down',
      ['<S-up>'] = 'preview-page-up',
      ['<S-left>'] = 'preview-page-reset',
    },
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-z'] = 'abort',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['alt-a'] = 'toggle-all',
      ['ctrl-n'] = 'half-page-down',
      ['ctrl-p'] = 'half-page-up',
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ['f3'] = 'toggle-preview-wrap',
      ['ctrl-/'] = 'toggle-preview',
      ['ctrl-f'] = 'preview-page-down',
      ['ctrl-b'] = 'preview-page-up',
    },
  },
  actions = {
    -- These override the default tables completely
    -- no need to set to `false` to disable an action
    -- delete or modify is sufficient
    files = {
      -- providers that inherit these actions:
      --   files, git_files, git_status, grep, lsp
      --   oldfiles, quickfix, loclist, tags, btags
      --   args
      -- default action opens a single selection
      -- or sends multiple selection to quickfix
      -- replace the default action with the below
      -- to open all files whether single or multiple
      -- ["default"]     = actions.file_edit,
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-s'] = actions.file_split,
      ['ctrl-v'] = actions.file_vsplit,
      -- ['ctrl-t'] = actions.file_tabedit,
      ['ctrl-i'] = { actions.toggle_ignore },
      ['alt-q'] = actions.file_sel_to_qf,
      ['alt-l'] = actions.file_sel_to_ll,
    },
    buffers = {
      -- providers that inherit these actions:
      --   buffers, tabs, lines, blines
      ['default'] = actions.buf_edit,
      ['ctrl-s'] = actions.buf_split,
      ['ctrl-v'] = actions.buf_vsplit,
      ['ctrl-t'] = actions.buf_tabedit,
    },
  },
  fzf_opts = {
    -- set to `false` to remove a flag
    -- set to `true` for a no-value flag
    -- for raw args use `fzf_args` instead
    ['--info'] = 'inline-right', -- fzf < v0.42 = "inline"
    ['--highlight-line'] = true, -- fzf >= v0.53
    ['--ansi'] = true,
    ['--height'] = '100%',
    ['--layout'] = 'reverse',
    ['--border'] = 'sharp',
    ['--history'] = history_dir .. '-default.txt',
  },
  defaults = {
    -- formatter = 'path.filename_first',
  },
  files = {
    -- previewer      = "bat",          -- uncomment to override previewer
    -- (name from 'previewers' table)
    -- set to 'false' to disable
    prompt = 'Files❯ ',
    multiprocess = true, -- run command in a separate process
    git_icons = true, -- show git icons?
    file_icons = true, -- show file icons?
    color_icons = true, -- colorize file|git icons
    -- path_shorten   = 1,              -- 'true' or number, shorten path?
    -- Uncomment for custom vscode-like formatter where the filename is first:
    -- e.g. "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
    -- formatter      = "path.filename_first",
    -- executed command priority is 'cmd' (if exists)
    -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
    -- default options are controlled by 'fd|rg|find|_opts'
    -- NOTE: 'find -printf' requires GNU find
    -- cmd = "find . -type f -printf '%P\n'",
    cmd = 'rg --files --sortr=modified',
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
    fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
    fzf_opts = {
      ['--history'] = history_dir .. '-files.txt',
    },
    -- by default, cwd appears in the header only if {opts} contain a cwd
    -- parameter to a different folder than the current working directory
    -- uncomment if you wish to force display of the cwd as part of the
    -- query prompt string (fzf.vim style), header line or both
    -- cwd_header = true,
    cwd_prompt = true,
    cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
    cwd_prompt_shorten_val = 1, -- shortened path parts length
    toggle_ignore_flag = '--no-ignore', -- flag toggled in `actions.toggle_ignore`
    actions = {
      -- inherits from 'actions.files', here we can override
      -- or set bind to 'false' to disable a default action
      -- action to toggle `--no-ignore`, requires fd or rg installed
      ['ctrl-i'] = { actions.toggle_ignore },
      -- uncomment to override `actions.file_edit_or_qf`
      --   ["default"]   = actions.file_edit,
      -- custom actions are available too
      --   ["ctrl-y"]    = function(selected) print(selected[1]) end,
    },
  },
  grep = {
    prompt = 'grep❯ ',
    multiprocess = true, -- run command in a separate process
    git_icons = true, -- show git icons?
    file_icons = use_icons, -- show file icons?
    color_icons = true, -- colorize file|git icons
    -- executed command priority is 'cmd' (if exists)
    -- otherwise auto-detect prioritizes `rg` over `grep`
    -- default options are controlled by 'rg|grep_opts'
    -- cmd            = "rg --vimgrep",
    grep_opts = '--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e',
    rg_opts = rg_grep_opt,
    -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
    -- search strings will be split using the 'glob_separator' and translated
    -- to '--iglob=' arguments, requires 'rg'
    -- can still be used when 'false' by calling 'live_grep_glob' directly
    rg_glob = false, -- default to glob parsing?
    glob_flag = '--iglob', -- for case sensitive globs use '--glob'
    glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
    -- advanced usage: for custom argument parsing define
    -- 'rg_glob_fn' to return a pair:
    --   first returned argument is the new search query
    --   second returned argument are additional rg flags
    -- rg_glob_fn = function(query, opts)
    --   ...
    --   return new_query, flags
    -- end,
    actions = {
      -- actions inherit from 'actions.files' and merge
      -- this action toggles between 'grep' and 'live_grep'
      ['ctrl-r'] = { actions.grep_lgrep },
      -- uncomment to enable '.gitignore' toggle for grep
      ['ctrl-i'] = { actions.toggle_ignore },
    },
    no_header = false, -- hide grep|cwd header?
    no_header_i = false, -- hide interactive header?
    fzf_opts = {
      ['--history'] = history_dir .. '-grep.txt',
    },
  },
  colorschemes = {
    prompt = 'Colorschemes❯ ',
    live_preview = true,
    winopts = { height = 1, width = 0.20 },
    actions = { ['default'] = actions.colorscheme },
    -- uncomment to ignore colorschemes names (lua patterns)
    -- ignore_patterns   = { "^delek$", "^blue$" },
    -- uncomment to execute a callback on preview|close
    -- e.g. a call to reset statusline highlights
    -- cb_preview        = function() ... end,
    -- cb_exit           = function() ... end,
  },
  awesome_colorschemes = {
    prompt = 'Colorschemes❯ ',
    live_preview = true,
    max_threads = 5,
    winopts = { row = 0, col = 0.99, width = 0.50 },
    fzf_opts = {
      ['--info'] = 'default',
      ['--multi'] = true,
      ['--delimiter'] = '[:]',
      ['--with-nth'] = '3..',
      ['--tiebreak'] = 'index',
    },
    actions = {
      ['default'] = actions.colorscheme,
      ['ctrl-/'] = { fn = actions.cs_update, reload = true },
      ['ctrl-g'] = { fn = actions.toggle_bg, exec_silent = true },
      ['ctrl-x'] = { fn = actions.cs_delete, reload = true },
    },
    -- uncomment to execute a callback on preview|close
    -- cb_preview = function() end,
    -- cb_exit = function() end,
  },
  oldfiles = {
    prompt = 'oldfiles❯ ',
    cwd_only = false,
    stat_file = true, -- verify files exist on disk
    include_current_session = false, -- include bufs from current session
  },
  buffers = {
    prompt = 'Buffers❯ ',
    file_icons = use_icons, -- show file icons?
    color_icons = false, -- colorize file|git icons
    sort_lastused = true, -- sort buffers() by last used
    show_unloaded = true, -- show unloaded buffers
    cwd_only = false, -- buffers for the cwd only
    cwd = nil, -- buffers list for a given dir
    actions = {
      -- actions inherit from 'actions.buffers' and merge
      -- by supplying a table of functions we're telling
      -- fzf-lua to not close the fzf window, this way we
      -- can resume the buffers picker on the same window
      -- eliminating an otherwise unaesthetic win "flash"
      ['ctrl-x'] = { fn = actions.buf_del, reload = true },
    },
  },
  git = {
    icons = {
      ['M'] = { icon = 'M', color = 'yellow' },
      ['D'] = { icon = 'D', color = 'red' },
      ['A'] = { icon = 'A', color = 'green' },
      ['R'] = { icon = 'R', color = 'yellow' },
      ['C'] = { icon = 'C', color = 'yellow' },
      ['T'] = { icon = 'T', color = 'magenta' },
      ['?'] = { icon = '?', color = 'magenta' },
      -- override git icons?
      -- ["M"]        = { icon = "★", color = "red" },
      -- ["D"]        = { icon = "✗", color = "red" },
      -- ["A"]        = { icon = "+", color = "green" },
    },
    commits = {
      prompt = 'Commits❯ ',
      winopts = {
        height = 1,
        fullscreen = true,
        preview = { hidden = 'nohidden' },
      },
      cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
        .. [[%Cgreen(%><(12)%ch%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
      preview = 'git show --format=fuller --color {1}',
      -- git-delta is automatically detected as pager, uncomment to disable
      -- preview_pager = false,
      actions = {
        ['default'] = function(selected, _)
          local line = selected[1]
          local commit_hash = line:match('[^ ]+')
          vim.cmd('Git show --format=fuller ' .. commit_hash)
        end,
        ['ctrl-u'] = function(selected, _)
          local line = selected[1]
          vim.fn.setreg([[+]], line)
        end,
        -- remove `exec_silent` or set to `false` to exit after yank
        ['ctrl-y'] = { fn = actions.git_yank_commit, exec_silent = true },
      },
    },
    files = {
      prompt = 'GitFiles❯ ',
      cmd = 'git ls-files --exclude-standard',
      multiprocess = true,
      git_icons = true, -- git status icon
      file_icons = use_icons, -- show file icons?
      color_icons = true, -- colorize file|git icons
      -- force display the cwd header line regardless of your current working
      -- directory can also be used to hide the header when not wanted
      -- cwd_header = true
    },
  },
})
