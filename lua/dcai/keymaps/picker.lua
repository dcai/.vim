local has_fff, fff = pcall(require, 'fff')
local has_fzf, fzf = pcall(require, 'fzf-lua')

local picker_keymap = {
  mode = { 'n', 'v' },
  { '<leader>f', group = 'Picker' },
  {
    '<leader>fb',
    function()
      if not has_fzf then
        return
      end

      fzf.buffers()
    end,
    desc = 'Browse buffers',
  },
  -- { '<leader>fc', fzf.colorschemes, desc = 'Browse colorschemes' },
  {
    '<leader>fd',
    function()
      if not has_fzf then
        return
      end

      fzf.diagnostics_document()
    end,
    desc = 'Browse buffer diagnostics',
  },
  {
    '<leader>fr',
    function()
      if not has_fzf then
        return
      end

      fzf.oldfiles()
    end,
    desc = 'Browse recent files',
  },
  -- { '<leader>fs', fzf.spell_suggest, desc = 'spell suggest' },
  {
    '<leader>fs',
    function()
      if not has_fzf then
        return
      end

      fzf.git_status()
    end,
    desc = 'Browse changed files',
  },
  {
    '<leader>f/',
    function()
      if not has_fzf then
        return
      end

      fzf.builtin()
    end,
    desc = 'fzf builtin',
  },
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
      if not has_fff then
        return
      end

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
      if not has_fff then
        return
      end

      fff.find_files({ cwd = vim.fn.expand('%:p:h') })
    end,
    desc = 'Browse current folder files',
  },
  {
    '<leader>fp',
    function()
      if not has_fff then
        return
      end

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
      if not has_fzf then
        return
      end

      fzf.files({ cwd = vim.g.state_dir })
    end,
    desc = 'Browse nvim state files',
  },
}

return picker_keymap
