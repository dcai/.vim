let s:vim_home = expand('<sfile>:p:h')
exec 'source ' . s:vim_home . '/loader.vim'

call IncludeDir('$HOME/' . g:vimrc . '/conf.d/vim8/*.vim')

try
  if !has('gui_running')
    colorscheme oasis
  else
    colorscheme gruvbox
    " colorscheme tender
    " colorscheme solarized
    " colorscheme zenburn
    " colorscheme desertink
    " colorscheme gotham
    " colorscheme lucius
    " colorscheme apprentice
    " colorscheme jellybeans
    " colorscheme badwolf
    " colorscheme wombat
    " colorscheme distinguished
    " colorscheme seoul256
    " colorscheme tokyonight
  endif
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry
