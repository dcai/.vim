"""""""""""""""""""""""""""""""""""""""
""" status line
"""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" BEGIN
"""""""""""""""""""""""""""""""""""""""
""""" set statusline=%<%F\ [%Y]\ [%{&ff}]\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",\ BOM\":\",\ NOBOM\")}]\ %-14.(%l,%c%V%)\ %P

""""" default the statusline to green when entering Vim
hi statusline guibg=green guifg=black ctermbg=green ctermfg=black
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
"""""""""""""""""""""""""""""""""""""""
" END
"""""""""""""""""""""""""""""""""""""""

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green guifg=black ctermbg=green ctermfg=black

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    "hi statusline guifg=magenta ctermfg=magenta
    hi statusline guibg=red guifg=white ctermbg=red ctermfg=white
  elseif a:mode == 'r'
    hi statusline guifg=Blue ctermfg=Blue
  else
    hi statusline ctermfg=black guifg=black
  endif
endfunction
