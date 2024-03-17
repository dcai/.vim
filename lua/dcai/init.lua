require('dcai.globals')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '~/.local/share/nvim/venv/bin/python3',
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})
vim.g.node_host_prog = find_executable({
  '~/.npm-packages/bin/neovim-node-host',
})

-- vim.opt.cmdheight = 0
local shadafile = os.getenv('NVIM_SHADA')
if shadafile then
  vim.opt.shadafile = shadafile
end

source('loader.vim')
setup_colorscheme()

---load all files under a given folder
---@param dir string
-- local function require_dir(dir)
--   local config_dir = vim.fn.stdpath('config')
--   local modfolder = string.format('%s/lua/%s', config_dir, dir)
--   local globpath = string.format('%s/*.lua', modfolder)
--   local filepaths = vim.fn.split(vim.fn.glob(globpath), '\n')
--   local modnames = vim.tbl_map(function(filepath)
--     local filename = string.gsub(filepath, modfolder .. '/', '')
--     return string.match(filename, '(.+).lua$')
--   end, filepaths)
--   for _, submod in ipairs(modnames) do
--     local mod = string.format('%s.%s', string.gsub(dir, '/', '.'), submod)
--     package.loaded[mod] = nil
--     require(mod)
--   end
-- end
