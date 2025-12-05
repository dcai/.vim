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

local function line_separator(title)
  local s = string.rep('-', 5)
  return s .. title .. s
end

local function wrapcode(code)
  return line_separator('BEGIN CODE BLOCK')
    .. vim.g.nl
    .. code
    .. vim.g.nl
    .. line_separator('END CODE BLOCK')
end

local function get_relative_path()
  local git_root = vim.g.git_root()
  local filepath = vim.fn.expand('%:p')
  if git_root and vim.startswith(filepath, git_root) then
    return filepath:sub(#git_root + 2)
  end
  return filepath
end

local function format_line_reference()
  local line_number = vim.fn.line('.')
  local relpath = get_relative_path()
  return '`' .. relpath .. ' LINE ' .. tostring(line_number) .. '`'
end

local function format_visual_selection()
  local fname = get_relative_path()
  local line1 = vim.fn.line('v')
  local line2 = vim.fn.line('.')
  if line1 > line2 then
    line1, line2 = line2, line1
  end
  local lines = vim.fn.getline(line1, line2)
  local header = string.format(
    'FILE: %s, LINES: %d-%d, FILETYPE: %s',
    fname,
    line1,
    line2,
    vim.bo.filetype
  )
  local code = table.concat(lines, '\n')
  return header .. vim.g.nl .. wrapcode(code)
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
      vim.fn.setreg('*', format_line_reference())
    end,
    desc = 'yank file path and current line',
    mode = 'n',
  },
  {
    '<leader>yt',
    function()
      vim.fn['VimuxSendText'](format_line_reference())
    end,
    desc = 'send file path and line to tmux',
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
  {
    '<leader>yy',
    function()
      vim.fn.setreg('+', format_visual_selection())
      vim.g.feedkeys('<esc>', 'n')
    end,
    desc = 'Yank visual selection with file name and line range',
    mode = 'v',
  },
  {
    '<leader>yt',
    function()
      vim.fn['VimuxSendText'](format_visual_selection())
      vim.g.feedkeys('<esc>', 'n')
    end,
    desc = 'Send visual selection with metadata to tmux',
    mode = 'v',
  },
}
return yank_keymap
