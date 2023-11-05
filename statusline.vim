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
    return FugitiveStatusline()
endfunction


set statusline=[%{mode()}]                      " editing mode
set statusline+=%f
set statusline+=%m                              " modified flag
" set statusline+=%{FugitiveStatus()}
" set statusline+=[%{LinterStatus()}]
set statusline+=%=                              " left/right separator
set statusline+=[
set statusline+=%l                              " cursor line/total lines
set statusline+=\/%L                            " total lines
set statusline+=\|%c                            " cursor column
set statusline+=]
set statusline+=%y                              " filetype
set statusline+=[
set statusline+=%{strlen(&fileencoding)?&fileencoding:'none'}\| " file encoding
set statusline+=%{&fileformat}                  " file format
set statusline+=%{&bomb?'\|BOM':''}             " BOM
set statusline+=]
set statusline+=%h                              " help file flag
set statusline+=%r                              " read only flag
