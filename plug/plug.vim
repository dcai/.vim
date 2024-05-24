"""""""""""""""""""""""""""""""""""""""
"""            vim-plug
"""""""""""""""""""""""""""""""""""""""

let s:plugged=g:vim_data . '/plug'
let s:autoload=g:vim_home . '/autoload'
let s:vimplug=s:autoload . '/plug.vim'
" this is a boolean value not the depth
let g:plug_shallow=1
let g:plug_threads=16
let s:oldvim=!has('nvim')

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

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

""""""""""""""""""""""""""""""""""""""""""
""" neovim only
""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  Plug 'Wansmer/treesj'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'echasnovski/mini.nvim'
  Plug 'pocco81/auto-save.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'ibhagwan/fzf-lua', Cond(!exists('g:vscode'), {'branch': 'main'})
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
  " Plug 'desdic/marlin.nvim'
  Plug 'dcai/marlin.nvim'
  " Plug 'elihunter173/dirbuf.nvim'
  Plug 'folke/which-key.nvim'
  Plug 'Robitx/gp.nvim' , Cond(IsEnvVarSet('OPENAI_API_KEY'), {'branch': 'main'})
  """"""""""""""""""""""""""""""""""""""""""
  """ ultisnips
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  """"""""""""""""""""""""""""""""""""""""""
  """ LSP
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvimdev/lspsaga.nvim'
  Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
  Plug 'williamboman/mason-lspconfig.nvim'
  """"""""""""""""""""""""""""""""""""""""""
  """ treesitter
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'

  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  """"""""""""""""""""""""""""""""""""""""""
  """ git
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'ruifm/gitlinker.nvim'
  """"""""""""""""""""""""""""""""""""""""""
  """ coding assist
  """"""""""""""""""""""""""""""""""""""""""
  "" this is for inline code suggestions
  Plug 'Exafunction/codeium.vim', Cond(!IsEnvVarSet('NO_CODEIUM'), {'branch': 'main'})
  Plug 'sourcegraph/sg.nvim', { 'do': 'nvim -l build/init.lua' }
  "" this is nvim plugin for cmp
  Plug 'Exafunction/codeium.nvim', Cond(!IsEnvVarSet('NO_CODEIUM'), {'branch': 'main'})
  " Plug 'zbirenbaum/copilot.lua', Cond(!IsEnvVarSet('NO_COPILOT'), {'branch': 'master'})
  " Plug 'github/copilot.vim', Cond(!IsEnvVarSet('NO_COPILOT'), {'branch': 'release'})
  """"""""""""""""""""""""""""""""""""""""""
  """ BEGIN code completion plugins
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'andersevenrud/cmp-tmux'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  " Plug 'petertriho/cmp-git'
  " Plug 'dmitmel/cmp-cmdline-history'
  """"""""""""""""""""""""""""""""""""""""""
  """ END code completion
  """"""""""""""""""""""""""""""""""""""""""
  """ BEGIN markdown
  """"""""""""""""""""""""""""""""""""""""""
  Plug 'mzlogin/vim-markdown-toc'
  let g:vmt_dont_insert_fence = 1
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
  let g:mkdp_theme = 'light'
  """"""""""""""""""""""""""""""""""""""""""
  """ END markdown
  """"""""""""""""""""""""""""""""""""""""""
endif
"""""""""""""""""""""""""""""""""""""""
""" colorschemes
"""""""""""""""""""""""""""""""""""""""
Plug 'rafi/awesome-vim-colorschemes'
" Plug 'rebelot/kanagawa.nvim'
" Plug 'rose-pine/neovim'
" Plug 'sainnhe/everforest'
" let g:everforest_background = 'hard' " 'hard', 'medium'(default), 'soft'
" let g:everforest_better_performance = 1
"""""""""""""""""""""""""""""""""""""""
""" Ale
"""""""""""""""""""""""""""""""""""""""
Plug 'dcai/ale', { 'do': function('InstallAle'), 'frozen': 1 }
" if v:version >= 800
"   Plug 'dense-analysis/ale', { 'do': function('InstallAle') }
" else
"   Plug 'scrooloose/syntastic', { 'for': ['php', 'sh', 'python', 'javascript'] }
" endif
"""""""""""""""""""""""""""""""""""""""
""" vimux
"""""""""""""""""""""""""""""""""""""""
Plug 'preservim/vimux'
let g:VimuxOrientation = "h"
Plug 'vim-test/vim-test'

let g:test#javascript#runner = 'jest'
let test#javascript#mocha#executable = 'npx mocha'
let test#javascript#mocha#options = ' --full-trace '
let test#javascript#jest#executable = 'npx jest'
let test#javascript#jest#file_pattern = '\v(__tests__/.+|(spec|test))\.(js|jsx|coffee|ts|tsx)$'

let g:test#runner_commands = ['Jest', 'Mocha']
let test#strategy = 'neovim'
let test#neovim#term_position = "vert"
"""""""""""""""""""""""""""""""""""""""
""" utils
"""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'dstein64/vim-startuptime'
Plug 'junegunn/vader.vim', { 'for': 'vader' }
Plug 'reedes/vim-lexical'
Plug 'djoshea/vim-autoread'
Plug 'andymass/vim-matchup'
Plug 'tyru/open-browser.vim'
Plug 'mbbill/undotree'
"""""""""""""""""""""""""""""""""""""""
""" bufferize
"""""""""""""""""""""""""""""""""""""""
Plug 'AndrewRadev/bufferize.vim'
let g:bufferize_command = 'new'
let g:bufferize_keep_buffers = 1
let g:bufferize_focus_output = 1

" not for nvim
if s:oldvim
  """""""""""""""""""""""""""""""""""""""
  """ syntax
  """""""""""""""""""""""""""""""""""""""
  Plug 'tpope/vim-dispatch'
  Plug 'chr4/nginx.vim'
  Plug 'mustache/vim-mustache-handlebars'
  """""""""""""""""""""""""""""""""""""""
  Plug 'neoclide/coc.nvim',
        \ { 'branch': 'release',
        \   'do': function('InstallCoc')
        \ }
  " Plug 'bronson/vim-trailing-whitespace'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --bin --no-update-rc --no-completion --no-key-bindings' }
  Plug 'junegunn/fzf.vim'
  Plug 'mhinz/vim-signify'
  Plug 'editorconfig/editorconfig-vim'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'jiangmiao/auto-pairs'
  """""""""""""""""""""""""""""""""""""""
  """ Text objects
  """""""""""""""""""""""""""""""""""""""
  " Plug 'kana/vim-textobj-user'
  " Plug 'kana/vim-textobj-indent'
  Plug 'wellle/targets.vim'

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

  Plug '907th/vim-auto-save'
  let g:auto_save = 1  " enable AutoSave on Vim startup

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
  nmap <silent> <c-u> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 2)<CR>
  nmap <silent> <c-d> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 2)<CR>
  nmap <silent> <c-b> :call smooth_scroll#up(&scroll, smooth_scroll_duration, 4)<CR>
  nmap <silent> <c-f> :call smooth_scroll#down(&scroll, smooth_scroll_duration, 4)<CR>
  nmap <silent> <PageUp> :call smooth_scroll#up(&scroll*2, smooth_scroll_duration, 4)<CR>
  nmap <silent> <PageDown> :call smooth_scroll#down(&scroll*2, smooth_scroll_duration, 4)<CR>
  """""""""""""""""""""""""""""""""""""""
  """ Tabular
  """""""""""""""""""""""""""""""""""""""
  " Plug 'godlygeek/tabular'
  " nmap <Leader>t= :Tabularize /=<CR>
  " vmap <Leader>t= :Tabularize /=<CR>
  " nmap <Leader>t: :Tabularize /:\zs<CR>
  " vmap <Leader>t: :Tabularize /:\zs<CR>
  """""""""""""""""""""""""""""""""""""""
  """ vim-sneak
  """ alternatives:
  """   hop, leap.nvim, clever-f
  """""""""""""""""""""""""""""""""""""""
  Plug 'justinmk/vim-sneak'
  let g:sneak#label = 1
  " case insensitive search
  let g:sneak#use_ic_scs = 1
endif

if g:osuname ==? 'Windows'
  " only windows
endif
call plug#end()
