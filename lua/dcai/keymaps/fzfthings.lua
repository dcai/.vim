local fzf = require('fzf-lua')
local utils = require('dcai.keymaps.utils')
LOG.trace('fzf keymap setting up...')

local fzf_keymap = {
  name = 'fzf',
  ['b'] = { fzf.buffers, 'buffers' },
  ['c'] = { fzf.colorschemes, 'colorschemes' },
  ['r'] = { fzf.oldfiles, 'recent files' },
  ['s'] = { fzf.spell_suggest, 'spell suggest' },
  ['/'] = { fzf.builtin, 'fzf builtin' },
  ['f'] = {
    function()
      fzf.files({ cwd = G.smart_root() })
    end,
    'project files',
  },
  ['g'] = {
    function()
      if G.is_git_repo() then
        fzf.git_files()
      else
        fzf.files({ cwd = G.smart_root() })
      end
    end,
    'git files',
  },
  ['l'] = {
    function()
      fzf.files({ cwd = vim.fn.stdpath('log') })
    end,
    'xdg log files',
  },
}

return fzf_keymap
