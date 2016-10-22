"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let g:BUNDLEDIR='$HOME/.local/share/vimplug'
let g:VIMAUTOLOADDIR='$HOME/.vim/autoload'
let g:VIMPLUGPATH=VIMAUTOLOADDIR . "/plug.vim"

" Install vim-plug if we don't already have it
if empty(glob(expand(VIMPLUGPATH)))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    execute 'mkdir -p ' . expand(BUNDLEDIR)
    execute 'mkdir -p ' . expand(VIMAUTOLOADDIR)
    " Download the actual plugin manager
    execute '!curl -fLo ' . VIMPLUGPATH . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --tern-completer
  endif
endfunction

call plug#begin(expand(BUNDLEDIR))

" Utils
" =====
Plug 'jlanzarotta/bufexplorer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'Xuyuanp/nerdtree-git-plugin'
" Funcy start screen for vim
"Plug 'mhinz/vim-startify' " start screen
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'rking/ag.vim'
"Plug 'tyru/open-browser.vim'
" highlight trailing whitespaces
Plug 'bronson/vim-trailing-whitespace'
"Plug 'vimwiki/vimwiki'
"Plug 'maxbrunsfeld/vim-yankstack'
"Plug 'kien/rainbow_parentheses.vim'

" manipulate text
" ===============
Plug 'terryma/vim-smooth-scroll'
Plug 'matchit.zip'
Plug 'tpope/vim-surround'
"Plug 'Lokaltog/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'vasconcelloslf/vim-interestingwords'
Plug 'thinca/vim-visualstar'
Plug 'reedes/vim-lexical'
Plug 'kana/vim-textobj-user'
  \ | Plug 'kana/vim-textobj-function'
  \ | Plug 'bps/vim-textobj-python', { 'for': 'python' }
  \ | Plug 'thinca/vim-textobj-function-javascript', { 'for': 'javascript' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Snippets and auto complete
" ==========================
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" dev support
" ===========
"Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic', { 'for': ['php', 'python', 'javascript'] }
"Plug 'w0rp/ale', { 'for': ['php', 'python', 'javascript'] }
"Plug 'maralla/validator.vim', { 'for': ['php', 'python', 'javascript'] }

" HTML
" ====
Plug 'mattn/emmet-vim', { 'for': ['html', 'php'] }
" close tags
Plug 'Raimondi/delimitMate'

" Javascript
" ==========
"Plug 'othree/yajs.vim', { 'for': 'javascript' }
"Plug 'moll/vim-node'
Plug 'jimmyhchan/dustjs.vim'
Plug 'dcai/vim-react-es6-snippets'

" PHP 5.6
" ==========
Plug 'beanworks/vim-phpfmt', { 'for': 'php' }
Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' }

" Other syntax
" ============
Plug 'sheerun/vim-polyglot'

" Color
" =====
Plug 'vim-scripts/peaksea'
Plug 'Solarized'
Plug 'chriskempson/base16-vim'

call plug#end()
