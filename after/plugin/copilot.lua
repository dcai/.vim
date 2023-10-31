vim.cmd([[
  let g:copilot_no_tab_map = v:true
  imap <silent><script><expr> <c-f> copilot#Accept("\<CR>")
]])
