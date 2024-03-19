-------------------------------
--- mason
-------------------------------
local mason_loaded, mason = pcall(require, 'mason')
if not mason_loaded then
  print('mason not loaded!')
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
    'gopls',
    'bashls',
    'lua_ls',
    'pyright',
    'tsserver',
    'vimls',
  },
  automatic_installation = true,
})

-------------------------------
--- lspconfig
-------------------------------
local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  return
end

local root_pattern = nvim_lspconfig.util.root_pattern

local timeout_ms = 3000
local organize_imports = {
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

local function common_on_attach(client, buffer)
  vim.cmd([[command! LspFormat execute 'lua vim.lsp.buf.format()']])
  vim.cmd([[command! LspCodeAction execute 'lua vim.lsp.buf.code_action()']])
  local function map(mode, lhs, rhs, desc)
    local opts = { noremap = true, silent = true, buffer = buffer, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end
  map('n', 'D', vim.lsp.buf.hover, 'hover doc')
  map('n', 'R', vim.lsp.buf.rename, 'rename variable')
  map('n', 'gd', vim.lsp.buf.definition, 'go to definition')
  map('n', 'gr', vim.lsp.buf.references, 'go to references')
  map('n', 'OI', function()
    if organize_imports[client.name] then
      organize_imports[client.name](client, buffer)
    else
      print('No organize imports for ' .. client.name)
    end
  end, 'Organize Imports')
  -- map('n', 'gD', vim.lsp.buf.declaration, '')
  -- map('n', 'gi', vim.lsp.buf.implementation, '')
  -- map('n', 'go', vim.lsp.buf.type_definition, '')
end

nvim_lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force', -- force: use value from the rightmost map
  nvim_lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities() -- must use require here
)
nvim_lspconfig.vimls.setup({
  on_attach = common_on_attach,
})
nvim_lspconfig.gopls.setup({
  on_attach = common_on_attach,
})
nvim_lspconfig.bashls.setup({
  on_attach = common_on_attach,
})
nvim_lspconfig.tsserver.setup({
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
    hostInfo = 'neovim',
  },
  on_attach = common_on_attach,
})

nvim_lspconfig.pyright.setup({
  on_attach = common_on_attach,
})

nvim_lspconfig.lua_ls.setup({
  single_file_support = true,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file('', true),
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
        checkThirdParty = false,
      },
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
    local path = purple(filename)
    local lnum = green(item.lnum)
    local text = fzf_trim and vim.trim(item.text) or item.text
    return string.format('%s:%s:%s: %s', path, lnum, item.col, text)
  end

  -- https://github.com/ojroques/nvim-lspfuzzy/blob/main/lua/lspfuzzy.lua
  local fzf_location = wrap_handler(function(_label, result, _ctx, _config)
    result = vim.tbl_islist(result) and result or { result }
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

vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
