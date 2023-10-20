""""""""""""""""""""""""""""""""""""""""
"""  key mappings
""""""""""""""""""""""""""""""""""""""""
noremap <F15> <nop>
noremap! <F15> <nop>
noremap <F16> <nop>
noremap! <F16> <nop>

" Avoid ex mode
map q: <nop>
map q\ <nop>
map q? <nop>
nmap q: <nop>

" Keep search matches in the middle of the window.
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
" https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim#L511
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader><leader> m'

inoremap jj <Esc>
inoremap jk <Esc>
" inoremap kk <Esc> " not good, many words end with k
" inoremap ll <Esc> " not good, ll is common in english

nnoremap L $
nnoremap H ^

" Format entire buffer
" credit: http://vim.wikia.com/wiki/Fix_indentation
" how this works:
"   mz: mark current location to `z`
"   gg: go to file top
"   =: format
"   G: to the end of file
"   `z: jump back to mark `z`
"   gg=G would reformat the whole file but lose current location
nnoremap = mzgg=G`z

nnoremap T :Vexplore<cr>

noremap U :redo<cr>

" map <c-j> <ESC>:cn<CR> " next item in quickfix
" map <c-k> <ESC>:cp<CR> : prev item in quickfix

" Press <Home> or <End> to the 1st and last
" char of the line
noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
noremap  <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vnoremap <expr> <End>  (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
inoremap <Home> <C-o><Home>
inoremap <End>  <C-o><End>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk

vnoremap <silent> j gj
vnoremap <silent> k gk
vnoremap <silent> <Down> gj
vnoremap <silent> <Up> gk
" Press Ctrl-O switches to normal mode for one command
" http://vim.wikia.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

nnoremap <silent> <leader>ww :w<CR><CR>
" toggle most recently used file
" ctrl-6 <c-6> <c-^> doesn't work for some terminals
nnoremap <silent> <leader>aa :e #<cr>

" open file in sublime
nnoremap <leader>of :Dispatch! /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl %<CR>

function OpenDir()
  let d = expand("%:p:h")
  silent execute '!open ' . d
endfunction
nnoremap <leader>od :call OpenDir()<CR>

if has("nvim")
  nnoremap <leader>es :UltiSnipsEdit<cr>
  nnoremap <leader>ev :e $HOME/.vim/init.lua<cr>
  " nnoremap <leader>rr :source $HOME/.vim/init.lua<cr>
  nnoremap <leader>rc :source $MYVIMRC<cr>
else
  nnoremap <leader>ev :e $HOME/.vim/vimrc<cr>
  nnoremap <leader>rc :source $HOME/.vim/vimrc<cr>
endif

" source current file
nnoremap <leader>rr :source %<cr>

if !exists('g:vscode')
  nnoremap <leader>qq :qall<cr>
  nnoremap <leader>wq :silent wq<cr>
  nnoremap <leader>qw :silent wq<cr>
  nnoremap <leader>bd :bd!<cr>

  " close everything
  nnoremap <silent> <leader>xx :ccl<cr>:lcl<cr>:pcl<cr>:helpclose<cr>
  nnoremap <leader>on :on<cr>
  nnoremap <leader>vs :vs<cr>
  nnoremap <leader>sp :vs<cr>
endif
" This unsets the 'last search pattern' register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" copy messages to register
nnoremap <leader>ym :let @*=execute('messages')<CR>
" Convert slashes to backslashes for Windows.
if g:osuname ==? 'Windows'
  nmap <leader>yp :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap <leader>yf :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
else
  " copy fullpath to vim * register
  nnoremap <leader>yp :let @*=expand("%:p")<CR>
  " copy file name to vim register
  nnoremap <leader>yf :let @*=expand("%")<CR>
endif

" Toggle quickfix
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
nnoremap <silent> <leader>qf :call ToggleQuickFix()<cr>

" " copied from
" " https://www.zhihu.com/question/533699196/answer/2503107479
" Open scratch split buffers
" nnoremap <silent> <space>ttss<space> :new<cr>:setl bt=nofile bh=wipe nobl noswf<cr>
" nnoremap <silent> <space>ttsv<space> :vnew<cr>:setl bt=nofile bh=wipe nobl noswf<cr>
" " run shell command
" nmap <space>sh<space> yy<space>ttss<space>P:.!bash<cr>
" xmap <space>sh<space> y<space>ttss<space>P:%!bash<cr>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null
