local loaded, which_key = pcall(require, 'which-key')
if not loaded then
  print('which-key not loaded')
  return
end
local pjob = require('plenary.job')
local fzf = require('fzf-lua')
local marlin = require('marlin')
local vimrc_to_edit = '~/.config/nvim/after/plugin/whichkey_userconfig.lua'
local subl = '/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl'
local zed = [[/Applications/Zed.app/Contents/MacOS/cli]]

local function shelljob(command)
  return function(opts, desc)
    return {
      function()
        local plenary_loaded, Job = pcall(require, 'plenary.job')
        if not plenary_loaded then
          return
        end
        opts = opts or {}
        opts.cwd = opts.cwd or vim.fn.expand('%:p:h')
        vim.notify(string.format('[%s] start...', desc or command))
        Job
          :new({
            command = command,
            args = opts.args,
            cwd = opts.cwd,
            on_exit = function(job, ret)
              vim.notify(
                string.format('[%s] done: status: %d', desc or command, ret)
              )
            end,
          })
          :start()
      end,
      desc or vim.inspect(opts.args),
    }
  end
end
local git_cmd = shelljob('git')

local function project_root()
  local dir = vim.fn.expand('%:p:h')
  local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_loaded then
    return dir
  end
  local root_pattern = nvim_lspconfig.util.root_pattern
  return root_pattern(
    'package.json',
    'readme.md',
    'README.md',
    'readme.txt',
    'LICENSE.txt',
    'LICENSE',
    '.git'
  )(dir)
end

vim.keymap.set('n', 'K', function()
  fzf.grep_cword({ cwd = project_root() })
end, { noremap = true, silent = true })

local function live_grep()
  fzf.live_grep({ cwd = project_root() })
end

local function cmd(vim_cmd, desc, notify_after)
  return {
    function()
      vim.cmd(vim_cmd)
      if notify_after then
        vim.notify(notify_after)
      end
    end,
    desc or vim_cmd,
  }
end

local function open_git_hosting_web()
  local mode = vim.fn.mode()
  if string.lower(mode) == 'v' then
    mode = 'v'
  else
    mode = 'n'
  end

  require('gitlinker').get_buf_range_url(mode)
end

---@param vimscript_func string custom function name in string
local function run_testfile(vimscript_func)
  return {
    function()
      local file = vim.fn.expand('%')
      if string.find(file, 'spec.') or string.find(file, 'test.') then
        vim.notify('start test runner for ' .. file)
        vim.call(vimscript_func)
      else
        vim.notify('this is not a test file')
      end
    end,
    vimscript_func,
  }
end

local runtests_keymap = {
  name = 'Test',
  i = cmd('VimuxInspectRunner', 'inspect runner'),
  j = run_testfile('TestCurrentFileWithJestJsdom'),
  J = run_testfile('TestCurrentFileWithJestNode'),
  h = cmd('HurlRun', 'run hurl file'),
  -- l = cmd('VimuxRunLastCommand', 'last command'),
  l = {
    function()
      fzf.files({
        cwd = vim.g.dropbox_home .. '/src/hurl_files',
      })
    end,
    'list all hurl files',
  },
  m = run_testfile('TestCurrentFileWithMocha'),
  p = cmd('VimuxPromptCommand', 'prompt command'),
  q = cmd('VimuxCloseRunner', 'close runner'),
  x = cmd('call VimuxZoomRunner()', 'zoom in'),
  z = cmd('call LastPath()', 'open last path in runner'),
  t = {
    function()
      vim.call('EditMatchingTestFile')
    end,
    'alternate test file',
  },
}

local function marlin_marks()
  marlin.load_project_files()
  local results = marlin.get_indexes()
  local files = {}
  for _, item in ipairs(results) do
    table.insert(
      files,
      string.format('%s:%d:%d', item.filename, item.row, item.col)
    )
  end
  fzf.fzf_exec(files, { actions = fzf.defaults.actions.files })
end

local fzf_keymap = {
  name = 'fzf',
  ['b'] = { fzf.buffers, 'buffers' },
  ['c'] = { fzf.colorschemes, 'colorschemes' },
  ['f'] = {
    function()
      if G.is_git_repo() then
        fzf.git_files()
      else
        fzf.files({ cwd = project_root() })
      end
    end,
    'project files',
  },
  ['g'] = { fzf.buffers, 'buffers' },
  ['m'] = { marlin_marks, 'marlin files' },
  ['r'] = { fzf.oldfiles, 'recent files' },
}

local gitsigns = require('gitsigns')
local git_keymap = {
  name = 'git',
  -- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
  -- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", 'Next Hunk' },
  -- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", 'Prev Hunk' },
  -- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
  -- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
  ['+'] = { gitsigns.stage_hunk, 'stage hunk' },
  ['-'] = { gitsigns.undo_stage_hunk, 'unstage hunk' },
  ['2'] = cmd('diffget //2'),
  ['3'] = cmd('diffget //3'),
  a = cmd('Gwrite', 'git add'),
  A = cmd('Git add -A', 'git add untracked'),
  b = cmd('FzfLua git_branches', 'checkout branch'),
  c = cmd('Git commit -a', 'commit all'),
  d = cmd('Git diff', 'diff'),
  f = git_cmd(
    { args = { 'commit', '--no-verify', '--fixup HEAD -a' } },
    'git fixup'
  ),
  g = git_cmd({ args = { 'pull', '--tags', '--rebase' } }, 'git pull'),
  h = git_cmd({ args = { 'stash' } }, 'git stash'),
  H = git_cmd({ args = { 'stash', 'pop' } }, 'git stash pop'),
  -- l = cmd('Gllog', 'list commits'),
  l = { fzf.git_commits, 'git log' },
  L = {
    function()
      -- local current_file_path = vim.fn.expand('%:p')
      local current_file_path = vim.api.nvim_buf_get_name(0)
      vim.cmd('Git log ' .. current_file_path)
    end,
    "current buffer's git log",
  },
  m = { require('gitsigns').blame_line, 'blame line' },
  M = cmd('Git blame', 'git blame'),
  p = git_cmd({ args = { 'push', '-u', '--no-verify' } }, 'git push'),
  P = git_cmd({
    args = {
      'push',
      '-u',
      '--force-with-lease',
      '--no-verify',
    },
  }, 'force push with lease'),
  r = cmd(
    'Git rebase -i --committer-date-is-author-date origin/HEAD~5',
    'rebase'
  ),
  s = cmd('Git', 'git status'),
  S = cmd('FzfLua git_status', 'changed files'),
  y = { open_git_hosting_web, 'open the file in web' },
  v = cmd('Gvdiffsplit!', '3-way diff'),
}

local lsp_keymap = {
  name = 'lsp',
  a = { vim.lsp.buf.code_action, 'code action' },
  d = { vim.diagnostic.open_float, 'diagnostic' },
  f = { vim.lsp.buf.format, 'format code' },
  I = cmd('LspInfo', 'lsp info'),
  p = {
    function()
      require('lspsaga.definition'):init(2, 1)
    end,
    'Peek type',
  },
  r = { vim.lsp.buf.rename, 'rename' },
  ['q'] = {
    function()
      vim.diagnostic.setqflist({
        open = false,
      })
      fzf.quickfix()
    end,
    'quickfix list',
  },
}

local yank_keymap = {
  name = 'yank things',
  l = {
    function()
      local loaded_packages = vim.tbl_keys(package.loaded)
      vim.fn.setreg('*', vim.inspect(loaded_packages))
    end,
    'yank loaded package names',
  },
  p = cmd('let @*=expand("%:p")', 'yank file full path', 'file path yanked'),
  f = cmd('let @*=expand("%")', 'yank file name'),
  m = cmd('let @*=execute("messages")', 'yank messages'),
}

local openthings_keymap = {
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
    shelljob(zed)({ args = { vim.fn.expand('%:p') } }, 'open file in zed'),
    'open file in gui editor',
  },
  g = { open_git_hosting_web, 'open file in git web' },
}

local notes_keymap = {
  name = 'notes',
  b = cmd('NoteGitBranch', 'create new note for current git branch'),
  c = cmd('NoteNew', 'create new note'),
  g = cmd('NoteGit', 'create new note for current git repo'),
  t = cmd('NoteToday', 'create new note for today'),
  l = {
    function()
      fzf.files({
        cwd = vim.g.notes_home,
      })
    end,
    'list all notes',
  },
  ['.'] = {
    function()
      fzf.live_grep({
        cwd = vim.g.notes_home,
        file_ignore_patterns = {
          'node_modules',
          '.png',
          '.pdf',
          '.jpg',
          '.docx',
          '.pptx',
        },
      })
    end,
    'full text search in notes',
  },
}
local vimrc_keymap = {
  name = 'vimrc',
  e = {
    function()
      fzf.git_files({ cwd = '~/.config/nvim' })
      -- vim.cmd('e $MYVIMRC')
    end,
    'edit root vimrc',
  },
  R = cmd(
    'source $MYVIMRC',
    'reload vimrc and lua configs',
    'Config reloaded!'
  ),
  r = {
    function()
      local ft = vim.bo.filetype
      if ft == 'vim' or ft == 'lua' then
        vim.cmd('source %')
        vim.notify('Current buffer sourced', vim.log.levels.WARN)
      else
        vim.notify('Cannot reload non vim/lua files')
      end
    end,
    'reload current buffer',
  },
}

local chatgpt_keymap_n = {
  name = 'chatgpt',
  D = cmd('GpChatDelete', 'delete chat'),
  c = cmd('GpNew', 'Enter a prompt'),
  f = cmd('GpChatFinder', 'chat Finder'),
  n = cmd('GpChatNew', 'new chat'),
  t = cmd('GpChatToggle', 'Toggle chat'),
}

local function wrapGpCmd(str)
  return ":<c-u>'<,'>" .. str .. '<cr>'
end
local chatgpt_keymap_v = {
  name = 'chatgpt',
  n = { wrapGpCmd('GpChatNew'), 'visual new chat' },
  e = { wrapGpCmd('GpExplain'), 'explain selcted code' },
}
local editing_keymap = {
  name = 'edit things',
  a = {
    function()
      local f = vim.fn.expand('#')
      marlin.add()
      marlin.save()
      vim.notify(f .. ' added to marlin')
    end,
    'add file to marlin collection',
  },
  D = {
    function()
      local f = vim.fn.expand('#')
      marlin.remove()
      marlin.save()
      vim.notify(f .. ' removed from marlin')
    end,
    'remove file from marlin collection',
  },
  e = {
    function()
      local f = vim.fn.expand('#')
      if f == '' then
        -- vim.notify('No file to alternate', vim.log.levels.WARN)
        vim.cmd('e ' .. vimrc_to_edit)
      else
        vim.cmd('e! #')
      end
    end,
    'toggle last used file',
  },
  l = {
    marlin_marks,
    'list marlin collection',
  },
  s = cmd('UltiSnipsEdit', 'edit snippet for current buffer'),
  v = cmd('e ' .. vimrc_to_edit, 'edit vimrc'),
  X = {
    marlin.remove_all,
    '',
  },
}

local n_keymap = {
  ['.'] = { live_grep, 'grep current repo' },
  ['/'] = { fzf.builtin, 'fzf-lua builtin' },
  c = chatgpt_keymap_n,
  e = editing_keymap,
  f = fzf_keymap,
  g = git_keymap,
  l = lsp_keymap,
  n = notes_keymap,
  o = openthings_keymap,
  r = vimrc_keymap,
  t = runtests_keymap,
  y = yank_keymap,
}

---generate opts for the plugin based on mode
---@param mode string
---@return table
local function make_mapping_opts(mode)
  return {
    mode = mode,
    prefix = '<leader>',
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false,
  }
end

which_key.register(n_keymap, make_mapping_opts('n'))

local v_keymap = {
  c = chatgpt_keymap_v,
  f = fzf_keymap,
  g = git_keymap,
  l = lsp_keymap,
  o = openthings_keymap,
  y = yank_keymap,
}

which_key.register(v_keymap, make_mapping_opts('v'))

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
      operators = true,
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
    margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 3, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = 'center', -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
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
