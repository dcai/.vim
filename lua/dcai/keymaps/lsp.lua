local utils = require('dcai.keymaps.utils')

local lsp_keymap = {
  { '<leader>l', group = 'lsp' },
  -- grn is default rename
  -- gra is default code action
  -- grr is default references
  -- gri is default find implementation
  { '<leader>ld', vim.diagnostic.open_float, desc = 'diagnostic' },
  -- { '<leader>lf', vim.lsp.buf.format, desc = 'format code' },
  { '<leader>lh', vim.lsp.buf.hover, desc = 'lsp hover' },
  { '<leader>lI', '<cmd>checkhealth lsp<cr>', desc = 'lsp info' },
  { '<leader>li', '<cmd>Inspect<cr>', desc = 'inspect' },
  {
    '<leader>ll',
    function()
      vim.diagnostic.setqflist({
        open = false,
      })
      local fzf = require('fzf-lua')
      -- lsp_live_workspace_symbols executes an LSP request on each key press.
      -- lsp_workspace_symbols executes an empty LSP request the first time and then uses fzf to filter the results.
      fzf.lsp_live_workspace_symbols()
    end,
    desc = 'list workspace symbols',
  },
  {
    '<leader>lf',
    function()
      vim.diagnostic.setqflist({
        open = false,
      })
      local fzf = require('fzf-lua')
      fzf.quickfix()
    end,
    desc = 'quickfix list',
  },
}

return lsp_keymap
