local cmp_loaded, cmp = pcall(require, 'cmp')
if not cmp_loaded then
  return
end

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

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
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
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
        vim.api.nvim_feedkeys(t('<Plug>(ultisnips_jump_forward)'), 'm', true)
      elseif check_back_space() then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
        return vim.api.nvim_feedkeys(
          t('<Plug>(ultisnips_jump_backward)'),
          'm',
          true
        )
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
    }),
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
    { name = 'path' },
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
    { name = 'cmdline_history' },
  }, {
    { name = 'cmdline' },
  }),
})
