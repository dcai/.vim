"""""""""""""""""""""""""""""""""""""""
"               __           _        "
"          ____/ /________ _(_)       "
"         / __  / ___/ __ `/ /        "
"        / /_/ / /__/ /_/ / /         "
"        \__,_/\___/\__,_/_/          "
"                                     "
"       Dongsheng Cai <d@tux.im>      "
"                                     "
"""""""""""""""""""""""""""""""""""""""

" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh
let g:OSUNAME=substitute(system('uname'), "\n", "", "")
" Bash on Ubuntu on Windows
let g:WSL=matchstr(substitute(system('uname -r'), "\n", "", ""), 'Microsoft$')

function! IncludeScript(scriptname)
  execute 'source' "$HOME/.vim/" . a:scriptname
endfunction

function! IncludeDir(dirname)
  for f in split(glob(a:dirname), '\n')
    exe 'source' f
  endfor
endfunction

call IncludeScript('plug/main.vim')
call IncludeScript('local.vim')

if has('gui_running')
  " Run in GUI
  call IncludeScript('gui.vim')
else
  " Run in term
  call IncludeScript('term.vim')
endif

if g:OSUNAME == 'Linux'
  call IncludeScript('linux.vim')
elseif g:OSUNAME == 'Darwin'
  call IncludeScript('macos.vim')
endif

if !exists('g:lightline')
  call IncludeScript('statusline.vim')
endif

call IncludeDir("$HOME/.vim/conf.d/*.vim")
