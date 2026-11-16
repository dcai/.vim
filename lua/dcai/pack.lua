local M = {}

-- Sources accept owner/repo shorthand for GitHub or a full repository URL.
-- deps accepts nested specs; shared sources merge, conflicting fields error.
-- setup() runs after all packages are available, on startup or config reload.
-- build(data) runs on install/update and receives PackChanged event data.
M.specs = {
  'nvim-mini/mini.nvim',
  'folke/snacks.nvim',

  -- AI and language servers
  {
    src = 'olimorris/codecompanion.nvim',
    version = 'main',
    deps = { 'nvim-lua/plenary.nvim' },
  },
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

local function resolve_specs()
  local nodes, declarations = {}, {}
  local function collect(spec)
    if declarations[spec] then
      return declarations[spec]
    end
    local is_table = type(spec) == 'table'
    local src = expand_source(is_table and spec.src or spec)
    local key = src:gsub('%.git$', '')
    local node = nodes[key]
    if not node then
      node = { spec = { src = src }, deps = {} }
      nodes[key] = node
    end
    if is_table then
      declarations[spec] = node
      node.is_table = true
      for field, value in pairs(spec) do
        if field ~= 'src' and field ~= 'deps' then
          local previous = node.spec[field]
          assert(
            previous == nil or vim.deep_equal(previous, value),
            'Conflicting plugin field ' .. field .. ': ' .. key
          )
          node.spec[field] = value
        end
      end
      for _, dep in ipairs(spec.deps or {}) do
        node.deps[#node.deps + 1] = collect(dep)
      end
    end
    return node
  end

  -- Collect first so later declarations can add settings and dependencies.
  local roots = vim.tbl_map(collect, M.specs)
  local ordered, visiting, visited = {}, {}, {}
  local function visit(node)
    assert(not visiting[node], 'Plugin dependency cycle: ' .. node.spec.src)
    if visited[node] then
      return
    end
    visiting[node] = true
    for _, dep in ipairs(node.deps) do
      visit(dep)
    end
    visiting[node] = nil
    visited[node] = true
    ordered[#ordered + 1] = node.is_table and node.spec or node.spec.src
  end
  for _, root in ipairs(roots) do
    visit(root)
  end
  return ordered
end

local function native_specs(specs)
  return vim.tbl_map(function(spec)
    if type(spec) == 'string' then
      return spec
    end
    local native = vim.tbl_extend('force', {}, spec)
    native.setup = nil
    native.build = nil
    return native
  end, specs)
end

function M.native_specs()
  return native_specs(resolve_specs())
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
  local specs = resolve_specs()
  local builds, setups = {}, {}
  for _, spec in ipairs(specs) do
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

  vim.pack.add(native_specs(specs))
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
