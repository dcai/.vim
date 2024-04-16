"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F15> <nop>
noremap! <F15> <nop>
noremap <F16> <nop>
noremap! <F16> <nop>

"""" Avoid enter ex mode
"""" this works but could make pressing `q` less responsive
"""" for example, quit help mode slower as vim is waiting
"""" for next char
" map q: <nop>
" map q\ <nop>
" map q? <nop>
" nmap q: <nop>

" Keep search matches in the middle of the window.
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
" https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim#L511
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap L $
nnoremap H ^
" nnoremap T :Vexplore<cr>
nnoremap U :redo<cr>
" close everything
nnoremap WW :w!<cr>
nnoremap XX :ccl<cr>:lcl<cr>:pcl<cr>:helpclose<cr>
nnoremap XC :cexpr []<cr>:lexpr []<cr>
" nnoremap QQ :qall<cr>
" nnoremap QA :qall!<cr>
nnoremap BD :bd!<cr>
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk
" This unset the 'last search pattern' register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>
nnoremap <leader>bd :bd!<cr>
nnoremap <leader>on :on<cr>
nnoremap <leader>vs :vs<cr>
nnoremap <leader>sp :sp<cr>

map <M-p> :lua require('fzf-lua').git_files()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" apply to all modes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" next item in quickfix
map <c-j> <ESC>:cn<CR>
" prev item in quickfix
map <c-k> <ESC>:cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" command"line mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" insert mode
""
""  Press Ctrl-O switches to normal mode for one command
""  http://vim.wikia.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jj <Esc>:w!<cr>
inoremap <C-c>  <ESC>
