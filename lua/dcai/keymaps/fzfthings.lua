local fzf = require('fzf-lua')
local utils = require('dcai.keymaps.utils')
-- LOG.trace('fzf keymap setting up...')

local fzf_keymap = {
  mode = { 'n', 'v' },
  { '<leader>f', group = 'fzf' },
  { '<leader>fb', fzf.buffers, desc = 'buffers' },
  { '<leader>fc', fzf.colorschemes, desc = 'colorschemes' },
  { '<leader>fr', fzf.oldfiles, desc = 'recent files' },
  { '<leader>fs', fzf.spell_suggest, desc = 'spell suggest' },
  { '<leader>f/', fzf.builtin, desc = 'fzf builtin' },
  {
    '<leader>ff',
    function()
      fzf.files({ cwd = G.smart_root() })
    end,
    desc = 'project files',
  },
  {
    '<leader>fg',
    function()
      if G.is_git_repo() then
        fzf.git_files()
      else
        fzf.files({ cwd = G.smart_root() })
      end
    end,
    desc = 'git files',
  },
  {
    '<leader>fl',
    function()
      fzf.files({ cwd = vim.fn.stdpath('log') })
    end,
    desc = 'xdg log files',
  },
}

return fzf_keymap
