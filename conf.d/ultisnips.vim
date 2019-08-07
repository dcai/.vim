"""""""""""""""""""""""""""""""""""""""
""" UltiSnips
"""""""""""""""""""""""""""""""""""""""

let s:snipsdir= 'ultisnips'

let g:UltiSnipsExpandTrigger = '<c-e>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetsDir=$HOME . '/' . g:VIMCONFROOT . '/' . s:snipsdir . '/'
let g:UltiSnipsSnippetDirectories=[s:snipsdir]
nnoremap <leader>ue :UltiSnipsEdit<cr>
