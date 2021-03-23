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

" git
" ===
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" usability
" =========
Plug 'reedes/vim-lexical'
Plug 'bronson/vim-trailing-whitespace' " highlight trailing whitespaces
Plug 'djoshea/vim-autoread'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'qpkorr/vim-bufkill'
" Plug 'mg979/vim-visual-multi'
Plug 'terryma/vim-smooth-scroll'
Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell
Plug 'tpope/vim-surround'
" Plug 'bronson/vim-visual-star-search'
Plug 'lfv89/vim-interestingwords'
nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
vnoremap <silent> <leader>k :call InterestingWords('v')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>
Plug 'vim-scripts/matchit.zip'
Plug 'scrooloose/nerdcommenter'
" Plug 'maxbrunsfeld/vim-yankstack'
" Plug 'kien/rainbow_parentheses.vim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
nmap z/ <Plug>(incsearch-fuzzy-/)
nmap z? <Plug>(incsearch-fuzzy-?)
nmap zz/ <Plug>(incsearch-fuzzyspell-/)
nmap zz? <Plug>(incsearch-fuzzyspell-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)
" map zg/ <Plug>(incsearch-fuzzyspell-stay)

" utils
" =====
Plug 'chrisbra/Colorizer' " :ColorHighlight in colorscheme file
let g:colorizer_auto_filetype='vim,css'
Plug 'diepm/vim-rest-console'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'mhinz/vim-signify'

" Text objects
" ============
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'bps/vim-textobj-python', { 'for': 'python' }
" Plug 'thinca/vim-textobj-function-javascript'
Plug 'haya14busa/vim-textobj-function-syntax'

" javascript
" ==========
Plug 'pangloss/vim-javascript'
Plug 'moll/vim-node'
Plug 'jparise/vim-graphql'
Plug 'GutenYe/json5.vim'
Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }

" Python
" ======
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/python_match.vim'

" Other syntax
" ============
Plug 'evidens/vim-twig'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'jceb/vim-orgmode', { 'for': 'org' }
Plug 'tpope/vim-speeddating', { 'for': 'org' }
Plug 'vim-scripts/nginx.vim'
Plug 'niftylettuce/vim-jinja'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml'
Plug 'dzeban/vim-log-syntax'
Plug 'nblock/vim-dokuwiki', { 'for': 'dokuwiki' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }

"""""" 16 color schemes
"""""" ================
" Plug 'noahfrederick/vim-noctu' " 16 colors
" Plug 'jeffkreeftmeijer/vim-dim' " 16 colors

"""""" color schemes
"""""" =============
" Plug 'nanotech/jellybeans.vim'
" Plug 'romainl/Apprentice'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'Lokaltog/vim-distinguished'
" Plug 'morhetz/gruvbox'
" Plug 'junegunn/seoul256.vim'
" Plug 'sjl/badwolf'
" Plug 'whatyouhide/vim-gotham'
" Plug 'toupeira/vim-desertink'
" Plug 'chriskempson/base16-vim'
" Plug 'vim-scripts/peaksea'
" Plug 'sheerun/vim-wombat-scheme'
" Plug 'jnurmine/Zenburn'

function! InstallCoc(info)
  if a:info.status ==? 'installed' || a:info.force
    " XXX: CocInstall is not available at this point
    " :CocInstall coc-tsserver coc-python coc-snippets
    " :CocInstall https://github.com/andys8/vscode-jest-snippets
  endif
endfunction

function! InstallAle(info)
  if a:info.status ==? 'installed' || a:info.force
    !npm install -g prettier eslint lua-fmt
    " !pip3 install --user vim-vint pathlib typing
    " !composer global require 'squizlabs/php_codesniffer=*'
    " !composer global require 'friendsofphp/php-cs-fixer'
  endif
endfunction

if v:version > 800
  Plug 'neoclide/coc.nvim',
        \ { 'branch': 'release',
        \   'do': function('InstallCoc')
        \ }

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

call plug#end()
