" disable airline in cli
"" let g:airline_powerline_fonts = 0
set term=xterm-256color
set termencoding=utf-8
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"

""" input method
"set imactivatekey=C-space
"inoremap <ESC> <ESC>:set iminsert=0<CR>
try
  " colorscheme slate
  colorscheme desert
  "colorscheme jellybeans
  "colorscheme seoul256
catch /^Vim\%((\a\+)\)\=:E185/
  " deal with it
endtry
"let g:jellybeans_overrides = {
      "\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
      "\}
"colorscheme slate
"colorscheme desert
"colorscheme elflord
"colorscheme solarized
"colorscheme base16-default
"colorscheme peaksea