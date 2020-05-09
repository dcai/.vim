"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let s:plugged='$HOME/.local/vim/plug'
let s:autoload='$HOME/' . g:vimrc . '/autoload'
let s:vimplug=s:autoload . '/plug.vim'

" Install vim-plug if we don't already have it
if empty(glob(expand(s:vimplug)))
  " Ensure all needed directories exist  (Thanks @kapadiamush)
  execute '!mkdir -p ' . expand(s:plugged)
  execute '!mkdir -p ' . expand(s:autoload)
  " Download the actual plugin manager
  execute '!curl -fLo ' . s:vimplug . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(expand(s:plugged))

Plug 'junegunn/vader.vim', { 'for': 'vader' }

" lexical
" =======
Plug 'reedes/vim-lexical'
Plug 'panozzaj/vim-autocorrect'

" git
" ===
Plug 'christoomey/vim-conflicted' " git conflict resolver
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" usability
" =========
Plug 'bronson/vim-trailing-whitespace' " highlight trailing whitespaces
Plug 'djoshea/vim-autoread'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'qpkorr/vim-bufkill'
" Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-smooth-scroll'
Plug 'thinca/vim-visualstar'
Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell
Plug 'tpope/vim-surround'
Plug 'vasconcelloslf/vim-interestingwords'
Plug 'vim-scripts/matchit.zip'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
      \ | Plug 'Xuyuanp/nerdtree-git-plugin'
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

" HTML
" ====
Plug 'mattn/emmet-vim', { 'for': ['html', 'php'] }

" javascript
" ==========
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'jparise/vim-graphql'
Plug 'GutenYe/json5.vim'
Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }

" PHP
" ===
Plug 'evidens/vim-twig'

" Python
" ======
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/python_match.vim'

" color
" =====
Plug 'chrisbra/Colorizer' " :ColorHighlight in colorscheme file
Plug 'noahfrederick/vim-noctu'
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'junegunn/seoul256.vim'
Plug 'toupeira/vim-desertink'
Plug 'sjl/badwolf'
Plug 'whatyouhide/vim-gotham'
Plug 'romainl/Apprentice'
Plug 'jonathanfilip/vim-lucius'
Plug 'Lokaltog/vim-distinguished'
" Plug 'vim-scripts/peaksea'
" Plug 'vim-scripts/Solarized'
" Plug 'sheerun/vim-wombat-scheme'  "wombat
" Plug 'jnurmine/Zenburn' "zenburn

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
Plug 'mhinz/vim-signify'

" misc
" ====
Plug 'diepm/vim-rest-console'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'honza/vim-snippets'

function! InstallCoc(info)
  if a:info.status ==? 'installed' || a:info.force
    " XXX: CocInstall is not available at this point
    " :CocInstall coc-tsserver coc-python coc-snippets
    " :CocInstall https://github.com/andys8/vscode-jest-snippets
  endif
endfunction

Plug 'neoclide/coc.nvim', { 'branch': 'release',  'do': function('InstallCoc') }

function! InstallAle(info)
  if a:info.status ==? 'installed' || a:info.force
    !npm install -g prettier eslint
    " !pip3 install --user vim-vint pathlib typing
    " !composer global require 'squizlabs/php_codesniffer=*'
  endif
endfunction

if v:version > 800
  Plug 'dcai/ale', { 'do': function('InstallAle') }
  " Plug 'dense-analysis/ale', { 'do': function('InstallAle') }
else
  Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }
endif

if g:osuname ==? 'Windows'
  call IncludeScript('plug/windows.vim')
else
  call IncludeScript('plug/unix.vim')
endif

if g:wsl ==? 'Microsoft'
  call IncludeScript('plug/wsl.vim')
endif

call plug#end()
