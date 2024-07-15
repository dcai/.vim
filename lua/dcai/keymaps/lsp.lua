local utils = require('dcai.keymaps.utils')
local tsj_loaded, tsj = pcall(require, 'treesj')
if tsj_loaded then
  tsj.setup({
    ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
    use_default_keymaps = false,
    ---@type boolean Node with syntax error will not be formatted
    check_syntax_error = true,
    ---If line after join will be longer than max value,
    ---@type number If line after join will be longer than max value, node will not be formatted
    max_join_length = 1200,
    ---Cursor behavior:
    ---hold - cursor follows the node/place on which it was called
    ---start - cursor jumps to the first symbol of the node being formatted
    ---end - cursor jumps to the last symbol of the node being formatted
    ---@type 'hold'|'start'|'end'
    cursor_behavior = 'hold',
    ---@type boolean Notify about possible problems or not
    notify = true,
    ---@type boolean Use `dot` for repeat action
    dot_repeat = true,
    ---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
    on_error = nil,
    ---@type table Presets for languages
    -- langs = {}, -- See the default presets in lua/treesj/langs
  })
end

local lsp_keymap = {
  { '<leader>l', group = 'lsp' },
  { '<leader>la', vim.lsp.buf.code_action, desc = 'code action' },
  { '<leader>ld', vim.diagnostic.open_float, desc = 'diagnostic' },
  { '<leader>lf', vim.lsp.buf.format, desc = 'format code' },
  { '<leader>lI', '<cmd>LspInfo<cr>', desc = 'lsp info' },
  -- p = {
  --   function()
  --     require('lspsaga.definition'):init(2, 1)
  --   end,
  --   'Peek type',
  -- },
  { '<leader>lr', vim.lsp.buf.rename, desc = 'rename' },
  {
    '<leader>lq',
    function()
      vim.diagnostic.setqflist({
        open = false,
      })
      local fzf = require('fzf-lua')
      fzf.quickfix()
    end,
    desc = 'quickfix list',
  },
  {
    '<leader>lt',
    function()
      if tsj_loaded then
        tsj.toggle()
      end
    end,
    desc = 'split or join code',
  },
}

return lsp_keymap
