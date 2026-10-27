local MiniTest = require('mini.test')
local M = {}

-- Stateful cases run in a fresh child so mocks, timers and autocmds cannot leak.
function M.new_set()
  local child = MiniTest.new_child_neovim()
  local directory
  local T = MiniTest.new_set({
    hooks = {
      pre_case = function()
        directory = vim.fn.tempname()
        vim.fn.mkdir(directory, 'p')
        child.restart({ '--noplugin', '-u', 'tests/minimal-init.lua' })
        child.g.test_directory = directory
      end,
      post_case = function()
        child.stop()
        if directory then
          vim.fn.delete(directory, 'rf')
        end
      end,
    },
  })
  return T, child
end

return M
