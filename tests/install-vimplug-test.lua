local MiniTest = require('mini.test')
local T = MiniTest.new_set()

local function run(binary, args)
  if vim.fn.has('win32') == 1 then
    MiniTest.skip('Installer fixtures require a POSIX shell')
  end
  if vim.fn.executable(binary) == 0 then
    MiniTest.skip(binary .. ' is not installed')
  end
  local command = vim.list_extend({ binary }, args)
  vim.list_extend(command, { '-S', 'tests/install-vimplug-test.vim' })
  local result = vim.system(command, { text = true }):wait(10000)
  if result.code ~= 0 then
    MiniTest.add_note((result.stdout or '') .. (result.stderr or ''))
  end
  MiniTest.expect.equality(result.code, 0)
end

T['installer works in Neovim'] = function()
  run(vim.v.progpath, { '--headless', '-u', 'NONE', '-i', 'NONE', '-n' })
end

T['installer works in Vim'] = function()
  run('vim', { '-Nu', 'NONE', '-i', 'NONE', '-n', '-es' })
end

return T
