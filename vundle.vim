"""""""""""""""""""""""""""""""""""""""
"               Vundle
"
"""""""""""""""""""""""""""""""""""""""
filetype off

let g:BUNDLEDIR='$HOME/.local/share/vimbundle'
let &runtimepath.=','.expand(BUNDLEDIR . '/Vundle.vim')

if isdirectory(expand(BUNDLEDIR))
call vundle#rc(expand(BUNDLEDIR))
call vundle#begin()
" Utils
" =====
Plugin 'VundleVim/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
"Plugin 'Xuyuanp/nerdtree-git-plugin'
" Funcy start screen for vim
"Plugin 'mhinz/vim-startify' " start screen
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'rking/ag.vim'
"Plugin 'tyru/open-browser.vim'
" highlight trailing whitespaces
Plugin 'bronson/vim-trailing-whitespace'
"Plugin 'vimwiki/vimwiki'
"Plugin 'maxbrunsfeld/vim-yankstack'
"Plugin 'kien/rainbow_parentheses.vim'

" manipulate text
" ===============
Plugin 'terryma/vim-smooth-scroll'
Plugin 'matchit.zip'
Plugin 'tpope/vim-surround'
"Plugin 'Lokaltog/vim-easymotion'
Plugin 'godlygeek/tabular'
Plugin 'vasconcelloslf/vim-interestingwords'
Plugin 'thinca/vim-visualstar'
Plugin 'reedes/vim-lexical'

" Snippets and auto complete
" ==========================
Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" dev support
" ===========
"Plugin 'tpope/vim-fugitive'
"Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/syntastic'

" HTML
" ====
"Plugin 'mattn/emmet-vim'
" close tags
Plugin 'Raimondi/delimitMate'

" Javascript
" ==========
"Plugin 'aaronj1335/underscore-templates.vim'
"Plugin 'othree/yajs.vim'
"Plugin 'moll/vim-node'
Plugin 'jimmyhchan/dustjs.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'marijnh/tern_for_vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'dcai/vim-react-es6-snippets'

" PHP 5.6
" ==========
"Plugin 'jwalton512/vim-blade'
Plugin 'evidens/vim-twig'
Plugin 'beanworks/vim-phpfmt'
Plugin '2072/PHP-Indenting-for-VIm'

" Other syntax
" ============
"Plugin 'rodjek/vim-puppet'
Plugin 'hdima/python-syntax'
Plugin 'nginx.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'lambdatoast/elm.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'keith/tmux.vim'

" Color
" =====
Plugin 'vim-scripts/peaksea'
"Plugin 'Solarized'
"Plugin 'chriskempson/base16-vim'

call vundle#end()
else
  call mkdir(expand(BUNDLEDIR), "p")
  call system('cd ' . expand(BUNDLEDIR) . '; git clone https://github.com/VundleVim/Vundle.vim.git')
endif
