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
    -- vim.g.logger.trace('setting up ' .. plugin)
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

local completion_engine = os.getenv('NVIM_COMPLETION_ENGINE') or 'copilot'

---setup vim-plug
---@param plug_opts table
M.setup = function(plug_opts)
  local dir = plug_opts.dir or vim.fn.expand(vim.g.data_dir .. '/plug')
  vim.call('plug#begin', dir)
  Plug('nvim-lua/plenary.nvim')
  Plug('echasnovski/mini.nvim')

  if completion_engine == 'copilot' then
    Plug('zbirenbaum/copilot.lua')
    Plug('CopilotC-Nvim/CopilotChat.nvim')
  elseif completion_engine == 'codeium' then
    -- Plug('Exafunction/codeium.nvim')
    Plug('dcai/neocodeium')
  elseif completion_engine == 'cody' then
    Plug('sourcegraph/sg.nvim')
  end

  if
    vim.g.is_env_var_set('OPENAI_API_KEY')
    or vim.g.is_env_var_set('GEMINI_API_KEY')
  then
    Plug('dcai/gp.nvim')
    Plug('olimorris/codecompanion.nvim')
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
  Plug('ruifm/gitlinker.nvim')
  ----------------------------------------------------------------------------
  --- UI and usability
  ----------------------------------------------------------------------------
  Plug('j-hui/fidget.nvim', {
    setup = function()
      local ok, fidget = pcall(require, 'fidget')
      if not ok then
        return
      end
      fidget.setup({})
    end,
  })
  Plug('nvim-tree/nvim-web-devicons')
  Plug('norcalli/nvim-colorizer.lua', {
    setup = function()
      local ok, colorizer = pcall(require, 'colorizer')
      if not ok then
        return
      end
      colorizer.setup()
    end,
  })
  Plug('ibhagwan/fzf-lua')
  Plug('rafi/awesome-vim-colorschemes')
  Plug('folke/which-key.nvim')
  Plug('dstein64/vim-startuptime')
  Plug('tyru/open-browser.vim')
  Plug('AndrewRadev/bufferize.vim', {
    setup = function()
      vim.g.bufferize_command = 'new'
      vim.g.bufferize_keep_buffers = 1
      vim.g.bufferize_focus_output = 1
    end,
  })
  Plug('preservim/vimux', {
    setup = function()
      vim.g.VimuxOrientation = 'h'
    end,
  })
  -- Plug('folke/snacks.nvim')
  ----------------------------------------------------------------------------
  --- treesitter
  ----------------------------------------------------------------------------
  Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
  Plug('nvim-treesitter/nvim-treesitter-textobjects')
  Plug('JoosepAlviste/nvim-ts-context-commentstring')
  Plug('windwp/nvim-ts-autotag', {
    setup = function()
      local ok, autotag = pcall(require, 'nvim-ts-autotag')
      if not ok then
        return
      end
      autotag.setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = { ['html'] = { enable_close = true } },
      })
    end,
  })

  ----------------------------------------------------------------------------
  --- cmp
  ----------------------------------------------------------------------------
  Plug('saghen/blink.cmp', { ['tag'] = 'v1.1.1' })
  -- Plug('andersevenrud/cmp-tmux')
  -- Plug('hrsh7th/cmp-buffer')
  -- Plug('hrsh7th/cmp-cmdline')
  -- Plug('hrsh7th/cmp-nvim-lsp')
  -- Plug('hrsh7th/cmp-path')
  -- Plug('hrsh7th/nvim-cmp')
  -- Plug('dcai/nvim-snippets', {
  --  setup = function()
  --  local ok, snippets = pcall(require, 'snippets')
  --     if not ok then
  --     return
  --      end
  --   snippets.setup({
  --    -- search_paths = { vim.fn.stdpath('config') .. '/snippets' },
  --   search_paths = { vim.fn.expand('~/src/vim-snippets/') },
  --     create_cmp_source = true,
  --  })
  --   end,
  --  })
  -- Plug('SirVer/ultisnips')
  -- Plug('quangnguyen30192/cmp-nvim-ultisnips')
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
  -- coding, development, writing
  ----------------------------------------------------------------------------
  Plug('reedes/vim-lexical')
  Plug('dcai/ale', { frozen = 1 })
  -- Plug('tpope/vim-dadbod')
  -- Plug('kristijanhusak/vim-dadbod-ui')
  -- Plug('kristijanhusak/vim-dadbod-completion')
  ----------------------------------------------------------------------------
  -- files and editing
  ----------------------------------------------------------------------------
  Plug('junegunn/vader.vim', { ['for'] = 'vader' })
  Plug('dcai/marlin.nvim') -- forked 'desdic/marlin.nvim'
  Plug('djoshea/vim-autoread')
  Plug('pocco81/auto-save.nvim')
  Plug('mbbill/undotree')
  Plug('tpope/vim-eunuch') -- Vim sugar for the UNIX shell
  Plug('isobit/vim-caddyfile', { ['for'] = 'caddyfile' })
  Plug('akinsho/toggleterm.nvim', {
    setup = function()
      local loaded, toggleterm = pcall(require, 'toggleterm')
      if not loaded then
        return
      end
      toggleterm.setup({
        -- shell = vim.o.shell,
        shell = 'fish',
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        -- XXX: dont bind esc, this blocks closing fzf with esc
        -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  })
  END()
end

return M
