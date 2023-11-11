local gsub = require('string').gsub
local gmatch = require('string').gmatch
local ini = require('ini')

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

function contains(table, val)
  for index, value in ipairs(table) do
    if value == val then
      return true
    end
  end

  return false
end

function find_executable(files)
  for _, file in ipairs(files) do
    if vim.fn.executable(file) == 1 then
      return file
    end
  end
  return nil
end

function global_keymap(mode, from, to)
  -- local expr_opts = { noremap = true, expr = true, silent = true }
  vim.api.nvim_set_keymap(mode, from, to, { noremap = true, silent = true })
end

-- copied from https://github.com/james2doyle/lit-slugify/blob/master/init.lua
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

-- @return project root dir
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

function use_theme(colorscheme, termguicolors)
  vim.opt.termguicolors = termguicolors and true or false
  xpcall(function()
    vim.cmd.colorscheme(colorscheme)
  end, function()
    vim.cmd.colorscheme('default')
  end)
end

--- apply given theme if no config found
-- @param theme fallback theme
function apply_theme(theme, truecolor)
  local termguicolors =
    get_local_config('colorscheme.termguicolors', truecolor or false)
  use_theme(get_local_config('colorscheme.name', theme), termguicolors)
end

function source(path)
  -- local vim_home = vim.fn.expand('<sfile>:p:h')
  vim.cmd('source ' .. vim.fn.stdpath('config') .. '/' .. path)
end

function file_exists(filepath)
  local status = vim.fn.filereadable(filepath) == 1

  return status
end

function touch(filepath)
  if not file_exists(filepath) then
    local file, error_message = io.open(filepath, 'w')
    if file then
      file:close()
    else
      print(error_message)
    end
  end
end

function split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

function get_or(table, key, default)
  local parts = split(key, '.')
  local v = table
  for i, k in ipairs(parts) do
    v = v[k]
  end
  return v or default
end

function get_all_local_config()
  local userconfig = vim.fn.stdpath('data') .. '/user.ini'
  touch(userconfig)
  local config = ini.load(userconfig)
  -- print(vim.inspect(config))
  return config or {}
end

function get_local_config(key, default)
  local config = get_or(get_all_local_config(), key, default)
  return config
end

function set(tbl, path, value)
  local keys = {}
  for key in path:gmatch('[^.]+') do
    table.insert(keys, key)
  end
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

function set_config(path, value)
  local userconfig = vim.fn.stdpath('data') .. '/user.ini'
  local config = get_all_local_config()
  set(config, path, value)
  ini.save(userconfig, config)
end

function handle_vim_event(evt, func)
  local cmd_name = 'Handle' .. evt
  local group_name = 'On' .. evt .. 'Group'
  vim.api.nvim_create_user_command(cmd_name, func, { nargs = 0, desc = evt })

  local colorSchemeChange =
    vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd(evt, {
    pattern = '*',
    command = cmd_name,
    group = colorSchemeChange,
  })
end
