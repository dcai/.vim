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
set nocompatible

filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""
"             Core setting
"
"""""""""""""""""""""""""""""""""""""""

" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,
      \.bbl,.blg,.brf,.cb,.ind,.idx,
      \.ilg,.inx,.out,.toc,.class,.pyc

set tags=./tags,./../tags,./../../tags,./../../../tags,./*/tags,
      \/Users/dcai/src/news-quickstart/www/wp/tags

if exists("syntax_on")
  syntax reset
else
  syntax on
endif

filetype plugin indent on
set history=100
set autoread
set spelllang=en
" vim spellfile must end with .{encoding}.add
"set spellfile=~/Dropbox/etc/user.dict.utf-8.add
set mouse=a
set noerrorbells
set visualbell
set showcmd
" Avoid hit ENTER to continue normal
set shortmess+=ac
"set ve[rsion]
set ve=all
"more powerful backspacing
set backspace=indent,eol,start
set nofoldenable
"set cryptmethod=blowfish

" source $VIMRUNTIME/mswin.vim
" make :Man command avaliable
" Default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"

let g:OSUNAME=substitute(system('uname'), "\n", "", "")
let g:GUI_RUNNING=has('gui_running')

"""""""""""""""""""""""""""""""""""""""
""" wrap
"""""""""""""""""""""""""""""""""""""""
" http://blog.ezyang.com/2010/03/vim-textwidth/
set wrap
set linebreak
"set textwidth=80
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

set grepprg=ag\ --vimgrep\ $*
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
if !GUI_RUNNING
  "set term=xterm-256color
  set termencoding=utf-8
  """ input method
  "set imactivatekey=C-space
  "inoremap <ESC> <ESC>:set iminsert=0<CR>
endif
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
endfunction

nmap <silent> <Leader>rts :call TrimWhiteSpace()<CR>
"""""""""""""""""""""""""""""""""""""""
""" Indent setting
"""""""""""""""""""""""""""""""""""""""
set expandtab
set softtabstop=4
set shiftwidth=4
set smarttab

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
""" Abbreviations
"""""""""""""""""""""""""""""""""""""""
:ab #b /**<CR><Space>*
:ab #e <Space>*/
"""""""""""""""""""""""""""""""""""""""
""" UI Setting
"""""""""""""""""""""""""""""""""""""""
set number
"Disable toolbar, go = guioptions
set guioptions=ar
"remove menu
set guioptions-=m
"remove toolbar
set guioptions-=T
"set background=light
set background=dark
if GUI_RUNNING
  set t_Co=256
  "colorscheme solarized
  "colorscheme base16-ocean
  "colorscheme base16-bright
  "colorscheme base16-pop
  "colorscheme base16-google
  "colorscheme base16-eighties
  colorscheme base16-chalk
  "colorscheme peaksea
  "colorscheme blue
  "colorscheme darkblue
  "colorscheme desert
  "colorscheme elflord
  "colorscheme evening
  "colorscheme koehler
  "colorscheme morning
  "colorscheme murphy
  "colorscheme pablo
  "colorscheme peachpuff
  "colorscheme ron
  "colorscheme slate
  "colorscheme torte
  if or(or(has("gui_qt"), has('gui_gtk2')), has('gui_gtk3'))
    "set guifont=Inconsolata\ 14
    "set guifont=DejaVu\ Sans\ Mono\ 12
    "set guifont=Bitstream\ Vera\ Sans\ Mono\ 14
    set guifont=FantasqueSansMono\ 14
    set guifont=Source\ Code\ Pro\ for\ Powerline\ Regular\ 14
  else
    "set guifont=Monaco:h14
    "set guifont=Hack:h14
    " Powerline fonts
    "set guifont=Anonymous\ Pro\ for\ Powerline:h16
    "set guifont=Cousine\ for\ Powerline:h16
    "set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14
    "set guifont=Droid\ Sans\ Mono\ Dotted\ for\ Powerline:h16
    "set guifont=Droid\ Sans\ Mono\ for\ Powerline:h16
    "set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h16
    "set guifont=Fira\ Mono\ for\ Powerline:h16
    "set guifont=Fira\ Mono\ Medium\ for\ Powerline:h16
    "set guifont=Inconsolata\ for\ Powerline:h14
    "set guifont=Inconsolata-dz\ for\ Powerline:h14
    "set guifont=Inconsolata-g\ for\ Powerline:h14
    "set guifont=Liberation\ Mono\ for\ Powerline:h16
    "set guifont=Meslo\ LG\ L\ DZ\ for\ Powerline:h14
    "set guifont=Meslo\ LG\ L\ for\ Powerline:h14
    "set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h14
    "set guifont=Meslo\ LG\ M\ for\ Powerline:h14
    "set guifont=Meslo\ LG\ S\ DZ\ for\ Powerline:h14
    "set guifont=Meslo\ LG\ S\ for\ Powerline:h14
    "set guifont=monofur\ for\ Powerline:h18
    "set guifont=Roboto\ Mono\ for\ Powerline:h16
    "set guifont=Roboto\ Mono\ Medium\ for\ Powerline:h14
    "set guifont=Roboto\ Mono\ Thin\ for\ Powerline:h15
    "set guifont=Roboto\ Mono\ Light\ for\ Powerline:h18
    "set guifont=Ubuntu\ Mono\ derivative\ Powerline:h16
    set guifont=Source\ Code\ Pro\ for\ Powerline:h16
  endif
else
  "colorscheme slate
  "colorscheme desert
  "colorscheme elflord
  "colorscheme solarized
  "colorscheme base16-default
  "colorscheme peaksea
endif

"""""""""""""""""""""""""""""""""""""""
""" Enable status bar
"""""""""""""""""""""""""""""""""""""""
set laststatus=2
"set statusline=%<%F\ [%Y]\ [%{&ff}]\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",\ BOM\":\",\ NOBOM\")}]\ %-14.(%l,%c%V%)\ %P

let g:defaultFgColor="black"
hi statusline guibg=green guifg=black ctermbg=green ctermfg=black

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    "hi statusline guifg=magenta ctermfg=magenta
    hi statusline guibg=red guifg=white ctermbg=red ctermfg=white
  elseif a:mode == 'r'
    hi statusline guifg=Blue ctermfg=Blue
  else
    hi statusline ctermfg=black guifg=black
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green guifg=black ctermbg=green ctermfg=black

" default the statusline to green when entering Vim
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
set statusline+=[
set statusline+=%l      "cursor line/total lines
set statusline+=\/%L      " total lines
set statusline+=,%c     "cursor column
set statusline+=]
set statusline+=\ %P     "percent through file

"""""""""""""""""""""""""""""""""""""""
""" key mappings
"""""""""""""""""""""""""""""""""""""""
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" unmap
"unmap q:

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
if OSUNAME == 'Linux'
  nmap <leader>c "+y
  "nmap <leader>p :set paste<CR>"+p :set nopaste<CR>
  nmap <leader>p :r !xsel -p<CR>
  vmap <leader>c "+y
elseif OSUNAME == 'Darwin'
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

map <leader>e :e! $HOME/.vim/local.vim<cr>
map <leader>a :source $HOME/.vim/vimrc<cr>
map <leader>d :bd!<cr>
map <leader>q :q<cr>
map <leader>w :w!<cr>
map <leader>fw :w !sudo tee > /dev/null %<cr>
"map <leader>u :set fileencoding=utf8<cr>
map <leader>i <ESC>:r! cat<CR>

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
"map <c-j> <ESC>:bn<CR>
"map <c-k> <ESC>:bp<CR>
map <c-l> :BufExplorer<cr>

"""""""""""""""""""""""""""""""""""""""
""" NERDTree
"""""""""""""""""""""""""""""""""""""""
map <c-a> :NERDTreeToggle<cr>
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeIgnore = ['\.vim$', '\~$']
let g:NERDTreeBookmarksFile = $HOME . '/.NERDTreeBookmarks'
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeMinimalUI=0
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"""""""""""""""""""""""""""""""""""""""
""" ctrl-p/ctrlp
"""""""""""""""""""""""""""""""""""""""
map <Leader>mru :CtrlPMRU<cr>
let g:ctrlp_mruf_exclude = '/tmp/.*\|/var/tmp/.*|COMMIT_EDITMSG'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn|CVS|node_modules|vendor)$',
      \ 'file': '\v\.(exe|so|dll|jar|pdf|doc|pyc|class|jpg|png|gif)$',
      \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
      \ }
"let g:ctrlp_use_caching = 1
"let g:cachedir=$HOME . "/.ctrlp_cache"
"if !isdirectory(expand(cachedir))
"call mkdir(expand(cachedir))
"endif
"let g:ctrlp_cache_dir = cachedir
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

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
""" vim-airline
"""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
if !GUI_RUNNING
  " disable airline in cli
  "" let g:airline_powerline_fonts = 0
endif
let g:airline_theme='term'
let g:Powerline_symbols = 'fancy'
""" Number of colors
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


"""""""""""""""""""""""""""""""""""""""
""" YouCompleteMe
"""""""""""""""""""""""""""""""""""""""
" make YCM compatible with UltiSnips
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
""" Syntastic
"""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""
""" Tabular
"""""""""""""""""""""""""""""""""""""""
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

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
let g:smooth_scroll_duration=25
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
nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>

nnoremap <silent> n :call WordNavigation('forward')<cr>
nnoremap <silent> N :call WordNavigation('backward')<cr>

"""""""""""""""""""""""""""""""""""""""
""" Vundle
"""""""""""""""""""""""""""""""""""""""

nnoremap <leader>pi :PluginInstall<cr>
nnoremap <leader>pc :PluginClean<cr>
"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
"""""""""""""""""""""""""""""""""""""""
let g:lexical#spell = 1
let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',]
let g:lexical#dictionary = ['/usr/share/dict/words',]
let g:lexical#spellfile = ['~/.vim/spell/en.utf-8.add',]
let g:lexical#spelllang = ['en_us','en_au',]
let g:lexical#thesaurus_key = '<leader>tt'
let g:lexical#spell_key = '<leader>ss'
let g:lexical#dictionary_key = '<leader>dd'
