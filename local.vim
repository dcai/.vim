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
if has('nvim')
  let &undodir=s:mkdir_p('~/.local/nvim/undo')
else
  let &undodir=s:mkdir_p('~/.local/vim/undo')
endif

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

set showmode
" disable colorcolumn
set colorcolumn=

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

  let g:ale_fix_on_save = 0

  if match(l:file, 'html\|twig\|jinja2') > -1
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

" set timeout

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"

set background=dark
try
  if !has('gui_running')
    colorscheme oasis
    " colorscheme noctu
  else
    " colorscheme oasis
    colorscheme gruvbox
    " colorscheme tender
    " colorscheme solarized
    " colorscheme zenburn
    " colorscheme desertink
    " colorscheme gotham
    " colorscheme lucius
    " colorscheme apprentice
    " colorscheme jellybeans
    " colorscheme badwolf
    " colorscheme wombat
    " colorscheme distinguished
    " colorscheme seoul256
    " colorscheme tokyonight
  endif
catch /^Vim\%((\a\+)\)\=:E185/
  " deal with it
endtry
