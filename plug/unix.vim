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
    !./install.py --clang-completer --ts-completer
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
