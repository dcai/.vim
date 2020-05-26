" https://www.c3scripts.com/tutorials/msdos/paste.html
nmap <leader>pp :set paste<CR>:r !paste.exe<CR>:set nopaste<CR>
" imap <leader>pp <Esc>:set paste<CR>:r !paste.exe<CR>:set nopaste<CR>
nmap <leader>yy :.w !clip.exe<CR><CR>
vmap <leader>yy :w !clip.exe<CR><CR>
