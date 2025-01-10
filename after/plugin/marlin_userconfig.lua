local loaded, marlin = pcall(require, 'marlin')
if not loaded then
  print('marlin not loaded!')
  return
end

marlin.setup({
  patterns = { '.git', 'package.json' },
  datafile = vim.g.data_dir .. '/marlin.json',
  open_callback = require('marlin.callbacks').change_buffer,
  sorter = require('marlin.sorters').by_name,
  save_cursor_location = false,
  suppress = {
    missing_root = true,
  },
})
