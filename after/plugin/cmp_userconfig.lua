local cmp_loaded, cmp = pcall(require, 'cmp')
if not cmp_loaded then
  LOG.error('cmp not loaded!')
  return
end
-- LOG.trace('cmp loaded, setting up...')

---@diagnostic disable-next-line: unused-function, unused-local
local function _check_back_space()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

local function has_words_before()
  local buftype = vim.api.nvim_get_option_value(
    'buftype',
    { buf = vim.api.nvim_win_get_buf(0) }
  )
  -- LOG.debug('has words before: ' .. buftype)
  if buftype == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
        :match('^%s*$')
      == nil
end

---@diagnostic disable-next-line: unused-function, unused-local
local function feedkeys(key, mode)
  -- Replaces terminal codes and keycodes
  -- (<CR>, <Esc>, ...) in a string with the internal representation.
  local keys = vim.api.nvim_replace_termcodes(key, true, true, true)
  mode = mode or ''
  -- Sends input-keys to Nvim, subject to various quirks
  -- controlled by mode flags. This is a blocking call, unlike nvim_input().
  vim.api.nvim_feedkeys(keys, mode, true)
end

---@diagnostic disable-next-line: unused-function, unused-local
local _prioritizeSource = function(source)
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
      -- cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
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
  -- if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
  --   return feedkeys('<Plug>(ultisnips_jump_backward)')
  -- elseif cmp.visible() then
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
  else
    fallback()
  end
end, { 'i', 's' })

local handle_down = cmp.mapping(function(fallback)
  -- if vim.fn['UltiSnips#CanJumpForwards']() == 1 then
  --   return feedkeys('<Plug>(ultisnips_jump_forward)')
  -- elseif cmp.visible() and has_words_before() then
  if cmp.visible() and has_words_before() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    -- below checks whether it is possible to jump forward to the next snippet placeholder
  elseif has_words_before() then
    cmp.complete()
  else
    -- cmp.complete(): populates the UI of complete
    -- fallback(): pass through, insert <tab>
    fallback()
  end
end, { 'i', 's' })

local _source_tmux = {
  name = 'tmux',
  -- priority = 1,
  group_index = 10,
  option = {
    -- Source from all panes in session instead of adjacent panes
    all_panes = true,
    trigger_characters = { '.' },
    keyword_pattern = [[\w\+]],
    -- keyword_pattern = [[[\w\-]+]],
    -- Specify trigger characters for filetype(s)
    -- { filetype = { '.' } }
    trigger_characters_ft = {},
    -- Capture full pane history
    -- `false`: show completion suggestion from text in the visible pane (default)
    -- `true`: show completion suggestion from text starting from the beginning of the pane history.
    --         This works by passing `-S -` flag to `tmux capture-pane` command. See `man tmux` for details.
    capture_history = true,
  },
}

local source_path = {
  name = 'path',
  option = {
    trailing_slash = true,
  },
}

local function formatter(entry, item)
  local source_name = entry.source.name
  local menu_icon = {
    cody = 'CODY',
    -- luasnip = 'ι',
    -- nvim_lsp = 'Ƒ',
    -- ultisnips = 'λ',
    -- path = '⋗',
    -- copilot = 'Copilot',
    path = 'PATH',
    -- path = '', -- devicons
    buffer = 'BUF',
    cmdline = 'CMD',
    cmdline_history = 'HIST',
    -- codeium = '⚡️',
    codeium = 'AI',
    git = 'GIT',
    -- git = '',
    -- nvim_lsp = '💡',
    nvim_lsp = 'LSP',
    tmux = 'tmux',
    ultisnips = 'SNIP',
    -- ultisnips = '🍪',
    ['vim-dadbod-completion'] = '[DB]',
  }
  local icon = menu_icon[source_name]
  if icon then
    item.menu = icon
  end
  return item
end

local WIDE_HEIGHT = 40
cmp.setup({
  window = {
    completion = {
      border = 'none',
      -- border = { '', '', '', '', '', '', '', '' },
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
      winblend = vim.o.pumblend,
      scrolloff = 0,
      col_offset = 0,
      side_padding = 0,
      scrollbar = true,
    },
    documentation = {
      side_padding = 1,
      border = 'rounded',
      -- border = { '', '', '', ' ', '', '', '', ' ' },
      max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      max_width = math.floor(
        (WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))
      ),
      winhighlight = 'FloatBorder:NormalFloat',
      winblend = vim.o.pumblend,
    },
  },
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
      -- vim.snippet.expand(args.body) -- enabling this may cause lsp snippet echo twice
      -- require('luasnip').lsp_expand(args.body)
    end,
  },
  experimental = {
    -- ghost_text = true,
    -- ghost text is false as codeium uses that for completion
    ghost_text = false,
  },
  mapping = {
    -- ['<C-e>'] = cmp.mapping.abort(),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<tab>'] = handle_down,
    ['<down>'] = handle_down,
    ['<S-Tab>'] = handle_up,
    ['<up>'] = handle_up,
    ['<CR>'] = handle_enter,
    -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  formatting = {
    fields = { 'abbr', 'menu', 'kind' },
    format = formatter,
  },
  sources = cmp.config.sources({
    -- { name = 'cody' },
    { name = 'nvim_lsp' },
    { name = 'codeium' },
    { name = 'ultisnips' },
    { name = 'buffer' },
    source_path,
  }),
})

cmp.setup.filetype('sql', {
  sources = cmp.config.sources({
    { name = 'vim-dadbod-completion' },
    source_path,
  }),
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
    source_path,
  }),
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    -- { name = 'cmdline_history' },
    -- source_path,
    -- source_tmux,
  }),
})
