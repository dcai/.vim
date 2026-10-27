-- Run: nvim --headless --clean -l tests/globals-test.lua
vim.opt.runtimepath:append(vim.fn.getcwd())
require('dcai.globals')
local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), vim.inspect(actual))
end
local temporary = vim.fn.tempname()
vim.g.data_dir = temporary .. '/settings'
local config = vim.g.data_dir .. '/user.json'
local colorscheme = vim.cmd.colorscheme
local selected
vim.cmd.colorscheme = function(name)
  if name == 'missing-theme' then
    error('missing colorscheme')
  end
  selected = name
  vim.g.colors_name = name
  vim.api.nvim_exec_autocmds('ColorScheme', { pattern = name })
end

-- Reading settings must tolerate missing paths and must not write preferences.
vim.g.setup_colorscheme()
equal({ selected, vim.o.termguicolors }, { 'pine', true })
equal(vim.fn.filereadable(config), 0)
vim.fn.mkdir(vim.g.data_dir, 'p')
for _, case in ipairs({
  { '', 'pine', true },
  { 'invalid json', 'pine', true },
  { 'null', 'pine', true },
  { 'false', 'pine', true },
  { '{"other":42}', 'pine', true },
  { '{"colorscheme":false}', 'pine', true },
  { '{"colorscheme":{"name":null}}', 'pine', true },
  {
    '{"colorscheme":{"name":"default","termguicolors":false}}',
    'default',
    false,
  },
  {
    '{"colorscheme":{"name":"default","termguicolors":"false"}}',
    'default',
    false,
  },
  {
    '{"colorscheme":{"name":"missing-theme","termguicolors":"true"}}',
    'default',
    true,
  },
}) do
  vim.fn.writefile({ case[1] }, config, 'b')
  vim.g.setup_colorscheme()
  equal({ selected, vim.o.termguicolors }, { case[2], case[3] })
  equal(vim.g.readfile(config), case[1])
end
vim.fn.writefile({ '{"other":42,"colorscheme":false}' }, config)
vim.g.setup_colorscheme()
vim.cmd.colorscheme('changed')
equal(
  vim.json.decode(vim.g.readfile(config)),
  { other = 42, colorscheme = { name = 'changed' } }
)
equal(#vim.api.nvim_get_autocmds({ group = 'dcai_colorscheme' }), 1)
vim.g.data_dir = temporary .. '/new/settings'
vim.g.setup_colorscheme()
vim.cmd.colorscheme('saved')
equal(
  vim.json.decode(vim.g.readfile(vim.g.data_dir .. '/user.json')),
  { colorscheme = { name = 'saved' } }
)
vim.cmd.colorscheme = colorscheme

-- Literal separators and Lua-pattern characters must remain literal.
equal(vim.g.slugify(nil), '')
equal(vim.g.slugify('Hello_world 123'), 'hello-world-123')
for _, separator in ipairs({ '.', '%', '+', '*', '[]', '' }) do
  equal(
    vim.g.slugify('Hello World', separator),
    'hello' .. separator .. 'world'
  )
end
equal(vim.g.replace('a.b$[x]% end', 'a.b$[x]%', '%done'), '%done end')
equal(vim.g.replace('abc', nil, '-'), '-a-b-c-')
equal(vim.g.trim_trailing_slash('/path//'), '/path/')

local project = temporary .. '/project'
vim.fn.mkdir(project .. '/src', 'p')
vim.fn.writefile({ '{}' }, project .. '/package.json')
vim.fn.writefile({ '' }, project .. '/src/file.js')
equal(vim.g.node_project_root(project .. '/src/file.js'), project)
equal(vim.g.root_pattern({ 'not-present' })(project .. '/src/file.js'), nil)
local stdpath = vim.fn.stdpath
vim.fn.stdpath = function(name)
  return name == 'config' and temporary .. '/config with spaces'
    or stdpath(name)
end
vim.fn.mkdir(vim.fn.stdpath('config'), 'p')
vim.fn.writefile(
  { 'let g:globals_source_test = 1' },
  vim.fn.stdpath('config') .. '/file # %.vim'
)
vim.g.source('file # %.vim')
equal(vim.g.globals_source_test, 1)
vim.fn.stdpath = stdpath

-- Exercise real Neovim windows, scheduled chunks, closing and reopening.
vim.o.columns, vim.o.lines = 120, 45
local view = vim.g.new_win({ title = 'Output', w = 50, h = 40, x = 1, y = 2 })
equal(view.buf, nil)
view.append('alpha\r\nbe')
view.append('ta\n')
assert(
  vim.wait(1000, function()
    return view.buf and vim.api.nvim_buf_line_count(view.buf) == 3
  end),
  'scheduled output did not arrive'
)
equal(
  vim.api.nvim_buf_get_lines(view.buf, 0, -1, false),
  { 'alpha', 'beta', '' }
)
local win, buf = view.open(), view.buf
equal(vim.api.nvim_win_get_buf(win), buf)
local layout = vim.api.nvim_win_get_config(win)
equal({ layout.width, layout.height, layout.row, layout.col }, { 60, 18, 1, 2 })
equal({ vim.bo[buf].buftype, vim.bo[buf].fileformat }, { 'nofile', 'unix' })
equal(
  { vim.wo[win].number, vim.wo[win].spell, vim.wo[win].signcolumn },
  { false, false, 'no' }
)
view.close()
view.close()
assert(not vim.api.nvim_win_is_valid(win), 'window did not close')
view.open()
equal(view.buf, buf)
vim.api.nvim_win_close(view.win, true)
assert(
  vim.api.nvim_win_is_valid(view.open()),
  'externally closed window did not reopen'
)
vim.api.nvim_buf_delete(buf, { force = true })
assert(
  vim.api.nvim_win_is_valid(view.open()),
  'deleted buffer did not recreate'
)
view.close()
vim.api.nvim_buf_delete(view.buf, { force = true })

local split = vim.g.new_win({ split = 'left' })
equal(vim.api.nvim_win_get_config(split.open()).relative, '')
split.close()
vim.api.nvim_buf_delete(split.buf, { force = true })
local popup =
  vim.g.new_popup({ title = 'Terminal', number = true, width = 30, height = 4 })
assert(
  vim.api.nvim_buf_is_valid(popup.buffer),
  'terminal buffer must exist before open'
)
local popup_win = popup.open()
equal({ vim.wo[popup_win].number, vim.wo[popup_win].spell }, { true, false })
vim.api.nvim_chan_send(vim.api.nvim_open_term(popup.buffer, {}), 'hello\r\n')
vim.fn.maparg('q', 'n', false, true).callback()
assert(not vim.api.nvim_win_is_valid(popup_win), 'popup close mapping failed')
vim.api.nvim_buf_delete(popup.buffer, { force = true })
vim.fn.delete(temporary, 'rf')
print('Globals: settings, string/path helpers and window lifecycle passed')
