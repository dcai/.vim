" function! BuildYCM(info)
"   " info is a dictionary with 3 fields
"   " - name:   name of the plugin
"   " - status: 'installed', 'updated', or 'unchanged'
"   " - force:  set on PlugInstall! or PlugUpdate!
"   if a:info.status == 'installed' || a:info.force
"     !./install.py --clang-completer --ts-completer
"   endif
" endfunction
"
" if has('python3')
"   Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM'), 'frozen': 1 }
"   Plug 'SirVer/ultisnips'
" endif
