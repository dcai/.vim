"""""""""""""""""""""""""""""""""""""""
""" NERDTree
"""""""""""""""""""""""""""""""""""""""
nnoremap <leader>ft :NERDTreeCWD<cr>
nmap <c-n> :NERDTreeToggle<cr>
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeIgnore = ['\.vim$', '\~$']
let g:NERDTreeBookmarksFile = $HOME . '/.NERDTreeBookmarks'
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI=0
autocmd bufenter *
  \ if (winnr("$") == 1 &&
  \ exists("b:NERDTreeType") &&
  \ b:NERDTreeType == "primary") | q | endif

