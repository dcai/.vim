local utils = require('dcai.keymaps.utils')

local function diagnostic_tool(namespace_name, clients)
  for _, client in ipairs(clients) do
    -- Pull-diagnostic namespaces append a provider identifier to this prefix.
    local prefix = string.format('nvim.lsp.%s.%d', client.name, client.id)
    if
      namespace_name == prefix or vim.startswith(namespace_name, prefix .. '.')
    then
      return client.name
    end
  end
  return namespace_name
end

local function format_diagnostic(diagnostic, clients)
  local namespace = diagnostic.namespace
    and vim.diagnostic.get_namespace(diagnostic.namespace)
  local tool =
    diagnostic_tool(namespace and namespace.name or 'unknown', clients)

  local source = diagnostic.source
  if not source or source == '' then
    source = 'not provided'
  end

  local code = diagnostic.code and string.format(' (%s)', diagnostic.code) or ''

  return string.format(
    '[%s] tool: %s | source: %s%s\n%s',
    vim.diagnostic.severity[diagnostic.severity] or 'UNKNOWN',
    tool,
    source,
    code,
    diagnostic.message
  )
end

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
      if #diagnostics == 0 then
        vim.notify('No diagnostics on this line', vim.log.levels.INFO)
        return
      end

      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local messages = vim.tbl_map(function(diagnostic)
        return format_diagnostic(diagnostic, clients)
      end, diagnostics)
      local text = table.concat(messages, '\n\n')

      vim.cmd('vsplit')
      local pane = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(0, pane)
      vim.api.nvim_buf_set_lines(
        pane,
        0,
        -1,
        false,
        vim.split(text, '\n', { plain = true })
      )
      vim.bo[pane].bufhidden = 'wipe'
      vim.bo[pane].filetype = 'diagnostic'
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
