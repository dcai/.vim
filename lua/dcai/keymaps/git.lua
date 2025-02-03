local utils = require('dcai.keymaps.utils')

local git_keymap = {
  { '<leader>g', group = 'git' },
  { '<leader>g2', '<cmd>diffget //2<cr>' },
  { '<leader>g3', '<cmd>diffget //3<cr>' },
  { '<leader>ga', '<cmd>Gwrite<cr>' },
  { '<leader>gA', '<cmd>Git add -A<cr>' },
  { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'checkout branch' },
  -- { '<leader>gC', '<cmd>Git commit -a<cr>', desc = 'commit all' },
  {
    '<leader>gC',
    utils.git_cmd({
      args = { 'ci-unstaged' },
    }),
    desc = 'git ci-unstaged',
  },
  -- { '<leader>gd', '<cmd>Git diff<cr>', desc = 'diff' },
  {
    '<leader>gf',
    utils.git_cmd({
      args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' },
    }),
    desc = 'git fixup HEAD',
  },
  {
    '<leader>gg',
    '<cmd>Git<cr>',
    desc = 'git status',
  },
  {
    '<leader>gh',
    utils.git_cmd({ args = { 'stash' } }),
    desc = 'git stash',
  },
  {
    '<leader>gH',
    utils.git_cmd({ args = { 'stash', 'pop' } }),
    desc = 'git stash pop',
  },
  {
    '<leader>gj',
    '<cmd>Git -c sequence.editor=: rebase --autosquash -i origin/HEAD<cr>',
    desc = 'rebase origin/HEAD',
  },
  {
    '<leader>gl',
    function()
      local fzf = require('fzf-lua')
      fzf.git_commits()
    end,
    desc = 'git log',
  },
  {
    '<leader>gL',
    function()
      -- local current_file_path = vim.fn.expand('%:p')
      local current_file_path = vim.api.nvim_buf_get_name(0)
      vim.cmd('Git log ' .. current_file_path)
    end,
    desc = "current buffer's git log",
  },
  {
    '<leader>gM',
    '<cmd>Git blame<cr>',
    desc = 'git blame',
  },
  {
    '<leader>gp',
    utils.git_cmd({ args = { 'pull', '--tags', '--rebase' } }),
    desc = 'git pull',
  },
  {
    '<leader>gP',
    utils.git_cmd({
      args = {
        'push',
        '-u',
        -- '--force-with-lease',
        '--no-verify',
      },
    }),
    desc = 'git push',
  },
  {
    '<leader>gy',
    utils.open_git_hosting_web,
    desc = 'open the file in web',
  },
  {
    '<leader>gv',
    '<cmd>Gvdiffsplit!<cr>',
    desc = '3-way diff',
  },
}
return git_keymap
