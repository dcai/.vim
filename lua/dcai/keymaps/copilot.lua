local M = {}
local mappings = {
  {
    'n',
    '<S-Tab>',
    function()
      require('dcai.lsp.copilot-features').accept_edit(
        vim.api.nvim_get_current_buf()
      )
    end,
    'Copilot: jump to or accept next edit',
  },
  { 'n', '<leader>lc', nil, 'Copilot', false },
  { 'n', '<leader>lcs', '<cmd>LspCopilotStatus<CR>', 'Copilot: status' },
  {
    'n',
    '<leader>lcd',
    '<cmd>LspCopilotDismiss<CR>',
    'Copilot: dismiss suggestions',
  },
  {
    'n',
    '<leader>lct',
    '<cmd>LspCopilotToggle<CR>',
    'Copilot: toggle suggestions',
  },
  {
    'n',
    '<leader>lcn',
    '<cmd>LspCopilotNextEdit<CR>',
    'Copilot: request next edit',
  },
}

function M.attach(bufnr)
  local wk = require('which-key')
  for _, mapping in ipairs(mappings) do
    if mapping[3] then
      vim.keymap.set(mapping[1], mapping[2], mapping[3], {
        buffer = bufnr,
        desc = mapping[4],
        expr = mapping[5] or false,
      })
    else
      wk.add({ { mapping[2], group = mapping[4], buffer = bufnr } })
    end
  end
end

function M.detach(bufnr)
  for _, mapping in ipairs(mappings) do
    if mapping[3] then
      local modes = type(mapping[1]) == 'table' and mapping[1] or { mapping[1] }
      for _, mode in ipairs(modes) do
        pcall(vim.keymap.del, mode, mapping[2], { buffer = bufnr })
      end
    end
  end
end

return M
