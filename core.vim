set nocompatible
" this enables filetype specific plugin and indent files
" run :filetype see status
filetype plugin indent on

if exists('syntax_on')
  syntax reset
else
  syntax on
endif

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:maplocalleader = "\<Space>"

set path=.,src,node_modules,lib
set suffixesadd=.js,.jsx,.ts,.tsx

" so vim could treat "is-word" as whole word
" use textobject `dw` to delete it
" https://til.hashrocket.com/posts/t8osyzywau-treat-words-with-dash-as-a-word-in-vim
set iskeyword+=-

set fileformats=unix,dos
set fileencodings=utf-8,gbk,big5,latin1
set encoding=utf-8
" if has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif
" set signcolumn=auto
set signcolumn=yes

if has('multi_byte')
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
  endif
endif

set suffixes=.bak,~,.swp,.o,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,
      \.ilg,.inx,.toc,.class,.pyc

set synmaxcol=300
set updatetime=100
if &history < 9000
  set history=9000
endif
set autoread
set mouse=a
set scrolloff=10
set noerrorbells
set visualbell
set showcmd
" set cursorline
set hidden
" Avoid hit ENTER to continue normal
set shortmess+=a
" Virtual editing means that the cursor can be
" positioned where there is no actual character.
" This can be halfway into a tab or beyond the
" end of the line.
set virtualedit=all
" more powerful backspacing
set backspace=indent,eol,start
" always show status line
set laststatus=2
set number
set showmatch
set switchbuf=usetab

set ignorecase
set hlsearch
set incsearch
set grepformat=%f:%l:%c:%m

set noswapfile
set nowritebackup
function! Mkdir(dirname)
  let l:path = expand(a:dirname)
  if !isdirectory(l:path)
    call mkdir(l:path, 'p')
  endif
  return l:path
endfunction

" https://stackoverflow.com/a/26898986/69938
" let g:netrw_home=Mkdir(g:vim_data)
let g:netrw_home=g:vim_data

" enable persistent undo
set undofile
let &undodir=Mkdir(g:vim_data . '/undo')
let &backupdir=Mkdir(g:vim_data . '/backup')

set expandtab
set termguicolors
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
" splitting a new window below the current one
set splitbelow
" splitting new window right of the current one
set splitright
set nofoldenable
" zR: unfold all
" zA: fold all
set foldmethod=marker

if has('nvim')
  set clipboard+=unnamedplus
  set mousescroll=ver:25,hor:2
else
  set clipboard=unnamed
endif


" set list listchars=tab:»\ ,trail:￮,precedes:←,extends:→,nbsp:⏑
" set list listchars=tab:\|\ ,trail:￮,precedes:←,extends:→,nbsp:⏑
set list listchars=tab:⇥\ ,trail:￮,precedes:←,extends:→,nbsp:⏑
set showbreak=↪\

function! SoftWrap()
  let s:old_tw = &textwidth
  set textwidth=999999
  normal gggqG
  let &textwidth = s:old_tw
endfunction

function! TrimWhiteSpace()
  %s/\s\+$//e
  %s/[ \t\r]\+$//e
endfunction

" switch to current editing file's dir
function! ChangeCurrentDirectory()
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')

  if isdirectory(l:dir)
    exec 'cd ' . l:dir
  endif

  unlet l:file
  unlet l:dir
endfunction

augroup onEnterBuffer
  autocmd!
  autocmd BufEnter * call ChangeCurrentDirectory()
augroup END

function TryFileWithExts(filename, exts)
  for ext in a:exts
    let l:filepath = a:filename . '.' . ext
    if filereadable(l:filepath)
      execute ':e ' . l:filepath
    endif
  endfor
endfunction

function EditMatchingTestFile()
  let l:filename = expand('%:r')
  let l:istestfile=l:filename =~ 'test$' || l:filename =~ 'spec$'
  if l:istestfile
    let l:parts=split(l:filename, '\.')
    call TryFileWithExts(join(l:parts[0:-2], '.'), ['js', 'ts', 'jsx', 'tsx'])
    return
  endif
  let l:exts = ['spec.js', 'spec.jsx', 'test.js', 'test.jsx', 'test.ts', 'test.tsx', 'spec.tsx']
  call TryFileWithExts(l:filename, l:exts)
endfunction

" Toggle quickfix
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
