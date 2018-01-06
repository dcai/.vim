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

call plug#begin(expand(BUNDLEDIR))

" manipulate text
" ===============
Plug 'bronson/vim-trailing-whitespace' "highlight trailing whitespaces
Plug 'terryma/vim-smooth-scroll'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'vasconcelloslf/vim-interestingwords'
Plug 'thinca/vim-visualstar'
Plug 'reedes/vim-lexical'

" Text objects
" ============
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-function'
Plug 'bps/vim-textobj-python', { 'for': 'python' }
Plug 'thinca/vim-textobj-function-javascript', { 'for': 'javascript' }

" Finder
" ===============
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'

" status line
" ===========
"Plug 'itchyny/lightline.vim'
"Plug 'vim-airline/vim-airline'
"\ | Plug 'vim-airline/vim-airline-themes'


" dev support
" ===========
Plug 'Chiel92/vim-autoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'

" HTML
" ====
Plug 'mattn/emmet-vim', { 'for': ['html', 'php'] }
" close tags
Plug 'Raimondi/delimitMate'

" Javascript
" ==========
Plug 'pangloss/vim-javascript' | Plug 'mxw/vim-jsx'
Plug 'jimmyhchan/dustjs.vim'
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'flowtype/vim-flow' " static js analyser
"Plug 'othree/yajs.vim', { 'for': 'javascript' }
"Plug 'moll/vim-node'

" PHP 5.6
" ==========
Plug 'beanworks/vim-phpfmt', { 'for': 'php' }
Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' }
Plug 'evidens/vim-twig'

" Racket
" ======
" Plug 'wlangstroth/vim-racket'
" Plug 'ds26gte/scmindent'

" Python
" ======
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/python_match.vim'

" Other syntax
" ============
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'jceb/vim-orgmode', { 'for': 'org' } | Plug 'tpope/vim-speeddating', { 'for': 'org' }
Plug 'vim-scripts/nginx.vim'
Plug 'rodjek/vim-puppet'
Plug 'niftylettuce/vim-jinja'
Plug 'ElmCast/elm-vim'
Plug 'mustache/vim-mustache-handlebars'

" Misc.
Plug 'qpkorr/vim-bufkill'
Plug 'sotte/presenting.vim'
Plug 'djoshea/vim-autoread'
"Plug 'maxbrunsfeld/vim-yankstack'
"Plug 'kien/rainbow_parentheses.vim'
"Plug 'ludovicchabant/vim-gutentags'
" Funcy start screen for vim
"Plug 'mhinz/vim-startify' " start screen

" Color
" =====
Plug 'chrisbra/Colorizer' " :ColorHeight in colorscheme file

" Color schemes
Plug 'vim-scripts/peaksea'
Plug 'vim-scripts/Solarized'
Plug 'Lokaltog/vim-distinguished'
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'sheerun/vim-wombat-scheme'  "wombat
Plug 'jnurmine/Zenburn' "zenburn

" Snippets and auto complete
" ==========================
Plug 'ervandew/supertab'

" Linting
" ==========================
Plug 'w0rp/ale', { 'for': ['php', 'python', 'javascript'] }
"Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }

if g:OSUNAME == 'Windows'
  call IncludeScript('plug/windows.vim')
else
  call IncludeScript('plug/unix.vim')
endif

if g:WSL == 'Microsoft'
  call IncludeScript('plug/wsl.vim')
endif

call plug#end()
