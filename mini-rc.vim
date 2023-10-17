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
" bare minimal vimrc
"
" URL: https://gist.github.com/dcai/cd2b8102218eb8381e6a1aacc80a0cb0
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
" set cursorline
set hidden
" Avoid hit ENTER to continue normal
set shortmess+=a
"set ve[rsion]
set ve=all
"more powerful backspacing
set backspace=indent,eol,start
set nofoldenable
" always show status line
set laststatus=2

" set number
" set relativenumber
set nonumber
set showmatch

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
function! CHANGE_CURR_DIR()
  let _dir = expand("%:p:h")
  exec "cd " . _dir  . ""
  unlet _dir
endfunction
autocmd BufEnter * call CHANGE_CURR_DIR()
autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

"""""""""""""""""""""""""""""""""""""""
""" Visual Search
"""""""""""""""""""""""""""""""""""""""
function! VisualSearch(direction) range
  " From an idea by Michael Naumann
  let l:saved_reg = @"
  :echo 'test'
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Press * or # to search
map <silent> * :call VisualSearch('f')<CR>
map <silent> # :call VisualSearch('b')<CR>

"""""""""""""""""""""""""""""""""""""""
""" status line
"""""""""""""""""""""""""""""""""""""""
set statusline=%f                               " tail of the filename
set statusline+=%m                              " modified flag
set statusline+=%=                              " left/right separator
set statusline+=%y                              " filetype
set statusline+=[
set statusline+=%{strlen(&fileencoding)?&fileencoding:'none'}\| " file encoding
set statusline+=%{&fileformat}                  " file format
set statusline+=%{&bomb?'\|BOM':''}             " BOM
set statusline+=]
set statusline+=[
set statusline+=%l                              " cursor line/total lines
set statusline+=\/%L                            " total lines
" set statusline+=\ %P                            " percent through file
" set statusline+=\|%c                            " cursor column
set statusline+=]
set statusline+=%h                              " help file flag
set statusline+=%r                              " read only flag

"""""""""""""""""""""""""""""""""""""""
""" vim-plug
"""""""""""""""""""""""""""""""""""""""
let s:plugged='$HOME/.local/mini-vim/plug'
let s:autoload='$HOME/.vim/autoload'
let s:vimplug=s:autoload . '/plug.vim'
let g:plug_shallow=3
" Install vim-plug if we don't already have it
if empty(glob(expand(s:vimplug)))
  " Ensure all needed directories exist  (Thanks @kapadiamush)
  execute '!mkdir -p ' . expand(s:plugged)
  execute '!mkdir -p ' . expand(s:autoload)
  " Download the actual plugin manager
  execute '!curl -fLo ' . s:vimplug . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(expand(s:plugged))
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_preview_window = []
let g:fzf_buffers_jump = 1
let g:fzf_command_prefix = 'Fzf'
nnoremap <silent> <leader>ff :FzfGFiles<cr>
nnoremap <silent> <leader>fr :FzfHistory<CR>
call plug#end()

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

nnoremap <leader>ev :e! $HOME/.vim/vimrc<cr>
nnoremap <leader>rc :source $HOME/.vim/vimrc<cr>
nnoremap <leader>rr :source %<cr>
" BD is vim-bufkill plugin command
nnoremap <leader>bd :bd!<cr>
nnoremap <leader>qq :qall<cr>
nnoremap <leader>wq :silent wq<cr>
nnoremap <leader>qw :silent wq<cr>
nnoremap <silent> <leader>ww :w<CR><CR>
" enter to clear search highlight
nnoremap <silent> <CR> :noh<CR><CR>
" sudo write
cnoremap w!! w !sudo tee % >/dev/null
