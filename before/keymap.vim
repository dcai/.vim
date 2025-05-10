noremap <F15> <nop>
noremap! <F15> <nop>
noremap <F16> <nop>
noremap! <F16> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" Avoid enter ex mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""" this works but could make pressing `q` less responsive
"""" for example, quit help mode slower as vim is waiting
"""" for next char
" map q: <nop>
" map q\ <nop>
" map q? <nop>
" nmap q: <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep search matches in the middle of the window.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" zz centers the screen on the cursor, zv unfolds any fold if the cursor
" suddenly appears inside a fold.
" https://github.com/Valloric/dotfiles/blob/master/vim/vimrc.vim#L511
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
" This unset the 'last search pattern' register by hitting return
nnoremap <silent> <CR> :nohlsearch<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" handy things
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap U :redo<cr>
" nnoremap T :Vexplore<cr>
nnoremap XX :cclose<cr>:lclose<cr>:pclose<cr>:helpclose<cr>
nnoremap BD :bd!<cr>
nnoremap ON :on<cr>
nnoremap <leader>bd :bd!<cr>
nnoremap <leader>on :on<cr>
nnoremap <leader>vs :vs<cr>
nnoremap <leader>sp :sp<cr>
" XXX: this is bad idea, as this affects `V` line selection
" nnoremap VS :vs<cr>
" nnoremap SP :sp<cr>

" nnoremap QQ :qall<cr>
" nnoremap QA :qall!<cr>
nnoremap WW :w!<cr>
" close everything
nnoremap XC :cexpr []<cr>:lexpr []<cr>

" M-p is setup in iterm to translate cmd+p to M+p
" https://stackoverflow.com/a/73212046
map <M-p> :lua require('fzf-lua').git_files()<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap L $
nnoremap H ^
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" move between quickfix items
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" next item in quickfix
" map <c-j> <ESC>:cn<CR>
" prev item in quickfix
" map <c-k> <ESC>:cp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" sudo write file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee % >/dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" visual star and replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://old.reddit.com/r/vim/comments/19sm9v/replace_all_instances_of_currently_highlighted/c8rcxtr/
xnoremap <leader>ss :%s///g<left><left>
" https://stackoverflow.com/a/676619/69938
" vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" insert mode
""
""  Press Ctrl-O switches to normal mode for one command
""  https://vim.fandom.com/wiki/Use_Ctrl-O_instead_of_Esc_in_insert_mode_mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap jk <Esc>:w!<cr>
inoremap jj <Esc>
inoremap <C-c>  <ESC>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" delete to register
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" deleted line goes to register "d
" nnoremap dd "ddd
" nnoremap dw "ddw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" remap q to esc, and use Q to start macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap Q q
nnoremap q <Esc>
vnoremap q <Esc>
