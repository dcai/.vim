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
  for _plugin, setup in pairs(setups.afterEnd) do
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
  Plug('nvim-mini/mini.nvim')
  Plug('folke/snacks.nvim')

  ----------------------------------------------------------------------------
  --- AI
  ----------------------------------------------------------------------------
  Plug('github/copilot.vim', {
    setup = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_proxy_strict_ssl = false
      -- vim.g.copilot_npx = true
      -- vim.gcopilot_node_command = '~/.nodenv/versions/24.00.0/bin/node'
      vim.keymap.set('i', '<C-F>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_filetypes = {
        -- ['markdown'] = false,
        -- ['text'] = false,
        ['help'] = false,
        ['codecompanion'] = false,
      }
    end,
  })
  Plug('olimorris/codecompanion.nvim', { ['tag'] = 'v17.33.0' })
  -- Plug('dcai/gp.nvim', { frozen = 1 })
  ----------------------------------------------------------------------------
  --- lsp
  ----------------------------------------------------------------------------
  Plug('mason-org/mason.nvim', { ['branch'] = 'main' })
  ----------------------------------------------------------------------------
  --- git
  ----------------------------------------------------------------------------
  Plug('tpope/vim-fugitive')
  -- Plug('ruifm/gitlinker.nvim') -- folke/snacks.nvim has git browser support
  -- Plug('sindrets/diffview.nvim')
  -- Plug('NeogitOrg/neogit')
  ----------------------------------------------------------------------------
  --- UI and usability
  ----------------------------------------------------------------------------
  Plug('ibhagwan/fzf-lua')
  Plug('folke/which-key.nvim')
  Plug('j-hui/fidget.nvim')
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
  Plug('saghen/blink.cmp', { ['tag'] = 'v1.7.0' })
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
  -- Plug('greggh/claude-code.nvim')
  END()
end

return M
