local fff = require('fff')
local fzf = require('fzf-lua')

local picker_keymap = {
  mode = { 'n', 'v' },
  { '<leader>f', group = 'Picker' },
  { '<leader>fb', fzf.buffers, desc = 'Browse buffers' },
  -- { '<leader>fc', fzf.colorschemes, desc = 'Browse colorschemes' },
  {
    '<leader>fd',
    fzf.diagnostics_document,
    desc = 'Browse buffer diagnostics',
  },
  { '<leader>fr', fzf.oldfiles, desc = 'Browse recent files' },
  -- { '<leader>fs', fzf.spell_suggest, desc = 'spell suggest' },
  {
    '<leader>fs',
    '<cmd>FzfLua git_status<cr>',
    desc = 'Browse changed files',
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
    desc = 'Toggle Mini Files',
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
      local root = vim.g.git_root()
      -- vim.notify(vim.inspect({
      --   buf = vim.api.nvim_buf_get_name(0),
      --   cwd = vim.fn.getcwd(),
      --   git_root = root,
      -- }))
      fff.find_files({ cwd = root })
    end,
    desc = 'Browse Git files',
  },
  {
    '<leader>fc',
    -- fzf.files,
    function()
      fff.find_files({ cwd = vim.fn.expand('%:p:h') })
    end,
    desc = 'Browse current folder files',
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
    desc = 'Browse project files',
  },
  {
    '<leader>fl',
    function()
      fzf.files({ cwd = vim.g.state_dir })
    end,
    desc = 'Browse nvim state files',
  },
}

return picker_keymap
