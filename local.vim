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

" Fold stuff {{{
set foldmethod=marker
set nofoldenable
" }}}

" Encoding and Decoding {{{ 1
set fileformats=unix,dos
set fileencodings=utf-8,gbk,big5,latin1
set encoding=utf-8
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
" }}}

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,
      \.bbl,.blg,.brf,.cb,.ind,.idx,
      \.ilg,.inx,.out,.toc,.class,.pyc

set wildignore+=node_modules
" http://vim.wikia.com/wiki/Single_tags_file_for_a_source_tree
set tags=tags;
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
" always show status line
set laststatus=2
" set number
" set relativenumber
set nonumber
set showmatch
set switchbuf=usetab


" Search Setting {{{
set ignorecase
set hlsearch
set incsearch
set grepformat=%f:%l:%c:%m
" }}}

" backup, undo & caches {{{1
set noswapfile
set nowritebackup
function! s:mkdir_p(dirname)
  if !isdirectory(a:dirname)
    call mkdir(a:dirname, "p")
  endif
  return a:dirname
endfunction

" https://stackoverflow.com/a/26898986/69938
let g:netrw_home=$XDG_CACHE_HOME.'/vim'

" backup {{{2
" let s:backupdir=s:mkdir_p(expand("~/.vim/backup"))
" set backupdir=s:backupdir
set nobackup
" }}}

" Persistent undo {{{2
set undofile " Create FILE.un~ files for persistent undo
let s:undodir=s:mkdir_p(expand('~/.vim/undo'))
set undodir=s:undodir
" }}}
" }}}

" default indent & wrapping settings {{{
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set smartindent
set wrap
" set colorcolumn=80
" http://blog.ezyang.com/2010/03/vim-textwidth/
" Maximum width of text that is being inserted
" set textwidth=100
set formatoptions=cqt
set wrapmargin=0
set linebreak

function! SoftWrap()
  let s:old_tw = &textwidth
  set tw=999999
  normal gggqG
  let &tw = s:old_tw
endfunction

" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s\+$//e
  %s/[ \t\r]\+$//e
endfunction
" }}}

" Keep in current dir {{{
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
" }}}

" Visual Search {{{
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
" }}}

" key mappings {{{1
"set timeout
"set ttimeoutlen=2000
" leader {{{2
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"
" }}}

" no ex mode {{{2
" not go into Ex mode
" or use unmap
map q: <nop>
nnoremap Q <nop>
nmap Q  <silent>
nmap q: <silent>
nmap K  <silent>
" }}}

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

" press jj or jk in insert mode twice to return normal mode
inoremap jk <ESC>
inoremap jj <Esc>

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
noremap <F7> mzgg=G`z

" Press <Home> or <End> to the 1st and last
" char of the line
noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
noremap  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vnoremap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
inoremap <Home> <C-o><Home>
inoremap <End>  <C-o><End>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

vnoremap j gj
vnoremap k gk
vnoremap <Down> gj
vnoremap <Up> gk
" Press Ctrl-O switches to normal mode for one command
" http://vim.wikia.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" toggle most recently used file
" ctrl-6 doesn't work for some terms
noremap <c-o> :e #<cr>

" Spacemacs like mappings {{{2
nnoremap <leader>wv :vs<cr>
nnoremap <leader>ws :sp<cr>
" Close window
nnoremap <leader>wd :close<cr>
nnoremap <leader>fs :w!<cr>
nnoremap <leader>fed :vsplit $HOME/.vim/local.vim<cr>
nnoremap <leader>feR :source $HOME/.vim/vimrc<cr>
nnoremap <leader>qq :qall<cr>
nnoremap <leader>cp :let @+ = expand("%:p")<CR>
" kill hlsearch until next time
nnoremap <Leader>sc :nohlsearch<CR>
" copy current file path to clipboard
nnoremap <leader>tp :tabp<CR>
vnoremap <leader>tn :tabn<CR>
" }}}
" }}}
