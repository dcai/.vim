"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""

function! FindConfig(prefix, what, where)
    let cfg = findfile(a:what, escape(a:where, ' ') . ';')
    return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

autocmd FileType javascript let g:ale_jshint_config_loc =
      \ FindConfig('-c', '.jshintrc', expand('<afile>:p:h', 1))

let g:ale_sign_error = 'x'
let g:ale_sign_warning = '-'
let g:ale_set_loclist = 1

" Ale linters settings
let g:ale_linters = {
  \ 'typescript': ['tslint'],
  \ 'javascript': ['eslint'],
  \ 'sh': ['shellcheck'],
  \ 'php': ['phpmd', 'phpcs'],
  \ 'yaml': ['yamllint'],
  \ 'python': ['pylint'],
\}
let g:ale_fixers = {
  \ 'generic': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'php': ['phpcbf'],
  \ 'javascript': ['prettier'],
  \ 'yaml': ['prettier'],
  \ 'html': ['prettier'],
  \ 'css': ['prettier'],
  \ 'json': ['prettier'],
  \ 'typescript': ['prettier'],
\}

" let g:ale_php_phpcs_standard = $HOME . '/src/moodle/local/codechecker'
let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_php_phpcbf_standard = 'PSR2'
let g:ale_javascript_eslint_executable = ''
