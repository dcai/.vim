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

"execute 'source' "$HOME/.vim/vundle.vim"
let g:GUI_RUNNING=has('gui_running')
if !GUI_RUNNING
  execute 'source' "$HOME/.vim/term.vim"
else
  execute 'source' "$HOME/.vim/gui.vim"
endif

execute 'source' "$HOME/.vim/plug.vim"
execute 'source' "$HOME/.vim/local.vim"
execute 'source' "$HOME/.vim/statusline.vim"
