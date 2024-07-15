local utils = require('dcai.keymaps.utils')
local yank_keymap = {
  { '<leader>y', group = 'yank things' },
  {
    '<leader>yl',
    function()
      local loaded_packages = vim.tbl_keys(package.loaded)
      vim.fn.setreg('*', vim.inspect(loaded_packages))
    end,
    desc = 'yank loaded package names',
  },
  utils.vim_cmd(
    '<leader>yp',
    'let @*=expand("%:p")',
    'yank file full path',
    'file path yanked'
  ),
  utils.vim_cmd('<leader>yf', 'let @*=expand("%")', 'yank file name'),
  utils.vim_cmd('<leader>ym', 'let @*=execute("messages")', 'yank messages'),
}
return yank_keymap
