-- Bootstrap mini.test without loading the personal configuration or plugins.
vim.opt.runtimepath:append(vim.fn.getcwd())
vim.opt.packpath:append(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
vim.cmd.packadd({ 'mini.nvim', bang = true })
require('mini.test').setup({
  collect = {
    emulate_busted = false,
    find_files = function()
      local files = vim.fn.globpath('tests', '**/*-test.lua', true, true)
      vim.list_extend(
        files,
        vim.fn.globpath('tests', '**/test_*.lua', true, true)
      )
      table.sort(files)
      return files
    end,
  },
})
