call IncludeScript('plug-base.vim')

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --tern-completer
  endif
endfunction

" Snippets and auto complete
" ==========================
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'frozen': 1 }

" Linting
" ==========================
Plug 'w0rp/ale', { 'for': ['php', 'python', 'javascript'] }
"Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }

" Syntax
Plug 'mustache/vim-mustache-handlebars'
