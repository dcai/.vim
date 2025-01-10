local gsub = require('string').gsub
local gmatch = require('string').gmatch

vim.uv = vim.uv or vim.loop

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
  writefile(userconfigfile, vim.json.encode(config))
end

vim.g.handle_vim_event_by_command = function(evt, command)
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
  local v = os.getenv(name)
  return v == 'true' or v == '1'
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
---@param string string
---@param replacement string
---@return string
vim.g.slugify = function(string, replacement)
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
vim.g.log_dir = trim_trailing_slash(vim.fn.stdpath('log'))
vim.g.std_cfg_dir = trim_trailing_slash(vim.fn.stdpath('config'))
vim.g.cache_dir = trim_trailing_slash(vim.fn.stdpath('cache'))
vim.g.state_dir = trim_trailing_slash(vim.fn.stdpath('state'))

vim.g.parent_dir = function(input)
  return vim.g.trim_right(input, '/'):match('(.*/)')
end

vim.g.setup_colorscheme = function()
  local defaulcolorscheme = 'oasis'
  local termguicolors = get_user_config('colorscheme.termguicolors', true)
  local cs = get_user_config('colorscheme.name', defaulcolorscheme)
  apply_colorscheme(cs, termguicolors)
  create_autocmd('ColorScheme', 'SaveColorScheme', function(ev)
    set_user_config('colorscheme.name', ev.match or vim.g.colors_name)
  end)
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
      vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(winid, true)
      end, { buffer = buffer })
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

---get project root
---@param markers table
---@return function
local function root(markers)
  return function(filepath)
    local buf = filepath or vim.api.nvim_get_current_buf()
    if vim.fs and vim.fs.root then
      local fs_root = vim.fs.root(buf, markers)
      if fs_root then
        return fs_root
      end
    end

    local current_dir = vim.fn.expand('%:p:h')
    local dir = shell_cmd('git rev-parse --show-toplevel') or current_dir
    local loaded, lspconfig = pcall(require, 'lspconfig')
    if not loaded then
      return dir
    end

    if lspconfig.util and lspconfig.util.root_pattern then
      local root_pattern = lspconfig.util.root_pattern
      return root_pattern(unpack(markers))(current_dir)
    else
      return dir
    end
  end
end

vim.g.git_root = root({
  '.github',
  '.gitlab-ci.yml',
  '.git',
})

vim.g.smart_root = root({
  'appsettings.json',
  'Jenkinsfile_Build',
  'Makefile',
  '.husky',
  '.vscode',
  '.editorconfig',
  '.tool-versions',
  '.mise.toml',
  'mise.toml',
  '.envrc',
  -- js or typescript
  'package.json',
  'tsconfig.json',
  -- lua
  'stylua.toml',
  -- python
  'pyproject.toml',
  -- biome
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
})

vim.g.node_project_root = root({
  'package.json',
})

vim.g.nl = '\r\n'

vim.g.red = colortext('red')
vim.g.green = colortext('green')
vim.g.yellow = colortext('yellow')
vim.g.blue = colortext('blue')
vim.g.purple = colortext('purple')
