local group = 'chat'

local loaded_codecompanion = pcall(require, 'codecompanion')
if not loaded_codecompanion then
  return {
    { '<leader>c', group = group },
  }
end

require('dcai.llm.codecompanion').setup()

local keymap = {
  { '<leader>c', group = group },
  {
    '<leader>cc',
    function()
      vim.cmd('CodeCompanionActions')
    end,
    desc = 'CodeCompanion',
  },
  {
    '<leader>cv',
    function()
      require('codecompanion').prompt('neovim')
    end,
    desc = 'ask neovim topic',
  },
  {
    '<leader>cf',
    function()
      require('codecompanion').sessions()
    end,
    desc = 'CodeCompanion saved chats',
  },
  ----------------------------------------------------------------------------
  --- Visual mode below
  ----------------------------------------------------------------------------
  { '<leader>c', group = group, mode = 'v' },
  {
    '<leader>cc',
    ":<c-u>'<,'>CodeCompanionActions<cr>",
    desc = 'Code Companion Actions',
    mode = 'v',
  },
}

return keymap
