local M = {}

local setups = {
  lazy = {},
  afterEnd = {},
}

---extract plugin name from `username/reponame` format
---@param repo string
local function plugin_name(repo)
  return repo:match('^[%w-]+/([%w-_.]+)$')
end

local function END()
  vim.fn['plug#end']()

  -- run setup scripts
  for plugin, setup in pairs(setups.afterEnd) do
    LOG.trace('setting up ' .. plugin)
    setup()
  end
end

---Install a plugin
---@param repo string
---@param opts table|string|nil
---@return nil
local function Plug(repo, opts)
  opts = opts or vim.empty_dict()
  local fn = vim.fn['plug#']
  local plugin = plugin_name(repo)
  local setup = opts.setup
  fn(repo, opts)
  if type(setup) == 'function' then
    setups.afterEnd[plugin] = setup
  end
end

---setup vim-plug
---@param plugOpts table
M.setup = function(plugOpts)
  local dir = plugOpts.dir or vim.fn.expand(vim.fn.stdpath('data') .. '/plug')
  vim.call('plug#begin', dir)
  if G.is_env_var_true('NVIM_USE_COPILOT') then
    Plug('github/copilot.vim', {
      setup = function()
        vim.cmd([[
          let g:copilot_no_tab_map = v:true
          imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
        ]])
      end,
    })
  end
  if G.is_env_var_true('NVIM_USE_CODEIUM') then
    Plug('monkoose/neocodeium')
    -- Plug('Exafunction/codeium.nvim')
    -- Plug('Exafunction/codeium.vim', {
    --   setup = function()
    --     -- vim.g.codeium_enabled = true
    --     -- vim.g.codeium_disable_bindings = 1
    --     -- vim.g.codeium_no_map_tab = true
    --     -- vim.g.codeium_log_file = vim.fn.stdpath('log') .. '/codeium.vim.log'
    --     -- -- imap <script><silent><nowait><expr> <C-f> codeium#Accept()
    --     -- vim.keymap.set('i', '<c-f>', function()
    --     --   vim.cmd('call codeium#Accept()')
    --     -- end, {
    --     --   silent = true,
    --     --   nowait = true,
    --     -- })
    --     -- vim.keymap.set('i', '<c-n>', function()
    --     --   vim.cmd('call codeium#CycleCompletions(1)')
    --     -- end, {
    --     --   silent = true,
    --     --   nowait = true,
    --     -- })
    --   end,
    -- })
  end

  if G.is_env_var_set('OPENAI_API_KEY') then
    Plug('Robitx/gp.nvim')
  end
  ----------------------------------------------------------------------------
  --- lsp
  ----------------------------------------------------------------------------
  Plug('neovim/nvim-lspconfig')
  Plug('pmizio/typescript-tools.nvim')
  Plug('williamboman/mason.nvim', { ['do'] = ':MasonUpdate' })
  Plug('williamboman/mason-lspconfig.nvim')
  ----------------------------------------------------------------------------
  --- git
  ----------------------------------------------------------------------------
  Plug('tpope/vim-fugitive')
  -- Plug('NeogitOrg/neogit', {
  --   setup = function()
  --     local loaded, neogit = pcall(require, 'neogit')
  --     if loaded then
  --       neogit.setup({})
  --     end
  --   end,
  -- })
  -- Plug('lewis6991/gitsigns.nvim')
  Plug('ruifm/gitlinker.nvim')
  ----------------------------------------------------------------------------
  --- treesitter
  ----------------------------------------------------------------------------
  Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
  Plug('nvim-treesitter/nvim-treesitter-textobjects')
  Plug('JoosepAlviste/nvim-ts-context-commentstring')
  Plug('windwp/nvim-ts-autotag')
  -- Plug('laytan/tailwind-sorter.nvim', {
  --   ['do'] = 'cd formatter && npm ci && npm run build',
  --   setup = function()
  --     local loaded, tailwindsorter = pcall(require, 'tailwind-sorter')
  --     if loaded then
  --       tailwindsorter.setup({
  --         on_save_enabled = false, -- If `true`, automatically enables on save sorting.
  --         on_save_pattern = {
  --           '*.html',
  --           '*.js',
  --           '*.jsx',
  --           '*.tsx',
  --           '*.twig',
  --           '*.hbs',
  --           '*.php',
  --           '*.heex',
  --           '*.astro',
  --         },
  --         node_path = 'node',
  --       })
  --     end
  --   end,
  -- })
  ----------------------------------------------------------------------------
  --- nvim-cmp
  ----------------------------------------------------------------------------
  Plug('andersevenrud/cmp-tmux')
  Plug('hrsh7th/cmp-buffer')
  Plug('hrsh7th/cmp-cmdline')
  Plug('hrsh7th/cmp-nvim-lsp')
  Plug('hrsh7th/cmp-path')
  Plug('hrsh7th/nvim-cmp')
  -- Plug('petertriho/cmp-git')
  -- Plug('dmitmel/cmp-cmdline-history')
  Plug('SirVer/ultisnips')
  Plug('quangnguyen30192/cmp-nvim-ultisnips')
  ----------------------------------------------------------------------------
  --- markdown
  ----------------------------------------------------------------------------
  Plug('mzlogin/vim-markdown-toc', {
    ['for'] = 'markdown',
    setup = function()
      vim.g.vmt_dont_insert_fence = 1
    end,
  })
  Plug('iamcco/markdown-preview.nvim', {
    ['do'] = 'cd app && npx --yes yarn install',
    ['for'] = 'markdown',
    setup = function()
      vim.g.mkdp_theme = 'light'
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 1
      -- vim.g.mkdp_theme = 'dark'
    end,
  })
  ----------------------------------------------------------------------------
  --- END of markdown
  ----------------------------------------------------------------------------
  --- vim-test
  ----------------------------------------------------------------------------
  Plug('preservim/vimux', {
    setup = function()
      vim.g.VimuxOrientation = 'h'
    end,
  })
  Plug('vim-test/vim-test', {
    setup = function()
      vim.g['test#javascript#runner'] = 'jest'
      vim.g['test#javascript#mocha#executable'] = 'npx mocha'
      vim.g['test#javascript#mocha#options'] = ' --full-trace '
      vim.g['test#javascript#jest#executable'] = 'npx jest'
      -- vim.g['test#javascript#jest#file_pattern'] = '(spec|test).(js|jsx|ts|tsx)$'
      vim.g['test#runner_commands'] = { 'Jest', 'Mocha' }
      vim.g['test#strategy'] = 'neovim'
      -- vim.g['test#strategy'] = 'vimux'
      -- vim.g['test#strategy'] = 'toggleterm'
      vim.g['test#neovim#term_position'] = 'vert'
    end,
  })
  ----------------------------------------------------------------------------
  --- END vim-test
  ----------------------------------------------------------------------------
  -- coding, development, writing
  ----------------------------------------------------------------------------
  Plug('norcalli/nvim-colorizer.lua', {
    setup = function()
      require('colorizer').setup()
    end,
  })
  Plug('reedes/vim-lexical')
  Plug('nvim-lua/plenary.nvim')
  Plug('dcai/ale', { frozen = 1 })
  Plug('Wansmer/treesj')
  Plug('nvim-tree/nvim-web-devicons')
  -- Plug('tpope/vim-dadbod')
  -- Plug('kristijanhusak/vim-dadbod-ui')
  -- Plug('kristijanhusak/vim-dadbod-completion')
  ----------------------------------------------------------------------------
  --- END coding, development, writing
  ----------------------------------------------------------------------------
  -- files and editing
  ----------------------------------------------------------------------------
  Plug('djoshea/vim-autoread')
  Plug('pocco81/auto-save.nvim')
  Plug('dcai/marlin.nvim') -- forked 'desdic/marlin.nvim'
  Plug('mbbill/undotree')
  Plug('tpope/vim-eunuch') -- Vim sugar for the UNIX shell
  Plug('ibhagwan/fzf-lua')
  Plug('nvim-telescope/telescope.nvim')
  Plug('andymass/vim-matchup')
  Plug('AndrewRadev/bufferize.vim', {
    setup = function()
      vim.g.bufferize_command = 'new'
      vim.g.bufferize_keep_buffers = 1
      vim.g.bufferize_focus_output = 1
    end,
  })
  ----------------------------------------------------------------------------
  -- end of files
  ----------------------------------------------------------------------------
  -- Plug('junegunn/vader.vim', { ['for'] = 'vader' })
  Plug('rafi/awesome-vim-colorschemes')
  Plug('echasnovski/mini.nvim')
  Plug('folke/which-key.nvim')
  Plug('dstein64/vim-startuptime')
  Plug('tyru/open-browser.vim')

  END()
end

return M
