function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --tern-completer --go-completer
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'frozen': 1 }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'dcai/vim-react-es6-snippets'
Plug 'airblade/vim-gitgutter'
