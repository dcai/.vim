local vim_keymap = {
  name = 'vimrc',
  M = {
    function()
      vim.cmd('Mason')
    end,
    'Mason',
  },
  I = {
    function()
      vim.cmd('PlugInstall')
    end,
    'PlugInstall',
  },
  H = {
    function()
      vim.cmd('checkhealth')
    end,
    'PlugUpdate',
  },
  U = {
    function()
      vim.cmd('PlugUpdate')
    end,
    'PlugUpdate',
  },
  e = {
    function()
      local fzf = require('fzf-lua')
      -- vim.cmd('e $MYVIMRC')
      fzf.files({ cwd = '~/.config/nvim' })
    end,
    'edit root vimrc',
  },
  R = {
    function()
      G.reload('dcai')
      dofile(vim.env.MYVIMRC)
    end,
    'force reload everything',
  },
  r = {
    function()
      local ft = vim.bo.filetype
      if ft == 'vim' or ft == 'lua' then
        vim.cmd('source %')
        G.reload('dcai')
        vim.notify('Current buffer sourced', vim.log.levels.WARN)
      else
        vim.notify('Cannot reload non vim/lua files')
      end
    end,
    'reload current buffer',
  },
}

return vim_keymap
