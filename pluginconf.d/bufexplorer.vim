"""""""""""""""""""""""""""""""""""""""
""" BufExplorer
"""""""""""""""""""""""""""""""""""""""
" see buffer list

let g:bufExplorerDisableDefaultKeyMapping=0
let g:bufExplorerDefaultHelp=1
map <c-j> <ESC>:bn<CR>
map <c-k> <ESC>:bp<CR>
nmap <leader>bb :BufExplorerHorizontalSplit<cr>
