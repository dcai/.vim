"""""""""""""""""""""""""""""""""""""""
""" nerdcommenter
"""""""""""""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
let g:NERDDefaultAlign = 'left'
" c-_ is c-/
map <c-_> <plug>NERDCommenterToggle
