local status, nvim_lspconfig = pcall(require, 'lspconfig')

if not status then
  return
end

local cmpstatus, cmp = pcall(require, 'cmp')
if not cmpstatus then
  return
end
local nulllsstatus, null_ls = pcall(require, 'null-ls')
if not nulllsstatus then
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.completion.spell,
  },
})

local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ee', vim.diagnostic.setloclist, opts)

cmp.setup({
  snippet = {
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-j>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<c-k>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<tab>'] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    -- { name = "vsnip" } -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local commonBufKeyMap = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
end

-- TypeScript
nvim_lspconfig.tsserver.setup({
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
  on_attach = function(client, bufnr)
    commonBufKeyMap(client, bufnr)
  end,
  capabilities = capabilities,
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
