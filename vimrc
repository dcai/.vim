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

let g:GUI_RUNNING=has('gui_running')
let g:OSUNAME=substitute(system('uname'), "\n", "", "")

execute 'source' "$HOME/.vim/plug.vim"
execute 'source' "$HOME/.vim/local.vim"

if GUI_RUNNING
  " Run in GUI
  execute 'source' "$HOME/.vim/gui.vim"
else
  " Run in term
  execute 'source' "$HOME/.vim/term.vim"
endif

if OSUNAME == 'Linux'
  execute 'source' "$HOME/.vim/linux.vim"
elseif OSUNAME == 'Darwin'
  execute 'source' "$HOME/.vim/macos.vim"
endif

execute 'source' "$HOME/.vim/statusline.vim"
