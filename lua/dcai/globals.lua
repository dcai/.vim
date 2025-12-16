local gsub = require('string').gsub
local gmatch = require('string').gmatch

vim.uv = vim.uv or vim.loop
vim.g.uv = vim.uv

vim.g.human_readable_osname = function()
  ---@diagnostic disable: undefined-field
  local osname = vim.uv.os_uname().sysname
  if osname == 'Darwin' then
    osname = 'macos'
  end
  return osname
end

vim.g.print = function(val)
  print(vim.inspect(val))
  return val
end

vim.g.reload = function(module)
  require('plenary.reload').reload_module(module)
  return require(module)
end

local function file_exists(filepath)
  local status = vim.fn.filereadable(filepath) == 1

  return status
end

vim.g.file_exists = file_exists

--- read file
---@param file string
---@return string
local function readfile(file)
  local lines = vim.fn.readfile(file)
  local content = table.concat(lines, '\n') -- content is now the file as a string
  return content
end

vim.g.readfile = readfile

local function io_file_write(file, contents)
  local f = assert(io.open(file, 'w'))
  f:write(contents)
  f:close()
end

local function touch(filepath)
  if not file_exists(filepath) then
    vim.fn.writefile({}, filepath, 'a')
  end
  return nil
end

local function user_config_file_path()
  return vim.g.data_dir .. '/user.json'
end

local function get_all_local_config()
  local userconfigfile = user_config_file_path()
  touch(userconfigfile)
  local json = readfile(userconfigfile)
  local ok, config = pcall(vim.json.decode, json)
  if ok then
    return config
  else
    return {}
  end
end

local function get_or(table, key, default)
  if vim.tbl_isempty(table) then
    return default
  end
  local v = table
  for k in vim.gsplit(key, '.', { plain = true }) do
    v = v[k]
  end
  if v == 'true' or v == true then
    return true
  elseif v == 'false' or v == false then
    return false
  elseif v == nil then
    return default
  end
  return v
end

local function get_user_config(key, default)
  local config = get_or(get_all_local_config(), key, default)
  return config
end

local function set(tbl, path, value)
  local keys = vim.split(path, '.', { plain = true })
  local current = tbl
  for i = 1, #keys - 1 do
    local key = keys[i]
    if not current[key] or type(current[key]) ~= 'table' then
      current[key] = {}
    end
    current = current[key]
  end
  local finalKey = keys[#keys]
  current[finalKey] = value
end

local function set_user_config(path, value)
  local userconfigfile = user_config_file_path()
  local config = get_all_local_config()
  set(config, path, value)
  io_file_write(userconfigfile, vim.json.encode(config))
end

vim.g.handle_vim_event_by_command = function(evt, command)
  local group_name = 'On' .. evt .. 'Group'
  return vim.api.nvim_create_autocmd(evt, {
    command = command,
    pattern = '*',
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
  })
end

vim.g.handle_autocmd = function(event_name, pattern, callback, desc, group_id)
  return vim.api.nvim_create_autocmd(event_name, {
    pattern = pattern or '*',
    group = group_id or nil,
    callback = callback,
    desc = desc or ('On' .. event_name),
  })
end

local function apply_colorscheme(colorscheme, termguicolors)
  vim.opt.termguicolors = termguicolors and true or false
  xpcall(function()
    vim.cmd.colorscheme(colorscheme)
  end, function()
    vim.cmd.colorscheme('default')
  end)
end

vim.g.is_git_repo = function()
  local handle = io.popen('git rev-parse --is-inside-work-tree 2> /dev/null')
  if handle == nil then
    return false
  end
  local result = handle:read('*a')
  handle:close()
  if result:match('true') then
    return true
  else
    return false
  end
end

vim.g.isempty = function(s)
  return s == nil or s == ''
end

local function is_env_var_true(name)
  local v = vim.env[name]
  -- vim.g.logger.info(
  --   'environment variable ' .. tostring(name) .. '=' .. tostring(v)
  -- )
  return v == 'true' or v == '1' or v == true or v == 1
end
vim.g.is_env_var_true = is_env_var_true

local function is_env_var_false(name)
  local v = os.getenv(name)
  return v == 'false' or v == '0' or v == '' or v == nil
end
vim.g.is_env_var_false = is_env_var_false

vim.g.is_env_var_set = function(name)
  return os.getenv(name) ~= nil and os.getenv(name) ~= ''
end

---return the first executable from given list
---@param files string[]
---@return string|nil
vim.g.find_executable = function(files)
  for _, file in ipairs(files) do
    local resolved = vim.fn.expand(file)
    if vim.fn.executable(resolved) == 1 then
      return resolved
    end
  end
  return nil
end

---create keymap item
---@param mode string
---@param from string
---@param to string
vim.g.keymap = function(mode, from, to)
  -- local expr_opts = { noremap = true, expr = true, silent = true }
  vim.api.nvim_set_keymap(mode, from, to, { noremap = true, silent = true })
end

-- https://stackoverflow.com/a/29379912
vim.g.replace = function(str, what, with)
  what = string.gsub(what and what or '', '[%(%)%.%+%-%*%?%[%]%^%$%%]', '%%%1') -- escape pattern
  with = string.gsub(with, '[%%]', '%%%%') -- escape replacement
  return string.gsub(str, what, with)
end

---copied from https://github.com/james2doyle/lit-slugify/blob/master/init.lua
---@param string string|nil
---@param replacement string
---@return string
vim.g.slugify = function(string, replacement)
  if not string or string == '' then
    return ''
  end
  if replacement == nil then
    replacement = '-'
  end
  local result = ''
  -- loop through each word or number
  for word in gmatch(string, '(%w+)') do
    result = result .. word .. replacement
  end
  -- remove trailing separator
  result = gsub(result, replacement .. '$', '')
  return result:lower()
end

vim.g.trim_right = function(str, char)
  local last_char = str:sub(-1)
  if last_char == char then
    return str:sub(1, -2)
  end
  return str
end

local function trim_trailing_slash(str)
  -- return gsub(str, '/$', '')
  return vim.g.trim_right(str, '/')
end

vim.g.trim_trailing_slash = trim_trailing_slash

vim.g.data_dir = trim_trailing_slash(vim.fn.stdpath('data'))
vim.g.log_dir = trim_trailing_slash(vim.fn.stdpath('log')) .. '/logs'
vim.g.config_dir = trim_trailing_slash(vim.fn.stdpath('config'))
vim.g.cache_dir = trim_trailing_slash(vim.fn.stdpath('cache'))
vim.g.state_dir = trim_trailing_slash(vim.fn.stdpath('state'))
vim.g.run_dir = trim_trailing_slash(vim.fn.stdpath('run'))

vim.g.parent_dir = function(input)
  return vim.g.trim_right(input, '/'):match('(.*/)')
end

vim.g.setup_colorscheme = function()
  local defaulcolorscheme = 'pine'
  local termguicolors = get_user_config('colorscheme.termguicolors', true)
  local cs = get_user_config('colorscheme.name', defaulcolorscheme)
  apply_colorscheme(cs, termguicolors)
  vim.g.handle_autocmd('ColorScheme', '*', function(ev)
    -- vim.g.logger.debug('ColorScheme: ' .. vim.inspect(ev))
    set_user_config('colorscheme.name', ev.match or vim.g.colors_name)
  end, 'save new colorscheme')
end

vim.g.source = function(path)
  -- local vim_home = vim.fn.expand('<sfile>:p:h')
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. path)
end

---higher order function to color text
---@param color string
---@return function
local function colortext(color)
  ---@enum ansi_colors
  local ansi_colors = {
    reset = string.char(0x001b) .. '[0m',
    red = string.char(0x001b) .. '[31m',
    green = string.char(0x001b) .. '[32m',
    yellow = string.char(0x001b) .. '[33m',
    blue = string.char(0x001b) .. '[34m',
    purple = string.char(0x001b) .. '[35m',
  }
  return function(text)
    return string.format('%s%s%s', ansi_colors[color], text, ansi_colors.reset)
  end
end

--@param opts table
--@return table
--@see https://github.com/dharmx/nvim/blob/d39e0637607e214cedc8beb8c5fb88fd0ff0ccd2/after/compiler/leetcode.lua
vim.g.new_popup = function(opts)
  local Popup = require('plenary.popup')
  -- vim.api.nvim_set_hl(
  --   0,
  --   'PopupNormal',
  --   { foreground = 'white', background = '#151A1F' }
  -- )
  local height = opts.height or 10
  local width = opts.width or 80
  local buffer = vim.api.nvim_create_buf(false, false)
  local title = opts.title or 'Job'
  -- local channel = vim.api.nvim_open_term(buffer, {})
  return {
    -- channel = channel,
    buffer = buffer,
    open = function()
      local winid, _ = Popup.create(buffer, {
        title = title,
        -- highlight = 'PopupNormal',
        padding = { 0, 0, 0, 0 },
        line = 3,
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        -- borderchars = { '+', '|', '+', '|', '|', '|', '|', '|' },
      })
      vim.api.nvim_set_option_value(
        'number',
        opts.number or false,
        { win = winid }
      )
      vim.api.nvim_set_option_value('spell', false, { win = winid })
      local close = function()
        vim.api.nvim_win_close(winid, true)
      end
      local winopt = { buffer = buffer, noremap = true, silent = true }
      vim.keymap.set('n', 'q', close, winopt)
      vim.keymap.set('n', '<esc>', close, winopt)
      return winid, _
    end,
  }
end

local function shell_cmd(cmd)
  local result = vim.fn.systemlist(cmd)[1]
  if vim.v.shell_error == 0 then
    return result
  end
  return nil
end

vim.g.shell_cmd = shell_cmd

vim.g.close_all_popups = function()
  -- Get all windows
  local windows = vim.api.nvim_list_wins()

  for _, win_id in ipairs(windows) do
    -- Check if window is valid
    if vim.api.nvim_win_is_valid(win_id) then
      -- Get window config
      local config = vim.api.nvim_win_get_config(win_id)

      -- Check if it's a floating window (popup)
      if config.relative ~= '' then
        -- Close the popup window
        vim.api.nvim_win_close(win_id, false)
      end
    end
  end
end

vim.g.merge_list = function(...)
  local result = {}
  local arrays = { ... }

  for _, arr in ipairs(arrays) do
    if type(arr) == 'table' then
      for _, value in ipairs(arr) do
        table.insert(result, value)
      end
    end
  end

  return result
end

---get project root
---@param markers string[]
---@return fun(filepath: string?): string?
local function root(markers)
  return function(filepath)
    local buf = filepath or vim.api.nvim_get_current_buf()

    if vim.fs and vim.fs.root then
      local fs_root = vim.fs.root(buf, markers)
      if fs_root then
        return fs_root
      end
    end
  end
end
vim.g.root_pattern = root

vim.g.git_root = root({
  '.github',
  '.gitlab-ci.yml',
  '.git',
})

vim.g.smart_root = root({
  'package.json',
  'Makefile',
  '.husky',
  '.editorconfig',
  '.tool-versions',
  '.mise.toml',
  'mise.toml',
  '.envrc',
  'tsconfig.json',
  'stylua.toml',
  'pyproject.toml',
  'biome.json',
  'biome.jsonc',
  -- prettier
  'prettier.config.js',
  'prettier.config.cjs',
  '.prettierrc',
  '.prettierrc.js',
  '.prettierrc.yml',
  '.prettierrc.yaml',
  '.prettierrc.json',
  'appsettings.json',
  'Jenkinsfile_Build',
  '.vscode',
  '.git',
})

vim.g.node_project_root = root({
  'package.json',
})

vim.g.python_project_root = root({
  'requirements.txt',
  'pyproject.toml',
})

vim.g.nl = '\r\n'

vim.g.red = colortext('red')
vim.g.green = colortext('green')
vim.g.yellow = colortext('yellow')
vim.g.blue = colortext('blue')
vim.g.purple = colortext('purple')

---@class new_win_opt
---@field filetype? string
---@field title? string
---@field split? "left"|"right"
---@field w? number percentage of screen width (0-100)
---@field h? number percentage of screen height (0-100)
---@field x? number
---@field y? number

---@class new_win
---@field buf number
---@field win number
---@field append function
---@field open fun(value: string): void
---@field close fun(): void

---create new window
---@param opt new_win_opt
---@return new_win
vim.g.new_win = function(opt)
  opt = opt or {}

  local win = nil
  ---@type number
  local buf = nil

  local strict_indexing = false

  local width = opt.w and math.floor((opt.w / 100) * vim.o.columns)
    or math.min(80, vim.o.columns - 4)
  local height = opt.h and math.floor((opt.h / 100) * vim.o.lines)
    or math.min(20, vim.o.lines - 4)

  -- default to center of editor
  local row = opt.x and opt.x or math.floor((vim.o.lines - height) / 2)
  local col = opt.y and opt.y or math.floor((vim.o.columns - width) / 2)

  local win_opts = {}
  if opt.split then
    win_opts = {
      split = opt.split,
    }
  else
    win_opts = {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
      focusable = true,
      zindex = 300,
      title = opt.title,
    }
  end

  local function map_close_buffer(localbuf)
    vim.api.nvim_buf_set_keymap(
      localbuf,
      'n',
      'q',
      ':close<CR>',
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      localbuf,
      'n',
      '<Esc>',
      ':close<CR>',
      { noremap = true, silent = true }
    )
  end

  local function open()
    if not win then
      -- Create a scratch buffer (unlisted, not saved to disk)
      local is_listed = false
      local is_scratch = true
      buf = vim.api.nvim_create_buf(is_listed, is_scratch)
      -- Initial content
      vim.api.nvim_buf_set_lines(buf, 0, -1, strict_indexing, { '' })

      vim.api.nvim_set_option_value('fileformat', 'unix', { buf = buf })
      vim.api.nvim_set_option_value(
        'filetype',
        opt.filetype and opt.filetype or 'text',
        { buf = buf }
      )
      win = vim.api.nvim_open_win(buf, true, win_opts)
      map_close_buffer(buf)
      vim.api.nvim_set_option_value('spell', false, { win = win })
      vim.api.nvim_set_option_value('cursorline', true, { win = win })
      vim.api.nvim_set_option_value('number', false, { win = win }) -- Disable line numbers
      vim.api.nvim_set_option_value('relativenumber', false, { win = win }) -- Disable relative line numbers
      vim.api.nvim_set_option_value('signcolumn', 'no', { win = win }) -- Disable sign column
    end
    return win
  end

  -- remove ^M at the end of line
  local function trim_line_end(line)
    if not line then
      return ''
    end
    return line:gsub('\r$', '')
  end

  -- Create a function to append text without creating new lines
  local function append_text(text)
    local w = open()
    local last_lineno = vim.api.nvim_buf_line_count(buf) - 1
    local last_line = vim.api.nvim_buf_get_lines(
      buf,
      last_lineno,
      last_lineno + 1,
      strict_indexing
    )[1]

    -- Split text by newlines and handle them properly
    local lines = vim.split(text, '\n', { plain = true })

    -- Append first part to the last line
    local new_last_line = last_line .. trim_line_end(lines[1])

    -- Create the updated lines: modified last line + any additional lines
    local updated_lines = { new_last_line }
    for i = 2, #lines do
      -- remove ^M
      lines[i] = trim_line_end(lines[i])
      table.insert(updated_lines, lines[i])
    end

    -- Replace the last line with our updated lines
    vim.api.nvim_buf_set_lines(
      buf,
      last_lineno,
      last_lineno + 1,
      strict_indexing,
      updated_lines
    )
    -- jump to the bottom
    vim.api.nvim_win_set_cursor(w, { vim.api.nvim_buf_line_count(buf), 0 })
  end

  return {
    buf = buf,
    win = win,
    append = vim.schedule_wrap(append_text),
    open = open,
    close = function()
      if win then
        vim.api.nvim_win_close(win, true)
      end
    end,
  }
end

vim.g.repo_instructions = function()
  local files_to_check = {
    '.gp.md',
    'readme.txt',
    'readme.md',
    'README.md',
    'instructions.md',
  }
  local git_root = vim.g.git_root()

  if git_root == '' or not git_root then
    return ''
  end

  local instruct_file = ''
  for _, file in ipairs(files_to_check) do
    local path = git_root .. '/' .. file
    if vim.fn.filereadable(path) == 1 then
      instruct_file = path
      break
    end
  end

  if instruct_file == '' then
    return ''
  end

  if vim.fn.filereadable(instruct_file) == 0 then
    return ''
  end

  local lines = vim.fn.readfile(instruct_file)
  return table.concat(lines, '\n')
end

vim.g.feedkeys = function(key, mode)
  -- Replaces terminal codes and keycodes
  -- (<CR>, <Esc>, ...) in a string with the internal representation.
  local keys = vim.api.nvim_replace_termcodes(key, true, true, true)
  mode = mode or ''
  -- Sends input-keys to Nvim, subject to various quirks
  -- controlled by mode flags. This is a blocking call, unlike nvim_input().
  vim.api.nvim_feedkeys(keys, mode, true)
end
