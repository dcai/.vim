-------------------------------
--- mason
-------------------------------
local mason_loaded, mason = pcall(require, 'mason')
if not mason_loaded then
  LOG.error('mason not loaded!')
  return
end
local masonpath = require('mason-core.path')
mason.setup({
  install_root_dir = masonpath.concat({ vim.fn.stdpath('data'), 'mason' }),
})
-------------------------------
--- mason-lspconfig
-------------------------------
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls',
    'pyright',
    'tsserver',
    'vimls',
  },
  automatic_installation = false,
})

-------------------------------
--- lspconfig
-------------------------------
local lspconfig_loaded, cfg = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  LOG.error('lspconfig not loaded!')
  return
end
require('lspconfig.ui.windows').default_options.border = 'single'

local util = cfg.util
local root_pattern = cfg.util.root_pattern

local timeout_ms = 3000
local organize_imports = {
  ---@diagnostic disable-next-line: unused-local
  pyright = function(_client, buf)
    local params = {
      command = 'pyright.organizeimports',
      arguments = { vim.api.nvim_buf_get_name(buf) },
    }
    vim.lsp.buf.execute_command(params)
  end,
  ---@diagnostic disable-next-line: unused-local
  tsserver = function(_client, buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    local params = {
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(buffer) },
      title = 'Organize Imports',
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

local function common_on_attach(client, bufnr)
  if client.supports_method('textDocument/codeLens', { bufnr = bufnr }) then
    -- client.notify('workspace/didChangeConfiguration', {
    --   settings = {
    --     ['javascript.referencesCodeLens.enabled'] = true,
    --     ['typescript.referencesCodeLens.enabled'] = true,
    --   },
    -- })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })
  end
  if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  vim.cmd([[command! LspFormat execute 'lua vim.lsp.buf.format()']])
  vim.cmd([[command! LspCodeAction execute 'lua vim.lsp.buf.code_action()']])
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
    local clientname = client.name
    if
      client.name == 'tailwindcss' or client.name == 'emmet_language_server'
    then
      clientname = 'tsserver'
    end
    if organize_imports[clientname] then
      organize_imports[clientname](client, bufnr)
    else
      print('No organize imports for ' .. client.name)
    end
  end, 'Organize Imports')
  -- nmap('gD', vim.lsp.buf.declaration, '')
  -- nmap('gi', vim.lsp.buf.implementation, '')
  -- nmap('go', vim.lsp.buf.type_definition, '')
end

cfg.util.default_config.capabilities = vim.tbl_deep_extend(
  'force', -- force: use value from the rightmost map
  cfg.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities() -- must use require here
)
-- LOG.info(cfg.util.default_config.capabilities)
cfg.vimls.setup({
  on_attach = common_on_attach,
})
if vim.fn.executable('go') == 1 then
  cfg.gopls.setup({
    on_attach = common_on_attach,
  })
end
-- cfg.fish_lsp.setup({
--   on_attach = common_on_attach,
-- })
cfg.bashls.setup({
  on_attach = common_on_attach,
})
cfg.tsserver.setup({
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
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
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
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
  return string.format('%s/plug/%s/lua', vim.fn.stdpath('data'), plugin_name)
end

local workspace_libs = {
  checkThirdParty = false,
  maxPreload = 2000,
  preloadFileSize = 1000,
  ---- it's slow to load all
  -- library = vim.api.nvim_get_runtime_file('', true),
  --- so only load selected libs
  library = {
    vim.fn.expand('$VIMRUNTIME/lua'),
    vim.fn.stdpath('config') .. '/lua',
    plugin_path('gp.nvim'),
    plugin_path('fzf-lua'),
    plugin_path('plenary.nvim'),
  },
}

cfg.lua_ls.setup({
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      -- https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json
      runtime = {
        version = 'LuaJIT',
        path = lua_runtime_path,
      },
      hint = {
        enable = false,
      },
      codeLens = {
        enable = false,
      },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any',
        },
        disable = {
          'need-check-nil',
          'missing-parameter',
          'cast-local-type',
          'codestyle-check',
        },
      },
      workspace = workspace_libs,
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
    local path = G.purple(filename)
    local lnum = G.green(item.lnum)
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

vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.HINT },
    source = true,
    format = function(report)
      local strings = {
        'ERR',
        'WARN',
        'INFO',
        'HINT',
      }
      if strings[report.severity] then
        return string.format(
          '[%s] %s\n%s',
          strings[report.severity],
          report.message,
          report.code
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
      -- LOG.info(report)
      return string.format(
        '[%s] %s %s',
        report.source,
        report.message,
        report.code
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
-- vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end

cfg.pyright.setup({
  on_attach = common_on_attach,
  -- settings = {
  --   pyright = {
  --     disableOrganizeImports = true, -- if use Ruff
  --   },
  --   python = {
  --     analysis = {
  --       ignore = { '*' }, -- if use Ruff
  --       typeCheckingMode = 'off', -- if use mypy
  --     },
  --   },
  -- },
})

cfg.csharp_ls.setup({
  on_attach = common_on_attach,
})

cfg.tailwindcss.setup({
  on_attach = common_on_attach,
})

cfg.mojo.setup({
  on_attach = common_on_attach,
})

cfg.svelte.setup({
  on_attach = common_on_attach,
})
cfg.html.setup({
  on_attach = common_on_attach,
})
cfg.templ.setup({
  on_attach = common_on_attach,
})

cfg.rust_analyzer.setup({
  on_attach = common_on_attach,
})
cfg.biome.setup({
  cmd = { 'biome', 'lsp-proxy' },
})

cfg.phpactor.setup({
  root_dir = function(startpath)
    local cwd = vim.uv.cwd()
    -- local root = root_pattern('composer.json')(startpath)
    local root =
      root_pattern('.editorconfig', '.phpactor.json', '.phpactor.yml')(
        startpath
      )
    -- prefer cwd if root is a descendant
    local result = util.path.is_descendant(cwd, root) and cwd or root
    return result
  end,
})

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

cfg.elixirls.setup({
  on_attach = common_on_attach,
})
cfg.emmet_language_server.setup({
  filetypes = {
    'elixir',
    'heex',
    'css',
    'eruby',
    'html',
    'javascript',
    'javascriptreact',
    'less',
    'sass',
    'scss',
    'pug',
    'typescriptreact',
  },

  on_attach = common_on_attach,
})
cfg.azure_pipelines_ls.setup({})
