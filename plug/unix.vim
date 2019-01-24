function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --js-completer --go-completer
  endif
endfunction

if or(has("python"), has('python3'))
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM'), 'frozen': 1 }
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'dcai/vim-react-es6-snippets'
endif

function! InstallPython3Black(info)
  if a:info.status == 'installed' || a:info.force
    " TODO
  endif
endfunction

if has('python3')
  Plug 'ambv/black', { 'do': function('InstallPython3Black'), 'frozen': 1 }
  autocmd BufWritePre *.py execute ':Black'
endif

Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install -g tern' }
nnoremap <silent> <f2> :TernRename<CR>

" Plug 'flowtype/vim-flow' " static js analyser
