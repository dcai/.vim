local utils = require('keymaps.utils')
local yank_keymap = {
  name = 'yank things',
  l = {
    function()
      local loaded_packages = vim.tbl_keys(package.loaded)
      vim.fn.setreg('*', vim.inspect(loaded_packages))
    end,
    'yank loaded package names',
  },
  p = utils.vim_cmd(
    'let @*=expand("%:p")',
    'yank file full path',
    'file path yanked'
  ),
  f = utils.vim_cmd('let @*=expand("%")', 'yank file name'),
  m = utils.vim_cmd('let @*=execute("messages")', 'yank messages'),
}
return yank_keymap
