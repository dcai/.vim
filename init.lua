-- disable traditional Vim syntax highlighting to avoid conflicts with Tree-sitter’s highlighting.
vim.cmd('syntax off')
-- vim.loader.enable()
require('dcai')

-- local lazypath = G.data_dir .. '/lazy/lazy.nvim'
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   vim.fn.system({
--     'git',
--     'clone',
--     '--filter=blob:none',
--     'https://github.com/folke/lazy.nvim.git',
--     '--branch=stable', -- latest stable release
--     lazypath,
--   })
-- end
--
-- vim.opt.rtp:prepend(lazypath)
--
-- require('lazy').setup({
--   { 'ibhagwan/fzf-lua' },
--   { 'dcai/ale' },
--   'folke/which-key.nvim',
--   'folke/neodev.nvim',
-- })
