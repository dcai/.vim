"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""
" let g:ale_completion_enabled = 1
let g:ale_disable_lsp = 1
let g:ale_set_highlights = 1
let g:ale_sign_column_always = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
" let g:ale_keep_list_window_open = 0
let g:ale_php_cs_fixer_use_global = 1
let g:ale_php_cs_fixer_options = ''

let g:ale_lua_stylua_options = '--search-parent-directories'

let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_set_loclist = 1
let g:ale_plaintext_pandoc_use_gfm = 1
let g:ale_plaintext_pandoc_options = '--columns=120'
let g:ale_xml_xmllint_indentsize = 4

" javascript
" let g:ale_javascript_eslint_executable = ''
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_javascript_eslint_use_global = 1
" let g:ale_javascript_prettier_executable = 'prettierd'
" shouldn't global prettier as the project might
" use different version which generates different format
let g:ale_javascript_prettier_use_global = 0

" Ale linters settings
let g:ale_linters = {
  \ 'php': [],
  \ 'markdown': ['cspell'],
  \ 'c': ['clangd', 'ccls'],
  \ 'javascript': ['eslint', 'tsserver'],
  \ 'javascriptreact': ['eslint', 'tsserver'],
  \ 'json': [],
  \ 'lua': ['luac'],
  \ 'python': ['flake8'],
  \ 'sh': ['shellcheck'],
  \ 'typescript': ['eslint', 'tsserver'],
  \ 'typescriptreact': ['eslint', 'tsserver'],
  \ 'vim': ['vimls'],
\}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'c': ['clang-format'],
  \ 'css': ['prettier'],
  \ 'dokuwiki': ['plaintext'],
  \ 'fish': ['fish_indent'],
  \ 'go': ['gofmt'],
  \ 'graphql': ['prettier'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'javascriptreact': ['prettier'],
  \ 'json': ['prettier'],
  \ 'json5': ['prettier'],
  \ 'less': ['prettier'],
  \ 'lua': ['stylua'],
  \ 'markdown': ['prettier'],
  \ 'php': ['php_cs_fixer'],
  \ 'python': ['black', 'isort'],
  \ 'sh': ['shfmt'],
  \ 'sql': ['pgformatter'],
  \ 'terraform': ['terraform'],
  \ 'typescript': ['prettier'],
  \ 'typescriptreact': ['prettier'],
  \ 'yaml': ['prettier'],
  \ 'vue': ['prettier'],
  \ 'xml': ['xmllint'],
\}

nnoremap <leader>, :ALEFix<cr>
nnoremap <silent> [d :ALEPreviousWrap<cr>
nnoremap <silent> ]d :ALENextWrap<cr>
