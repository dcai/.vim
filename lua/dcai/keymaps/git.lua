local utils = require('dcai.keymaps.utils')

local function lazy_git_cmd(opts, desc)
  return utils.lazy_shell_cmd('git', opts, desc)
end

local git_keymap = {
  { '<leader>g', group = 'git' },
  { '<leader>ga', '<cmd>!git add --verbose %<cr>', desc = 'git add' },
  { '<leader>gS', '<cmd>!git reset %<cr>', desc = 'unstage this file' },
  { '<leader>gb', '<cmd>Git blame<cr>', desc = 'git blame' },
  { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'fzf branches' },
  { '<leader>gy', utils.open_git_hosting_web, desc = 'view file in github' },
  { '<leader>gc', group = 'git commit' },
  {
    '<leader>gcU',
    lazy_git_cmd({
      args = { 'ciu' },
    }),
    desc = 'commit all',
  },
  {
    '<leader>gcS',
    lazy_git_cmd({
      args = { 'cis' },
    }),
    desc = 'commit staged',
  },
  {
    '<leader>gcf',
    lazy_git_cmd({
      args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' },
    }),
    desc = 'fixup HEAD',
  },
  {
    '<leader>gG',
    utils.cmd_with_fidget('git', { 'auto-commit-and-push' }),
    desc = 'git ai commit and push',
  },
  { '<leader>gd', '<cmd>Git diff<cr>', desc = 'fugitive diff' },
  {
    '<leader>gg',
    '<cmd>FzfLua git_status<cr>',
    desc = 'fzf git status',
  },
  {
    '<leader>gh',
    group = 'git stash',
  },
  {
    '<leader>ghs',
    lazy_git_cmd({ args = { 'stash' } }),
    desc = 'git stash',
  },
  {
    '<leader>ghp',
    lazy_git_cmd({ args = { 'stash', 'pop' } }),
    desc = 'git stash pop',
  },
  {
    '<leader>gj',
    lazy_git_cmd({
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
    function()
      Snacks.lazygit()
    end,
    desc = 'lazygit',
  },
  {
    '<leader>glt',
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
    '<leader>gpr',
    function()
      vim.fn.jobstart({ 'gh', 'pr', 'view', '--web' }, { detach = true })
    end,
    desc = 'github pull requests',
  },
  {
    '<leader>gpp',
    lazy_git_cmd({ args = { 'pull', '--tags', '--rebase' } }),
    desc = 'git pull',
  },
  {
    '<leader>gpP',
    lazy_git_cmd({ args = { 'push', '-u', '--force-with-lease' } }),
    desc = 'git push',
  },
  {
    '<leader>gpf',
    lazy_git_cmd({ args = { 'fetch', '--tags', '--all', '--verbose' } }),
    desc = 'git fetch',
  },
}
return git_keymap
