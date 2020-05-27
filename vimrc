"""""""""""""""""""""""""""""""""""
"             __           _      "
"        ____/ /________ _(_)     "
"       / __  / ___/ __ `/ /      "
"      / /_/ / /__/ /_/ / /       "
"      \__,_/\___/\__,_/_/        "
"                                 "
" Owner: Dongsheng Cai <d@tux.im> "
"                                 "
"""""""""""""""""""""""""""""""""""

set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""
""" Vundle
""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'yegappan/mru'
Plugin 'tpope/vim-surround'
"Plugin 'bling/vim-airline'
" align texts
Plugin 'godlygeek/tabular'
Plugin 'maxbrunsfeld/vim-yankstack'
" jump around
Plugin 'Lokaltog/vim-easymotion'
Plugin 'vimwiki/vimwiki'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
Plugin 'matchit.zip'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'tyru/open-browser.vim'
Plugin 'thinca/vim-visualstar'

""" Snippets and complete
Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

"Plugin "MarcWeber/vim-addon-mw-utils"
"Plugin "tomtom/tlib_vim"

""" Aka ZenCoding
Plugin 'mattn/emmet-vim'
" close tags
Plugin 'Raimondi/delimitMate'

" Javascript
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'marijnh/tern_for_vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'moll/vim-node'
Plugin 'dcai/vim-react-es6-snippets'

""" PHP 5.6
"Plugin 'StanAngeloff/php.vim'
"Plugin 'shawncplus/phpcomplete.vim'
Plugin 'jwalton512/vim-blade'
Plugin 'evidens/vim-twig'

""" Ruby
"Plugin 'rking/ag.vim'
"Plugin 'rails.vim'

""" Other syntax
Plugin 'rodjek/vim-puppet'
Plugin 'hdima/python-syntax'
Plugin 'nginx.vim'
Plugin 'plasticboy/vim-markdown'
"Plugin 'jceb/vim-orgmode'
"Plugin 'dag/vim-fish'
"Plugin 'derekwyatt/vim-scala'

""" Color
Plugin 'Solarized'
Plugin 'chriskempson/base16-vim'


call vundle#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" End of Vundle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" core setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,
                \.ilg,.inx,.out,.toc

set tags=./tags,./../tags,./../../tags,./../../../tags,./*/tags
if exists("syntax_on")
    syntax reset
else
    syntax on 
endif

filetype plugin indent on
set history=10
set autoread
set spelllang=en
set mouse=a
set noerrorbells
set visualbell
set showcmd
" Avoid hit ENTER to continue
set shortmess=a
"set t_vb
set ve=all
set backspace=indent,eol,start  " more powerful backspacing
set nofoldenable 
"set cryptmethod=blowfish
"set omnifunc=syntaxcomplete#Complete

" source $VIMRUNTIME/mswin.vim
" make :Man command avaliable
" Default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"

let g:OS=substitute(system('uname'), "\n", "", "")
let g:ISGUI=has('gui_running')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" PHP Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set makeprg=php\ -l\ %
"set errorformat=%EError\ %n,%Cline\ %l,%Ccolumn\ %c,%Z%m
set errorformat=%m\ in\ %f\ on\ line\ %l

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" wrap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://blog.ezyang.com/2010/03/vim-textwidth/
set wrap
set linebreak
"set textwidth=80
set formatoptions=cqt
set wrapmargin=0 
" note trailing space at end of next line
"set showbreak=>\ \ \
set showbreak=↪

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Search Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set hlsearch
set incsearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" backup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" UI Setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
"Disable toolbar, go = guioptions
set guioptions=ar
"remove menu
set guioptions-=m
"remove toolbar
set guioptions-=T

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Encoding and Decoding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fileformat=unix
set fileencodings=utf-8,gbk,big5,latin1
if !ISGUI
    "set term=xterm-256color
    set termencoding=utf-8
    """ input method
    "set imactivatekey=C-space
    "inoremap <ESC> <ESC>:set iminsert=0<CR>
endif
"set enc=utf-8
set langmenu=zh_CN.utf8
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
endfunction

nmap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Indent setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set softtabstop=4
set shiftwidth=4 	 	 	
set smarttab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Keep in curr dir
""" Vim tip #64
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CHANGE_CURR_DIR()
    let _dir = expand("%:p:h")
    exec "cd " . _dir  . ""
    unlet _dir
endfunction
"autocmd BufEnter * call CHANGE_CURR_DIR() 
" http://vim.wikia.com/wiki/VimTip64
autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

function! SoftWrap()
    let s:old_tw = &textwidth
    set tw=999999
    normal gggqG
    let &tw = s:old_tw
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Visual Search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Abbreviations 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:ab #b /**<CR><Space>*
:ab #e <Space>*/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if ISGUI
    "set background=light
    "set background=dark
    "colorscheme solarized
    colorscheme base16-ocean
    if or(has("gui_qt"), has('gui_gtk2'))
        "set guifont=Inconsolata\ 14
        "set guifont=DejaVu\ Sans\ Mono\ 12
        "set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
        set guifont=FantasqueSansMono\ 14
    else
        "set guifont=monofur\ for\ Powerline:h20 
        set guifont=Monaco:h14
        "set guifont=Liberation\ Mono\ for\ Powerline:h16 
        "set guifont=Source\ Code\ Pro\ for\ Powerline:h18 
        "set guifont=Anonymous\ Pro\ for\ Powerline:h18 
    endif
else
    "colorscheme slate
    colorscheme desert
    "colorscheme elflord
    "colorscheme zenburn
    "set background=light
    "set background=dark
    "colorscheme solarized
    "colorscheme base16-default
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Enable status bar
""" if vim version >= 7, the style of bar will be
""" changed
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
"set statusline=%<%F\ [%Y]\ [%{&ff}]\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",\ BOM\":\",\ NOBOM\")}]\ %-14.(%l,%c%V%)\ %P

hi statusline guibg=black ctermbg=black ctermfg=green guifg=green

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guifg=magenta ctermfg=magenta
  elseif a:mode == 'r'
    hi statusline guifg=Blue ctermfg=Blue
  else
    hi statusline ctermfg=green guifg=green
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guifg=green ctermfg=green

" default the statusline to green when entering Vim
hi statusline guibg=green
set statusline=%F        "tail of the filename
set statusline+=%m       "modified flag
set statusline+=%=       "left/right separator
set statusline+=%y       "filetype
set statusline+=[
set statusline+=%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}  "file format
set statusline+=,%{&bomb?'bom':'nobom'} " BOM
set statusline+=]
set statusline+=%h       "help file flag
set statusline+=%r       "read only flag
set statusline+=\ 
set statusline+=%l      "cursor line/total lines
set statusline+=\/%L      " total lines
set statusline+=,%c     "cursor column
set statusline+=\ %P     "percent through file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_autofocus = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" ctrl-p
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|CVS)$',
    \ 'file': '\v\.(exe|so|dll|jar|pdf|doc|jpg|png|gif)$',
    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
    \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" zen coding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" vim-airline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
if !ISGUI
    "let g:airline_powerline_fonts = 0
endif
let g:airline_theme='base16'
"let g:airline_theme='solarized'
let g:Powerline_symbols = 'fancy'
""" Number of colors
set t_Co=256
set fillchars+=stl:\ ,stlnc:\

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

" make YCM compatible with UltiSnips
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" UltiSnips
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger = "<c-space>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
"let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_php_checkers = ['php']
let g:syntastic_python_checkers = []
let g:syntastic_java_checkers = []
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_typescript_checkers = ['tslint']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" vimwiki
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" key mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" Press <Home> or <End> to the 1st and last 
" char of the line
map  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
map  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vmap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
imap <Home> <C-o><Home>
imap <End>  <C-o><End>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %

" copy/paste from system clipboard
if OS == 'Linux'
    nmap <leader>c "+y
    "nmap <leader>p :set paste<CR>"+p :set nopaste<CR>
    nmap <leader>p :r !xsel -p<CR>
    vmap <leader>c "+y
elseif OS == 'Darwin'
    set clipboard=unnamed
    nmap <leader>p :r !pbpaste<CR>
endif

vmap j gj
vmap k gk
vmap <Down> gj
vmap <Up> gk

imap <Down> <C-o>gj
imap <Up> <C-o>gk 
" not go into Ex mode
nmap Q <nop>
" kill hlsearch until next time
nmap <silent> <Leader>/ :nohlsearch<CR>
nmap <Down> gj
nmap <Up> gk

let g:smooth_scroll_duration=25
map <silent> <c-u> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 2)<CR>
map <silent> <c-d> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 2)<CR>
map <silent> <c-b> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
map <silent> <c-f> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>

map <silent> <PageUp> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
map <silent> <PageDown> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>

map <leader>e :e! $HOME/.vim/vimrc<cr>
map <leader>s :source $HOME/.vim/vimrc<cr>
map <leader>k :bd!<cr>
map <leader>q :q<cr>
map <leader>w :w!<cr>
map <leader>fw :w !sudo tee > /dev/null %<cr>
map <leader>u :set fileencoding=utf8<cr>
map <leader>i <ESC>:r! cat<CR>

map <leader>b :TagbarToggle<cr>
map <leader>t :NERDTreeToggle<cr>

" see buffer list
map <c-l> :BufExplorer<cr>
"map <c-j> <ESC>:bn<CR>
"map <c-k> <ESC>:bp<CR>
map Q gqip
map QQ gggqG

nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

map <Leader>wwi <Plug>VimwikiDiaryIndex
