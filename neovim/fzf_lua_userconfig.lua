local status, fzflua = pcall(require, 'fzf-lua')

if not status then
  return
end
fzflua.setup({
  winopts = {},
})
