local utils = require('dcai.keymaps.utils')

local function put_content(contents)
  vim.fn.setreg('*', contents)
  vim.cmd('enew')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
  local lines = { contents }
  if type(contents) == 'table' then
    lines = contents
  end
  vim.api.nvim_put(lines, 'c', true, true)
end

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
  {
    '<leader>yp',
    function()
      local filepath = vim.fn.expand('%:~')
      put_content(filepath)
    end,
    desc = 'yank full file path',
  },
  {
    '<leader>yf',
    function()
      local filename = vim.fn.expand('%')
      put_content(filename)
    end,
    desc = 'yank full file path',
  },
  {
    '<leader>ym',
    function()
      local messages = vim.fn.execute('messages')
      put_content(messages)
    end,
    desc = 'yank full file path',
  },
  -- utils.vim_cmd(
  --   '<leader>yp',
  --   'let @*=expand("%:p")',
  --   'yank file full path',
  --   'file path yanked'
  -- ),
  -- utils.vim_cmd('<leader>yf', 'let @*=expand("%")', 'yank file name'),
  -- utils.vim_cmd('<leader>ym', 'let @*=execute("messages")', 'yank messages'),
}
return yank_keymap
