local loaded, marlin = pcall(require, 'marlin')
if not loaded then
  return
end

marlin.setup({
  patterns = { '.git', 'package.json' },
  datafile = vim.fn.stdpath('data') .. '/marlin.json',
  open_callback = require('marlin.callbacks').change_buffer,
  sorter = require('marlin.sorters').by_name,
  suppress = {
    missing_root = false,
  },
})

local keymap = vim.keymap.set
for index = 1, 4 do
  keymap('n', '<Leader>' .. index, function()
    marlin.open(index)
  end, { desc = 'marlin ' .. index })
end
