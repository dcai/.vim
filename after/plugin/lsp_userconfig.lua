vim.lsp.set_log_level(vim.log.levels.ERROR)

-------------------------------
--- mason
-------------------------------
local mason_loaded, mason = pcall(require, 'mason')
if not mason_loaded then
  vim.g.logger.error('mason not loaded!')
  return
end
local masonpath = require('mason-core.path')
mason.setup({
  install_root_dir = masonpath.concat({ vim.g.data_dir, 'mason' }),
})

-- :help diagnostic-toggle-virtual-lines-example
vim.diagnostic.config({
  virtual_text = {
    -- virt_text_pos = 'eol_right_align',
  },
  virtual_lines = true,
})

-------------------------------
--- mason-lspconfig
-------------------------------
local mason_lspconfig = require('mason-lspconfig')
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
local lspconfig_loaded, lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  vim.g.logger.error('lspconfig not loaded!')
  return
end

local lsputils = require('lspconfig/util')

require('lspconfig.ui.windows').default_options.border = 'single'

local util = lspconfig.util
local root_pattern = lspconfig.util.root_pattern

local timeout_ms = 3000
local ts_ls_cmd_orgimports = '_typescript.organizeImports'
local organize_imports = {
  ---@diagnostic disable-next-line: unused-local
  pyright = function(buf)
    local params = {
      command = 'pyright.organizeimports',
      arguments = { vim.api.nvim_buf_get_name(buf) },
    }
    vim.lsp.buf.execute_command(params)
  end,
  ---@diagnostic disable-next-line: unused-local
  ts_ls = function(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    local params = {
      command = ts_ls_cmd_orgimports,
      arguments = { vim.api.nvim_buf_get_name(buffer) },
    }
    vim.lsp.buf_request_sync(
      buffer,
      'workspace/executeCommand',
      params,
      timeout_ms
    )
  end,
  gopls = function(client, buffer)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(
      buffer,
      'textDocument/codeAction',
      params,
      timeout_ms
    )
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
}

local function map(mode, buffer)
  local opts = { noremap = true, silent = true, buffer = buffer }
  return function(lhs, rhs, desc)
    if desc then
      opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

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

local IGNORE_DIAGNOSTIC_CODES = vim.tbl_deep_extend(
  'force',
  IGNORE_LUA_DIAGNOSTIC_CODES,
  IGNORE_TS_DIAGNOSTICS_CODES
)

local function common_on_attach(client, bufnr)
  -- if client.supports_method('textDocument/codeLens', { bufnr = bufnr }) then
  --   -- client.notify('workspace/didChangeConfiguration', {
  --   --   settings = {
  --   --     ['javascript.referencesCodeLens.enabled'] = true,
  --   --     ['typescript.referencesCodeLens.enabled'] = true,
  --   --   },
  --   -- })
  --   vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.codelens.refresh({ bufnr = bufnr })
  --     end,
  --   })
  -- end
  -- if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end
  -- vim.cmd([[command! LspFormat execute 'lua vim.lsp.buf.format()']])
  -- vim.cmd([[command! LspCodeAction execute 'lua vim.lsp.buf.code_action()']])
  vim.api.nvim_create_user_command('LspCodeAction', function()
    vim.lsp.buf.code_action()
  end, {})
  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, {})
  local nmap = map('n', bufnr)
  local xmap = map('x', bufnr)
  nmap('gA', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action')
  if vim.lsp.buf.range_code_action then
    xmap('gA', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', 'Code action')
  else
    xmap('gA', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action')
  end
  nmap('[d', vim.diagnostic.goto_prev, 'go to prev diagnostic')
  nmap(']d', vim.diagnostic.goto_next, 'go to next diagnostic')
  nmap('gd', vim.lsp.buf.definition, 'go to definition')
  nmap('gr', vim.lsp.buf.references, 'go to references')
  nmap('<leader>lh', vim.lsp.buf.hover, 'hover doc')
  nmap('<leader>lo', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local filetype =
      vim.api.nvim_get_option_value('filetype', { buf = current_buf })
    local lstype = ''
    if vim.list_contains(ts_ls_supported_filetypes, filetype) then
      lstype = 'ts_ls'
    end
    if filetype == 'php' then
      lstype = 'phpactor'
    end

    if organize_imports[lstype] then
      organize_imports[lstype](current_buf)
    else
      print('No organize imports for ' .. filetype)
    end
  end, 'Organize Imports')
  -- nmap('gD', vim.lsp.buf.declaration, '')
  -- nmap('gi', vim.lsp.buf.implementation, '')
  -- nmap('go', vim.lsp.buf.type_definition, '')
end

lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force', -- force: use value from the rightmost map
  lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities() -- must use require here
)
-- LOG.info(cfg.util.default_config.capabilities)
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
        vim.lsp.buf.execute_command({
          command = ts_ls_cmd_orgimports,
          arguments = { vim.api.nvim_buf_get_name(0) },
        })
      end,
      description = 'Organize Imports',
    },
  },
  init_options = {
    preferences = {
      -- includeInlayParameterNameHints = 'all',
      -- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      -- includeInlayFunctionParameterTypeHints = true,
      -- includeInlayVariableTypeHints = true,
      -- includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      -- includeInlayPropertyDeclarationTypeHints = true,
      -- includeInlayFunctionLikeReturnTypeHints = true,
      -- includeInlayEnumMemberValueHints = true,

      includeCompletionsForModuleExports = true,
      importModuleSpecifierEnding = 'auto',
      -- organizeImportsIgnoreCase = false,
      -- organizeImportsCollation = 'unicode',
    },
    hostInfo = 'neovim',
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
    plugin_path('gp.nvim'),
    plugin_path('nvim-cmp'),
    plugin_path('nvim-snippets'),
    plugin_path('fzf-lua'),
    plugin_path('plenary.nvim'),
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
        callSnippet = 'Replace', -- 'Disable' | 'Both' | 'Replace'
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

local fzfloaded, fzflua = pcall(require, 'fzf-lua')
if fzfloaded then
  local offset_encoding
  ---wrap function for error handling and encoding setting
  ---@param handler function
  ---@return function
  local function wrap_handler(handler)
    return function(label)
      return function(err, result, ctx, config)
        if err then
          return print(
            string.format('%s: %s', 'wrap_handler() error', err.message)
          )
        end
        -- Print message if no result
        if not result or vim.tbl_isempty(result) then
          return print(string.format('No %s found', string.lower(label)))
        end

        -- Save offset encoding
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        offset_encoding = client and client.offset_encoding or 'utf-16'
        return handler(label, result, ctx, config)
      end
    end
  end
  local function lsp_to_fzf(item)
    local fzf_modifier = ':~:.' -- format FZF entries, see |filename-modifiers|
    local fzf_trim = true
    local filename = vim.fn.fnamemodify(item.filename, fzf_modifier)
    local path = vim.g.purple(filename)
    local lnum = vim.g.green(item.lnum)
    local text = fzf_trim and vim.trim(item.text) or item.text
    return string.format('%s:%s:%s: %s', path, lnum, item.col, text)
  end

  -- https://github.com/ojroques/nvim-lspfuzzy/blob/main/lua/lspfuzzy.lua
  ---@diagnostic disable-next-line: unused-local
  local fzf_location = wrap_handler(function(_label, result, _ctx, _config)
    result = vim.islist(result) and result or { result }
    if #result == 1 then
      return vim.lsp.util.jump_to_location(result[1], offset_encoding)
    end
    local items = vim.lsp.util.locations_to_items(result, offset_encoding)
    local source = vim.tbl_map(lsp_to_fzf, items)
    fzflua.fzf_exec(source, { actions = fzflua.defaults.actions.files })
  end)

  local handlers = vim.lsp.handlers
  handlers['textDocument/declaration'] = fzf_location('declaration')
  handlers['textDocument/definition'] = fzf_location('definition')
  handlers['textDocument/implementation'] = fzf_location('implementation')
  handlers['textDocument/references'] = fzf_location('references')
  handlers['textDocument/typeDefinition'] = fzf_location('typeDefinition')
end

local DIAGNOSTIC_LEVELS = {
  'ERR',
  'WARN',
  'INFO',
  'HINT',
}
vim.diagnostic.config({
  virtual_text = {
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
  underline = false,
  float = {
    show_header = false,
    format = function(report)
      return string.format(
        '[%s] %s\nCODE: [%s]\nMessage: %s',
        DIAGNOSTIC_LEVELS[report.severity],
        report.source,
        report.code,
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
    -- vim.g.logger.info('code: ' .. vim.inspect(diagnostic.code))
    if not vim.tbl_contains(IGNORE_DIAGNOSTIC_CODES, diagnostic.code) then
      table.insert(filtered_diagnostic, diagnostic)
    end
  end

  result.diagnostics = filtered_diagnostic

  return vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    virtual_text = true,
    loclist = true,
  })(err, result, ctx, config)
end

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return lsputils.path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  if workspace and vim.g.file_exists(workspace .. '/.venv') then
    return lsputils.path.join(workspace, '.venv', 'bin', 'python')
  end

  local py_path =
    lsputils.path.join(vim.g.smart_root() or '', '.venv', 'bin', 'python')

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
    vim.g.logger.info('python binary: ' .. vim.inspect(py_path))
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
    local result = util.path.is_descendant(cwd, root) and cwd or root
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
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
})

lspconfig.tailwindcss.setup({})
