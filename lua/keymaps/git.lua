local utils = require('keymaps.utils')

local git_keymap = {
  name = 'git',
  -- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
  -- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", 'Next Hunk' },
  -- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", 'Prev Hunk' },
  -- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
  -- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
  ['+'] = {
    function()
      local gitsigns = require('gitsigns')
      gitsigns.stage_hunk()
    end,
    'stage hunk',
  },
  ['-'] = {
    function()
      local gitsigns = require('gitsigns')
      gitsigns.undo_stage_hunk()
    end,
    'unstage hunk',
  },
  ['2'] = utils.vim_cmd('diffget //2'),
  ['3'] = utils.vim_cmd('diffget //3'),
  a = utils.vim_cmd('Gwrite', 'git add'),
  A = utils.vim_cmd('Git add -A', 'git add untracked'),
  b = utils.vim_cmd('FzfLua git_branches', 'checkout branch'),
  c = utils.vim_cmd('Git commit -a', 'commit all'),
  d = utils.vim_cmd('Git diff', 'diff'),
  f = utils.git_cmd(
    { args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' } },
    'git fixup HEAD'
  ),
  g = utils.git_cmd({ args = { 'pull', '--tags', '--rebase' } }, 'git pull'),
  h = utils.git_cmd({ args = { 'stash' } }, 'git stash'),
  H = utils.git_cmd({ args = { 'stash', 'pop' } }, 'git stash pop'),
  -- l = cmd('Gllog', 'list commits'),
  l = {
    function()
      local fzf = require('fzf-lua')
      fzf.git_commits()
    end,
    'git log',
  },
  L = {
    function()
      -- local current_file_path = vim.fn.expand('%:p')
      local current_file_path = vim.api.nvim_buf_get_name(0)
      vim.cmd('Git log ' .. current_file_path)
    end,
    "current buffer's git log",
  },
  m = {
    function()
      require('gitsigns').blame_line()
    end,
    'blame line',
  },
  M = utils.vim_cmd('Git blame', 'git blame'),
  p = utils.git_cmd({ args = { 'push', '-u', '--no-verify' } }, 'git push'),
  P = utils.git_cmd({
    args = {
      'push',
      '-u',
      '--force-with-lease',
      '--no-verify',
    },
  }, 'force push with lease'),
  r = utils.vim_cmd(
    'Git rebase -i --committer-date-is-author-date origin/HEAD~5',
    'rebase HEAD~5'
  ),
  s = utils.vim_cmd('Git', 'git status'),
  S = utils.vim_cmd('FzfLua git_status', 'changed files'),
  y = { utils.open_git_hosting_web, 'open the file in web' },
  v = utils.vim_cmd('Gvdiffsplit!', '3-way diff'),
}
return git_keymap
