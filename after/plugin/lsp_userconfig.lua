local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  return
end

local lsp_defaults = nvim_lspconfig.util.default_config

local nullls_loaded, null_ls = pcall(require, 'null-ls')
if not nullls_loaded then
  return
end

null_ls.setup({
  sources = {
    -- null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.completion.spell,
  },
})

-- local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, opts)
-- vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '<leader>dd', vim.diagnostic.setqflist, opts)

local commonBufKeyMap = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'D', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
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
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
  commands = {
    organizeImports = {
      organize_imports,
      description = 'Organize Imports',
    },
  },
  on_attach = function(client, bufnr)
    commonBufKeyMap(client, bufnr)
  end,
})

nvim_lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    commonBufKeyMap(client, bufnr)
  end,
})

nvim_lspconfig.lua_ls.setup({
  on_attach = function(client, bufnr)
    commonBufKeyMap(client, bufnr)
  end,
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
})
vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
