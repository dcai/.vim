vim.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'
-- disable traditional Vim syntax highlighting to avoid conflicts with Tree-sitter’s highlighting.
vim.cmd('syntax off')
-- vim.loader.enable()
require('dcai')

-- local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
--   local out = vim.fn.system({
--     'git',
--     'clone',
--     '--filter=blob:none',
--     '--branch=stable',
--     lazyrepo,
--     lazypath,
--   })
--   if vim.v.shell_error ~= 0 then
--     vim.api.nvim_echo({
--       { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
--       { out, 'WarningMsg' },
--       { '\nPress any key to exit...' },
--     }, true, {})
--     vim.fn.getchar()
--     os.exit(1)
--   end
-- end
--
-- vim.opt.rtp:prepend(lazypath)
--
-- require('lazy').setup({
--   { 'ibhagwan/fzf-lua' },
--   { 'dcai/ale' },
--   'folke/which-key.nvim',
--   -- 'folke/neodev.nvim',
-- })
