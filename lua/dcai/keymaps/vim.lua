local vim_keymap = {
  { '<leader>v', group = 'vimrc' },
  {
    '<leader>vA',
    function()
      vim.cmd('ALEInfo')
    end,
    desc = 'ALEInfo',
  },
  {
    '<leader>vC',
    '<cmd>Copilot status<cr>',
    desc = 'copilot status',
  },
  {
    '<leader>vM',
    function()
      vim.cmd('Mason')
    end,
    desc = 'Mason',
  },
  {
    '<leader>vI',
    function()
      vim.cmd('PlugInstall')
    end,
    desc = 'PlugInstall',
  },
  {
    '<leader>vH',
    function()
      vim.cmd('checkhealth')
    end,
    desc = 'checkhealth',
  },
  {
    '<leader>vU',
    function()
      vim.cmd('PlugUpdate')
    end,
    desc = 'PlugUpdate',
  },
  {
    '<leader>ve',
    function()
      local fzf = require('fzf-lua')
      -- vim.cmd('e $MYVIMRC')
      fzf.files({ cwd = '~/.config/nvim' })
    end,
    desc = 'edit root vimrc',
  },
  {
    '<leader>vR',
    function()
      vim.g.reload('dcai')
      dofile(vim.env.MYVIMRC)
    end,
    desc = 'force reload everything',
  },
  {
    '<leader>vr',
    function()
      local ft = vim.bo.filetype
      local filepath = vim.api.nvim_buf_get_name(0)
      local filename_only = vim.fn.fnamemodify(filepath, ':t')
      if ft == 'vim' or ft == 'lua' then
        vim.cmd('source %')
        vim.g.reload('dcai')
        vim.notify(filename_only .. ' sourced', vim.log.levels.WARN)
      else
        vim.notify(filepath .. ' cannot source non vim/lua files')
      end
    end,
    desc = 'reload current buffer',
  },
}

return vim_keymap
