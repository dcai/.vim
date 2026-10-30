local M = {}

local function features()
  return package.loaded['dcai.lsp.copilot-features']
end

-- Ctrl-f accepts native Copilot inline completion.
local insert_mappings = {
  {
    '<C-f>',
    function()
      if vim.lsp.inline_completion.get() then
        return ''
      end
      return '<C-f>'
    end,
    'AI: accept inline completion',
    true,
  },
  -- {
  --   '<M-]>',
  --   function()
  --     vim.lsp.inline_completion.select({ count = 1 })
  --   end,
  --   'AI: next inline completion',
  -- },
  -- {
  --   '<M-[>',
  --   function()
  --     vim.lsp.inline_completion.select({ count = -1 })
  --   end,
  --   'AI: previous inline completion',
  -- },
  -- {
  --   '<C-]>',
  --   function()
  --     local copilot = features()
  --     if copilot then
  --       copilot.dismiss(vim.api.nvim_get_current_buf())
  --     end
  --   end,
  --   'AI: dismiss suggestions',
  -- },
}

function M.attach(bufnr)
  for _, mapping in ipairs(insert_mappings) do
    vim.keymap.set('i', mapping[1], mapping[2], {
      buffer = bufnr,
      desc = mapping[3],
      expr = mapping[4] or false,
    })
  end
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('dcai_completion', { clear = true }),
    pattern = { 'BlinkCmpMenuOpen', 'BlinkCmpMenuClose' },
    callback = function(event)
      local copilot = features()
      if copilot then
        copilot.menu_changed(
          vim.api.nvim_get_current_buf(),
          event.match == 'BlinkCmpMenuOpen'
        )
      end
    end,
  })
end

function M.detach(bufnr)
  for _, mapping in ipairs(insert_mappings) do
    pcall(vim.keymap.del, 'i', mapping[1], { buffer = bufnr })
  end
end

function M.setup()
  local ok = pcall(require, 'blink.cmp')
  if not ok then
    vim.g.logger.error('blink.cmp not loaded!')
    return
  end
  local sources = { 'lsp', 'path', 'snippets', 'buffer' }

  local codecompanion_ok = pcall(require, 'codecompanion')
  if codecompanion_ok then
    table.insert(sources, 'codecompanion')
  end

  require('blink.cmp').setup({
    keymap = {
      preset = 'none',
      ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true },
    },
    signature = {
      enabled = true,
    },

    sources = {
      default = sources,
      providers = {
        snippets = {
          opts = {
            search_paths = { vim.fn.expand('~/src/vim-snippets/') },
          },
        },
      },
    },

    fuzzy = {
      implementation = 'prefer_rust',
      sorts = {
        'exact',
        'score',
        'sort_text',
      },
    },
    cmdline = {
      keymap = {
        ['<Tab>'] = { 'show', 'accept' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
      },
      completion = { menu = { auto_show = true } },
    },
  })
end

return M
