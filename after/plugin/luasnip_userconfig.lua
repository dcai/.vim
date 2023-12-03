local loaded, luasnip = pcall(require, 'luasnip')
if loaded then
  local fromVscode = require('luasnip.loaders.from_vscode')
  fromVscode.lazy_load({})
  fromVscode.lazy_load({
    paths = { './src/snippets' },
  })
end
