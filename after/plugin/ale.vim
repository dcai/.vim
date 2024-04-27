"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""
let g:ale_completion_enabled = 0
let g:ale_disable_lsp = 'auto'
let g:ale_hover_cursor = 0
let g:ale_virtualtext_cursor = "disabled"
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
let g:ale_javascript_eslint_use_global = 0
" let g:ale_javascript_prettier_executable = 'prettierd'
" shouldn't global prettier as the project might
" use different version which generates different format
let g:ale_javascript_prettier_use_global = 0

let g:ale_biome_use_global = 1
let g:ale_biome_executable = 'biome'

let s:default_js_linter = []
let s:jslinter = getenv('JSLINTER') ? [getenv('JSLINTER')] : s:default_js_linter
let s:jsfixer = getenv('JSFIXER') ? [getenv('JSFIXER')] : ['biome']

" Ale linters settings
let g:ale_linters = {
  \ 'c': ['clangd', 'ccls'],
  \ 'cs': ['mcs'],
  \ 'go': ['gopls'],
  \ 'graphql': [],
  \ 'javascript': s:jslinter,
  \ 'javascriptreact': s:jslinter,
  \ 'json': [],
  \ 'lua': ['luac', 'luacheck'],
  \ 'markdown': ['cspell'],
  \ 'php': [],
  \ 'python': ['flake8'],
  \ 'rust': ['analyzer', 'cargo'],
  \ 'sh': ['shellcheck'],
  \ 'typescript': s:jslinter,
  \ 'typescriptreact': s:jslinter,
  \ 'vim': ['vimls'],
\}

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'c': ['clang-format'],
  \ 'cpp': ['clang-format'],
  \ 'cs': ['dotnet-format'],
  \ 'css': ['prettier'],
  \ 'dokuwiki': ['plaintext'],
  \ 'fish': ['fish_indent'],
  \ 'go': ['goimports'],
  \ 'graphql': ['prettier'],
  \ 'html': ['prettier'],
  \ 'hurl': ['hurlfmt'],
  \ 'gotmpl': ['prettier'],
  \ 'templ': ['templ'],
  \ 'java': ['clang-format'],
  \ 'javascript': s:jsfixer,
  \ 'javascriptreact': s:jsfixer,
  \ 'json': ['biome'],
  \ 'json5': ['biome'],
  \ 'less': ['prettier'],
  \ 'lua': ['stylua'],
  \ 'markdown': ['prettier'],
  \ 'php': ['php_cs_fixer'],
  \ 'python': ['black', 'isort'],
  \ 'rust': ['rustfmt'],
  \ 'sh': ['shfmt'],
  \ 'svelte': ['prettier'],
  \ 'sql': ['pgformatter'],
  \ 'terraform': ['terraform'],
  \ 'typescript': s:jsfixer,
  \ 'typescriptreact': s:jsfixer,
  \ 'vue': ['prettier'],
  \ 'xml': ['xmllint'],
  \ 'yaml': ['prettier'],
\}

nnoremap <leader>, :ALEFix<cr>
nnoremap <silent> [d :ALEPrevious<cr>
nnoremap <silent> ]d :ALENext<cr>

""""""""""""""""""""""""""""""""""""
" Set ale fix on save conditionally
""""""""""""""""""""""""""""""""""""
function! UpdateAleFixOnSave()
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')

  let g:ale_fix_on_save = 0

  if g:IsEnvVarFalse('VIM_ALE_FIX_ON_SAVE')
    let g:ale_fix_on_save = 0
  endif

  if match(l:file, 'html\|twig\|jinja2') > -1
    " disable auto fix for html
    let b:ale_fix_on_save = 0
  endif

  if match(l:file, 'cs') > -1
    " csharp
    let b:ale_fix_on_save = 0
  endif

  if match(l:file, 'php\|phps') > -1
    " disable auto fix for php
    let b:ale_fix_on_save = 0
  endif

  " Install moodle coding style:
  "   > phpcs --config-set installed_paths /home/vagrant/projects/moodle/local/codechecker/moodle
  " Above command add moodle coding style to
  "   /home/vagrant/.config/composer/vendor/squizlabs/php_codesniffer/CodeSniffer.conf
  " let s:php_coding_standard = 'moodle'
  " let s:php_coding_standard = 'WordPress-Core'
  let l:php_coding_standard = 'PSR12'
  if l:dir =~ 'moodle'
    let g:ale_fix_on_save = 0
    let l:php_coding_standard = 'moodle'
  endif
  let g:ale_php_phpcs_standard = l:php_coding_standard
  let g:ale_php_phpcbf_standard = l:php_coding_standard

  unlet l:php_coding_standard
  unlet l:file
  unlet l:dir
endfunction

augroup aleGlobalOptionsGroup
  autocmd!
  autocmd BufEnter * call UpdateAleFixOnSave()
augroup END
