vim.lsp.set_log_level(vim.log.levels.ERROR)

local lspconfig_loaded = pcall(require, 'lspconfig')
if not lspconfig_loaded then
  vim.g.logger.error('lspconfig not loaded!')
  return
end

local fzflua = require('fzf-lua')
local lspconfig = require('lspconfig')
local lsputils = require('lspconfig/util')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local masonpath = require('mason-core.path')

mason.setup({
  install_root_dir = masonpath.concat({ vim.g.data_dir, 'mason' }),
})

mason_lspconfig.setup({
  ensure_installed = {
    'biome',
    'bashls',
    'lua_ls',
    'pyright',
    'ts_ls',
    'vimls',
  },
  automatic_installation = false,
})

-------------------------------
--- lspconfig
-------------------------------
local ts_ls_supported_filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
}

---location to fzf params
---@param options vim.lsp.LocationOpts.OnList
---@return string[]
local function locations_to_fzf(options)
  local items = options.items
  local fzf_items = {}
  for index, item in ipairs(items) do
    local fzf_modifier = ':~:.' -- format FZF entries, see |filename-modifiers|
    local fzf_trim = true
    local filename = vim.fn.fnamemodify(item.filename, fzf_modifier)
    local path = vim.g.purple(filename)
    local lnum = vim.g.green(item.lnum)
    local text = fzf_trim and vim.trim(item.text) or item.text
    table.insert(
      fzf_items,
      string.format('%s:%s:%s: %s', path, lnum, item.col, text)
    )
  end

  return fzf_items
end

---handle lsp location list, use fzf when multiple locations found
---@param options vim.lsp.LocationOpts.OnList
local function lsp_on_list_handler(options)
  local result = options.items
  if #result == 1 then
    vim.fn.setqflist(result, 'r')
    return vim.cmd('cfirst')
  end
  local fzf_items = locations_to_fzf(options)
  if #fzf_items > 0 then
    fzflua.fzf_exec(fzf_items, { actions = fzflua.defaults.actions.files })
  end
end

require('lspconfig.ui.windows').default_options.border = 'single'

local root_pattern = lspconfig.util.root_pattern

---get client instance
---@param client_name string
---@param bufnr? number
---@return vim.lsp.Client | nil
local function get_client(client_name, bufnr)
  local clients = vim.lsp.get_clients({ name = client_name, bufnr = bufnr })
  return clients[1] or nil
end

local function ts_ls_organize_imports(client, bufnr)
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }
  client = client or get_client('ts_ls', bufnr)
  client:exec_cmd(params, { bufnr = bufnr })
end

local organize_imports = {
  ---@diagnostic disable-next-line: unused-local
  pyright = function(client, bufnr)
    local command = {
      command = 'pyright.organizeimports',
      arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }
    get_client('pyright', bufnr):exec_cmd(command, { bufnr = bufnr })
  end,
  ts_ls = ts_ls_organize_imports,
}

local function key_map(mode, buffer)
  local opts = { noremap = true, silent = true, buffer = buffer }
  return function(lhs, rhs, desc)
    if desc then
      opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.api.nvim_create_user_command('LspCodeAction', function()
  vim.lsp.buf.code_action()
end, {})

vim.api.nvim_create_user_command('LspFormat', function()
  vim.lsp.buf.format()
end, {})

local IGNORE_LUA_DIAGNOSTIC_CODES = {
  'unused-local',
  'need-check-nil',
  'missing-parameter',
  'cast-local-type',
  'codestyle-check',
  'undefined-doc-name',
}
local IGNORE_TS_DIAGNOSTICS_CODES = {
  80001, -- commonjs module
  6133, -- unused var
  7016, -- missing declaration file
}
local IGNORE_PHP_DIAGNOSTIC_CODES = {
  'worse.undefined_variable',
}

local IGNORE_DIAGNOSTIC_CODES = vim.g.merge_list(
  IGNORE_PHP_DIAGNOSTIC_CODES,
  IGNORE_LUA_DIAGNOSTIC_CODES,
  IGNORE_TS_DIAGNOSTICS_CODES
)

---return a function
---@param direction number
---@return function
local function diagnostic_jump(direction)
  return function()
    vim.diagnostic.jump({ count = direction, float = true })
  end
end

local function common_on_attach(client, bufnr)
  local nmap = key_map('n', bufnr)
  local xmap = key_map('x', bufnr)
  nmap('gA', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action')
  if vim.lsp.buf.range_code_action then
    xmap('gA', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', 'Code action')
  else
    xmap('gA', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action')
  end
  nmap('[d', diagnostic_jump(-1), 'go to prev diagnostic')
  nmap(']d', diagnostic_jump(1), 'go to next diagnostic')
  nmap('gd', function()
    vim.lsp.buf.definition({ on_list = lsp_on_list_handler })
  end, 'go to definition')
  nmap('gr', function()
    vim.lsp.buf.references(nil, { on_list = lsp_on_list_handler })
  end, 'go to references')
  nmap('<leader>lo', function()
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
    local lsp_type = ''
    if vim.list_contains(ts_ls_supported_filetypes, filetype) then
      lsp_type = 'ts_ls'
    end
    if filetype == 'php' then
      lsp_type = 'phpactor'
    end

    if lsp_type and organize_imports[lsp_type] then
      organize_imports[lsp_type](client, bufnr)
    else
      print('No organize imports for ' .. filetype)
    end
  end, 'Organize Imports')
end

local cmp_capabilities = require('blink.cmp').get_lsp_capabilities()
-- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force', -- force: use value from the rightmost map
  lspconfig.util.default_config.capabilities,
  cmp_capabilities
)
lspconfig.vimls.setup({
  on_attach = common_on_attach,
})
if vim.fn.executable('go') == 1 then
  lspconfig.gopls.setup({
    on_attach = common_on_attach,
  })
end
-- cfg.fish_lsp.setup({
--   on_attach = common_on_attach,
-- })
lspconfig.bashls.setup({
  on_attach = common_on_attach,
})

lspconfig.ts_ls.setup({
  filetypes = ts_ls_supported_filetypes,
  root_dir = root_pattern(
    'package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git'
  ),
  cmd = { 'typescript-language-server', '--stdio' },
  commands = {
    OrganizeImports = {
      function()
        local buf = vim.api.nvim_get_current_buf()
        ts_ls_organize_imports(buf)
      end,
      description = 'Organize Imports',
    },
  },
  on_attach = common_on_attach,
})

local lua_runtime_path = vim.split(package.path, ';')
table.insert(lua_runtime_path, 'lua/?.lua')
table.insert(lua_runtime_path, 'lua/?/init.lua')

local function plugin_path(plugin_name)
  return string.format('%s/plug/%s/lua', vim.g.data_dir, plugin_name)
end

local lua_workspace_libs = {
  checkThirdParty = false,
  maxPreload = 2000,
  preloadFileSize = 1000,
  ---- it's slow to load all
  -- library = vim.api.nvim_get_runtime_file('', true),
  --- so only load selected libs
  library = {
    vim.fn.expand('$VIMRUNTIME/lua'),
    vim.g.std_cfg_dir .. '/lua',
    -- plugin_path('gp.nvim'),
    plugin_path('fzf-lua'),
    plugin_path('nvim-lspconfig'),
  },
}

lspconfig.lua_ls.setup({
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      -- https://github.com/LuaLS/vscode-lua/blob/master/setting/schema.json
      runtime = {
        version = 'LuaJIT',
        path = lua_runtime_path,
      },
      completion = {
        enable = true,
        callSnippet = 'Both', -- 'Disable' | 'Both' | 'Replace'
      },
      hint = {
        enable = false,
      },
      codeLens = {
        enable = false,
      },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim', 'hs' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
        disable = IGNORE_LUA_DIAGNOSTIC_CODES,
      },
      workspace = lua_workspace_libs,
    },
  },
  on_attach = common_on_attach,
})

local DIAGNOSTIC_LEVELS = {
  'ERR',
  'WARN',
  'INFO',
  'HINT',
}
vim.diagnostic.config({
  -- :help diagnostic-toggle-virtual-lines-example
  virtual_lines = false,
  virtual_text = {
    virt_text_pos = 'eol',
    -- virt_text_pos = 'eol_right_align',
    -- virt_text_pos = 'overlay',
    -- severity = { min = vim.diagnostic.severity.WARN },
    severity = { min = vim.diagnostic.severity.HINT },
    source = true,
    format = function(report)
      if DIAGNOSTIC_LEVELS[report.severity] then
        return string.format(
          '[%s] %s [%s]',
          report.code, -- this is a number, for example 80000
          report.message,
          DIAGNOSTIC_LEVELS[report.severity]
        )
      else
        return report.message
      end
    end,
  },
  underline = false, -- use underline for diagnostics
  float = {
    format = function(report)
      return string.format(
        'RULE_CODE: %s\n[%s] from [%s]\nMessage: %s',
        report.code,
        DIAGNOSTIC_LEVELS[report.severity],
        report.source,
        report.message
      )
    end,
  },
  signs = {
    severity = { min = vim.diagnostic.severity.HINT },
    linehl = {
      -- -- line hl has background color, so disable
      -- [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = function(
  err,
  result,
  ctx,
  config
)
  local filtered_diagnostic = {}
  for i, diagnostic in ipairs(result.diagnostics) do
    -- vim.g.logger.info('all codes: ' .. vim.inspect(IGNORE_DIAGNOSTIC_CODES))
    -- vim.g.logger.info('code: ' .. vim.inspect(diagnostic.code))
    if not vim.tbl_contains(IGNORE_DIAGNOSTIC_CODES, diagnostic.code) then
      table.insert(filtered_diagnostic, diagnostic)
    end
  end

  result.diagnostics = filtered_diagnostic
  return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx)
end

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return table.concat({ vim.env.VIRTUAL_ENV, 'bin', 'python' }, '/')
  end

  if workspace and vim.g.file_exists(workspace .. '/.venv') then
    return table.concat({ workspace, '.venv', 'bin', 'python' }, '/')
  end

  local py_path =
    table.concat({ vim.g.smart_root() or '', '.venv', 'bin', 'python' }, '/')

  if vim.g.file_exists(py_path) then
    return py_path
  else
    -- Fallback to system Python.
    return vim.g.python3_host_prog
  end
end

-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
lspconfig.pyright.setup({
  on_attach = common_on_attach,
  before_init = function(_, config)
    local py_path = get_python_path(config.root_dir)
    -- vim.g.logger.info('python binary: ' .. vim.inspect(py_path))
    config.settings.python.pythonPath = py_path
  end,
  settings = {
    pyright = {
      disableOrganizeImports = true, -- if use Ruff
    },
    python = {
      analysis = {
        ignore = { '*' }, -- if use Ruff
        --       typeCheckingMode = 'off', -- if use mypy
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
})

lspconfig.csharp_ls.setup({
  on_attach = common_on_attach,
})

lspconfig.biome.setup({
  cmd = { 'biome', 'lsp-proxy' },
})

lspconfig.phpactor.setup({
  on_attach = common_on_attach,
  init_options = {
    ['language_server_phpstan.enabled'] = false,
    ['language_server_psalm.enabled'] = false,
  },
  root_dir = function(startpath)
    ---@diagnostic disable-next-line: undefined-field
    local cwd = vim.uv.cwd()
    -- local root = root_pattern('composer.json')(startpath)
    local root = root_pattern(
      'composer.lock',
      '.editorconfig',
      '.phpactor.json',
      '.phpactor.yml'
    )(startpath)
    -- prefer cwd if root is a descendant
    local result = lsputils.path.is_descendant(cwd, root) and cwd or root
    return result
  end,
})

-- cfg.templ.setup({
--   on_attach = common_on_attach,
-- })
--
-- cfg.rust_analyzer.setup({
--   on_attach = common_on_attach,
-- })
--
-- cfg.intelephense.setup({
--   root_dir = function(startpath)
--     local cwd = vim.uv.cwd()
--     -- local root = root_pattern('composer.json')(startpath)
--     local root = root_pattern('.editorconfig')(startpath)
--     -- prefer cwd if root is a descendant
--     local result = util.path.is_descendant(cwd, root) and cwd or root
--     return result
--   end,
-- })
--
-- cfg.elixirls.setup({
--   on_attach = common_on_attach,
-- })

lspconfig.sourcekit.setup({
  on_attach = common_on_attach,
  capabilities = {
    textDocument = {
      diagnostic = {
        dynamicRegistration = true,
        relatedDocumentSupport = true,
      },
    },
  },
})

lspconfig.nushell.setup({})
lspconfig.tailwindcss.setup({})
