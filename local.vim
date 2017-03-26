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
""" backup & undo
"""""""""""""""""""""""""""""""""""""""
" let g:backupdir="~/.vim-backup"
" if !isdirectory(expand(backupdir))
  " call mkdir(expand(backupdir))
" endif
" set backupdir=backupdir
set nobackup

" Persistent undo
let undodir = expand('~/.vim-undo')
if !isdirectory(undodir)
  call mkdir(undodir)
endif
set undodir=undodir
set undofile " Create FILE.un~ files for persistent undo

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
" This has been replaced by
" `thinca/VisualSelection` plugin
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

nmap <leader>tp :tabp<CR>
vmap <leader>tn :tabn<CR>

"""""""""""""""""""""""""
" Spacemacs like mappings
"""""""""""""""""""""""""
nnoremap <leader>wv :vs<cr>
nnoremap <leader>ws :sp<cr>
" Close window
nnoremap <leader>wd :close<cr>
nnoremap <leader>ft :NERDTreeCWD<cr>
nnoremap <leader>fs :w!<cr>
nnoremap <leader>fed :e! $HOME/.vim/local.vim<cr>
nnoremap <leader>feR :source $HOME/.vim/vimrc<cr>
" BD is vim-bufkill plugin command
nnoremap <leader>bd :BD<cr>
nnoremap <leader>qq :qall<cr>
" kill hlsearch until next time
nnoremap <Leader>sc :nohlsearch<CR>
