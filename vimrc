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
let g:OSUNAME=substitute(system('uname'), "\n", "", "")

execute 'source' "$HOME/.vim/plug.vim"
execute 'source' "$HOME/.vim/local.vim"

if OSUNAME == 'Linux'
  execute 'source' "$HOME/.vim/linux.vim"
elseif OSUNAME == 'Darwin'
  nmap <leader>p :r !pbpaste<CR>
endif

if !GUI_RUNNING
  execute 'source' "$HOME/.vim/term.vim"
else
  execute 'source' "$HOME/.vim/gui.vim"
endif

execute 'source' "$HOME/.vim/statusline.vim"
