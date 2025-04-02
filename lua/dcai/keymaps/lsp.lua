local utils = require('dcai.keymaps.utils')

local lsp_keymap = {
  { '<leader>l', group = 'lsp' },
  { '<leader>la', vim.lsp.buf.code_action, desc = 'code action' },
  { '<leader>ld', vim.diagnostic.open_float, desc = 'diagnostic' },
  { '<leader>lf', vim.lsp.buf.format, desc = 'format code' },
  { '<leader>lh', vim.lsp.buf.hover, desc = 'lsp hover' },
  { '<leader>lI', '<cmd>LspInfo<cr>', desc = 'lsp info' },
  { '<leader>li', '<cmd>Inspect<cr>', desc = 'inspect' },
  { '<leader>lr', vim.lsp.buf.rename, desc = 'rename' },
  {
    '<leader>ll',
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
