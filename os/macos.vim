if exists('$TMUX')
  " TODO: find out how to access clipboard in tmux
else
  set clipboard=unnamed
endif

nmap <leader>pp :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
" imap <leader>pp <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <leader>yy :.w !pbcopy<CR><CR>
vmap <leader>yy :w !pbcopy<CR><CR>

if has("gui_macvim")
  set guifont=Hack:h14
  " set guifont=Source\ Code\ Pro\ for\ Powerline:h18
  " set guifont=Anonymous\ Pro\ for\ Powerline:h18
  " set guifont=Cousine\ for\ Powerline:h16
  " set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14
  " set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powerline:h16
  " set guifont=Droid\ Sans\ Mono\ for\ Powerline:h16
  " set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h16
  " set guifont=Fira\ Mono\ for\ Powerline:h16
  " set guifont=Fira\ Mono\ Medium\ for\ Powerline:h16
  " set guifont=Inconsolata\ for\ Powerline:h14
  " set guifont=Inconsolata-dz\ for\ Powerline:h14
  " set guifont=Inconsolata-g\ for\ Powerline:h14
  " set guifont=Liberation\ Mono\ for\ Powerline:h16
  " set guifont=Meslo\ LG\ L\ DZ\ for\ Powerline:h14
  " set guifont=Meslo\ LG\ L\ for\ Powerline:h14
  " set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h14
  " set guifont=Meslo\ LG\ M\ for\ Powerline:h14
  " set guifont=Meslo\ LG\ S\ DZ\ for\ Powerline:h14
  " set guifont=Meslo\ LG\ S\ for\ Powerline:h14
  " set guifont=monofur\ for\ Powerline:h18
  " set guifont=Roboto\ Mono\ for\ Powerline:h16
  " set guifont=Roboto\ Mono\ Medium\ for\ Powerline:h14
  " set guifont=Roboto\ Mono\ Thin\ for\ Powerline:h15
  " set guifont=Roboto\ Mono\ Light\ for\ Powerline:h18
  " set guifont=Ubuntu\ Mono\ derivative\ Powerline:h16
  " set guifont=Monaco:h14
endif
