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
_G.dump = vim.g.print

vim.g.reload = function(module)
  require('plenary.reload').reload_module(module)
  return require(module)
end

local function file_exists(filepath)
  return vim.fn.filereadable(filepath) == 1
end

vim.g.file_exists = file_exists

---@param file string
---@return string
local function readfile(file)
  return table.concat(vim.fn.readfile(file), '\n')
end

vim.g.readfile = readfile

local function user_config_file_path()
  return vim.fs.joinpath(vim.g.data_dir, 'user.json')
end

local function get_all_local_config()
  local path = user_config_file_path()
  if not file_exists(path) then
    return {}
  end
  local ok, config = pcall(function()
    return vim.json.decode(readfile(path))
  end)
  return ok and type(config) == 'table' and config or {}
end

local function get_user_config(key, default)
  local value = vim.tbl_get(
    get_all_local_config(),
    unpack(vim.split(key, '.', { plain = true }))
  )
  if value == nil or value == vim.NIL then
    return default
  elseif value == 'true' then
    return true
  elseif value == 'false' then
    return false
  end
  return value
end

local function set_user_config(path, value)
  local config = get_all_local_config()
  local keys = vim.split(path, '.', { plain = true })
  local current = config
  for i = 1, #keys - 1 do
    local key = keys[i]
    if type(current[key]) ~= 'table' then
      current[key] = {}
    end
    current = current[key]
  end
  current[keys[#keys]] = value
  vim.fn.mkdir(vim.g.data_dir, 'p')
  vim.fn.writefile({ vim.json.encode(config) }, user_config_file_path(), 'b')
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

---@param sequence string
---@return string
local function wrap_tmux_passthrough(sequence)
  if vim.g.isempty(sequence) then
    return ''
  end

  if not vim.env.TMUX or vim.env.TMUX == '' then
    return sequence
  end

  local esc = '\27'
  local tmux_start = esc .. 'Ptmux;' .. esc
  local tmux_end = esc .. '\\'
  local escaped_sequence = sequence:gsub(esc, esc .. esc)

  return tmux_start .. escaped_sequence .. tmux_end
end

vim.g.wrap_tmux_passthrough = wrap_tmux_passthrough

---@param sequence string
---@return nil
local function send_terminal_sequence(sequence)
  local wrapped_sequence = wrap_tmux_passthrough(sequence)

  if vim.api.nvim_ui_send then
    vim.api.nvim_ui_send(wrapped_sequence)
    return nil
  end

  io.write(wrapped_sequence)
  io.flush()
  return nil
end

vim.g.send_terminal_sequence = send_terminal_sequence

---Send native terminal progress using OSC 9;4.
---
---Sequence format: ESC ] 9 ; 4 ; <state> ; <progress> BEL
---ESC is the escape character (ASCII 27).
---BEL is the bell character (ASCII 7).
---
---State values:
---0: hide the progress bar and clear progress state
---1: set progress value in the default state
---2: set progress value in the error state
---3: show indeterminate progress; ignores the progress value
---4: set progress value in the warning state
---@param state integer Progress state value in the range 0-4.
---@param percent? integer Progress percentage in the range 0-100, inclusive. Ignored for state 3. Optional for state 0.
---@return nil
local function send_terminal_progress(state, percent)
  local osc_seq

  if state == 0 or state == 3 then
    osc_seq = string.format('\27]9;4;%d\a', state)
  else
    local resolved_percent = percent or 0
    osc_seq = string.format('\27]9;4;%d;%d\a', state, resolved_percent)
  end

  return send_terminal_sequence(osc_seq)
end

vim.g.send_terminal_progress = send_terminal_progress

---Set native terminal progress in the default state.
---@param percent integer Progress percentage in the range 0-100, inclusive.
---@return nil
local function set_terminal_progress(percent)
  if percent >= 100 then
    return send_terminal_progress(0)
  end

  return send_terminal_progress(1, percent)
end

vim.g.set_terminal_progress = set_terminal_progress

---@return nil
local function set_terminal_progress_loading()
  return send_terminal_progress(3)
end

vim.g.set_terminal_progress_loading = set_terminal_progress_loading

---@return nil
local function clear_terminal_progress()
  return send_terminal_progress(0)
end

vim.g.clear_terminal_progress = clear_terminal_progress

---@param percent integer Progress percentage in the range 0-100, inclusive.
---@return nil
local function set_terminal_progress_error(percent)
  return send_terminal_progress(2, percent)
end

vim.g.set_terminal_progress_error = set_terminal_progress_error

---@param percent integer Progress percentage in the range 0-100, inclusive.
---@return nil
local function set_terminal_progress_warning(percent)
  return send_terminal_progress(4, percent)
end

vim.g.set_terminal_progress_warning = set_terminal_progress_warning

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

vim.g.replace = function(str, what, with)
  return str:gsub(vim.pesc(what or ''), function()
    return with
  end)
end

---@param text string|nil
---@param replacement? string
---@return string
vim.g.slugify = function(text, replacement)
  local words = {}
  for word in (text or ''):gmatch('%w+') do
    words[#words + 1] = word
  end
  return table.concat(words, replacement or '-'):lower()
end

vim.g.trim_right = function(str, char)
  if str:sub(-1) == char then
    return str:sub(1, -2)
  end
  return str
end

local function trim_trailing_slash(str)
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
  local group =
    vim.api.nvim_create_augroup('dcai_colorscheme', { clear = true })
  apply_colorscheme(
    get_user_config('colorscheme.name', 'pine'),
    get_user_config('colorscheme.termguicolors', true)
  )
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    desc = 'Save selected colorscheme',
    callback = function(ev)
      set_user_config('colorscheme.name', ev.match or vim.g.colors_name)
    end,
  })
end

vim.g.source = function(path)
  vim.cmd.source({
    vim.fs.joinpath(vim.fn.stdpath('config'), path),
    magic = { file = false },
  })
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

---@param opts table
---@return table
vim.g.new_popup = function(opts)
  opts = opts or {}
  local width = opts.width or 80
  local buffer = vim.api.nvim_create_buf(false, false)
  return {
    buffer = buffer,
    open = function()
      local win, border = require('plenary.popup').create(buffer, {
        title = opts.title or 'Job',
        padding = { 0, 0, 0, 0 },
        line = 3,
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = opts.height or 10,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      })
      vim.wo[win].number = opts.number or false
      vim.wo[win].spell = false
      local function close()
        vim.api.nvim_win_close(win, true)
      end
      for _, key in ipairs({ 'q', '<Esc>' }) do
        vim.keymap.set('n', key, close, { buffer = buffer, silent = true })
      end
      return win, border
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
    return vim.fs.root(filepath or 0, markers)
  end
end
vim.g.root_pattern = root

vim.g.git_root = root({
  '.git',
  '.github',
  '.gitlab-ci.yml',
})

vim.g.smart_root = root({
  '.git',
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
---@field buf integer?
---@field win integer?
---@field append fun(text: string)
---@field open fun(): integer
---@field close fun()

---create new window
---@param opt new_win_opt
---@return new_win
vim.g.new_win = function(opt)
  opt = opt or {}
  local view = {}
  local width = opt.w and math.floor(opt.w / 100 * vim.o.columns)
    or math.min(80, vim.o.columns - 4)
  local height = opt.h and math.floor(opt.h / 100 * vim.o.lines)
    or math.min(20, vim.o.lines - 4)
  local win_opts = opt.split and { split = opt.split }
    or {
      relative = 'editor',
      width = width,
      height = height,
      row = opt.x or math.floor((vim.o.lines - height) / 2),
      col = opt.y or math.floor((vim.o.columns - width) / 2),
      style = 'minimal',
      border = 'rounded',
      focusable = true,
      zindex = 300,
      title = opt.title,
    }

  function view.open()
    if view.win and vim.api.nvim_win_is_valid(view.win) then
      return view.win
    end
    if not view.buf or not vim.api.nvim_buf_is_valid(view.buf) then
      view.buf = vim.api.nvim_create_buf(false, true)
      vim.bo[view.buf].fileformat = 'unix'
      vim.bo[view.buf].filetype = opt.filetype or 'text'
      for _, key in ipairs({ 'q', '<Esc>' }) do
        vim.keymap.set('n', key, '<cmd>close<CR>', {
          buffer = view.buf,
          silent = true,
        })
      end
    end
    view.win = vim.api.nvim_open_win(view.buf, true, win_opts)
    local wo = vim.wo[view.win]
    wo.spell = false
    wo.cursorline = true
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = 'no'
    return view.win
  end

  view.append = vim.schedule_wrap(function(text)
    local win = view.open()
    local last = vim.api.nvim_buf_line_count(view.buf) - 1
    local lines = vim.split(text, '\n', { plain = true })
    for i, line in ipairs(lines) do
      lines[i] = line:gsub('\r$', '')
    end
    lines[1] = vim.api.nvim_buf_get_lines(view.buf, last, last + 1, false)[1]
      .. lines[1]
    vim.api.nvim_buf_set_lines(view.buf, last, last + 1, false, lines)
    vim.api.nvim_win_set_cursor(
      win,
      { vim.api.nvim_buf_line_count(view.buf), 0 }
    )
  end)
  function view.close()
    if view.win and vim.api.nvim_win_is_valid(view.win) then
      vim.api.nvim_win_close(view.win, true)
    end
    view.win = nil
  end
  return view
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
