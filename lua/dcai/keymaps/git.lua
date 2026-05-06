local utils = require('dcai.keymaps.utils')

local function lazy_git_cmd(opts, desc)
  return utils.lazy_cmd_with_window('git', opts, desc)
end

local git_keymap = {
  { '<leader>g', group = 'Git' },
  { '<leader>ga', '<cmd>!git add --verbose %<cr>', desc = 'Stage current file' },
  { '<leader>gS', '<cmd>!git reset %<cr>', desc = 'Unstage current file' },
  { '<leader>gb', '<cmd>Git blame<cr>', desc = 'Blame current file' },
  { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'Browse branches' },
  {
    '<leader>gy',
    utils.open_git_hosting_web,
    desc = 'Open file on Git hosting',
    mode = { 'v', 'n' },
  },
  { '<leader>gc', group = 'Commit' },
  {
    '<leader>gcU',
    lazy_git_cmd({
      args = { 'ciu' },
    }),
    desc = 'Commit all changes',
  },
  {
    '<leader>gcS',
    lazy_git_cmd({
      args = { 'cis' },
    }),
    desc = 'Commit staged changes',
  },
  {
    '<leader>gcf',
    lazy_git_cmd({
      args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' },
    }),
    desc = 'Create fixup commit for HEAD',
  },
  {
    '<leader>gG',
    utils.lazy_cmd_with_progress('git', { 'nvim-auto-commit-and-push' }),
    desc = 'AI commit and push',
  },
  { '<leader>gd', '<cmd>Git diff<cr>', desc = 'Open Git diff' },
  {
    '<leader>gg',
    '<cmd>FzfLua git_status<cr>',
    desc = 'Browse Git status',
  },
  {
    '<leader>gh',
    group = 'Stash',
  },
  {
    '<leader>ghs',
    lazy_git_cmd({ args = { 'stash' } }),
    desc = 'Stash changes',
  },
  {
    '<leader>ghp',
    lazy_git_cmd({ args = { 'stash', 'pop' } }),
    desc = 'Pop stash',
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
    desc = 'Autosquash rebase onto origin/HEAD',
  },
  {
    '<leader>gl',
    group = 'Log',
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
    desc = 'Open Lazygit',
  },
  {
    '<leader>glt',
    '<cmd>!tmux popup -E -h "80\\%" -w "80\\%" -d "'
      .. vim.fn.getcwd()
      .. '" -- tig<CR><CR>',
    desc = 'Open Tig',
  },
  {
    '<leader>glb',
    '<cmd>FzfLua git_bcommits<cr>',
    desc = 'Browse buffer commits',
  },
  {
    '<leader>gp',
    group = 'Sync',
  },
  {
    '<leader>gpr',
    function()
      vim.fn.jobstart({ 'gh', 'pr', 'view', '--web' }, { detach = true })
    end,
    desc = 'Open current PR in browser',
  },
  {
    '<leader>gpp',
    lazy_git_cmd({ args = { 'pull', '--tags', '--rebase' } }),
    desc = 'Pull with rebase and tags',
  },
  {
    '<leader>gpP',
    lazy_git_cmd({ args = { 'push', '-u', '--force-with-lease' } }),
    desc = 'Push with force-with-lease',
  },
  {
    '<leader>gpf',
    utils.lazy_cmd_with_progress(
      'git',
      { 'fetch', '--tags', '--all', '--verbose' }
    ),
    desc = 'Fetch all remotes and tags',
  },
}
return git_keymap
