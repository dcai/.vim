" quickfix buffer type
" credit: https://stackoverflow.com/a/76021219
nnoremap <buffer> <Down> <Down><CR><C-w>p
nnoremap <buffer> <Up> <Up><CR><C-w>p
nmap <buffer> q :ccl<CR>:lcl<CR>:pcl<CR>:helpclose<CR>
setlocal nospell
