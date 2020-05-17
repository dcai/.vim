"""""""""""""""""""""""""""""""""""""""
"
"          Plugin settings
"
"""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
""" vim-smooth-scroll
"""""""""""""""""""""""""""""""""""""""
let g:smooth_scroll_duration=10
map <silent> <c-u> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 2)<CR>
map <silent> <c-d> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 2)<CR>
map <silent> <c-b> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
map <silent> <c-f> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>

map <silent> <PageUp> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
map <silent> <PageDown> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>

"""""""""""""""""""""""""""""""""""""""
""" vim-rest-console
"""""""""""""""""""""""""""""""""""""""
let g:vrc_split_request_body = 0
let g:vrc_elasticsearch_support = 1
let g:vrc_output_buffer_name = 'api.json'
let g:vrc_show_command=1

"""""""""""""""""""""""""""""""""""""""
""" SuperTab
"""""""""""""""""""""""""""""""""""""""
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

"""""""""""""""""""""""""""""""""""""""
""" pangloss/vim-javascript
"""""""""""""""""""""""""""""""""""""""
let g:javascript_conceal_function       = 'ƒ'
let g:javascript_conceal_null           = 'ø'
let g:javascript_conceal_this           = '@'
let g:javascript_conceal_return         = '⇚'
let g:javascript_conceal_undefined      = '¿'
let g:javascript_conceal_NaN            = 'ℕ'
let g:javascript_conceal_prototype      = '¶'
let g:javascript_conceal_static         = '•'
let g:javascript_conceal_super          = 'Ω'
let g:javascript_conceal_arrow_function = '⇒'

"""""""""""""""""""""""""""""""""""""""
""" Tabular
"""""""""""""""""""""""""""""""""""""""
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>
"""""""""""""""""""""""""""""""""""""""
""" Emmet
"""""""""""""""""""""""""""""""""""""""
let g:user_emmet_settings = {
      \ 'php' : {
      \     'extends' : 'html',
      \     'filters' : 'c',
      \ },
      \ 'xml' : {
      \     'extends' : 'html',
      \ },
      \ 'haml' : {
      \     'extends' : 'html',
      \ },
      \}

"""""""""""""""""""""""""""""""""""""""
""" Hightlight interesting words
"""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>
nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>

"""""""""""""""""""""""""""""""""""""""
""" ludovicchabant/vim-gutentags
"""""""""""""""""""""""""""""""""""""""
let g:gutentags_ctags_executable_javascript = 'jsctags'
let g:gutentags_project_root = ['.git', '.hg', '.bzr', '_darcs',
      \ '_darcs', '_FOSSIL_', '.fslckout', 'Makefile', 'yarn.lock',
      \ '.editorconfig', 'eslintrc', 'eslintrc.js', 'package.json',
      \ '.jscsrc']

"""""""""""""""""""""""""""""""""""""""
""" junegunn/vim-easy-align
"""""""""""""""""""""""""""""""""""""""
" gaip*|
" ^^ Align table cells by `|`
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""
""" easymotion
"""""""""""""""""""""""""""""""""""""""
map <Leader><Leader>w <Plug>(easymotion-bd-w)
