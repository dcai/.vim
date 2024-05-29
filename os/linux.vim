nmap <leader>c "+y
nmap <leader>p :set paste<CR>"+p :set nopaste<CR>
" nmap <leader>p :r !xsel -p<CR>
vmap <leader>c "+y

if or(or(has("gui_qt"), has('gui_gtk2')), has('gui_gtk3'))
  "set guifont=Inconsolata\ 14
  "set guifont=DejaVu\ Sans\ Mono\ 12
  "set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
  "set guifont=FantasqueSansMono\ 14
  set guifont=Source\ Code\ Pro\ for\ Powerline\ Regular\ 14
endif
