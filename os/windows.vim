if has("gui_running")
  set guifont=Consolas:h14
endif

" https://www.c3scripts.com/tutorials/msdos/paste.html
nmap <leader>p :set paste<CR>:r !paste.exe<CR>:set nopaste<CR>
imap <leader>p <Esc>:set paste<CR>:r !paste.exe<CR>:set nopaste<CR>
nmap <leader>y :.w !clip.exe<CR><CR>
vmap <leader>y :w !clip.exe<CR><CR>
