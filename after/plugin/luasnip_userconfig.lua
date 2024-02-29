local loaded, ls = pcall(require, 'luasnip')
if loaded then
  ls.filetype_extend('typescript', { 'javascript' })
  -- load built in
  require('luasnip.loaders.from_vscode').lazy_load()
  -- load from custom folders
  require('luasnip.loaders.from_vscode').lazy_load({
    paths = {
      '~/src/vssnips',
    },
  })
  local fromSnipmate = require('luasnip.loaders.from_snipmate')
  fromSnipmate.lazy_load()
  fromSnipmate.lazy_load({
    paths = { '~/src/test-snip' },
  })
end
