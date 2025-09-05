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

local function with_dir(dir, cmd)
  return 'cd ' .. dir .. ' && ' .. cmd
end

local function run_nodejs_test(file, noderoot)
  local packagejson = vim.g.readfile(noderoot .. '/package.json')
  if not packagejson then
    return
  end
  local cmd = ''
  if string.find(packagejson, 'mocha') then
    cmd = 'npx mocha --full-trace --watch ' .. file
  end
  if string.find(packagejson, 'bun test') then
    cmd = 'bun test --watch ' .. file
  end
  if string.find(packagejson, 'vitest') then
    cmd = 'npx vitest --silent=false --watch ' .. file
  end
  if string.find(packagejson, 'jest') or cmd == '' then
    local env = 'node'
    if string.find(packagejson, 'jsdom') then
      env = 'jsdom'
    end
    cmd = 'npx jest --runInBand --verbose=false --silent=false --coverage=false --watch --env='
      .. env
      .. ' --runTestsByPath '
      .. file
  end
  vim.fn['VimuxRunCommand'](with_dir(noderoot, cmd))
end

local testthings_keymap = {
  { '<leader>t', group = 'test things' },
  {
    '<leader>tj',
    function()
      local file = vim.fn.expand('%:p')
      local noderoot = vim.g.node_project_root()
      if noderoot then
        run_nodejs_test(file, noderoot)
        return
      end
    end,
    desc = 'test javascript project',
  },
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
      local root = vim.g.node_project_root()
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
