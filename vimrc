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

function! IncludeScript(scriptname)
  execute 'source' "$HOME/.vim/" . a:scriptname
endfunction

function! IncludeDir(dirname)
  for f in split(glob(a:dirname), '\n')
    exe 'source' f
  endfor
endfunction

call IncludeScript('plug.vim')
call IncludeScript('local.vim')

if has('gui_running')
  " Run in GUI
  call IncludeScript('gui.vim')
else
  " Run in term
  call IncludeScript('term.vim')
endif

if OSUNAME == 'Linux'
  call IncludeScript('linux.vim')
elseif OSUNAME == 'Darwin'
  call IncludeScript('macos.vim')
endif

" call IncludeScript('statusline.vim')
call IncludeDir("$HOME/.vim/pluginconf.d/*.vim")
