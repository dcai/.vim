"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let s:plugged='$HOME/.local/vim/plug'
let s:autoload='$HOME/' . g:vimrc . '/autoload'
let s:vimplug=s:autoload . '/plug.vim'
let g:plug_shallow=3

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

" Install vim-plug if we don't already have it
if empty(glob(expand(s:vimplug)))
  " Ensure all needed directories exist  (Thanks @kapadiamush)
  execute '!mkdir -p ' . expand(s:plugged)
  execute '!mkdir -p ' . expand(s:autoload)
  " Download the actual plugin manager
  execute '!curl -fLo ' . s:vimplug . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(expand(s:plugged))

if v:version > 800
  Plug 'dcai/ale', { 'do': function('InstallAle'), 'frozen': 1 }
  " Plug 'dense-analysis/ale', { 'do': function('InstallAle') }
else
  Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }
endif


if has('nvim')
  call IncludeScript('plug/nvim.vim')
endif
if g:osuname ==? 'Windows'
  call IncludeScript('plug/windows.vim')
else
  call IncludeScript('plug/unix.vim')
endif

if has("patch-8.0.1453")
  Plug 'neoclide/coc.nvim',
    \ { 'branch': 'release',
    \   'do': function('InstallCoc')
    \ }
endif

Plug 'junegunn/vader.vim', { 'for': 'vader' }
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'reedes/vim-lexical'
Plug 'bronson/vim-trailing-whitespace' " highlight trailing whitespaces
Plug 'djoshea/vim-autoread'
Plug 'mbbill/undotree'
Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'mhinz/vim-signify'
" Plug 'mg979/vim-visual-multi'
" Plug 'bronson/vim-visual-star-search'
" Plug 'maxbrunsfeld/vim-yankstack'
" Plug 'kien/rainbow_parentheses.vim'
" Plug 'diepm/vim-rest-console'
" Plug 'chrisbra/Colorizer' " :ColorHighlight in colorscheme file
" let g:colorizer_auto_filetype='vim,css'

"""""""""""""""""""""""""""""""""""""""
""" 16 color schemes
"""""""""""""""""""""""""""""""""""""""
Plug 'noahfrederick/vim-noctu' " 16 colors
" Plug 'jeffkreeftmeijer/vim-dim' " 16 colors

"""""""""""""""""""""""""""""""""""""""
""" full colorschemes
"""""""""""""""""""""""""""""""""""""""
Plug 'morhetz/gruvbox'
Plug 'jnurmine/Zenburn'
Plug 'jacoborus/tender.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'romainl/Apprentice'
Plug 'jonathanfilip/vim-lucius'
Plug 'Lokaltog/vim-distinguished'
Plug 'junegunn/seoul256.vim'
Plug 'sjl/badwolf'
Plug 'whatyouhide/vim-gotham'
Plug 'toupeira/vim-desertink'
Plug 'chriskempson/base16-vim'
Plug 'vim-scripts/peaksea'
Plug 'sheerun/vim-wombat-scheme'
Plug 'ghifarit53/tokyonight-vim'
Plug 'ayu-theme/ayu-vim'

"""""""""""""""""""""""""""""""""""""""
""" syntax
"""""""""""""""""""""""""""""""""""""""
Plug 'evidens/vim-twig'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'jceb/vim-orgmode', { 'for': 'org' }
Plug 'tpope/vim-speeddating', { 'for': 'org' }
" Plug 'vim-scripts/nginx.vim'
Plug 'chr4/nginx.vim'
Plug 'glensc/vim-syntax-lighttpd'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'dzeban/vim-log-syntax'
Plug 'nblock/vim-dokuwiki', { 'for': 'dokuwiki' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }
Plug 'posva/vim-vue'
Plug 'kongo2002/fsharp-vim'
Plug 'hashivim/vim-terraform'

"""""""""""""""""""""""""""""""""""""""
""" lfv89/vim-interestingwords
"""""""""""""""""""""""""""""""""""""""
Plug 'lfv89/vim-interestingwords'
nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
vnoremap <silent> <leader>k :call InterestingWords('v')<cr>
nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
nnoremap <silent> n :call WordNavigation(1)<cr>
nnoremap <silent> N :call WordNavigation(0)<cr>

"""""""""""""""""""""""""""""""""""""""
""" movement
"""""""""""""""""""""""""""""""""""""""
" Plug 'easymotion/vim-easymotion'
" nmap s <Plug>(easymotion-overwin-f2)
" nmap <Leader><Leader>w <Plug>(easymotion-bd-w)
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
nmap z/ <Plug>(incsearch-fuzzy-/)
nmap z? <Plug>(incsearch-fuzzy-?)
nmap zz/ <Plug>(incsearch-fuzzyspell-/)
nmap zz? <Plug>(incsearch-fuzzyspell-?)
" map zg/ <Plug>(incsearch-fuzzy-stay)
" map zg/ <Plug>(incsearch-fuzzyspell-stay)

"""""""""""""""""""""""""""""""""""""""
""" Text objects
"""""""""""""""""""""""""""""""""""""""
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'wellle/targets.vim'

"""""""""""""""""""""""""""""""""""""""
""" javascript
"""""""""""""""""""""""""""""""""""""""
Plug 'pangloss/vim-javascript'
Plug 'zoubin/vim-gotofile'
Plug 'jparise/vim-graphql'
Plug 'GutenYe/json5.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript'] }

"""""""""""""""""""""""""""""""""""""""
""" Python
"""""""""""""""""""""""""""""""""""""""
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-scripts/python_match.vim'

"""""""""""""""""""""""""""""""""""""""
""" bufkill
"""""""""""""""""""""""""""""""""""""""
Plug 'qpkorr/vim-bufkill'
if exists(':BD')
  nnoremap X :BD<cr>
else
  nnoremap X :bd<cr>
endif

"""""""""""""""""""""""""""""""""""""""
"""  yuttie/comfortable-motion.vim
"""""""""""""""""""""""""""""""""""""""
" Plug 'yuttie/comfortable-motion.vim'
" let g:comfortable_motion_no_default_key_mappings = 1
"
" nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>
" nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
"
" nnoremap <silent> <C-b> :call comfortable_motion#flick(-100)<CR>
" nnoremap <silent> <C-f> :call comfortable_motion#flick(100)<CR>
"
" nnoremap <silent> <PageUp> :call comfortable_motion#flick(-200)<CR>
" nnoremap <silent> <PageDown> :call comfortable_motion#flick(200)<CR>

"""""""""""""""""""""""""""""""""""""""
""" vim-smooth-scroll
"""""""""""""""""""""""""""""""""""""""
Plug 'terryma/vim-smooth-scroll'
let g:smooth_scroll_duration=10

map <silent> <c-u> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 2)<CR>
map <silent> <c-d> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 2)<CR>

map <silent> <c-b> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 4)<CR>
map <silent> <c-f> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 4)<CR>

map <silent> <PageUp> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
map <silent> <PageDown> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>

"""""""""""""""""""""""""""""""""""""""
""" junegunn/vim-easy-align
"""""""""""""""""""""""""""""""""""""""
Plug 'junegunn/vim-easy-align'
" gaip*|
" ^^ Align table cells by `|`
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""
""" Tabular
"""""""""""""""""""""""""""""""""""""""
Plug 'godlygeek/tabular'
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>

"""""""""""""""""""""""""""""""""""""""
""" ludovicchabant/vim-gutentags
"""""""""""""""""""""""""""""""""""""""
" Plug 'ludovicchabant/vim-gutentags'
" let g:gutentags_ctags_executable_javascript = 'jsctags'
" let g:gutentags_project_root = ['.git', '.hg', '.bzr', '_darcs',
"       \ '_darcs', '_FOSSIL_', '.fslckout', 'Makefile', 'yarn.lock',
"       \ '.editorconfig', 'eslintrc', 'eslintrc.js', 'package.json',
"       \ '.jscsrc']

" Plug 'iberianpig/tig-explorer.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --bin --no-update-rc --no-completion --no-key-bindings' }
Plug 'junegunn/fzf.vim'

call plug#end()
