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

"""""""""""""""""""""""""""""""""""""""
"               Vundle
"               ======
"""""""""""""""""""""""""""""""""""""""
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
" Utils
" =======
Plugin 'VundleVim/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'yegappan/mru'
Plugin 'matchit.zip'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
"Plugin 'bling/vim-airline'
Plugin 'godlygeek/tabular'
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'vimwiki/vimwiki'
"Plugin 'scrooloose/syntastic'
Plugin 'rking/ag.vim'
Plugin 'tyru/open-browser.vim'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'thinca/vim-visualstar'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'junegunn/goyo.vim'

" Snippets and auto complete
" ==========================
Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" HTML
" ====
Plugin 'mattn/emmet-vim'
" close tags
Plugin 'Raimondi/delimitMate'

" Javascript
" ==========
Plugin 'pangloss/vim-javascript'
Plugin 'othree/yajs.vim'
Plugin 'mxw/vim-jsx'
Plugin 'marijnh/tern_for_vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'moll/vim-node'
Plugin 'dcai/vim-react-es6-snippets'

" PHP 5.6
" ==========
Plugin 'jwalton512/vim-blade'
Plugin 'evidens/vim-twig'

" Other syntax
" ============
Plugin 'rodjek/vim-puppet'
Plugin 'hdima/python-syntax'
Plugin 'nginx.vim'
Plugin 'plasticboy/vim-markdown'

" Color
" =====
Plugin 'vim-scripts/peaksea'
Plugin 'Solarized'
Plugin 'chriskempson/base16-vim'

call vundle#end()

execute 'source' 'vimrc.local'
