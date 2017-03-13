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

set updatetime=250
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
" always show status line
set laststatus=2

" show linenumber
" set number
" set relativenumber
set nonumber

" source $VIMRUNTIME/ftplugin/man.vim
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

nmap <leader>tp :tabp<CR>
vmap <leader>tn :tabn<CR>
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
let g:UltiSnipsExpandTrigger = "<c-space>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
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
let g:EditorConfig_core_mode = 'python_external'

"""""""""""""""""""""""""""""""""""""""
""" ludovicchabant/vim-gutentags
"""""""""""""""""""""""""""""""""""""""
let g:gutentags_ctags_executable_javascript = 'jsctags'
let g:gutentags_project_root = ['.git', '.hg', '.bzr', '_darcs',
      \ '_darcs', '_FOSSIL_', '.fslckout', '.jscsrc']

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
