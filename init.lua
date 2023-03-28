require('lib')

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = find_executable({
  '/opt/homebrew/bin/python3',
  '/usr/local/bin/python3',
  '/usr/bin/python3',
})

local vim_home = vim.fn.expand('<sfile>:p:h')
vim.cmd(f('source {vim_home}/loader.vim'))

xpcall(function()
  vim.cmd('colorscheme oasis')
end, function()
  vim.cmd('colorscheme default')
end)

vim.cmd([[
  let g:codeium_no_map_tab = v:true
  imap <script><silent><nowait><expr> <C-f> codeium#Accept()
  imap <C-j> <Cmd>call codeium#CycleCompletions(1)<CR>
  imap <C-k> <Cmd>call codeium#CycleCompletions(-1)<CR>
  imap <C-x> <Cmd>call codeium#Clear()<CR>
]])

-- vim.cmd([[
--   let g:copilot_no_tab_map = v:true
--   imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
-- ]])
