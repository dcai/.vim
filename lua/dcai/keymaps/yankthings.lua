local utils = require('dcai.keymaps.utils')

local function put_content(contents)
  vim.fn.setreg('*', contents)
  vim.cmd('enew')
  vim.bo.buftype = 'nofile'
  -- vim.bo.bufhidden = 'hide'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  local lines = { contents }
  if type(contents) == 'table' then
    lines = contents
  end
  vim.api.nvim_put(lines, 'c', true, true)
end

local yank_keymap = {
  { '<leader>y', group = 'yank things' },
  -- utils.vim_cmd('<leader>yp', 'let @*=expand("%:p")', 'yank file full path'),
  -- utils.vim_cmd('<leader>yf', 'let @*=expand("%")', 'yank file name'),
  -- utils.vim_cmd('<leader>ym', 'let @*=execute("messages")', 'yank messages'),
  {
    '<leader>yl',
    function()
      local loaded_packages = vim.tbl_keys(package.loaded)
      vim.fn.setreg('*', vim.inspect(loaded_packages))
    end,
    desc = 'yank loaded package names',
  },
  {
    '<leader>yy',
    function()
      local line_number = vim.fn.line('.')
      local project_root = vim.g.node_project_root()
      local filepath = vim.fn.expand('%:p')
      local relpath = filepath
      if project_root and vim.startswith(filepath, project_root) then
        relpath = filepath:sub(#project_root + 2)
      end
      local content = relpath .. vim.g.nl .. 'LINE ' .. tostring(line_number)
      vim.fn.setreg('*', content)
      -- put_content(content)
    end,
    desc = 'yank file path and current line',
    mode = 'n',
  },
  {
    '<leader>yf',
    function()
      local filename = vim.fn.expand('%')
      put_content(filename)
    end,
    desc = 'yank filename',
  },
  {
    '<leader>ym',
    function()
      local messages = vim.fn.execute('messages')
      put_content(vim.split(messages, '\n', { trimempty = true, plain = true }))
    end,
    desc = 'yank messages',
  },
  {
    '<leader>yk',
    function()
      local messages = vim.fn.execute('map')
      put_content(vim.split(messages, '\n', { trimempty = true, plain = true }))
    end,
    desc = 'yank keymap',
  },
}
return yank_keymap
