local fff = require('fff')
local fzf = require('fzf-lua')

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
    -- function()
    --   if vim.g.is_git_repo() then
    --     fzf.git_files()
    --   else
    --     fzf.files({ cwd = vim.g.smart_root() })
    --   end
    -- end,
    function()
      fff.find_files({ cwd = vim.g.git_root() })
    end,
    desc = 'git files',
  },
  {
    '<leader>fc',
    -- fzf.files,
    function()
      fff.find_files({ cwd = vim.fn.expand('%:p:h') })
    end,
    desc = 'current folder files',
  },
  {
    '<leader>fp',
    function()
      fff.find_files({ cwd = vim.g.smart_root() })
      -- fzf.files({
      --   cwd = vim.g.smart_root(),
      --   no_ignore = true,
      --   fd_opts = '--color=never --type f --hidden --follow --exclude .git --exclude node_modules',
      -- })
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
