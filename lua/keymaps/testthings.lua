local utils = require('keymaps.utils')

---@param vimscript_func string custom function name in string
local function run_testfile(vimscript_func)
  return {
    function()
      local file = vim.fn.expand('%')
      if string.find(file, 'spec.') or string.find(file, 'test.') then
        vim.notify('start test runner for ' .. file)
        vim.call(vimscript_func)
      else
        vim.notify('this is not a test file')
      end
    end,
    vimscript_func,
  }
end

local testthings_keymap = {
  name = 'Test',
  i = utils.vim_cmd('VimuxInspectRunner', 'inspect runner'),
  j = run_testfile('TestCurrentFileWithJestJsdom'),
  J = run_testfile('TestCurrentFileWithJestNode'),
  h = utils.vim_cmd('HurlRun', 'run hurl file'),
  -- l = cmd('VimuxRunLastCommand', 'last command'),
  l = {
    function()
      local fzf = require('fzf-lua')
      fzf.files({
        cwd = vim.g.dropbox_home .. '/src/hurl_files',
      })
    end,
    'list all hurl files',
  },
  m = run_testfile('TestCurrentFileWithMocha'),
  n = {
    function()
      local root = G.project_root()
      vim.api.nvim_command('cd ' .. root)
      vim.cmd('TestNearest')
    end,
    'Test nearest',
  },
  p = utils.vim_cmd('VimuxPromptCommand', 'prompt command'),
  q = utils.vim_cmd('VimuxCloseRunner', 'close runner'),
  s = utils.vim_cmd('!%:p', 'run current buffer in shell'),
  x = utils.vim_cmd('call VimuxZoomRunner()', 'zoom in'),
  z = utils.vim_cmd('call LastPath()', 'open last path in runner'),
  t = {
    function()
      vim.call('EditMatchingTestFile')
    end,
    'alternate test file',
  },
}

return testthings_keymap
