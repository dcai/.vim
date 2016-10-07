"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let g:BUNDLEDIR='$HOME/.local/share/vimplug'
let g:VIMCONFDIR='$HOME/.vim/autoload'

" Install vim-plug if we don't already have it
if empty(glob("~/.vim/autoload/plug.vim"))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    execute 'mkdir -p ' . expand(BUNDLEDIR)
    execute 'mkdir -p ' . expand(VIMCONFDIR)
    " Download the actual plugin manager
    execute '!curl -fLo ' . VIMCONFDIR . '/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
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
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-function'
  \ | Plug 'thinca/vim-textobj-function-javascript', { 'for': 'javascript' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Snippets and auto complete
" ==========================
Plug 'ervandew/supertab'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" dev support
" ===========
"Plug 'tpope/vim-fugitive'
"Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/syntastic'

" HTML
" ====
"Plugin 'mattn/emmet-vim'
" close tags
Plug 'Raimondi/delimitMate'

" Javascript
" ==========
"Plug 'aaronj1335/underscore-templates.vim'
"Plug 'othree/yajs.vim'
"Plug 'moll/vim-node'
Plug 'jimmyhchan/dustjs.vim'
"Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'dcai/vim-react-es6-snippets'

" PHP 5.6
" ==========
"Plug 'jwalton512/vim-blade'
Plug 'evidens/vim-twig'
Plug 'beanworks/vim-phpfmt'
Plug '2072/PHP-Indenting-for-VIm'

" Other syntax
" ============
"Plug 'rodjek/vim-puppet'
Plug 'hdima/python-syntax'
Plug 'nginx.vim'
Plug 'plasticboy/vim-markdown'
Plug 'lambdatoast/elm.vim'
Plug 'derekwyatt/vim-scala'
Plug 'keith/tmux.vim'

" Color
" =====
Plug 'vim-scripts/peaksea'
Plug 'Solarized'
Plug 'chriskempson/base16-vim'

call plug#end()
