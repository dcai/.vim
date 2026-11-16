local M = {}

-- Sources accept owner/repo shorthand for GitHub or a full repository URL.
-- setup() runs after all packages are available, on startup or config reload.
-- build(data) runs on install/update and receives PackChanged event data.
M.specs = {
  'nvim-lua/plenary.nvim',
  'nvim-mini/mini.nvim',
  'folke/snacks.nvim',

  -- AI and language servers
  { src = 'olimorris/codecompanion.nvim', version = 'main' },
  { src = 'mason-org/mason.nvim', version = 'main' },

  -- Git, UI, and navigation
  'tpope/vim-fugitive',
  {
    src = 'dmtrKovalenko/fff',
    version = 'main',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
  },
  'ibhagwan/fzf-lua',
  'folke/which-key.nvim',
  'nvim-tree/nvim-web-devicons',
  {
    src = 'dcai/nvim-colorizer.lua',
    -- Preserve the revision of the previously frozen fork.
    version = 'master',
    setup = function()
      require('colorizer').setup()
    end,
  },
  'rafi/awesome-vim-colorschemes',
  {
    src = 'dstein64/vim-startuptime',
    setup = function()
      vim.g.startuptime_exe_args = { '--headless' }
    end,
  },
  {
    src = 'tyru/open-browser.vim',
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
    src = 'AndrewRadev/bufferize.vim',
    setup = function()
      vim.g.bufferize_command = 'new'
      vim.g.bufferize_keep_buffers = 1
      vim.g.bufferize_focus_output = 1
    end,
  },
  {
    src = 'preservim/vimux',
    setup = function()
      vim.g.VimuxOrientation = 'h'
    end,
  },

  -- Syntax and completion
  {
    src = 'nvim-treesitter/nvim-treesitter',
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
    src = 'nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main',
  },
  {
    src = 'windwp/nvim-ts-autotag',
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
    src = 'saghen/blink.cmp',
    -- Prebuilt fuzzy matchers need a release tag, not the moving v1 branch.
    version = vim.version.range('1.*'),
  },

  -- Writing and editing (all plugins load eagerly)
  {
    src = 'mzlogin/vim-markdown-toc',
    setup = function()
      vim.g.vmt_dont_insert_fence = 1
    end,
  },
  {
    src = 'dcai/markdown-preview.nvim',
    setup = function()
      require('mkdp').setup({
        theme = 'light',
        auto_start = false,
        auto_close = false,
        refresh_slow = true,
      })
    end,
  },
  'preservim/vim-lexical',
  {
    src = 'dcai/ale',
    version = 'master',
  },
  {
    src = 'Wansmer/treesj',
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
  'junegunn/vader.vim',
  {
    src = 'dcai/marlin.nvim',
    version = 'main',
  },
  'djoshea/vim-autoread',
  'pocco81/auto-save.nvim',
  'mbbill/undotree',
  'tpope/vim-eunuch',
  'isobit/vim-caddyfile',
  'hashivim/vim-terraform',
}

local function expand_source(src)
  if src:match('^[%w_-]+/[%w_.-]+$') then
    return 'https://github.com/' .. src
  end
  return src
end

function M.native_specs()
  return vim.tbl_map(function(spec)
    if type(spec) == 'string' then
      return expand_source(spec)
    end
    local native = vim.tbl_extend('force', {}, spec)
    native.src = expand_source(native.src)
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

--- @param opts? { sync?: boolean } Sync installed plugins to locked revisions.
function M.setup(opts)
  opts = opts or {}
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
  if opts.sync then
    vim.pack.update(nil, { target = 'lockfile', force = true })
  end
  for _, setup in ipairs(setups) do
    setup()
  end

  -- loader.vim enables filetype detection before packages enter runtimepath.
  -- Refresh it so plugin detectors (including *.vader) are registered too.
  vim.cmd('filetype off')
  vim.cmd('filetype plugin indent on')
end

return M
