local utils = require('dcai.keymaps.utils')

local git_keymap = {
  { '<leader>g', group = 'git' },
  -- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", 'Reset Buffer' },
  -- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", 'Next Hunk' },
  -- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", 'Prev Hunk' },
  -- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", 'Preview Hunk' },
  -- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", 'Reset Hunk' },
  {
    '<leader>g+',
    function()
      local gitsigns = require('gitsigns')
      gitsigns.stage_hunk()
    end,
    desc = 'stage hunk',
  },
  {
    '<leader>g-',
    function()
      local gitsigns = require('gitsigns')
      gitsigns.undo_stage_hunk()
    end,
    desc = 'unstage hunk',
  },
  { '<leader>g2', '<cmd>diffget //2<cr>' },
  { '<leader>g3', '<cmd>diffget //3<cr>' },
  { '<leader>ga', '<cmd>Gwrite<cr>' },
  { '<leader>gA', '<cmd>Git add -A<cr>' },
  { '<leader>gB', '<cmd>FzfLua git_branches<cr>', desc = 'checkout branch' },
  { '<leader>gC', '<cmd>Git commit -a<cr>', desc = 'commit all' },
  { '<leader>gd', '<cmd>Git diff<cr>', desc = 'diff' },
  {
    '<leader>gf',
    utils.git_cmd({
      args = { 'commit', '--no-verify', '-a', '--fixup', 'HEAD' },
    }),
    desc = 'git fixup HEAD',
  },
  {
    '<leader>gg',
    utils.git_cmd({ args = { 'pull', '--tags', '--rebase' } }),
    desc = 'git pull',
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
  -- l = cmd('Gllog', 'list commits'),
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
    '<leader>gm',
    function()
      require('gitsigns').blame_line()
    end,
    desc = 'blame line',
  },
  {
    '<leader>gM',
    '<cmd>Git blame<cr>',
    desc = 'git blame',
  },
  {
    '<leader>gp',
    utils.git_cmd({ args = { 'push', '-u', '--no-verify' } }),
    desc = 'git push',
  },
  {
    '<leader>gP',
    utils.git_cmd({
      args = {
        'push',
        '-u',
        '--force-with-lease',
        '--no-verify',
      },
    }),
    desc = 'force push with lease',
  },
  {
    '<leader>gj',
    '<cmd>Git -c sequence.editor=: rebase --autosquash -i origin/HEAD<cr>',
    desc = 'rebase origin/HEAD',
  },
  {
    '<leader>gs',
    '<cmd>Git<cr>',
    desc = 'git status',
  },
  {
    '<leader>gS',
    '<cmd>FzfLua git_status<cr>',
    desc = 'changed files',
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
