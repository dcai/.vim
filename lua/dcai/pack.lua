local M = {}

-- setup() runs after all packages are available, on startup or config reload.
-- build(data) runs on install/update and receives PackChanged event data.
M.specs = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/folke/snacks.nvim',

  -- AI and language servers
  'https://github.com/copilotlsp-nvim/copilot-lsp',
  { src = 'https://github.com/olimorris/codecompanion.nvim', version = 'main' },
  { src = 'https://github.com/mason-org/mason.nvim', version = 'main' },

  -- Git, UI, and navigation
  'https://github.com/tpope/vim-fugitive',
  {
    src = 'https://github.com/dmtrKovalenko/fff',
    version = 'main',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
  },
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  {
    src = 'https://github.com/dcai/nvim-colorizer.lua',
    -- Preserve the revision of the previously frozen fork.
    version = 'master',
    setup = function()
      require('colorizer').setup()
    end,
  },
  'https://github.com/rafi/awesome-vim-colorschemes',
  {
    src = 'https://github.com/dstein64/vim-startuptime',
    setup = function()
      vim.g.startuptime_exe_args = { '--headless' }
    end,
  },
  {
    src = 'https://github.com/tyru/open-browser.vim',
    setup = function()
      vim.g.openbrowser_browser_commands = {
        {
          name = 'open',
          cmd = 'open',
          args = { 'open', '{uri}' },
          background = 0,
        },
      }
    end,
  },
  {
    src = 'https://github.com/AndrewRadev/bufferize.vim',
    setup = function()
      vim.g.bufferize_command = 'new'
      vim.g.bufferize_keep_buffers = 1
      vim.g.bufferize_focus_output = 1
    end,
  },
  {
    src = 'https://github.com/preservim/vimux',
    setup = function()
      vim.g.VimuxOrientation = 'h'
    end,
  },

  -- Syntax and completion
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    build = function()
      local treesitter = require('nvim-treesitter')
      treesitter.setup({
        install_dir = vim.fs.joinpath(
          vim.fn.stdpath('data'),
          'tree-sitter-parsers'
        ),
      })
      assert(treesitter.update(nil, { summary = true }):wait(300000))
    end,
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main',
  },
  {
    src = 'https://github.com/windwp/nvim-ts-autotag',
    setup = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = { ['html'] = { enable_close = true } },
      })
    end,
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    -- Prebuilt fuzzy matchers need a release tag, not the moving v1 branch.
    version = vim.version.range('1.*'),
  },

  -- Writing and editing (all plugins load eagerly)
  {
    src = 'https://github.com/mzlogin/vim-markdown-toc',
    setup = function()
      vim.g.vmt_dont_insert_fence = 1
    end,
  },
  {
    src = 'https://github.com/dcai/markdown-preview.nvim',
    setup = function()
      require('mkdp').setup({
        theme = 'light',
        auto_start = false,
        auto_close = false,
        refresh_slow = true,
      })
    end,
  },
  'https://github.com/preservim/vim-lexical',
  {
    src = 'https://github.com/dcai/ale',
    version = 'master',
  },
  {
    src = 'https://github.com/Wansmer/treesj',
    setup = function()
      local lang_utils = require('treesj.langs.utils')
      require('treesj').setup({
        use_default_keymaps = false,
        check_syntax_error = true,
        max_join_length = 120,
        cursor_behavior = 'hold',
        notify = true,
        dot_repeat = true,
        langs = {
          javascript = lang_utils.merge_preset(
            require('treesj.langs.javascript'),
            {}
          ),
          typescript = lang_utils.merge_preset(
            require('treesj.langs.typescript'),
            {}
          ),
        },
      })
    end,
  },
  'https://github.com/junegunn/vader.vim',
  {
    src = 'https://github.com/dcai/marlin.nvim',
    version = 'main',
  },
  'https://github.com/djoshea/vim-autoread',
  'https://github.com/pocco81/auto-save.nvim',
  'https://github.com/mbbill/undotree',
  'https://github.com/tpope/vim-eunuch',
  'https://github.com/isobit/vim-caddyfile',
  'https://github.com/hashivim/vim-terraform',
}

function M.native_specs()
  return vim.tbl_map(function(spec)
    if type(spec) == 'string' then
      return spec
    end
    local native = vim.tbl_extend('force', {}, spec)
    native.setup = nil
    native.build = nil
    return native
  end, M.specs)
end

local function build_plugin(build, data)
  if not build or (data.kind ~= 'install' and data.kind ~= 'update') then
    return
  end

  -- Install events fire before pack.add() makes the plugin's modules available.
  -- Restore runtimepath even on failure; normal package loading owns its order.
  local runtimepath = vim.o.runtimepath
  vim.opt.runtimepath:prepend(data.path)
  local ok, err = pcall(build, data)
  vim.o.runtimepath = runtimepath
  if not ok then
    error(err)
  end
end

function M.setup()
  local builds, setups = {}, {}
  for _, spec in ipairs(M.specs) do
    if type(spec) == 'table' then
      if spec.build then
        local name = (spec.name or spec.src:gsub('%.git$', '')):match('[^/]+$')
        builds[name] = spec.build
      end
      if spec.setup then
        setups[#setups + 1] = spec.setup
      end
    end
  end
  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('dcai_pack_builds', { clear = true }),
    callback = function(event)
      build_plugin(builds[event.data.spec.name], event.data)
    end,
    desc = 'Build native plugins and update installed parsers',
  })

  vim.pack.add(M.native_specs())
  for _, setup in ipairs(setups) do
    setup()
  end

  -- loader.vim enables filetype detection before packages enter runtimepath.
  -- Refresh it so plugin detectors (including *.vader) are registered too.
  vim.cmd('filetype off')
  vim.cmd('filetype plugin indent on')
end

return M
