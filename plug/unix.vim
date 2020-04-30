" function! InstallPython3Black(info)
  " if a:info.status == 'installed' || a:info.force
    " TODO
  " endif
" endfunction

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --ts-completer --go-completer
  endif
endfunction

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

if has('python3')
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'frozen': 1 }
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

" if has('python3')
  " Plug 'ambv/black', { 'do': function('InstallPython3Black'), 'frozen': 1, 'for': ['python'] }
  " autocmd BufWritePre *.py execute ':Black'
  " let g:black_virtualenv = '~/.local/python-black'
  " let g:black_virtualenv = '/usr/local/Cellar/black/19.10b0_1/libexec'
  " let g:black_linelength = 88
" endif
