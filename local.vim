"""""""""""""""""""""""""""""""""""""""
"               __           _        "
"          ____/ /________ _(_)       "
"         / __  / ___/ __ `/ /        "
"        / /_/ / /__/ /_/ / /         "
"        \__,_/\___/\__,_/_/          "
"                                     "
"       Dongsheng Cai <d@tux.im>      "
"                                     "
"""""""""""""""""""""""""""""""""""""""
" http://www.figlet.org/fontdb_example.cgi?font=slant.flf
"
set nocompatible

"""""""""""""""""""""""""""""""""""""""
"             Core setting
"
"""""""""""""""""""""""""""""""""""""""

" this enables filetype specific plugin and indent files
" must enable this
" run :filetype see status
filetype plugin indent on

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,
      \.bbl,.blg,.brf,.cb,.ind,.idx,
      \.ilg,.inx,.out,.toc,.class,.pyc

set wildignore+=node_modules
" http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
set tags=tags;

if exists("syntax_on")
  syntax reset
else
  syntax on
endif

set history=100
set autoread
set spelllang=en
set mouse=a
set noerrorbells
set visualbell
set showcmd
set hidden
" Avoid hit ENTER to continue normal
set shortmess+=a
"set ve[rsion]
set ve=all
"more powerful backspacing
set backspace=indent,eol,start
set nofoldenable
set cryptmethod=blowfish2

" show linenumber
" set number
" set relativenumber
set nonumber

" source $VIMRUNTIME/mswin.vim
" make :Man command avaliable
" Default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"

"""""""""""""""""""""""""""""""""""""""
""" wrap
"""""""""""""""""""""""""""""""""""""""
" http://blog.ezyang.com/2010/03/vim-textwidth/
set wrap
"set nowrap
set linebreak
"set textwidth=72
set formatoptions=cqt
set wrapmargin=0
" note trailing space at end of next line
"set showbreak=>\ \ \
set showbreak=↪

"""""""""""""""""""""""""""""""""""""""
""" Search Setting
"""""""""""""""""""""""""""""""""""""""
set ignorecase
set hlsearch
set incsearch
set grepformat=%f:%l:%c:%m

"""""""""""""""""""""""""""""""""""""""
""" backup
"""""""""""""""""""""""""""""""""""""""
let g:backupdir="~/.vim_backups"
if !isdirectory(expand(backupdir))
  call mkdir(expand(backupdir))
endif
set backupdir=backupdir

set nobackup
"set directory=~/.vim_backups/,.
set noswapfile
set switchbuf=usetab
set nowritebackup

"""""""""""""""""""""""""""""""""""""""
""" Encoding and Decoding
"""""""""""""""""""""""""""""""""""""""
set fileformat=unix
set fileencodings=utf-8,gbk,big5,latin1
"set enc=utf-8
if has ('multi_byte') && v:version > 601
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
  endif
endif

" Common code for encodings, used by *.nfo files
function! SetFileEncodings(encodings)
  let b:myfileencodingsbak=&fileencodings
  let &fileencodings=a:encodings
endfunction

function! RestoreFileEncodings()
  let &fileencodings=b:myfileencodingsbak
  unlet b:myfileencodingsbak
endfunction

" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s\+$//e
  %s/[ \t\r]\+$//e
endfunction

"""""""""""""""""""""""""""""""""""""""
""" Indent setting
"""""""""""""""""""""""""""""""""""""""
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set smartindent

"""""""""""""""""""""""""""""""""""""""
""" Keep in curr dir
""" Vim tip #64
"""""""""""""""""""""""""""""""""""""""
function! CHANGE_CURR_DIR()
  let _dir = expand("%:p:h")
  exec "cd " . _dir  . ""
  unlet _dir
endfunction
"autocmd BufEnter * call CHANGE_CURR_DIR()
" http://vim.wikia.com/wiki/VimTip64
autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /

function! SoftWrap()
  let s:old_tw = &textwidth
  set tw=999999
  normal gggqG
  let &tw = s:old_tw
endfunction

" Persistent undo
let undodir = expand('~/.undo-vim')
if !isdirectory(undodir)
  call mkdir(undodir)
endif
set undodir=~/.undo-vim
set undofile " Create FILE.un~ files for persistent undo

"""""""""""""""""""""""""""""""""""""""
""" Visual Search
"""""""""""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
"function! VisualSearch(direction) range
"let l:saved_reg = @"
":echo 'test'
"execute "normal! vgvy"
"let l:pattern = escape(@", '\\/.*$^~[]')
"let l:pattern = substitute(l:pattern, "\n$", "", "")
"if a:direction == 'b'
"execute "normal ?" . l:pattern . "^M"
"else
"execute "normal /" . l:pattern . "^M"
"endif
"let @/ = l:pattern
"let @" = l:saved_reg
"endfunction

"" Basically you press * or # to search
"" for the current selection !! Really useful
"map <silent> * :call VisualSearch('f')<CR>
"map <silent> # :call VisualSearch('b')<CR>

"""""""""""""""""""""""""""""""""""""""
""" key mappings
"""""""""""""""""""""""""""""""""""""""
"set timeout
"set ttimeoutlen=2000
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"

nmap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

" not go into Ex mode
" or use unmap
map q: <nop>
nnoremap Q <nop>

" Press <Home> or <End> to the 1st and last
" char of the line
map  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
map  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vmap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
imap <Home> <C-o><Home>
imap <End>  <C-o><End>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %
vmap j gj
vmap k gk
vmap <Down> gj
vmap <Up> gk

imap <Down> <C-o>gj
imap <Up> <C-o>gk
" kill hlsearch until next time
nmap <silent> <Leader>/ :nohlsearch<CR>
nmap <Down> gj
nmap <Up> gk

nmap <leader>fed :e! $HOME/.vim/local.vim<cr>
nmap <leader>feR :source $HOME/.vim/vimrc<cr>
nmap <leader>cwd :NERDTreeCWD<cr>
" BD is vim-bufkill plugin command
nmap <leader>bd :BD<cr>
nmap <leader>kk :close<cr>
nmap <leader>qq :quit<cr>
nmap <leader>fs :w!<cr>
"map <leader>fw :w !sudo tee > /dev/null %<cr>
"nmap <leader>u :set fileencoding=utf8<cr>
nmap <leader>paste <ESC>:r! cat<CR>

map Q gqip
map QQ gggqG
inoremap jj <ESC>

"""""""""""""""""""""""""""""""""""""""
"
"          Plugin settings
"
"""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
""" BufExplorer
"""""""""""""""""""""""""""""""""""""""
" see buffer list

let g:bufExplorerDisableDefaultKeyMapping=0
let g:bufExplorerDefaultHelp=1
map <c-j> <ESC>:bn<CR>
map <c-k> <ESC>:bp<CR>
nmap <leader>bb :BufExplorerHorizontalSplit<cr>

"""""""""""""""""""""""""""""""""""""""
""" NERDTree
"""""""""""""""""""""""""""""""""""""""
nmap <c-a> :NERDTreeToggle<cr>
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeIgnore = ['\.vim$', '\~$']
let g:NERDTreeBookmarksFile = $HOME . '/.NERDTreeBookmarks'
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI=0
autocmd bufenter *
  \ if (winnr("$") == 1 &&
  \ exists("b:NERDTreeType") &&
  \ b:NERDTreeType == "primary") | q | endif

"""""""""""""""""""""""""""""""""""""""
""" FZF
"""
""" Credit:
""" https://github.com/zenbro/dotfiles/blob/master/.nvimrc
"""""""""""""""""""""""""""""""""""""""
map <c-l> :Buffers<cr>
nmap <leader>ff :GitFiles<cr>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
" search in current dir
nnoremap <silent> <leader>. :AgIn
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>
imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)
nnoremap <silent> KK :call SearchWordWithAg()<CR>

function! SearchWordWithAg()
  execute 'AgGitRoot ' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
endfunction

" Ag search in current dir
function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1},
                \ g:fzf#vim#default_layout))
endfunction
command! -nargs=+ -complete=dir AgIn
            \ call SearchWithAgInDirectory(<f-args>)

" Ag search in git root
function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction
command! -nargs=* AgGitRoot
            \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(),
            \ g:fzf#vim#default_layout))
"""""""""""""""""""""""""""""""""""""""
""" ctrl-p/ctrlp
"""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_root_markers = ['pom.xml',
            \ 'Makefile',
            \ 'package.json']
"let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_mruf_exclude = '/tmp/.*\|/var/tmp/.*|COMMIT_EDITMSG'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn|CVS|node_modules|vendor)$',
      \ 'file': '\v\.(exe|so|dll|jar|pdf|doc|pyc|class|jpg|png|gif)$',
      \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
      \ }
let g:ctrlp_use_caching = 1
let g:cachedir=$HOME . "/.ctrlp_cache"
if !isdirectory(expand(cachedir))
  call mkdir(expand(cachedir))
endif
let g:ctrlp_cache_dir = cachedir

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --vimgrep\ --nogroup\ --nocolor
  "set grepprg=ag\ --vimgrep\ $*

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
"t - in a new tab.
"h - in a new horizontal split.
"v - in a new vertical split.
"r - in the current window.
let g:ctrlp_open_new_file = 'r'

"""""""""""""""""""""""""""""""""""""""
""" lightline
"""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

"""""""""""""""""""""""""""""""""""""""
""" vim-airline
"""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
"let g:airline_theme='jellybeans'
let g:airline_theme='papercolor'
let g:Powerline_symbols = 'fancy'
""" Number of colors
set fillchars+=stl:\ ,stlnc:\

" let g:airline_section_b => (hunks, branch)
"let g:airline_section_b = '%{getcwd()}'
let g:airline_section_b = "%{fnamemodify(getcwd(), ':t')}"
let g:airline_section_error = ""
let g:airline_section_warning = ""

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'


"""""""""""""""""""""""""""""""""""""""
""" YouCompleteMe
"""""""""""""""""""""""""""""""""""""""
" make YCM compatible with UltiSnips
let g:ycm_filetype_blacklist = {
  \ 'sql': 1,
  \ 'json': 1,
  \ 'tags': 1,
  \ 'tagbar' : 1,
  \ 'qf' : 1,
  \ 'notes' : 1,
  \ 'markdown' : 1,
  \ 'unite' : 1,
  \ 'text' : 1,
  \ 'vimwiki' : 1,
  \ 'pandoc' : 1,
  \ 'infolog' : 1,
  \ 'mail' : 1
  \}

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
      \             're!\[.*\]\s'],
      \   'ocaml' : ['.', '#'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::'],
      \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
      \   'ruby' : ['.', '::'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \ }

"""""""""""""""""""""""""""""""""""""""
""" SuperTab
"""""""""""""""""""""""""""""""""""""""
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = '<C-n>'

"""""""""""""""""""""""""""""""""""""""
""" UltiSnips
"""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger = "<c-space>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$HOME . '/Dropbox/etc/vim/ultisnips/'
nnoremap <leader>ue :UltiSnipsEdit<cr>

"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""

function! FindConfig(prefix, what, where)
    let cfg = findfile(a:what, escape(a:where, ' ') . ';')
    return cfg !=# '' ? ' ' . a:prefix . ' ' . shellescape(cfg) : ''
endfunction

let g:ale_sign_column_always = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0

autocmd FileType javascript let g:ale_jshint_config_loc =
      \ FindConfig('-c', '.jshintrc', expand('<afile>:p:h', 1))

let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_set_loclist = 1

" Ale linters settings
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'sh': ['shellcheck'],
  \ 'php': ['phpcs'],
\}

let g:ale_php_phpcs_standard = $HOME . '/src/src/moodle/local/codechecker'
"let g:ale_php_phpcs_standard = 'PSR2'
let g:ale_javascript_eslint_executable = ''
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
""" vimwiki
"""""""""""""""""""""""""""""""""""""""
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_use_mouse = 1
let g:vimwiki_CJK_length = 1
let g:mainwiki = {
      \ 'auto_export':      0,
      \ 'custom_wiki2html': '~/Dropbox/src/php/phpvimwiki/main.php',
      \ 'path':             '~/Dropbox/mysite/contents/wiki/',
      \ 'path_html':        '~/Dropbox/mysite/output/wiki/',
      \ 'template_path':    '~/Dropbox/mysite/contents/wiki/templates',
      \ 'template_default': 'default',
      \ 'template_ext':     '.tpl',
      \ 'syntax':           'markdown',
      \ 'ext':              '.md',
      \ 'css_name':         'wikistyle.css',
      \ 'list_margin':      0,
      \ 'diary_rel_path':   'diary/',
      \ }
let g:vimwiki_list = [mainwiki]
":map <leader>ww <Nop>
":map <leader>wt <Nop>
map <Leader>wwi <Plug>VimwikiDiaryIndex

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
""" Rainbow parentheses
"""""""""""""""""""""""""""""""""""""""
let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgray',    'DarkOrchid3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['gray',        'RoyalBlue3'],
      \ ['black',       'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ['red',         'firebrick3'],
      \ ]

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
let g:EditorConfig_core_mode = 'python_external'

"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
"""""""""""""""""""""""""""""""""""""""
let g:lexical#spell = 1
let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',]
let g:lexical#dictionary = ['/usr/share/dict/words',]
" vim spellfile must end with .{encoding}.add
"set spellfile=~/Dropbox/etc/user.dict.utf-8.add
let g:lexical#spellfile = ['~/.vim/spell/en.utf-8.add',]
let g:lexical#spelllang = ['en_us','en_au',]
let g:lexical#thesaurus_key = '<leader>tt'
let g:lexical#spell_key = '<leader>ss'
let g:lexical#dictionary_key = '<leader>dd'

"""""""""""""""""""""""""""""""""""""""
""" ludovicchabant/vim-gutentags
"""""""""""""""""""""""""""""""""""""""
let g:gutentags_ctags_executable_javascript = 'jsctags'
let g:gutentags_project_root = ['.git', '.hg', '.bzr', '_darcs',
      \ '_darcs', '_FOSSIL_', '.fslckout', '.jscsrc']

"""""""""""""""""""""""""""""""""""""""
""" flowtype
"""""""""""""""""""""""""""""""""""""""
let g:flow#enable = 1

"""""""""""""""""""""""""""""""""""""""
""" nerdcommenter
"""""""""""""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" c-_ is c-/
map <c-_> <plug>NERDCommenterToggle

"""""""""""""""""""""""""""""""""""""""
""" gitgutter
"""""""""""""""""""""""""""""""""""""""
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk
