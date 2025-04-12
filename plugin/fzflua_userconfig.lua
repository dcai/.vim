local loaded = pcall(require, 'fzf-lua')
if not loaded then
  print('fzf-lua not loaded!')
  return
end
local actions = require('fzf-lua.actions')
local fzflua = require('fzf-lua')
local path_helper = require('fzf-lua.path')
-- vim.g.logger.trace('fzf-lua loaded, setting up...')

local icons_loaded, devicons = pcall(require, 'nvim-web-devicons')
if icons_loaded then
  devicons.setup({})
end

-- local use_icons = icons_loaded
--   and os.getenv('VIM_FZF_ENABLE_FILE_ICONS') == 'true'
local use_icons = icons_loaded
local git_icons = true
local color_icons = true
---@diagnostic disable-next-line
local history_dir = vim.g.log_dir .. '/fzf-history'
-- local rg_ignore_file = vim.fn.expand('~') .. '/.rgignore'

local do_not_reset_defaults = false
fzflua.setup({
  'fzf-native', -- profile
  winopts = {
    width = 1,
    row = 1, -- window row position (0=top, 1=bottom)
    col = 1, -- window col position (0=left, 1=right)
    height = 0.5,
    fullscreen = false,
    -- border = false,
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
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
  hls = {
    normal = 'NormalFloat',
    border = 'FloatBorder',
    title = 'FloatTitle',
    cursorline = 'CursorLine',
    gutter = 'LineNr',
  },
  keymap = {
    fzf = {
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
  -- fzf_opts = {
  --   -- set to `false` to remove a flag
  --   -- set to `true` for a no-value flag
  --   -- for raw args use `fzf_args` instead
  --   ['--info'] = 'inline-right', -- fzf < v0.42 = "inline"
  --   ['--highlight-line'] = true, -- fzf >= v0.53
  --   ['--ansi'] = true,
  --   ['--height'] = '100%',
  --   ['--layout'] = 'reverse',
  --   ['--border'] = 'sharp',
  --   ['--bind'] = 'esc:abort',
  --   ['--history'] = history_dir .. '-default.txt',
  -- },
  files = {
    actions = {
      ['enter'] = actions.file_edit,
      ['ctrl-i'] = { actions.toggle_ignore },
      ['ctrl-h'] = { actions.toggle_hidden },
      ['ctrl-g'] = false,
      ['tab'] = false,
      ['ctrl-y'] = function(selected)
        vim.fn.setreg([[*]], path_helper.entry_to_file(selected[1]).path)
      end,
    },
    -- previewer = "bat",
    prompt = 'Files❯ ',
    multiprocess = true, -- run command in a separate process
    git_icons = git_icons, -- show git icons?
    file_icons = use_icons, -- show file icons?
    color_icons = color_icons, -- colorize file|git icons
    cmd = 'rg --files --sortr=modified',
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = [[--color=never --files --hidden --follow --glob "!.git"]],
    fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
    dir_opts = [[/s/b/a:-d]],
    cwd_header = false,
    cwd_prompt = true,
    cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
    cwd_prompt_shorten_val = 1, -- shortened path parts length
    toggle_ignore_flag = '--no-ignore', -- flag toggled in `actions.toggle_ignore`
    toggle_hidden_flag = '--hidden', -- flag toggled in `actions.toggle_hidden`
    hidden = true,
    follow = true,
    no_ignore = false,
  },
  grep = {
    prompt = 'grep❯ ',
    multiprocess = true,
    git_icons = git_icons,
    file_icons = use_icons,
    color_icons = color_icons,
    cmd = nil,
    grep_opts = '--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e',
    rg_opts = '--sortr=modified --column --line-number --no-heading --color=always --smart-case '
      .. '--max-columns=4096 -e',
    rg_glob = false,
    glob_flag = '--iglob',
    glob_separator = '%s%-%-',
    -- advanced usage: for custom argument parsing define
    -- 'rg_glob_fn' to return a pair:
    --   first returned argument is the new search query
    --   second returned argument are additional rg flags
    -- rg_glob_fn = function(query, opts)
    --   ...
    --   return new_query, flags
    -- end,
    actions = {
      ['ctrl-r'] = { actions.grep_lgrep },
      ['ctrl-i'] = { actions.toggle_ignore },
      ['ctrl-g'] = false,
    },
    no_header = false, -- hide grep|cwd header?
    no_header_i = false, -- hide interactive header?
  },
  colorschemes = {
    prompt = 'Colorschemes❯ ',
    live_preview = true,
    winopts = { height = 1, width = 0.20 },
    actions = { ['enter'] = actions.colorscheme },
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
      ['enter'] = actions.colorscheme,
      ['ctrl-/'] = { fn = actions.cs_update, reload = true },
      ['ctrl-b'] = { fn = actions.toggle_bg, exec_silent = true },
      ['ctrl-g'] = false,
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
    color_icons = color_icons, -- colorize file|git icons
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
        .. [[%Cgreen(%><(10)%cs%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
      preview = 'git show --format=fuller --color {1}',
      -- git-delta is automatically detected as pager, uncomment to disable
      -- preview_pager = false,
      actions = {
        ['enter'] = function(selected, _)
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
      git_icons = git_icons, -- git status icon
      file_icons = use_icons, -- show file icons?
      color_icons = color_icons, -- colorize file|git icons
      -- force display the cwd header line regardless of your current working
      -- directory can also be used to hide the header when not wanted
      -- cwd_header = true
    },
  },
}, do_not_reset_defaults)

require('fzf-lua').register_ui_select()
