local loaded, which_key = pcall(require, 'which-key')
if not loaded then
  return
end

which_key.setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      -- adds help for operators like d, y, ... and registers them for motion / text object completion
      operators = false,
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- -- For example:
    -- ['<space>'] = 'SPC',
    -- ['<cr>'] = 'RET',
    -- ['<tab>'] = 'TAB',
  },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = 'rounded', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'left', -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = 'auto', -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
})

local function cmd(command, desc)
  return function()
    vim.cmd(command)
    if desc then
      vim.notify(desc)
    end
  end
end

local function dp(str, desc)
  return cmd(string.format('Dispatch! %s', str), desc)
end

local function open_git_hosting_web()
  require('gitlinker').get_buf_range_url('n')
end

local git_keymap = {
  name = 'git',
  -- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
  -- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", 'Next Hunk' },
  -- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", 'Prev Hunk' },
  -- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
  -- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
  -- u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", 'unstage' },
  a = { cmd('Gwrite'), 'git add' },
  A = { cmd('git add -A'), 'git add untracked' },
  b = { cmd('FzfLua git_branches'), 'Checkout branch' },
  c = { cmd('Git commit -a'), 'commit all' },
  d = { cmd('Git diff'), 'Diff' },
  f = { dp('git commit --no-verify --fixup HEAD -a'), 'fixup' },
  g = { dp('git pull --tags --rebase'), 'git pull' },
  h = { dp('git stash'), 'git stash' },
  H = { dp('git stash pop'), 'git stash pop' },
  l = { cmd('Gllog'), 'list commits' },
  m = { require('gitsigns').blame_line, 'Blame line' },
  M = { cmd('Git blame'), 'Blame' },
  p = { dp('git push -u --no-verify'), 'git push' },
  P = {
    dp('git push -u --force-with-lease --no-verify'),
    'force push with lease',
  },
  r = {
    cmd('Git rebase -i --committer-date-is-author-date origin/HEAD~5'),
    'rebase',
  },
  s = { cmd('Git'), 'git status' },
  S = { cmd('FzfLua git_status'), 'Changed files' },
  y = { open_git_hosting_web, 'open the file in web' },
}

local lsp_keymap = {
  name = 'lsp',
  a = { vim.lsp.buf.code_action, 'Code Action' },
  f = { vim.lsp.buf.format, 'Format' },
  i = { cmd('LspInfo'), 'Info' },
  r = { vim.lsp.buf.rename, 'Rename' },
  q = { require('fzf-lua').quickfix, 'linting' },
}

local mappings = {
  ['w'] = { '<cmd>w!<CR>', 'Save' },
  o = {
    name = 'open things',
    b = {
      '<Plug>(openbrowser-smart-search)',
      'search current word in browser',
    },
    d = {
      function()
        local folder = vim.fn.expand('%:p:h')
        vim.fn.execute('!open ' .. folder)
      end,
      'open in folder',
    },
    f = {
      dp('/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl %'),
      'open file in sublime',
    },
    g = { open_git_hosting_web, 'open file in git web' },
  },
  e = {
    name = 'edit things',
    s = {
      cmd('UltiSnipsEdit'),
      'edit snippet for current buffer',
    },
  },
  y = {
    name = 'yank things',
    p = {
      cmd('let @*=expand("%:p")', 'file path yanked'),
      'yank file full path',
    },
    f = {
      cmd('let @*=expand("%")'),
      'yank file name',
    },
    m = {
      cmd('let @*=execute("messages")'),
      'yank messages',
    },
  },
  r = {
    name = 'vimrc',
    e = {
      function()
        local fzf = require('fzf-lua')
        fzf.git_files({ cwd = '~/.config/nvim' })
        -- vim.cmd('e $MYVIMRC')
      end,
      'edit root vimrc',
    },
    r = {
      cmd('source $MYVIMRC'),
      'reload vimrc',
    },
    ['%'] = {
      function()
        local ft = vim.bo.filetype
        if ft == 'vim' or ft == 'lua' then
          vim.cmd('source %')
          vim.notify('current buffer sourced', vim.log.levels.WARN)
        else
          vim.notify('nothing')
        end
      end,
      'reload current buffer',
    },
  },
  g = git_keymap,
  l = lsp_keymap,
}

local opts = {
  mode = 'n', -- NORMAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

which_key.register(mappings, opts)
