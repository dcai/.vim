let s:vim_home = expand('<sfile>:p:h')
exec 'source ' . s:vim_home . '/loader.vim'

call IncludeDir('$HOME/' . g:vimrc . '/vim8/*.vim')

try
  if !has('gui_running')
    colorscheme oasis
  else
    colorscheme gruvbox
  endif
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
endtry
