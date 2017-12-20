"""""""""""""""""""""""""""""""""""""""
""" Syntastic
"""""""""""""""""""""""""""""""""""""""
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_javascript_checkers = ['eslint']
"""""""""""""""""""""
" Automatically check
let g:syntastic_check_on_open = 1
"""""""""""""""""""""
autocmd FileType javascript
            \ let b:syntastic_checkers =
            \ findfile('.jscsrc', '.;') != ''
            \ ? ['jscs', 'jshint'] : ['eslint']
let g:syntastic_aggregate_errors = 1
let g:syntastic_id_checkers = 0
let g:syntastic_loc_list_height=5
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_php_checkers = ['php']
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_html_checkers = []
let g:syntastic_python_checkers = []
let g:syntastic_java_checkers = []
let g:syntastic_typescript_checkers = ['tslint']
let g:syntastic_enable_balloons = 1

let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = '☡'
let g:syntastic_style_warning_symbol = '¡'

"let g:syntastic_error_symbol = '❌'
"let g:syntastic_warning_symbol = '⚠️'
"let g:syntastic_style_error_symbol = '⁉️'
"let g:syntastic_style_warning_symbol = '💩'
