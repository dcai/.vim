local utils = require('dcai.keymaps.utils')

local lsp_keymap = {
  { '<leader>l', group = 'lsp' },
  -- grn is default rename
  -- gra is default code action
  -- grr is default references
  -- gri is default find implementation
  { '<leader>lD', vim.diagnostic.open_float, desc = 'diagnostic' },
  {
    '<leader>ld',
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
      local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })
      if vim.tbl_isempty(diagnostics) then
        vim.notify('No diagnostics on this line', vim.log.levels.INFO)
        return
      end

      local severity_names = {
        [vim.diagnostic.severity.ERROR] = 'ERROR',
        [vim.diagnostic.severity.WARN] = 'WARN',
        [vim.diagnostic.severity.INFO] = 'INFO',
        [vim.diagnostic.severity.HINT] = 'HINT',
      }

      local lines = {}
      for i, d in ipairs(diagnostics) do
        local header = string.format(
          '[%s]%s%s',
          severity_names[d.severity] or 'UNKNOWN',
          d.source and (' ' .. d.source) or '',
          d.code and (' (' .. tostring(d.code) .. ')') or ''
        )
        table.insert(lines, header)
        for _, msg_line in ipairs(vim.split(d.message, '\n', { plain = true })) do
          table.insert(lines, msg_line)
        end
        if i < #diagnostics then
          table.insert(lines, '')
        end
      end

      vim.cmd('vsplit')
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(0, buf)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].buftype = 'nofile'
      vim.bo[buf].bufhidden = 'wipe'
      vim.bo[buf].swapfile = false
      vim.bo[buf].modifiable = true
      vim.bo[buf].filetype = 'diagnostic'
    end,
    desc = 'diagnostic in side pane',
  },
  -- { '<leader>lf', vim.lsp.buf.format, desc = 'format code' },
  { '<leader>lh', vim.lsp.buf.hover, desc = 'lsp hover' },
  {
    '<leader>lI',
    function()
      vim.cmd('enew')
      vim.cmd('checkhealth vim.lsp')
    end,
    desc = 'lsp info',
  },
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
