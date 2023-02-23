local lspconfig_loaded, nvim_lspconfig = pcall(require, 'lspconfig')

if not lspconfig_loaded then
  return
end

local lsp_defaults = nvim_lspconfig.util.default_config

local cmp_loaded, cmp = pcall(require, 'cmp')
if not cmp_loaded then
  return
end
local nullls_loaded, null_ls = pcall(require, 'null-ls')
if not nullls_loaded then
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.completion.spell,
  },
})

local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ee', vim.diagnostic.setloclist, opts)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

local select_opts = { behavior = cmp.SelectBehavior.Insert }

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
    ['<c-j>'] = cmp.mapping(
      cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      { 'i' }
    ),
    ['<c-k>'] = cmp.mapping(
      cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
      { 'i' }
    ),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1
      if cmp and cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif check_back_space() then
        return t('<Tab>')
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- ['<tab>'] = cmp.mapping.confirm({
    --   select = true,
    --   behavior = cmp.ConfirmBehavior.Replace,
    -- }),
  }),
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        -- nvim_lsp = 'Ƒ',
        -- ultisnips = 'λ',
        -- tmux = 'Ω',
        -- path = '⋗',
        nvim_lsp = 'LSP',
        ultisnips = 'SNIP',
        tmux = 'TMUX',
        path = 'PATH',
      }

      if menu_icon[entry.source.name] then
        item.menu = menu_icon[entry.source.name]
      end
      return item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'buffer' },
    { name = 'buffer' },
    {
      name = 'path',
      option = {
        -- Options go into this table
      },
    },
    {
      name = 'tmux',
      keyword_length = 3,
      option = {
        -- Source from all panes in session instead of adjacent panes
        all_panes = false,
        -- Completion popup label
        label = '[tmux]',
        -- Trigger character
        trigger_characters = { '.' },
        -- Specify trigger characters for filetype(s)
        -- { filetype = { '.' } }
        trigger_characters_ft = {},
        -- Keyword patch mattern
        keyword_pattern = [[\w\+]],
      },
    },
    -- { name = "vsnip" } -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'snippy' }, -- For snippy users.
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

local commonBufKeyMap = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'D', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
end

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

nvim_lspconfig.tsserver.setup({
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
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
