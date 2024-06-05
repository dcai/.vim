local M = {}

---Install a plugin
---@param repo string
---@param opts table|string|nil
---@param setup function
---@return nil
local function Plug(repo, opts, setup)
  local fn = vim.fn['plug#']
  if opts then
    fn(repo, opts)
  else
    fn(repo)
  end
  if type(setup) == 'function' then
    setup()
  end
end

---setup vim-plug
---@param plugOpts table
M.setup = function(plugOpts)
  local dir = plugOpts.dir or vim.fn.expand(vim.fn.stdpath('data') .. '/plug')
  vim.call('plug#begin', dir)

  if G.is_env_var_set('OPENAI_API_KEY') then
    Plug('Robitx/gp.nvim')
    Plug('monkoose/neocodeium')
    Plug('Exafunction/codeium.nvim')
    -- Plug('sourcegraph/sg.nvim', { ['do'] = 'nvim -l build/init.lua' })
    -- Plug('Exafunction/codeium.vim')
    -- Plug('zbirenbaum/copilot.lua')
    -- Plug('github/copilot.vim')
  end
  ----------------------------------------------------------------------------
  --- lsp
  ----------------------------------------------------------------------------
  Plug('neovim/nvim-lspconfig')
  Plug('williamboman/mason.nvim', { ['do'] = ':MasonUpdate' })
  Plug('williamboman/mason-lspconfig.nvim')
  ----------------------------------------------------------------------------
  --- git
  ----------------------------------------------------------------------------
  Plug('tpope/vim-fugitive')
  Plug('lewis6991/gitsigns.nvim')
  Plug('ruifm/gitlinker.nvim')
  ----------------------------------------------------------------------------
  --- treesitter
  ----------------------------------------------------------------------------
  Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
  Plug('nvim-treesitter/nvim-treesitter-textobjects')
  Plug('JoosepAlviste/nvim-ts-context-commentstring')
  Plug('windwp/nvim-ts-autotag')
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
  Plug('mzlogin/vim-markdown-toc', { ['for'] = 'markdown' }, function()
    vim.g.vmt_dont_insert_fence = 1
  end)
  Plug(
    'iamcco/markdown-preview.nvim',
    { ['do'] = 'cd app && npx --yes yarn install', ['for'] = 'markdown' },
    function()
      vim.g.mkdp_theme = 'light'
      -- vim.g.mkdp_theme = 'dark'
    end
  )
  ----------------------------------------------------------------------------
  --- END of markdown
  ----------------------------------------------------------------------------
  --- vim-test
  ----------------------------------------------------------------------------
  Plug('preservim/vimux', nil, function()
    vim.g.VimuxOrientation = 'h'
  end)
  Plug('vim-test/vim-test', nil, function()
    vim.g['test#javascript#runner'] = 'jest'
    vim.g['test#javascript#mocha#executable'] = 'npx mocha'
    vim.g['test#javascript#mocha#options'] = ' --full-trace '
    vim.g['test#javascript#jest#executable'] = 'npx jest'
    vim.g['test#javascript#jest#file_pattern'] =
      '\v(__tests__/.+|(spec|test)).(js|jsx|coffee|ts|tsx)$'
    vim.g['test#runner_commands'] = { 'Jest', 'Mocha' }
    vim.g['test#strategy'] = 'neovim'
    vim.g['test#neovim#term_position'] = 'vert'
  end)
  ----------------------------------------------------------------------------
  --- END vim-test
  ----------------------------------------------------------------------------
  -- coding, development, writing
  ----------------------------------------------------------------------------
  Plug('norcalli/nvim-colorizer.lua')
  Plug('reedes/vim-lexical')
  Plug('nvim-lua/plenary.nvim')
  Plug('dcai/ale', { frozen = 1 })
  Plug('Wansmer/treesj')
  Plug('nvim-tree/nvim-web-devicons')
  Plug('tpope/vim-dadbod')
  Plug('kristijanhusak/vim-dadbod-ui')
  Plug('kristijanhusak/vim-dadbod-completion')
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
  Plug('AndrewRadev/bufferize.vim', nil, function()
    vim.g.bufferize_command = 'new'
    vim.g.bufferize_keep_buffers = 1
    vim.g.bufferize_focus_output = 1
  end)
  ----------------------------------------------------------------------------
  -- end of files
  ----------------------------------------------------------------------------
  -- Plug('junegunn/vader.vim', { ['for'] = 'vader' })
  Plug('rafi/awesome-vim-colorschemes')
  Plug('echasnovski/mini.nvim')
  Plug('folke/which-key.nvim')
  Plug('dstein64/vim-startuptime')
  Plug('tyru/open-browser.vim')

  vim.call('plug#end')
end

return M
