local codeium_loaded, codeium = pcall(require, 'codeium')
if codeium_loaded then
  codeium.setup({})
end

local copilot_loaded, copilot = pcall(require, 'copilot')
if copilot_loaded then
  copilot.setup({
    suggestion = { enabled = false, auto_trigger = false },
    panel = {
      enabled = true,
      auto_refresh = true,
      layout = {
        position = 'right',
      },
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      ['*'] = true,
    },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {},
  })

  require('copilot_cmp').setup()
end

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

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        :match('^%s*$')
      == nil
end

function prioritizeCopilot(entry1, entry2)
  if entry1.copilot and not entry2.copilot then
    return true
  elseif entry2.copilot and not entry1.copilot then
    return false
  end
end

cmp.setup({
  sorting = {
    priority_weight = 2,
    comparators = {
      prioritizeCopilot,
      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
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
    -- ['<c-j>'] = cmp.mapping(
    --   cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    --   { 'i' }
    -- ),
    -- ['<c-k>'] = cmp.mapping(
    --   cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    --   { 'i' }
    -- ),
    -- ['<C-e>'] = cmp.mapping.abort(),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping(function(fallback)
      -- local copilotAccept = vim.fn['copilot#Accept']()
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
        vim.api.nvim_feedkeys(t('<Plug>(ultisnips_jump_forward)'), 'm', true)
      else
        -- cmp.complete() populates list of options
        -- cmp.complete()
        -- fallback() is tab character
        fallback()
      end
      -- elseif copilotAccept ~= '' and type(copilotAccept) == 'string' then
      --   vim.api.nvim_feedkeys(copilotAccept, 'i', true)
      -- elseif check_back_space() then
      --   fallback()
      -- else
      --   cmp.complete()
      -- end
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
        copilot = 'COPILOT',
        codeium = 'Codeium',
      }

      if menu_icon[entry.source.name] then
        item.menu = menu_icon[entry.source.name]
      end
      return item
    end,
  },
  sources = cmp.config.sources({
    { name = 'codeium' },
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
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
