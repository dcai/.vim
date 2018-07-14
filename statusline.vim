" status line {{{
set statusline=%f                               " tail of the filename
set statusline+=\ %{fugitive#statusline()}
set statusline+=%m                              " modified flag
set statusline+=[
set statusline+=%l                              " cursor line/total lines
set statusline+=\/%L                            " total lines
set statusline+=\|%c                            " cursor column
set statusline+=]
set statusline+=%=                              " left/right separator
set statusline+=%y                              " filetype
set statusline+=[
set statusline+=%{strlen(&fenc)?&fenc:'none'}\| " file encoding
set statusline+=%{&ff}                          " file format
set statusline+=\|%{&bomb?'bom':'nobom'}        " BOM
set statusline+=]
set statusline+=%h                              " help file flag
set statusline+=%r                              " read only flag
set statusline+=\ %P                            " percent through file
" }}}

highlight statusline cterm=NONE ctermbg=Magenta ctermfg=white

" highlight CursorLine ctermbg=Green ctermfg=DarkGrey
au InsertEnter  * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave  * call InsertLeaveActions()

function! InsertLeaveActions()
  highlight statusline cterm=NONE ctermfg=white ctermbg=Magenta
endfunction

function! InsertStatuslineColor(mode)
  highlight statusline cterm=NONE ctermfg=white ctermbg=darkmagenta
endfunction

" function! InsertStatuslineColor(mode)
  " if a:mode == 'i'
    " hi statusline guibg=red guifg=white ctermbg=red ctermfg=white
  " elseif a:mode == 'r'
    " replace mode
    " hi statusline guibg=Green guifg=black ctermbg=Green ctermfg=black
  " else
    " hi statusline guibg=Green guifg=black ctermbg=Green ctermfg=black
  " endif
" endfunction
