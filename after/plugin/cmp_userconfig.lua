local cmp_loaded, cmp = pcall(require, 'cmp')
if not cmp_loaded then
  print('cmp not loaded!')
  return
end

local codeium_loaded, codeium = pcall(require, 'codeium')
if codeium_loaded then
  -- for Exafunction/codeium.nvim
  codeium.setup({})
end

local function check_back_space()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

local function has_words_before()
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

local function feedkeys(key, mode)
  -- Replaces terminal codes and keycodes
  -- (<CR>, <Esc>, ...) in a string with the internal representation.
  local keys = vim.api.nvim_replace_termcodes(key, true, true, true)
  mode = mode or ''
  -- Sends input-keys to Nvim, subject to various quirks
  -- controlled by mode flags. This is a blocking call, unlike nvim_input().
  vim.api.nvim_feedkeys(keys, mode, true)
end

local prioritizeSource = function(source)
  return function(entry1, entry2)
    if entry1[source] and not entry2[source] then
      return true
    elseif entry2[source] and not entry1[source] then
      return false
    end
  end
end

local compare = cmp.config.compare

-- `behavior=cmp.ConfirmBehavior.Insert`: inserts the selected item and
--   moves adjacent text to the right (default).
-- `behavior=cmp.ConfirmBehavior.Replace`: replaces adjacent text with
--   the selected item.
-- If you didn't select any item and the option table contains `select = true`,
-- nvim-cmp will automatically select the first item.

local handle_enter = cmp.mapping({
  i = function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
      -- cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
    else
      fallback()
    end
  end,
  s = cmp.mapping.confirm({ select = true }),
  c = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  }),
})
local handle_up = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
  elseif vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
    return feedkeys('<Plug>(ultisnips_jump_backward)')
  else
    fallback()
  end
end, { 'i', 's' })

local handle_down = cmp.mapping(function(fallback)
  if cmp.visible() and has_words_before() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    -- below checks whether it is possible to jump forward to the next snippet placeholder
  elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
    return feedkeys('<Plug>(ultisnips_jump_forward)')
  elseif has_words_before() then
    cmp.complete()
  else
    -- cmp.complete(): populates the UI of complete
    -- fallback(): pass through, insert <tab>
    fallback()
  end
end, { 'i', 's' })

cmp.setup({
  preselect = cmp.PreselectMode.None,
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn['UltiSnips#Anon'](args.body)
      -- require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    -- ['<C-e>'] = cmp.mapping.abort(),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<tab>'] = handle_down,
    ['<down>'] = handle_down,
    ['<S-Tab>'] = handle_up,
    ['<up>'] = handle_up,
    ['<CR>'] = handle_enter,
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        -- luasnip = 'ι',
        -- nvim_lsp = 'Ƒ',
        -- ultisnips = 'λ',
        -- tmux = 'Ω',
        -- path = '⋗',
        nvim_lsp = 'lsp',
        ultisnips = 'snip',
        tmux = 'tmux',
        path = 'PATH',
        -- copilot = 'Copilot',
        codeium = 'Codeium',
      }

      if menu_icon[entry.source.name] then
        item.menu = menu_icon[entry.source.name]
      end
      return item
    end,
  },
  sources = cmp.config.sources({
    { name = 'codeium', group_index = 1 },
    -- { name = 'copilot' },
    { name = 'nvim_lsp', group_index = 3 },
    { name = 'ultisnips', group_index = 5 },
    -- { name = 'luasnip' },
    { name = 'buffer' },
    {
      name = 'path',
      option = {
        trailing_slash = true,
      },
    },
    {
      name = 'tmux',
      -- priority = 1,
      group_index = 10,
      option = {
        -- Source from all panes in session instead of adjacent panes
        all_panes = false,
        -- trigger_characters = { '.' },
        -- keyword_pattern = [[\w\+]],
        keyword_pattern = [[[\w\-]+]],
        -- Completion popup label
        label = '[tmux]',
        -- Specify trigger characters for filetype(s)
        -- { filetype = { '.' } }
        trigger_characters_ft = {},
        -- Capture full pane history
        -- `false`: show completion suggestion from text in the visible pane (default)
        -- `true`: show completion suggestion from text starting from the beginning of the pane history.
        --         This works by passing `-S -` flag to `tmux capture-pane` command. See `man tmux` for details.
        capture_history = false,
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
