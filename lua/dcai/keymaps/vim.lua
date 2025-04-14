local function config_files()
  local fzf = require('fzf-lua')
  -- vim.cmd('e $MYVIMRC')
  fzf.files({ cwd = '~/.config/nvim' })
end

local vim_keymap = {
  { '<leader>k', group = 'Neovim' },
  {
    '<leader>kA',
    function()
      vim.cmd('ALEInfo')
    end,
    desc = 'ALEInfo',
  },
  {
    '<leader>kC',
    '<cmd>Copilot status<cr>',
    desc = 'copilot status',
  },
  {
    '<leader>kM',
    function()
      vim.cmd('Mason')
    end,
    desc = 'Mason',
  },
  {
    '<leader>kI',
    function()
      vim.cmd('PlugInstall')
    end,
    desc = 'PlugInstall',
  },
  {
    '<leader>kH',
    function()
      vim.cmd('checkhealth')
    end,
    desc = 'checkhealth',
  },
  {
    '<leader>kL',
    function()
      vim.cmd('checkhealth lsp')
    end,
    desc = 'lsp status',
  },
  {
    '<leader>kU',
    function()
      vim.cmd('PlugUpdate')
    end,
    desc = 'PlugUpdate',
  },
  {
    '<leader>kf',
    config_files,
    desc = 'edit root vimrc',
  },
  {
    '<leader>kl',
    config_files,
    desc = 'edit root vimrc',
  },
  {
    '<leader>kK',
    function()
      vim.g.reload('dcai')
      dofile(vim.env.MYVIMRC)
    end,
    desc = 'force reload everything',
  },
  {
    '<leader>kk',
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
