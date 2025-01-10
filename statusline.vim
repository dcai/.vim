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

function! ExtractAfter(path, substrings)
  for substring in a:substrings
    let result = substitute(a:path, '.*' . substring . '/', '', '')
    if result != a:path
      return '@/' . result
    endif
  endfor
  return a:path
endfunction

function! CurrentBuffer()
  let l:fullpath = expand('%:~')
  let l:markers = ["iris", "packages", "services"]
  return ExtractAfter(l:fullpath, l:markers)
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

function! RedrawStatusLine()
  let l:lg = winwidth(0) > 100

  set statusline=
  " use User1 highlight group
  set statusline+=%1*

  if l:lg
    set statusline+=%{toupper(g:currentmode[mode()])}
  endif

  " reset highlight group
  set statusline+=%0*
  " a space
  " set statusline+=\ %f  " filepath relative to current dir
  " set statusline+=\ %F " full path
  set statusline+=\ %{CurrentBuffer()}
  " modified flag
  set statusline+=%m
  " set statusline+=[%{LinterStatus()}]

  set statusline+=%=   " Switch to the right side

  " only show more when winwidth is bigger than 100
  if l:lg
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
  endif
endfunction

call RedrawStatusLine()

augroup AutoRedrawOnSplit
  autocmd!
  autocmd WinResized,WinNew,WinEnter,WinClosed * call RedrawStatusLine()
augroup END
