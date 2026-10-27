-- Bootstrap mini.test without loading the personal configuration or plugins.
vim.opt.runtimepath:append(vim.fn.getcwd())
vim.opt.packpath:append(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))
vim.cmd.packadd({ 'mini.nvim', bang = true })
require('mini.test').setup({ collect = { emulate_busted = false } })
