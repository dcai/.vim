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

"""""""""""""""""""""""""""""""""""""""
""" Encoding and Decoding
""" This is be at the beginning of the
""" file.
"""""""""""""""""""""""""""""""""""""""
set fileformats=unix,dos
set fileencodings=utf-8,gbk,big5,latin1
set encoding=utf-8
if has ('multi_byte') && v:version > 601
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
  endif
endif

" this enables filetype specific plugin and indent files
" must enable this
" run :filetype see status
filetype plugin indent on
" https://stackoverflow.com/a/26898986/69938
let g:netrw_home=$XDG_CACHE_HOME.'/vim'

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

function! s:mkdir_p(dirname)
  if !isdirectory(a:dirname)
    call mkdir(a:dirname, "p")
  endif
  return a:dirname
endfunction

set updatetime=250
set viminfo='500
if &history < 1000
  set history=1000
endif
set autoread
set spelllang=en
set mouse=a
set noerrorbells
set visualbell
set showcmd
" set cursorline
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

" set number
" set relativenumber
set nonumber
set showmatch

"""""""""""""""""""""""""""""""""""""""
""" wrap
"""""""""""""""""""""""""""""""""""""""
set wrap
" set nowrap
set colorcolumn=120
" http://blog.ezyang.com/2010/03/vim-textwidth/
" Maximum width of text that is being inserted
" set textwidth=100
set formatoptions=cqt
set wrapmargin=0
set linebreak
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
""" backup & undo
"""""""""""""""""""""""""""""""""""""""
" set backupdir=s:mkdir_p(expand("~/.vim-backup"))
set nobackup

" Persistent undo
set undofile " Create FILE.un~ files for persistent undo
set undodir=s:mkdir_p(expand('~/.vim-undo'))

set noswapfile
set switchbuf=usetab
set nowritebackup

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
" Keep in current dir
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" or
" Vim tip #64
" http://vim.wikia.com/wiki/VimTip64
"""""""""""""""""""""""""""""""""""""""
set autochdir
" function! CHANGE_CURR_DIR()
  " let _dir = expand("%:p:h")
  " exec "cd " . _dir  . ""
  " unlet _dir
" endfunction
" autocmd BufEnter * call CHANGE_CURR_DIR()
" autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
" autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

function! SoftWrap()
  let s:old_tw = &textwidth
  set tw=999999
  normal gggqG
  let &tw = s:old_tw
endfunction

"""""""""""""""""""""""""""""""""""""""
""" Visual Search
"""""""""""""""""""""""""""""""""""""""
" This has been replaced by `thinca/VisualSelection` plugin
" function! VisualSearch(direction) range
  " " From an idea by Michael Naumann
  " let l:saved_reg = @"
  " :echo 'test'
  " execute "normal! vgvy"
  " let l:pattern = escape(@", '\\/.*$^~[]')
  " let l:pattern = substitute(l:pattern, "\n$", "", "")
  " if a:direction == 'b'
    " execute "normal ?" . l:pattern . "^M"
  " else
    " execute "normal /" . l:pattern . "^M"
  " endif
  " let @/ = l:pattern
  " let @" = l:saved_reg
" endfunction

"" Press * or # to search
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
" not go into Ex mode
" or use unmap
map q: <nop>
nnoremap Q <nop>

" Use Q for formatting the current paragraph (or visual selection)
" vnoremap Q gq
" nnoremap Q gqap

" Format Jump
nnoremap <silent> g; g;zz nnoremap <silent> g, g,zz

" Keep search matches in the middle of the window.
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
" https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim#L511
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

" press jj in insert mode twice to return normal mode
inoremap jj <ESC>

" format entire buffer
" credit: http://vim.wikia.com/wiki/Fix_indentation
" Explain:
" mz: mark current location to `z`
" gg: go to file top
" =: format
" G: to the end of file
" `z: jump back to mark `z`
"
" gg=G would reformat the whole file but lose current location
map <F7> mzgg=G`z

" Press <Home> or <End> to the 1st and last
" char of the line
map  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
map  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vmap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
imap <Home> <C-o><Home>
imap <End>  <C-o><End>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null
nmap j gj
nmap k gk
nmap <Down> gj
nmap <Up> gk

vmap j gj
vmap k gk
vmap <Down> gj
vmap <Up> gk
" Press Ctrl-O switches to normal mode for one command
" http://vim.wikia.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
imap <Down> <C-o>gj
imap <Up> <C-o>gk

" toggle most recently used file
" ctrl-6 doesn't work for some terms
map <c-o> :e #<cr>

"""""""""""""""""""""""""
" Spacemacs like mappings
"""""""""""""""""""""""""
nnoremap <leader>wv :vs<cr>
nnoremap <leader>ws :sp<cr>
" Close window
nnoremap <leader>wd :close<cr>
nnoremap <leader>fs :w!<cr>
nnoremap <leader>fed :e! $HOME/.vim/local.vim<cr>
nnoremap <leader>feR :source $HOME/.vim/vimrc<cr>
nnoremap <leader>qq :qall<cr>
" kill hlsearch until next time
nnoremap <Leader>sc :nohlsearch<CR>
nmap <leader>tp :tabp<CR>
" copy current file path to clipboard
nmap <leader>cp :let @+ = expand("%:p")<CR>
vmap <leader>tn :tabn<CR>
