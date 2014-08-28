"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"         __   __   ____
"        /    |  \ |___
"        \__  |__/ ____|
"
" Author:   Dongsheng Cai
" Version:  1.0
" Modified: 29/08/2014
" Changelog:
"           06/03/2013 vundle
"           04/04/2013 gui_qt
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" sometimes vim confused with shell
"set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh
filetype off
set rtp+=~/.vim/bundle/vundle/
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

call vundle#begin()
"Plugin 'jceb/vim-orgmode'
Plugin 'dag/vim-fish'
Plugin 'gmarik/vundle'
Plugin 'vimwiki/vimwiki'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'scrooloose/nerdcommenter'
Plugin 'matchit.zip'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'majutsushi/tagbar'
" also known as ZenCoding
"Plugin 'mattn/emmet-vim'
Plugin 'nginx.vim'
Plugin 'Python-Syntax'
Plugin 'wlangstroth/vim-racket'
" With php 5.6
Plugin 'StanAngeloff/php.vim'
" Color
Plugin 'Solarized'
"Plugin 'rking/ag.vim'
"Plugin 'rails.vim'
" Syntax
Plugin 'derekwyatt/vim-scala'
"Plugin 'Textile-for-VIM'
call vundle#end()

filetype on

""""""""""""""""""""""""""""""
" core setting
""""""""""""""""""""""""""""""
if exists("syntax_on")
    syntax reset
else
    syntax on 
endif
filetype plugin indent on
set history=10
set autoread
set spelllang=en
set nowb
set mouse=a
set noerrorbells
set novisualbell
set showcmd
" Avoid hit ENTER to continue
set shortmess=a
"set t_vb
set ve=all
set backspace=indent,eol,start  " more powerful backspacing
set nofoldenable 
set cryptmethod=blowfish

let g:OS=substitute(system('uname'), "\n", "", "")
let g:USER=substitute(system('whoami'), "\n", "", "")
let g:ISGUI=has('gui_running')

if OS == 'Linux'
    let list=["/home/", $USER, "/"]
elseif OS == 'FreeBSD'
    let list=["/home/", $USER, "/"]
elseif OS == "Darwin"
    let list=["/Users/", $USER, "/"]
endif

let g:HOME=join(list, "")
""""""""""""""""""""""""""""""
" PHP Settings
""""""""""""""""""""""""""""""
"set efm=%EError\ %n,%Cline\ %l,%Ccolumn\ %c,%Z%m
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l
""""""""""""""""""""""""""""""
" wrap
""""""""""""""""""""""""""""""
set wrap
set textwidth=0
set linebreak
" note trailing space at end of next line
"set showbreak=>\ \ \

""""""""""""""""""""""""""""""
" Search Setting
""""""""""""""""""""""""""""""
set ignorecase
"set noic
set hls
set incsearch
""""""""""""""""""""""""""""""
" backup
""""""""""""""""""""""""""""""
let g:backupdir="~/.vim_backups"
if !isdirectory(expand(backupdir))
  call mkdir(expand(backupdir))
endif
set backupdir=backupdir

set nobackup
"set directory=~/.vim_backups/,.
set noswapfile
set switchbuf=usetab
""""""""""""""""""""""""""""""
" UI Setting
""""""""""""""""""""""""""""""
set number
"Disable toolbar, go = guioptions
set guioptions=ar
"remove menu
set guioptions-=m
"remove toolbar
set guioptions-=T
""""""""""""""""""""""""""""""
" Enable status bar
" if vim version >= 7, the style of bar will be
" changed
"""""""""""""""""""""""""""""""
set laststatus=2
if version >= 700
    au InsertEnter * hi StatusLine guibg=#818D29 guifg=#FCFCFC gui=none
    au InsertLeave * hi StatusLine guibg=#EEEEEE guifg=#363636 gui=none
endif
set statusline=%<%F\ [%Y]\ [%{&ff}]\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",\ BOM\":\",\ NOBOM\")}]\ %-14.(%l,%c%V%)\ %P

""""""""""""""""""""""""""""""
" Encoding and Decoding
""""""""""""""""""""""""""""""
set fileformat=unix
set fileencodings=utf-8,gbk,big5,latin1
if !ISGUI
    set termencoding=utf-8
endif
set enc=utf-8
set langmenu=zh_CN.utf8
if has ('multi_byte') && v:version > 601
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
  endif
endif

""""""""""""""""""""""""""""""
" Indent setting
""""""""""""""""""""""""""""""
set expandtab
set softtabstop=4
set shiftwidth=4 	 	 	
set smarttab
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
""""""""""""""""""""""""""""""
let python_highlight_all=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Inc_Winwidth=0
let g:explVertical=1
let g:explWinSize=35
let g:winManagerWidth=35
let g:winManagerLayout='FileExplorer,TagsExplorer|BufExplorer'
set tags=./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./*/tags

""""""""""""""""""""""""""""""
" Keep in curr dir
" Vim tip #64
""""""""""""""""""""""""""""""
function! CHANGE_CURR_DIR()
    let _dir = expand("%:p:h")
    exec "cd " . _dir  . ""
    unlet _dir
endfunction
"autocmd BufEnter * call CHANGE_CURR_DIR() 
"http://vim.wikia.com/wiki/VimTip64
autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /


function! SoftWrap()
    let s:old_tw = &textwidth
    set tw=999999
    normal gggqG
    let &tw = s:old_tw
endfunction

""""""""""""""""""""""""""""""
" Visual Search
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
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

" Basically you press * or # to search 
" for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Abbreviations 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:ab #b /**<CR><Space>*
:ab #e <Space>*/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Press <Home> or <End> to the 1st and last 
" char of the line
noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
noremap  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vnoremap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
imap <Home> <C-o><Home>
imap <End>  <C-o><End>

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" copy/paste from system clipboard
if OS == 'Linux'
    nmap <leader>c "+y
    vmap <leader>c "+y
    nmap <leader>p :set paste<CR>"+p :set nopaste<CR>
elseif OS == 'Darwin'
    set clipboard=unnamed
endif

map <leader>e :e! $HOME/.vim/vimrc<cr>
map <leader>s :source $HOME/.vim/vimrc<cr>

" see buffer list
map <c-l> :BufExplorer<cr>
map <leader>l :BufExplorer<cr>
" close buffer
map <leader>k :bd!<cr>
map <leader>t :TagbarToggle<cr>
map <leader>q :q<cr>
map <leader>w :w!<cr>
map <leader>fw :w !sudo tee > /dev/null %<cr>
map <leader>u :set fileencoding=utf8<cr>
map <c-j> <ESC>:bn<CR>
map <c-k> <ESC>:bp<CR>
map <leader>i <ESC>:r! cat<CR>

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk 

" source $VIMRUNTIME/mswin.vim
" make :Man command avaliable
" Default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"

" Common code for encodings, used by *.nfo files
function! SetFileEncodings(encodings)
    let b:myfileencodingsbak=&fileencodings
    let &fileencodings=a:encodings
endfunction

function! RestoreFileEncodings()
    let &fileencodings=b:myfileencodingsbak
    unlet b:myfileencodingsbak
endfunction

if ISGUI
     set background=dark
     "set background=light
     colorscheme solarized
    "colorscheme manuscript
    if or(has("gui_qt"), has('gui_gtk2'))
        "set guifont=Inconsolata\ 14
        "set guifont=DejaVu\ Sans\ Mono\ 12
        "set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
        set guifont=FantasqueSansMono\ 14
    else
        set guifont=Monaco:h14
    endif
else
    "set background=light
    "colorscheme slate
    "colorscheme solarized
    colorscheme desert
    "colorscheme zenburn
endif

"Tagbar
let g:tagbar_autofocus = 1

" ctrl-p
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|CVS)$',
    \ 'file': '\v\.(exe|so|dll|jar|pdf|doc|jpg|png|gif)$',
    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    \ }

" zen coding
let g:user_zen_settings = {
    \ 'php' : {
    \    'extends' : 'html',
    \    'filters' : 'c',
    \ },
    \ 'xml' : {
    \    'extends' : 'html',
    \ },
    \'haml' : {
    \    'extends' : 'html',
    \ },
    \    'extends' : 'html',
    \ }

" vimwiki
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_use_mouse = 1
let g:vimwiki_CJK_length = 1 
let g:wiki_1 = {
            \ 'auto_export':      0,
            \ 'custom_wiki2html': '~/Dropbox/src/php/phpvimwiki/main.php',
            \ 'path':             '~/Dropbox/mysite/contents/wiki',
            \ 'path_html':        '~/Dropbox/mysite_html/wiki',
            \ 'template_path':    '~/Dropbox/mysite/contents/wiki/templates',
            \ 'template_default': 'default',
            \ 'template_ext':     '.tpl',
            \ 'syntax':           'markdown',
            \ 'ext':              '.md',
            \ 'css_name':         'wikistyle.css',
            \ 'list_margin':      0,
            \ }
let g:vimwiki_list = [wiki_1]