"""""""""""""""""""""""""""""""""""""""
""" UltiSnips
"""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger = '<c-\>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'
let s:snipsdir=expand("$HOME/Dropbox/src/snippets")
let g:UltiSnipsSnippetDirectories=[s:snipsdir]
nnoremap <leader>ue :UltiSnipsEdit<cr>
