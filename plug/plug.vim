"""""""""""""""""""""""""""""""""""""""
"               vim-plug
"
"""""""""""""""""""""""""""""""""""""""

let s:plugged=g:vim_data . '/plug'
let s:autoload=g:vim_home . '/autoload'
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
    " !npm install -g prettier eslint
    " !pip3 install --user vim-vint pathlib typing
    " !composer global require 'squizlabs/php_codesniffer=*'
    " !composer global require 'friendsofphp/php-cs-fixer'
  endif
endfunction

" download vim-plug if not installed
if empty(glob(expand(s:vimplug)))
  execute '!mkdir -p ' . expand(s:plugged)
  execute '!mkdir -p ' . expand(s:autoload)
  execute '!curl -fLo ' . s:vimplug . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(expand(s:plugged))

Plug 'dcai/ale', { 'do': function('InstallAle'), 'frozen': 1 }
" if v:version >= 800
"   " Plug 'dense-analysis/ale', { 'do': function('InstallAle') }
" else
"   Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }
" endif

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" just for neovim
if has('nvim')
  Plug 'ibhagwan/fzf-lua'
  " Plug 'ibhagwan/fzf-lua', Cond(!exists('g:vscode'), {'branch': 'main'})
  Plug 'ruifm/gitlinker.nvim'
  Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'L3MON4D3/LuaSnip',
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  if !has('nvim-0.9')
    Plug 'gpanders/editorconfig.nvim'
  endif
  Plug 'Exafunction/codeium.nvim', Cond(!IsEnvVarSet('NO_CODEIUM'), {'branch': 'main'})
  """"""""""""""""""""""""""""""""""""""""""
  """ BEGIN code completion plugins
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'andersevenrud/cmp-tmux'
  Plug 'hrsh7th/nvim-cmp'
  """"""""""""""""""""""""""""""""""""""""""
  """ END code completion
  """"""""""""""""""""""""""""""""""""""""""
endif

if g:osuname ==? 'Windows'
  " only windows
endif

" not for nvim
if !has('nvim')
  Plug 'neoclide/coc.nvim',
        \ { 'branch': 'release',
        \   'do': function('InstallCoc')
        \ }
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --bin --no-update-rc --no-completion --no-key-bindings' }
  Plug 'junegunn/fzf.vim'
  Plug 'mhinz/vim-signify'
  Plug 'editorconfig/editorconfig-vim'
endif

Plug 'dstein64/vim-startuptime'
Plug 'junegunn/vader.vim', { 'for': 'vader' }
Plug 'tpope/vim-fugitive'
Plug 'reedes/vim-lexical'
Plug 'djoshea/vim-autoread'
Plug 'mbbill/undotree'
Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell
Plug 'tpope/vim-surround'
Plug 'andymass/vim-matchup'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-dispatch'
Plug 'jiangmiao/auto-pairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tyru/open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap <leader>ob <Plug>(openbrowser-smart-search)
vmap <leader>ob <Plug>(openbrowser-smart-search)

"""""""""""""""""""""""""""""""""""""""
""" vimux
"""""""""""""""""""""""""""""""""""""""
Plug 'preservim/vimux'
let g:VimuxOrientation = "h"

"""""""""""""""""""""""""""""""""""""""
""" syntax
"""""""""""""""""""""""""""""""""""""""
Plug 'chr4/nginx.vim'
Plug 'glensc/vim-syntax-lighttpd'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nblock/vim-dokuwiki', { 'for': 'dokuwiki' }
Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }

"""""""""""""""""""""""""""""""""""""""
""" vim-sneak
""" alternatives:
"""   hop, lightspeed, clever-f
"""""""""""""""""""""""""""""""""""""""
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
" case insensitive search
let g:sneak#use_ic_scs = 1

"""""""""""""""""""""""""""""""""""""""
""" Text objects
"""""""""""""""""""""""""""""""""""""""
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'wellle/targets.vim'

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
" Plug 'godlygeek/tabular'
" nmap <Leader>t= :Tabularize /=<CR>
" vmap <Leader>t= :Tabularize /=<CR>
" nmap <Leader>t: :Tabularize /:\zs<CR>
" vmap <Leader>t: :Tabularize /:\zs<CR>

"""""""""""""""""""""""""""""""""""""""
""" colorschemes
"""""""""""""""""""""""""""""""""""""""
Plug 'rafi/awesome-vim-colorschemes'
" Plug 'rebelot/kanagawa.nvim'
Plug 'rose-pine/neovim'
call plug#end()
