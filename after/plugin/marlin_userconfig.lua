local loaded, marlin = pcall(require, 'marlin')
if not loaded then
  return
end

marlin.setup({
  patterns = { '.git', '.svn' },
  datafile = vim.fn.stdpath('data') .. '/marlin.json',
  suppress = {
    missing_root = false,
  },
})
local keymap = vim.keymap.set
keymap('n', '<Leader>fa', function()
  marlin.add()
end, { desc = 'add file' })
keymap('n', '<Leader>fd', function()
  marlin.remove()
end, { desc = 'remove file' })
-- keymap('n', '<Leader>fx', function()
--   marlin.remove_all()
-- end, { desc = 'remove all for current project' })

for index = 1, 4 do
  keymap('n', '<Leader>' .. index, function()
    marlin.open(index)
  end, { desc = 'marlin ' .. index })
end
