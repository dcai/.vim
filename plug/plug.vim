"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let g:BUNDLEDIR='$HOME/.local/vim/plug'
let g:VIMAUTOLOADDIR='$HOME/' . VIMCONFROOT . '/autoload'
let g:VIMPLUGPATH=VIMAUTOLOADDIR . '/plug.vim'

" Install vim-plug if we don't already have it
if empty(glob(expand(VIMPLUGPATH)))
  " Ensure all needed directories exist  (Thanks @kapadiamush)
  execute '!mkdir -p ' . expand(BUNDLEDIR)
  execute '!mkdir -p ' . expand(VIMAUTOLOADDIR)
  " Download the actual plugin manager
  execute '!curl -fLo ' . VIMPLUGPATH . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(expand(BUNDLEDIR))

" Stats
" Plug 'wakatime/vim-wakatime'

" Usability
" =========
Plug 'bronson/vim-trailing-whitespace' "highlight trailing whitespaces
Plug 'djoshea/vim-autoread'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'panozzaj/vim-autocorrect'
Plug 'qpkorr/vim-bufkill'
Plug 'reedes/vim-lexical'
Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-smooth-scroll'
Plug 'thinca/vim-visualstar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'vasconcelloslf/vim-interestingwords'
Plug 'vim-scripts/matchit.zip'
"Plug 'maxbrunsfeld/vim-yankstack'
"Plug 'kien/rainbow_parentheses.vim'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zz/ <Plug>(incsearch-fuzzyspell-/)
map zz? <Plug>(incsearch-fuzzyspell-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)
" map zg/ <Plug>(incsearch-fuzzyspell-stay)

" Text objects
" ============
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'bps/vim-textobj-python', { 'for': 'python' }
Plug 'thinca/vim-textobj-function-javascript'

" Finder
" ===============
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'

" utils
" ===========
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-conflicted'
Plug 'diepm/vim-rest-console'

" HTML
" ====
Plug 'mattn/emmet-vim', { 'for': ['html', 'php'] }

" Javascript
" ==========
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'jparise/vim-graphql'
Plug 'GutenYe/json5.vim'
Plug 'leafgarland/typescript-vim'

" PHP 5.6
" ==========
" Plug 'beanworks/vim-phpfmt', { 'for': 'php' }
" Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' }
Plug 'evidens/vim-twig'

" Python
" ======
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/python_match.vim'

" Other syntax
" ============
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'jceb/vim-orgmode', { 'for': 'org' }
Plug 'tpope/vim-speeddating', { 'for': 'org' }
Plug 'vim-scripts/nginx.vim'
Plug 'niftylettuce/vim-jinja'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml'
Plug 'hashivim/vim-terraform'
Plug 'dzeban/vim-log-syntax'
Plug 'nblock/vim-dokuwiki', { 'for': 'dokuwiki' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'towolf/vim-helm'

" Color
" =====
Plug 'chrisbra/Colorizer' " :ColorHighlight in colorscheme file

" Color schemes
" Plug 'noahfrederick/vim-noctu'
" Plug 'vim-scripts/peaksea'
" Plug 'vim-scripts/Solarized'
" Plug 'Lokaltog/vim-distinguished'
" Plug 'chriskempson/base16-vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'junegunn/seoul256.vim'
" Plug 'sheerun/vim-wombat-scheme'  "wombat
" Plug 'jnurmine/Zenburn' "zenburn


function! InstallAle(info)
  if a:info.status ==? 'installed' || a:info.force
    " TODO
    !npm install -g prettier eslint tslint typescript
    !composer global require "squizlabs/php_codesniffer=*"
    !pip install vim-vint pathlib typing
  endif
endfunction

if v:version > 800
  Plug 'w0rp/ale', { 'do': function('InstallAle') }
else
  Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }
endif

if g:OSUNAME ==? 'Windows'
  call IncludeScript('plug/windows.vim')
else
  call IncludeScript('plug/unix.vim')
endif

if g:WSL ==? 'Microsoft'
  call IncludeScript('plug/wsl.vim')
endif

call plug#end()
