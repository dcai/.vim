function! LinterStatus() abort
    if !exists(":ALEInfo")
      return
    endif
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

function! FugitiveStatus() abort
    if !exists(":Git")
      return
    endif
    return fugitive#statusline()
endfunction


" status line {{{
set statusline=%f                               " tail of the filename
set statusline+=%m                              " modified flag
set statusline+=%{FugitiveStatus()}
set statusline+=[%{LinterStatus()}]
set statusline+=%=                              " left/right separator
set statusline+=%y                              " filetype
set statusline+=[
set statusline+=%{strlen(&fenc)?&fenc:'none'}\| " file encoding
set statusline+=%{&ff}                          " file format
set statusline+=\|%{&bomb?'bom':'nobom'}        " BOM
set statusline+=]
set statusline+=[
set statusline+=%l                              " cursor line/total lines
set statusline+=\/%L                            " total lines
" set statusline+=\ %P                            " percent through file
" set statusline+=\|%c                            " cursor column
set statusline+=]
set statusline+=%h                              " help file flag
set statusline+=%r                              " read only flag
" }}}

function! s:hi(group, value)
  let l:ctermbg = has_key(a:value, 'bg') ? join(["ctermbg", a:value.bg], "=") : ""
  let l:ctermfg = has_key(a:value, 'fg') ? join(["ctermfg", a:value.fg], "=") : ""
  let l:cterm = has_key(a:value, 'cterm') ? join(["cterm", a:value.cterm], "=") : ""
  let l:cmd = join(["hi", a:group, l:cterm, l:ctermbg, l:ctermfg], " ")
  exe l:cmd
endfunction

let s:active = {'fg': 'white', 'bg': 'green', 'cterm': 'none'}
let s:inactive = {'fg': 'white', 'bg': 'darkgrey', 'cterm': 'none'}
let s:insertmode = {'fg': 'white', 'bg': 'darkred', 'cterm': 'none'}

call s:hi('statusline', s:active)
call s:hi('statuslineNC', s:inactive)

au InsertEnter  * call InsertEnter(v:insertmode)
au InsertChange * call InsertEnte(v:insertmode)
au InsertLeave  * call InsertLeave()

function! InsertLeave()
  call s:hi('statusline', s:active)
endfunction

function! InsertEnter(mode)
  call s:hi('statusline', s:insertmode)
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
