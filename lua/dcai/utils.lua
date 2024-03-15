local gsub = require('string').gsub
local gmatch = require('string').gmatch

-- credit: https://hisham.hm/2016/01/04/string-interpolation-in-lua/
function f(str)
  local outer_env = _ENV
  return (
    str:gsub('%b{}', function(block)
      local code = block:match('{(.*)}')
      local exp_env = {}
      setmetatable(exp_env, {
        __index = function(_, k)
          local stack_level = 5
          while debug.getinfo(stack_level, '') ~= nil do
            local i = 1
            repeat
              local name, value = debug.getlocal(stack_level, i)
              if name == k then
                return value
              end
              i = i + 1
            until name == nil
            stack_level = stack_level + 1
          end
          return rawget(outer_env, k)
        end,
      })
      local fn, err =
          load('return ' .. code, 'expression `' .. code .. '`', 't', exp_env)
      if fn then
        return tostring(fn())
      else
        error(err, 0)
      end
    end)
  )
end

---return the first executable from given list
---@param files string[]
---@return string|nil
function find_executable(files)
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
function global_keymap(mode, from, to)
  -- local expr_opts = { noremap = true, expr = true, silent = true }
  vim.api.nvim_set_keymap(mode, from, to, { noremap = true, silent = true })
end

---copied from https://github.com/james2doyle/lit-slugify/blob/master/init.lua
---@param string string
---@param replacement string
---@return string
function slugify(string, replacement)
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

function trim_right(str, char)
  local last_char = str:sub(-1)
  if last_char == char then
    return str:sub(1, -2)
  end
  return str
end

function parent_dir(input)
  return trim_right(input, '/'):match('(.*/)')
end

---find project root
---@return string|nil
function project_root()
  local current_file = vim.fn.expand('%:p:h')
  local dir = parent_dir(current_file)

  while dir do
    local git_dir = dir .. '.git'
    local is_git_dir = io.open(git_dir, 'r')

    if is_git_dir then
      io.close(is_git_dir)
      return dir
    else
      dir = parent_dir(dir)
    end
  end

  return nil
end

function apply_colorscheme(colorscheme, termguicolors)
  vim.opt.termguicolors = termguicolors and true or false
  xpcall(function()
    vim.cmd.colorscheme(colorscheme)
  end, function()
    vim.cmd.colorscheme('default')
  end)
end

function setup_colorscheme()
  local defaulcolorscheme = 'oasis'
  local termguicolors = get_user_config('colorscheme.termguicolors', true)
  local cs = get_user_config('colorscheme.name', defaulcolorscheme)
  apply_colorscheme(cs, termguicolors)
  handle_vim_event_by_callback('ColorScheme', function(ev)
    set_user_config('colorscheme.name', ev.match or vim.g.colors_name)
  end)
end

function source(path)
  -- local vim_home = vim.fn.expand('<sfile>:p:h')
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. path)
end

function file_exists(filepath)
  local status = vim.fn.filereadable(filepath) == 1

  return status
end

function readfile(file)
  local f = assert(io.open(file, 'r'))
  local content = f:read('*all')
  f:close()
  return content
end

function writefile(file, contents)
  local f = assert(io.open(file, 'w'))
  f:write(contents)
  f:close()
end

function touch(filepath)
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

function get_or(table, key, default)
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

local function user_config_file_path()
  return vim.fn.stdpath('data') .. '/user.json'
end

function get_all_local_config()
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

function get_user_config(key, default)
  local config = get_or(get_all_local_config(), key, default)
  return config
end

function set(tbl, path, value)
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

function set_user_config(path, value)
  local userconfigfile = user_config_file_path()
  local config = get_all_local_config()
  set(config, path, value)
  writefile(userconfigfile, vim.json.encode(config))
end

function handle_vim_event_by_command(evt, command)
  local group_name = 'On' .. evt .. 'Group'
  return vim.api.nvim_create_autocmd(evt, {
    command = command,
    pattern = '*',
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
  })
end

function handle_vim_event_by_callback(evt, callback)
  local group_name = 'On' .. evt .. 'Group'
  return vim.api.nvim_create_autocmd(evt, {
    pattern = '*',
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
    callback = callback,
  })
end

---higher order function to color text
---@param color string
---@return function
local function colortext(color)
  ---@enum ansi_colors
  local ansi = {
    reset = string.char(0x001b) .. '[0m',
    red = string.char(0x001b) .. '[31m',
    green = string.char(0x001b) .. '[32m',
    yellow = string.char(0x001b) .. '[33m',
    blue = string.char(0x001b) .. '[34m',
    purple = string.char(0x001b) .. '[35m',
  }
  return function(text)
    return string.format('%s%s%s', ansi[color], text, ansi.reset)
  end
end

red = colortext('red')
green = colortext('green')
yellow = colortext('yellow')
blue = colortext('blue')
purple = colortext('purple')
