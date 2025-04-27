nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>ee :e #<cr>
nnoremap <leader>rR :source $MYVIMRC<cr>
" source current file
nnoremap <leader>rr :source %<cr>

" copy messages to register
nnoremap <leader>ym :let @*=execute('messages')<CR>
" Convert slashes to backslashes for Windows.
if g:osuname ==? 'Windows'
  nmap <leader>yp :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap <leader>yf :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
else
  " copy fullpath to vim * register
  nnoremap <leader>yp :let @*=expand("%:p")<CR>
  " copy file name to vim register
  nnoremap <leader>yf :let @*=expand("%")<CR>
endif
" open file in sublime
nnoremap <leader>of :Dispatch! /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl %<CR>
function OpenDir()
  let d = expand("%:p:h")
  silent execute '!open ' . d
endfunction
nnoremap <leader>od :call OpenDir()<CR>
" toggle last used file
" ctrl-6 <c-6> <c-^> doesn't work for some terminals
nnoremap <leader>tt :call EditMatchingTestFile()<cr>
nnoremap <leader>tf :call ToggleQuickFix()<cr>
