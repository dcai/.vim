function! RgSearchPHPFunction()
  execute 'RgGitRoot function' expand('<cword>')
endfunction
nnoremap <silent> F :call RgSearchPHPFunction()<CR>

set makeprg=php\ -l\ %
"set errorformat=%EError\ %n,%Cline\ %l,%Ccolumn\ %c,%Z%m
set errorformat=%m\ in\ %f\ on\ line\ %l
set expandtab
set shiftwidth=4
set tabstop=4
