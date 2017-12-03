"""""""""""""""""""""""""""""""""""""""
""" status line
"""""""""""""""""""""""""""""""""""""""
set statusline=%F        "tail of the filename
set statusline+=%m       "modified flag
set statusline+=%=       "left/right separator
set statusline+=%y       "filetype
set statusline+=[
set statusline+=%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}  "file format
set statusline+=,%{&bomb?'bom':'nobom'} " BOM
set statusline+=]
set statusline+=%h       "help file flag
set statusline+=%r       "read only flag
set statusline+=[
set statusline+=%l      "cursor line/total lines
set statusline+=\/%L      " total lines
set statusline+=,%c     "cursor column
set statusline+=]
set statusline+=\ %P     "percent through file

" Default the statusline to green when entering Vim
highlight statusline gui=none cterm=none guibg=Green guifg=DarkGrey ctermbg=Green ctermfg=DarkGrey
highlight CursorLine ctermbg=Green ctermfg=DarkGrey
au InsertEnter  * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave  * call InsertLeaveActions()

function! InsertLeaveActions()
  highlight statusline guibg=Green guifg=DarkGrey ctermbg=Green ctermfg=DarkGrey
  set nocursorline
endfunction

function! InsertStatuslineColor(mode)
  set cursorline
  highlight statusline guibg=red guifg=white ctermbg=red ctermfg=white
endfunction

" function! InsertStatuslineColor(mode)
  " if a:mode == 'i'
    " " normal insert
    " hi statusline guibg=red guifg=white ctermbg=red ctermfg=white
  " elseif a:mode == 'r'
    " "" replace mode
    " hi statusline guibg=Green guifg=black ctermbg=Green ctermfg=black
  " else
    " hi statusline guibg=Green guifg=black ctermbg=Green ctermfg=black
  " endif
" endfunction
