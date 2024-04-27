local gsub = require('string').gsub
local gmatch = require('string').gmatch

G = {}

G.print = function(val)
  print(vim.inspect(val))
  return val
end

G.reload = function(module)
  require('plenary.reload').reload_module(module)
  -- package.loaded[module] = nil
  return require(module)
end

local function file_exists(filepath)
  local status = vim.fn.filereadable(filepath) == 1

  return status
end

local function readfile(file)
  local f = assert(io.open(file, 'r'))
  local content = f:read('*all')
  f:close()
  return content
end

local function writefile(file, contents)
  local f = assert(io.open(file, 'w'))
  f:write(contents)
  f:close()
end

local function touch(filepath)
  if not file_exists(filepath) then
    local file, error_message = io.open(filepath, 'w')
    if file then
      file:close()
      return file
    else
      print(error_message)
    end
  end
  return nil
end

local function user_config_file_path()
  return vim.fn.stdpath('data') .. '/user.json'
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
  writefile(userconfigfile, vim.json.encode(config))
end

G.handle_vim_event_by_command = function(evt, command)
  local group_name = 'On' .. evt .. 'Group'
  return vim.api.nvim_create_autocmd(evt, {
    command = command,
    pattern = '*',
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
  })
end

local function create_autocmd(evt, group_name, callback)
  return vim.api.nvim_create_autocmd(evt, {
    pattern = '*',
    group = vim.api.nvim_create_augroup(
      group_name or ('On' .. evt .. 'Group'),
      { clear = true }
    ),
    callback = callback,
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

G.is_git_repo = function()
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

G.isempty = function(s)
  return s == nil or s == ''
end

local function is_env_var_true(name)
  local v = os.getenv(name)
  return v == 'true' or v == '1'
end
G.is_env_var_true = is_env_var_true

local function is_env_var_false(name)
  local v = os.getenv(name)
  return v == 'false' or v == '0'
end
G.is_env_var_false = is_env_var_false

---return the first executable from given list
---@param files string[]
---@return string|nil
G.find_executable = function(files)
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
G.keymap = function(mode, from, to)
  -- local expr_opts = { noremap = true, expr = true, silent = true }
  vim.api.nvim_set_keymap(mode, from, to, { noremap = true, silent = true })
end

---copied from https://github.com/james2doyle/lit-slugify/blob/master/init.lua
---@param string string
---@param replacement string
---@return string
G.slugify = function(string, replacement)
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

G.trim_right = function(str, char)
  local last_char = str:sub(-1)
  if last_char == char then
    return str:sub(1, -2)
  end
  return str
end

G.parent_dir = function(input)
  return G.trim_right(input, '/'):match('(.*/)')
end

G.setup_colorscheme = function()
  local defaulcolorscheme = 'oasis'
  local termguicolors = get_user_config('colorscheme.termguicolors', true)
  local cs = get_user_config('colorscheme.name', defaulcolorscheme)
  apply_colorscheme(cs, termguicolors)
  create_autocmd('ColorScheme', 'SaveColorScheme', function(ev)
    set_user_config('colorscheme.name', ev.match or vim.g.colors_name)
  end)
end

G.source = function(path)
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

G.red = colortext('red')
G.green = colortext('green')
G.yellow = colortext('yellow')
G.blue = colortext('blue')
G.purple = colortext('purple')
