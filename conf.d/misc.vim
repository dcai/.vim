"""""""""""""""""""""""""""""""""""""""
"
"          Plugin settings
"
"""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
""" SuperTab
"""""""""""""""""""""""""""""""""""""""
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

"""""""""""""""""""""""""""""""""""""""
""" UltiSnips
"""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$HOME . '/Dropbox/etc/vim/ultisnips/'
nnoremap <leader>ue :UltiSnipsEdit<cr>

"""""""""""""""""""""""""""""""""""""""
""" pangloss/vim-javascript
"""""""""""""""""""""""""""""""""""""""
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_this           = "@"
let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined      = "¿"
let g:javascript_conceal_NaN            = "ℕ"
let g:javascript_conceal_prototype      = "¶"
let g:javascript_conceal_static         = "•"
let g:javascript_conceal_super          = "Ω"
let g:javascript_conceal_arrow_function = "⇒"

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
"""  vim-phpfmt
"""""""""""""""""""""""""""""""""""""""
" A standard type: PEAR, PHPCS, PSR1, PSR2, Squiz and Zend
let g:phpfmt_standard = 'PSR2'
let g:phpfmt_autosave = 0

"""""""""""""""""""""""""""""""""""""""
""" Hightlight interesting words
"""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>
nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>

"""""""""""""""""""""""""""""""""""""""
""" vim-plug
"""""""""""""""""""""""""""""""""""""""
nnoremap <leader>vpi :PlugInstall<cr>
nnoremap <leader>vpc :PlugClean<cr>
nnoremap <leader>vpu :PlugUpdate<cr>

"""""""""""""""""""""""""""""""""""""""
""" editorconfig-vim
"""""""""""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"""""""""""""""""""""""""""""""""""""""
""" ludovicchabant/vim-gutentags
"""""""""""""""""""""""""""""""""""""""
let g:gutentags_ctags_executable_javascript = 'jsctags'
let g:gutentags_project_root = ['.git', '.hg', '.bzr', '_darcs',
      \ '_darcs', '_FOSSIL_', '.fslckout', 'Makefile', 'yarn.lock',
      \ '.editorconfig', 'eslintrc', 'eslintrc.js', 'package.json',
      \ '.jscsrc']

"""""""""""""""""""""""""""""""""""""""
""" flowtype
"""""""""""""""""""""""""""""""""""""""
let g:flow#enable = 0
let g:flow#autoclose = 1

"""""""""""""""""""""""""""""""""""""""
""" gitgutter
"""""""""""""""""""""""""""""""""""""""
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk
"""""""""""""""""""""""""""""""""""""""
""" vim-javascript
"""""""""""""""""""""""""""""""""""""""
let g:javascript_plugin_flow = 1

"""""""""""""""""""""""""""""""""""""""
""" tpope/markdown
"""""""""""""""""""""""""""""""""""""""
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript']

"""""""""""""""""""""""""""""""""""""""
""" junegunn/vim-easy-align
"""""""""""""""""""""""""""""""""""""""
" gaip*|
" ^^ Align table cells by `|`
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
