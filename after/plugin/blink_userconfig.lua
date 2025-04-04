local ok = pcall(require, 'blink.cmp')
if not ok then
  vim.g.logger.error('blink.cmp not loaded!')
  return
end

require('blink.cmp').setup({
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    -- preset = 'super-tab',
    preset = 'none',
    -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
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

    -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    documentation = { auto_show = true },
    -- menu = {
    --   auto_show = function(ctx)
    --     return vim.fn.getcmdtype() == ':'
    --   end,
    -- },
  },
  signature = {
    enabled = true,
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      snippets = {
        opts = {
          search_paths = { vim.fn.expand('~/src/vim-snippets/') },
        },
      },
    },
  },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
  --
  -- See the fuzzy documentation for more information
  fuzzy = {
    -- implementation = 'prefer_rust_with_warning'
    -- implementation = 'lua',
    implementation = 'prefer_rust',

    sorts = {
      'exact',
      -- defaults
      'score',
      'sort_text',
    },
    prebuilt_binaries = {
      download = true,
      ignore_version_mismatch = true,
    },
  },
  cmdline = {
    keymap = {
      -- recommended, as the default keymap will only show and select the next item
      ['<Tab>'] = { 'show', 'accept' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
    },
    completion = { menu = { auto_show = true } },
  },
})
