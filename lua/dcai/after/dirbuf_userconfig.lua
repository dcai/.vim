local loaded, dirbuf = pcall(require, 'dirbuf')
if not loaded then
  return
end

dirbuf.setup({
  hash_padding = 2,
  show_hidden = true,
  sort_order = 'default',
  write_cmd = 'DirbufSync',
})
