set t_Co=256
let base16colorspace=256  " Access colors present in 256 colorspace
"colorscheme desert
"colorscheme solarized
"colorscheme base16-ocean
"colorscheme base16-bright
"colorscheme base16-pop
"colorscheme base16-google
"colorscheme base16-eighties
"colorscheme base16-chalk
colorscheme peaksea
"colorscheme blue
"colorscheme darkblue
"colorscheme elflord
"colorscheme evening
"colorscheme koehler
"colorscheme morning
"colorscheme murphy
"colorscheme pablo
"colorscheme peachpuff
"colorscheme ron
"colorscheme slate
"colorscheme torte
if or(or(has("gui_qt"), has('gui_gtk2')), has('gui_gtk3'))
  "set guifont=Inconsolata\ 14
  "set guifont=DejaVu\ Sans\ Mono\ 12
  "set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
  "set guifont=FantasqueSansMono\ 14
  set guifont=Source\ Code\ Pro\ for\ Powerline\ Regular\ 14
else
  " Powerline fonts
  set guifont=Hack:h16
  "set guifont=Source\ Code\ Pro\ for\ Powerline:h18
  "set guifont=Anonymous\ Pro\ for\ Powerline:h16
  "set guifont=Cousine\ for\ Powerline:h16
  "set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14
  "set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powerline:h16
  "set guifont=Droid\ Sans\ Mono\ for\ Powerline:h16
  "set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h16
  "set guifont=Fira\ Mono\ for\ Powerline:h16
  "set guifont=Fira\ Mono\ Medium\ for\ Powerline:h16
  "set guifont=Inconsolata\ for\ Powerline:h14
  "set guifont=Inconsolata-dz\ for\ Powerline:h14
  "set guifont=Inconsolata-g\ for\ Powerline:h14
  "set guifont=Liberation\ Mono\ for\ Powerline:h16
  "set guifont=Meslo\ LG\ L\ DZ\ for\ Powerline:h14
  "set guifont=Meslo\ LG\ L\ for\ Powerline:h14
  "set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h14
  "set guifont=Meslo\ LG\ M\ for\ Powerline:h14
  "set guifont=Meslo\ LG\ S\ DZ\ for\ Powerline:h14
  "set guifont=Meslo\ LG\ S\ for\ Powerline:h14
  "set guifont=monofur\ for\ Powerline:h18
  "set guifont=Roboto\ Mono\ for\ Powerline:h16
  "set guifont=Roboto\ Mono\ Medium\ for\ Powerline:h14
  "set guifont=Roboto\ Mono\ Thin\ for\ Powerline:h15
  "set guifont=Roboto\ Mono\ Light\ for\ Powerline:h18
  "set guifont=Ubuntu\ Mono\ derivative\ Powerline:h16
  " Regular fonts
  "set guifont=Monaco:h14
endif
