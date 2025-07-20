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
    '<leader>yy',
    function()
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local project_root = vim.g.node_project_root()
      local filepath = vim.fn.expand('%:p')
      local relpath = filepath
      if project_root and vim.startswith(filepath, project_root) then
        relpath = filepath:sub(#project_root + 2)
      end

      vim.g.logger.info(vim.inspect({
        start_pos = start_pos,
        end_pos = end_pos,
      }))
      -- Extract line numbers (1-indexed)
      local start_line = start_pos[2]
      local end_line = end_pos[2]

      -- Get the full lines (this handles line-wise selection automatically)
      local lines =
        vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

      local text = table.concat(lines, '\n')

      local content = relpath
        .. vim.g.nl
        .. string.format('LINE %s-%s', start_line, end_line)
        .. vim.g.nl
        .. text

      vim.fn.setreg('*', content, 'l')
      vim.g.feedkeys('<Esc>', 'n')
      -- put_content(content)
    end,
    desc = 'yank file path and selected line',
    mode = 'v',
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
