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
" http://www.figlet.org/fonts/slant.flf

" Fold stuff {{{
set foldmethod=marker
set nofoldenable
" }}}

" Encoding and Decoding {{{ 1
set fileformats=unix,dos
set fileencodings=utf-8,gbk,big5,latin1
set encoding=utf-8
" if has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif

set signcolumn=auto

if has('multi_byte')
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
set synmaxcol=300
set tags=tags;
set updatetime=100
set viminfo='500
if &history < 1000
  set history=1000
endif
set autoread
set mouse=a
set noerrorbells
set visualbell
set showcmd
" set cursorline
set hidden
" Avoid hit ENTER to continue normal
set shortmess+=a
set virtualedit=all
"more powerful backspacing
set backspace=indent,eol,start
" always show status line
set laststatus=2
set number
" set nonumber
set showmatch
set switchbuf=usetab

" Search Setting {{{
set ignorecase
set hlsearch
set incsearch
set grepformat=%f:%l:%c:%m
" }}}

set noswapfile
set nowritebackup
function! s:mkdir_p(dirname)
  let l:path = expand(a:dirname)
  if !isdirectory(l:path)
    call mkdir(l:path, 'p')
  endif
  return l:path
endfunction

" https://stackoverflow.com/a/26898986/69938
if !empty($XDG_CACHE_HOME)
  let g:netrw_home=s:mkdir_p($XDG_CACHE_HOME.'/vim')
endif
let &backupdir=s:mkdir_p("~/.local/vim/backup")
set undofile " enable persistent undo
let &undodir=s:mkdir_p('~/.local/vim/undo')

" default indent & wrapping settings {{{
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set smartindent
set wrap
" http://blog.ezyang.com/2010/03/vim-textwidth/
" Maximum width of text that is being inserted
" set textwidth=100
set formatoptions=cqt
set wrapmargin=0
set linebreak

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

function! SoftWrap()
  let s:old_tw = &textwidth
  set textwidth=999999
  normal gggqG
  let &textwidth = s:old_tw
endfunction

" Removes trailing spaces
function! TrimWhiteSpace()
  %s/\s\+$//e
  %s/[ \t\r]\+$//e
endfunction
" }}}

" Keep in current dir {{{
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
"""""""""""""""""""""""""""""""""""""""
" switch to current dir
function! ChangeCurrentDirectory()
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')

  if isdirectory(l:dir)
    exec 'cd ' . l:dir
  endif

  let g:ale_fix_on_save = 1
  if l:dir =~ 'wow'
    " disable auto fix for woolworths projects
    let g:ale_fix_on_save = 0
  endif
  if l:dir =~ 'iag'
    " disable auto fix for iag projects
    let g:ale_fix_on_save = 0
  endif

  if match(l:file, 'html\|twig\|jinja2') > -1
    " disable auto fix for html
    let g:ale_fix_on_save = 0
  endif

  if match(l:file, 'mdk') > -1
    " disable auto fix for html
    let g:ale_fix_on_save = 0
  endif

  if match(l:file, 'php\|phps') > -1
    " disable auto fix for php
    let g:ale_fix_on_save = 0
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

augroup onEnterBuffer
  autocmd!
  autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
  autocmd BufEnter * call ChangeCurrentDirectory()
augroup END
" }}}

" Visual Search
function! VisualSearch(direction) range
  " From an idea by Michael Naumann
  let l:saved_reg = @"
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
" press * or # to search in visual mode
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

""""""""""""""""""""""""""""""""""""""""
"""  key mappings
""""""""""""""""""""""""""""""""""""""""
" set timeout

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null

noremap <F15> <nop>
noremap! <F15> <nop>
noremap <F16> <nop>
noremap! <F16> <nop>

" Avoid ex mode
map q: <nop>
map q\ <nop>
map q? <nop>
nmap q: <nop>

" close everything
nmap <silent> Q :ccl<cr>:lcl<cr>:pcl<cr>:helpclose<cr>

" Keep search matches in the middle of the window.
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
" https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim#L511
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

" press jj to escape
inoremap jj <Esc>

" Format entire buffer
" credit: http://vim.wikia.com/wiki/Fix_indentation
" how this works:
"   mz: mark current location to `z`
"   gg: go to file top
"   =: format
"   G: to the end of file
"   `z: jump back to mark `z`
"   gg=G would reformat the whole file but lose current location
nnoremap = mzgg=G`z

nnoremap T :Vexplore<cr>

" open new file
nnoremap gf :e <cfile><CR>

map <c-j> <ESC>:bn<CR>
map <c-k> <ESC>:bp<CR>

" Press <Home> or <End> to the 1st and last
" char of the line
noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
noremap  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vnoremap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
inoremap <Home> <C-o><Home>
inoremap <End>  <C-o><End>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk

vnoremap <silent> j gj
vnoremap <silent> k gk
vnoremap <silent> <Down> gj
vnoremap <silent> <Up> gk
" Press Ctrl-O switches to normal mode for one command
" http://vim.wikia.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" toggle most recently used file
" ctrl-6 <c-6> doesn't work for some terminals
" noremap <c-x> :e #<cr>

nnoremap <leader>ev :vsplit $HOME/.vim/local.vim<cr>
nnoremap <leader>sv :source $HOME/.vim/vimrc<cr>
nnoremap <leader>qq :qall<cr>
" This unsets the 'last search pattern' register by hitting return
nnoremap <silent> <CR> :noh<CR><CR>

" Convert slashes to backslashes for Windows.
if g:osuname ==? 'Windows'
  nmap <leader>cp :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap <leader>cf :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  " nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  " copy to vim default register
  nnoremap <leader>cp :let @"=expand("%:p")<CR>
  nnoremap <leader>cf :let @"=expand("%")<CR>
  " copy to clipboard
  " nnoremap <leader>cf :let @*=expand("%")<CR>
  " nnoremap <leader>cp :let @*=expand("%:p")<CR>
  " nnoremap <leader>cf :let @+=expand("%")<CR>
  " nnoremap <leader>cp :let @+=expand("%:p")<CR>
endif
