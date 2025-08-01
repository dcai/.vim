local fzf = require('fzf-lua')
local utils = require('dcai.keymaps.utils')
-- vim.g.logger.trace('fzf keymap setting up...')

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
  -- { '<leader>fc', fzf.colorschemes, desc = 'colorschemes' },
  { '<leader>fd', fzf.diagnostics_document, desc = 'diagnostics' },
  { '<leader>fr', fzf.oldfiles, desc = 'recent files' },
  -- { '<leader>fs', fzf.spell_suggest, desc = 'spell suggest' },
  {
    '<leader>fs',
    '<cmd>FzfLua git_status<cr>',
    desc = 'changed files',
  },
  { '<leader>f/', fzf.builtin, desc = 'fzf builtin' },
  -- file tree
  {
    '<leader>ft',
    function()
      local ok, minifiles = pcall(require, 'mini.files')
      if not ok then
        return
      end
      if not minifiles.close() then
        minifiles.open()
      end
    end,
    desc = 'mini files',
  },
  {
    '<leader>ff',
    git_files,
    desc = 'git files',
  },
  {
    '<leader>fc',
    fzf.files,
    desc = 'current folder files',
  },
  {
    '<leader>fp',
    function()
      fzf.files({ cwd = vim.g.smart_root() })
    end,
    desc = 'project files',
  },
  {
    '<leader>fl',
    function()
      fzf.files({ cwd = vim.g.state_dir })
    end,
    desc = 'log and state files',
  },
}

return fzf_keymap
