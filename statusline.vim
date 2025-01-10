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

" function! FugitiveStatus() abort
"     if !exists(":Git")
"         return
"     endif
"     return FugitiveStatusline()
" endfunction

function! GitBranch()
  let l:cmd="git rev-parse --abbrev-ref HEAD 2>/dev/null | fold -w30 | head -n1"
  let l:branch = trim(system(l:cmd))
  if empty(l:branch)
    return 'NOT IN GIT'
  endif
  return l:branch
endfunction

" got from https://jdhao.github.io/2019/11/03/vim_custom_statusline/
let g:currentmode={
            \  'n'  : 'NORMAL',
            \  'v'  : 'VISUAL',
            \  'V'  : 'V·Line',
            \  "\<C-V>" : 'V·Block',
            \  'i'  : 'INSERT',
            \  'R'  : 'R',
            \  'Rv' : 'V·Replace',
            \  'c'  : 'Command',
            \  't'  : 'Term',
            \}

set statusline=
" use User1 highlight group
set statusline+=%1*
set statusline+=%{toupper(g:currentmode[mode()])}
" reset highlight group
set statusline+=%0*
" a space
set statusline+=\ %f
" modified flag
set statusline+=%m
" set statusline+=[%{LinterStatus()}]
" left/right separator
set statusline+=%=
set statusline+=%1*  " start User1 highlight group
" cursor line/total lines
set statusline+=\ \[%l\]\ /\ %L
set statusline+=\ \|\ Col:\ %c
" reset highlight group
set statusline+=\ %0*
" filetype
set statusline+=\ %y
set statusline+=[
" file encoding
set statusline+=%{strlen(&fileencoding)?&fileencoding:'none'}\|
" file format
set statusline+=%{&fileformat}
" BOM
set statusline+=%{&bomb?'\|BOM':''}
set statusline+=]
" help file flag
set statusline+=%h
" read only flag
set statusline+=%r
set statusline+=\ %3*  " start User3 highlight group
set statusline+=\[%{GitBranch()}\]
set statusline+=%0*
