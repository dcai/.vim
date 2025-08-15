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

---setup vim-plug
---@param plug_opts table
M.setup = function(plug_opts)
  local dir = plug_opts.dir or vim.fn.expand(vim.g.data_dir .. '/plug')
  vim.call('plug#begin', dir)
  Plug('nvim-lua/plenary.nvim')
  Plug('echasnovski/mini.nvim')
  -- Plug('folke/snacks.nvim')

  ----------------------------------------------------------------------------
  --- AI
  ----------------------------------------------------------------------------
  -- Plug('zbirenbaum/copilot.lua')
  Plug('github/copilot.vim', {
    setup = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_proxy_strict_ssl = false
      vim.keymap.set('i', '<C-F>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_filetypes = {
        -- ['markdown'] = false,
        -- ['text'] = false,
        ['help'] = false,
      }
    end,
  })
  Plug('olimorris/codecompanion.nvim')
  Plug('dcai/gp.nvim', { frozen = 1 })
  ----------------------------------------------------------------------------
  --- lsp
  ----------------------------------------------------------------------------
  Plug('neovim/nvim-lspconfig')
  Plug('mason-org/mason.nvim', { ['branch'] = 'main' })
  ----------------------------------------------------------------------------
  --- git
  ----------------------------------------------------------------------------
  Plug('tpope/vim-fugitive')
  Plug('ruifm/gitlinker.nvim')
  ----------------------------------------------------------------------------
  --- UI and usability
  ----------------------------------------------------------------------------
  Plug('ibhagwan/fzf-lua')
  Plug('folke/which-key.nvim')
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
  Plug('rafi/awesome-vim-colorschemes')
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
  Plug('saghen/blink.cmp', { ['tag'] = 'v1.5.1' })
  ----------------------------------------------------------------------------
  --- markdown
  ----------------------------------------------------------------------------
  Plug('mzlogin/vim-markdown-toc', {
    ['for'] = 'markdown',
    setup = function()
      vim.g.vmt_dont_insert_fence = 1
    end,
  })
  Plug('dcai/markdown-preview.nvim', {
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
  Plug('preservim/vim-lexical')
  Plug('dcai/ale', { frozen = 1 })
  Plug('Wansmer/treesj', {
    ['setup'] = function()
      local ok, tj = pcall(require, 'treesj')
      if ok then
        tj.setup({
          use_default_keymaps = false,
          check_syntax_error = true,
          max_join_length = 120,
          cursor_behavior = 'hold',
          notify = true,
          dot_repeat = true,
          on_error = nil,
        })
      end
    end,
  })
  -- Plug('tpope/vim-dadbod')
  -- Plug('kristijanhusak/vim-dadbod-ui')
  -- Plug('kristijanhusak/vim-dadbod-completion')
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
  ----------------------------------------------------------------------------
  -- files and editing
  ----------------------------------------------------------------------------
  Plug('junegunn/vader.vim', { ['for'] = 'vader' })
  Plug('dcai/marlin.nvim', { frozen = 1 }) -- forked 'desdic/marlin.nvim'
  Plug('djoshea/vim-autoread')
  Plug('pocco81/auto-save.nvim')
  Plug('mbbill/undotree')
  Plug('tpope/vim-eunuch') -- Vim sugar for the UNIX shell
  Plug('isobit/vim-caddyfile')
  Plug('greggh/claude-code.nvim', {
    setup = function()
      require('claude-code').setup({
        window = {
          split_ratio = 0.5, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
          position = 'float', -- Position of the window: "botright", "topleft", "vertical", "float", etc.
          enter_insert = true, -- Whether to enter insert mode when opening Claude Code
          hide_numbers = true, -- Hide line numbers in the terminal window
          hide_signcolumn = true, -- Hide the sign column in the terminal window

          -- Floating window configuration (only applies when position = "float")
          float = {
            width = '80%', -- Width: number of columns or percentage string
            height = '80%', -- Height: number of rows or percentage string
            row = 'center', -- Row position: number, "center", or percentage string
            col = 'center', -- Column position: number, "center", or percentage string
            relative = 'editor', -- Relative to: "editor" or "cursor"
            border = 'rounded', -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
          },
        },
        -- Keymaps
        keymaps = {
          toggle = {
            normal = '<c-q>', -- Normal mode keymap for toggling Claude Code, false to disable
            terminal = '<c-q>', -- Terminal mode keymap for toggling Claude Code, false to disable
            variants = {
              continue = nil, -- Normal mode keymap for Claude Code with continue flag
              verbose = '<leader>cV', -- Normal mode keymap for Claude Code with verbose flag
            },
          },
          window_navigation = false, -- Enable window navigation keymaps (<C-h/j/k/l>)
          scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
        },
      })
    end,
  })
  END()
end

return M
