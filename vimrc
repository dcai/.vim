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
let g:VIMCONFROOT = ".vim"
if has("win64") || has("win32") || has("win16")
  let g:OSUNAME = "Windows"
  let g:VIMCONFROOT = "vimfiles"
endif
" Bash on Ubuntu on Windows
let g:WSL=matchstr(substitute(system('uname -r'), "\n", "", ""), 'Microsoft$')

function! IncludeScript(scriptname)
  execute 'source' "$HOME/" . g:VIMCONFROOT . "/" . a:scriptname
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
  call IncludeScript('os/linux.vim')
elseif g:OSUNAME == 'Darwin'
  call IncludeScript('os/macos.vim')
elseif g:OSUNAME == 'Windows'
  call IncludeScript('os/windows.vim')
endif

if !exists('g:lightline')
  call IncludeScript('statusline.vim')
endif

call IncludeDir("$HOME/" . g:VIMCONFROOT . "/conf.d/*.vim")
