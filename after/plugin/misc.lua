local whichkey_loaded, whichkey = pcall(require, 'which-key')
if not whichkey_loaded then
  return
end

require('which-key').setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
})
