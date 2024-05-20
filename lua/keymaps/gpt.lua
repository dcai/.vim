local utils = require('keymaps.utils')

local chatgpt_keymap_n = {
  name = 'chatgpt',
  D = utils.vim_cmd('GpChatDelete', 'delete chat'),
  c = utils.vim_cmd('GpNew', 'Enter a prompt'),
  f = utils.vim_cmd('GpChatFinder', 'chat Finder'),
  n = utils.vim_cmd('GpNextAgent', 'next agent'),
  N = utils.vim_cmd('GpChatNew', 'new chat buffer'),
  t = utils.vim_cmd('GpChatToggle', 'Toggle chat'),
  s = utils.vim_cmd('GpWhisper', 'speech to text'),
}

local function wrapGpCmd(str)
  return ":<c-u>'<,'>" .. str .. '<cr>'
end
local chatgpt_keymap_v = {
  name = 'chatgpt',
  n = { wrapGpCmd('GpChatNew'), 'visual new chat' },
  e = { wrapGpCmd('GpExplain'), 'explain selcted code' },
}

return chatgpt_keymap_n, chatgpt_keymap_v
