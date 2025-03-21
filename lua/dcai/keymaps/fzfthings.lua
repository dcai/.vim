local fzf = require('fzf-lua')
local utils = require('dcai.keymaps.utils')
-- LOG.trace('fzf keymap setting up...')

local function git_files()
  if vim.g.is_git_repo() then
    fzf.git_files()
  else
    fzf.files({ cwd = vim.g.smart_root() })
  end
end

local fzf_keymap = {
  mode = { 'n', 'v' },
  { '<leader>f', group = 'fzf' },
  { '<leader>fb', fzf.buffers, desc = 'buffers' },
  { '<leader>fc', fzf.colorschemes, desc = 'colorschemes' },
  { '<leader>fd', fzf.diagnostics_document, desc = 'diagnostics' },
  { '<leader>fr', fzf.oldfiles, desc = 'recent files' },
  -- { '<leader>fs', fzf.spell_suggest, desc = 'spell suggest' },
  {
    '<leader>fs',
    '<cmd>FzfLua git_status<cr>',
    desc = 'changed files',
  },
  { '<leader>f/', fzf.builtin, desc = 'fzf builtin' },
  {
    '<leader>ff',
    function()
      fzf.files({ cwd = vim.g.smart_root() })
    end,
    desc = 'project files',
  },
  {
    '<leader>fg',
    git_files,
    desc = 'git files',
  },
  {
    '<leader>fj',
    git_files,
    desc = 'git files',
  },
  {
    '<leader>fl',
    function()
      fzf.files({ cwd = vim.g.log_dir })
    end,
    desc = 'xdg log files',
  },
}

return fzf_keymap
