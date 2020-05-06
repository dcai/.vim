set termencoding=utf-8
set t_Co=256

""" input method
"set imactivatekey=C-space
"inoremap <ESC> <ESC>:set iminsert=0<CR>
try
  colorscheme badwolf
  " colorscheme desert2
  " colorscheme noctu
  " colorscheme wombat
  " colorscheme distinguished
  " colorscheme slate
  " colorscheme elflord
  " colorscheme peaksea
  " colorscheme jellybeans
  " colorscheme seoul256
catch /^Vim\%((\a\+)\)\=:E185/
  " deal with it
endtry

" allows cursor change in tmux mode
" https://dougblack.io/words/a-good-vimrc.html#colors
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
