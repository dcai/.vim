local M = {}

M.setup = function(opts)
  local vim = vim
  local Plug = vim.fn['plug#']
  local dir = opts.dir or vim.fn.expand(vim.fn.stdpath('data') .. '/plug')
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
  --- nvim-cmp
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
  -- ultisnips
  Plug('SirVer/ultisnips')
  Plug('quangnguyen30192/cmp-nvim-ultisnips')
  ----------------------------------------------------------------------------
  --- markdown
  ----------------------------------------------------------------------------
  Plug('mzlogin/vim-markdown-toc', { ['for'] = 'markdown' })
  vim.g.vmt_dont_insert_fence = 1
  Plug(
    'iamcco/markdown-preview.nvim',
    { ['do'] = 'cd app && npx --yes yarn install', ['for'] = 'markdown' }
  )
  vim.g.mkdp_theme = 'light'
  ----------------------------------------------------------------------------
  --- END of markdown
  ----------------------------------------------------------------------------
  --- vim-test
  ----------------------------------------------------------------------------
  Plug('preservim/vimux')
  vim.g.VimuxOrientation = 'h'
  Plug('vim-test/vim-test')
  vim.g['test#javascript#runner'] = 'jest'
  vim.g['test#javascript#mocha#executable'] = 'npx mocha'
  vim.g['test#javascript#mocha#options'] = ' --full-trace '
  vim.g['test#javascript#jest#executable'] = 'npx jest'
  vim.g['test#javascript#jest#file_pattern'] =
    '\v(__tests__/.+|(spec|test)).(js|jsx|coffee|ts|tsx)$'
  vim.g['test#runner_commands'] = { 'Jest', 'Mocha' }
  vim.g['test#strategy'] = 'neovim'
  vim.g['test#neovim#term_position'] = 'vert'
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
  Plug('AndrewRadev/bufferize.vim')
  vim.g.bufferize_command = 'new'
  vim.g.bufferize_keep_buffers = 1
  vim.g.bufferize_focus_output = 1
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
