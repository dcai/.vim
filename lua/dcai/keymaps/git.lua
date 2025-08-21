local utils = require('dcai.keymaps.utils')

local git_keymap = {
  { '<leader>g', group = 'git' },
  { '<leader>ga', '<cmd>!git add --verbose %<cr>', desc = 'git add' },
  { '<leader>gS', '<cmd>!git reset %<cr>', desc = 'unstage this file' },
  { '<leader>gb', '<cmd>Git blame<cr>', desc = 'git blame' },
  { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'git switch' },
  { '<leader>gc', group = 'git commit' },
  {
    '<leader>gcU',
    utils.git_cmd({
      args = { 'ciu' },
    }),
    desc = 'commit all',
  },
  {
    '<leader>gcS',
    utils.git_cmd({
      args = { 'cis' },
    }),
    desc = 'commit staged',
  },
  {
    '<leader>gG',
    utils.git_cmd({
      args = { 'auto-commit-and-push' },
    }),
    desc = 'git ai commit and push',
  },
  {
    '<leader>gcf',
    utils.git_cmd({
      args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' },
    }),
    desc = 'fixup HEAD',
  },
  -- { '<leader>gd', '<cmd>Git diff<cr>', desc = 'diff' },
  {
    '<leader>gg',
    '<cmd>FzfLua git_status<cr>',
    desc = 'git status',
  },
  {
    '<leader>gs',
    '<cmd>FzfLua git_status<cr>',
    desc = 'git status',
  },
  {
    '<leader>gh',
    group = 'git stash',
  },
  {
    '<leader>ghs',
    utils.git_cmd({ args = { 'stash' } }),
    desc = 'git stash',
  },
  {
    '<leader>ghp',
    utils.git_cmd({ args = { 'stash', 'pop' } }),
    desc = 'git stash pop',
  },
  {
    '<leader>gj',
    utils.git_cmd({
      args = {
        '-c',
        'sequence.editor=:',
        'rebase',
        '--autosquash',
        '-i',
        'origin/HEAD',
      },
    }, 'rebase HEAD'),
    desc = 'rebase autosquash',
  },
  {
    '<leader>gl',
    group = 'logs',
  },
  -- {
  --   '<leader>gll',
  --   function()
  --     local fzf = require('fzf-lua')
  --     fzf.git_commits()
  --   end,
  --   desc = 'git log',
  -- },
  {
    '<leader>gll',
    '<cmd>!tmux popup -E -h "80\\%" -w "80\\%" -d "'
      .. vim.fn.getcwd()
      .. '" -- tig<CR><CR>',
    desc = 'tig',
  },
  {
    '<leader>glb',
    '<cmd>FzfLua git_bcommits<cr>',
    desc = 'current buffer',
  },
  {
    '<leader>gp',
    group = 'pull and push',
  },
  {
    '<leader>gpp',
    utils.git_cmd({ args = { 'pull', '--tags', '--rebase' } }),
    desc = 'git pull',
  },
  {
    '<leader>gpP',
    utils.git_cmd({ args = { 'push', '-u', '--force-with-lease' } }),
    desc = 'git push',
  },
  {
    '<leader>gpf',
    utils.git_cmd({ args = { 'fetch', '--tags', '--all', '--verbose' } }),
    desc = 'git fetch',
  },
  {
    '<leader>gy',
    utils.open_git_hosting_web,
    desc = 'open in browser',
  },
}
return git_keymap
