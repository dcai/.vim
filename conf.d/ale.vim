"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""

" function! FindConfig(prefix, what, where)
    " let cfg = findfile(a:what, escape(a:where, ' ') . ';')
    " return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
" endfunction
" autocmd FileType javascript let g:ale_jshint_config_loc =
      " \ FindConfig('-c', '.jshintrc', expand('<afile>:p:h', 1))

" let g:ale_completion_enabled = 1
let g:ale_set_highlights = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

let g:ale_sign_error = 'x'
let g:ale_sign_warning = '>'
let g:ale_set_loclist = 1

" Ale linters settings
let g:ale_linters = {
  \ 'php': ['phpmd', 'phpcs'],
  \ 'javascript': ['eslint'],
  \ 'python': ['flake8'],
  \ 'sh': ['shellcheck'],
  \ 'typescript': ['eslint'],
  \ 'vim': ['ale_custom_linting_rules', 'vint'],
\}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'css': ['prettier'],
  \ 'lua': ['luafmt'],
  \ 'go': ['gofmt'],
  \ 'graphql': ['prettier'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'json': ['prettier'],
  \ 'dokuwiki': ['pandoc'],
  \ 'markdown': ['pandoc'],
  \ 'less': ['prettier'],
  \ 'php': ['phpcbf'],
  \ 'python': ['black'],
  \ 'sh': ['shfmt'],
  \ 'typescript': ['prettier'],
  \ 'yaml': ['prettier'],
\}

" Install moodle coding style:
"   > phpcs --config-set installed_paths /home/vagrant/projects/moodle/local/codechecker/moodle
" Above command add moodle coding style to
"   /home/vagrant/.config/composer/vendor/squizlabs/php_codesniffer/CodeSniffer.conf
" let s:php_coding_standard = 'moodle'
" let s:php_coding_standard = 'WordPress-Core'

let g:ale_javascript_eslint_executable = ''
let g:ale_pandoc_options = '--columns=120'
let g:ale_pandoc_use_gfm = 1
