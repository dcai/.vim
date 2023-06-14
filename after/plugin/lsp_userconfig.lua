-----------------------------------------------------------------------------
--- mason
-----------------------------------------------------------------------------
local mason_loaded, mason = pcall(require, 'mason')
if not mason_loaded then
  return
end
local path = require('mason-core.path')
mason.setup({
  install_root_dir = path.concat({ vim.fn.stdpath('data'), 'mason' }),
})
-----------------------------------------------------------------------------
--- mason-lspconfig
-----------------------------------------------------------------------------
local mason_lspconfig_loaded, mason_lspconfig =
  pcall(require, 'mason-lspconfig')
mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls',
    'pyright',
    'tsserver',
  },
  automatic_installation = true,
})

-----------------------------------------------------------------------------
--- null-ls
-----------------------------------------------------------------------------
local nullls_loaded, null_ls = pcall(require, 'null-ls')
if not nullls_loaded then
  return
end

null_ls.setup({
  debug = true,
  sources = {
    -- null_ls.builtins.formatting.prettier,
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.shfmt,
    -- null_ls.builtins.formatting.eslint,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.completion.spell,
  },
})

-----------------------------------------------------------------------------
--- lspconfig
-----------------------------------------------------------------------------
local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  return
end

local lsp_defaults = nvim_lspconfig.util.default_config

-- local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, opts)
-- vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '<leader>dd', vim.diagnostic.setqflist, opts)

local common_on_attach = function(client, bufnr)
  vim.cmd([[command! LspFormat execute 'lua vim.lsp.buf.format()']])

  local opts = { noremap = true, silent = true, buffer = bufnr }
  -- local opts = { noremap = true, silent = true }
  vim.keymap.set('n', 'D', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'R', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
end

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  -- must use require here
  require('cmp_nvim_lsp').default_capabilities()
)

local function organize_imports()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  }
  vim.lsp.buf.execute_command(params)
end

nvim_lspconfig.tsserver.setup({
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  cmd = { 'typescript-language-server', '--stdio' },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = 'Organize Imports',
    },
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
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
  on_attach = common_on_attach,
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
