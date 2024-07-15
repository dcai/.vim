local utils = require('dcai.keymaps.utils')

---@param vimscript_func string custom function name in string
local function run_testfile(key, vimscript_func)
  return {
    key,
    function()
      local file = vim.fn.expand('%')
      if string.find(file, 'spec.') or string.find(file, 'test.') then
        vim.notify('start test runner for ' .. file)
        vim.call(vimscript_func)
      else
        vim.notify('this is not a test file')
      end
    end,
    desc = vimscript_func,
  }
end

local testthings_keymap = {
  { '<leader>t', group = 'test things' },
  run_testfile('<leader>tj', 'TestCurrentFileWithJestJsdom'),
  run_testfile('<leader>tJ', 'TestCurrentFileWithJestNode'),
  run_testfile('<leader>tm', 'TestCurrentFileWithMocha'),
  -- l = cmd('VimuxRunLastCommand', 'last command'),
  {
    '<leader>tl',
    function()
      local fzf = require('fzf-lua')
      fzf.files({
        cwd = vim.g.dropbox_home .. '/src/hurl_files',
      })
    end,
    desc = 'list all hurl files',
  },
  {
    '<leader>tn',
    function()
      local root = G.node_project_root()
      vim.api.nvim_command('cd ' .. root)
      vim.cmd('TestNearest')
    end,
    desc = 'Test nearest',
  },
  {
    '<leader>tt',
    function()
      vim.call('EditMatchingTestFile')
    end,
    desc = 'alternate test file',
  },
  utils.vim_cmd('<leader>th', 'HurlRun', 'run hurl file'),
  utils.vim_cmd('<leader>ti', 'VimuxInspectRunner', 'inspect runner'),
  utils.vim_cmd('<leader>tp', 'VimuxPromptCommand', 'prompt command'),
  utils.vim_cmd('<leader>tq', 'VimuxCloseRunner', 'close runner'),
  utils.vim_cmd('<leader>ts', '!%:p', 'run current buffer in shell'),
  utils.vim_cmd('<leader>tx', 'call VimuxZoomRunner()', 'zoom in'),
  utils.vim_cmd('<leader>tz', 'call LastPath()', 'open last path in runner'),
}

return testthings_keymap
