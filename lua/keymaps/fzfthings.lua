local fzf = require('fzf-lua')
local utils = require('keymaps.utils')
LOG.trace('fzf keymap setting up...')

local fzf_keymap = {
  name = 'fzf',
  ['b'] = { fzf.buffers, 'buffers' },
  ['c'] = { fzf.colorschemes, 'colorschemes' },
  ['f'] = {
    function()
      if G.is_git_repo() then
        fzf.git_files()
      else
        fzf.files({ cwd = G.root() })
      end
    end,
    'project files',
  },
  ['l'] = {
    function()
      fzf.files({ cwd = vim.fn.stdpath('log') })
    end,
    'xdg log files',
  },
  ['g'] = { fzf.builtin, 'fzf builtin' },
  ['r'] = { fzf.oldfiles, 'recent files' },
}

return fzf_keymap
