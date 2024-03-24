"  for Exafunction/codeium.vim
let g:codeium_disable_bindings = 1
let g:codeium_no_map_tab = v:true
imap <script><silent><nowait><expr> <C-f> codeium#Accept()
imap <C-j> <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-k> <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x> <Cmd>call codeium#Clear()<CR>
