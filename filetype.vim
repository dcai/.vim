autocmd stdinreadpre * let s:std_in=1

" Spelling {{{
autocmd FileType gitcommit setlocal spell
autocmd FileType svn       setlocal spell
autocmd FileType asciidoc  setlocal spell
autocmd FileType markdown  setlocal spell
autocmd FileType vimwiki   setlocal spell
autocmd FileType text      setlocal spell
autocmd FileType help      setlocal nospell
" }}}

""""""""""""""""""""""""""""""
" dokuwiki
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.dokuwiki setf dokuwiki

""""""""""""""""""""""""""""""
" NFO
"""""""""""""""""""""""""""""""
autocmd BufReadPre  *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
autocmd BufReadPost *.nfo call RestoreFileEncodings()

""""""""""""""""""""""""""""""
" NGINX
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewfile nginx.conf set ft=nginx
autocmd BufRead,BufNewFile */nginx/* set ft=nginx

" dosini {{{
autocmd BufRead,BufNewFile /etc/supervisor/conf.d/* set ft=dosini
autocmd BufRead,BufNewFile supervisord.conf set filetype=dosini
autocmd BufRead,BufNewFile */.weechat/*.conf set filetype=dosini
autocmd BufRead,BufNewFile php-fpm.conf set filetype=dosini
autocmd BufRead,BufNewFile www.conf set filetype=dosini
" }}}

" PHP {{{
autocmd BufRead,BufNewFile *.phps set filetype=php
" Drupal files
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.module set filetype=php
" }}}

" Javascript {{{
autocmd BufRead,BufNewFile .eslintrc set filetype=json
autocmd BufRead,BufNewFile .jscsrc set filetype=json
autocmd BufRead,BufNewFile .babelrc set filetype=json
autocmd BufRead,BufNewFile .jshintrc set filetype=json
autocmd BufRead,BufNewFile .tern-config set filetype=json
autocmd BufRead,BufNewFile tsconfig.json set filetype=json5
" }}}


au BufNewFile,BufRead *.prisma setfiletype graphql

" Misc {{{
autocmd BufRead /tmp/mutt-* set tw=72
autocmd BufRead,BufNewFile *.scala set filetype=scala
autocmd BufRead,BufNewFile *gitconfig* set filetype=gitconfig
autocmd BufRead,BufNewFile */git/* set filetype=gitconfig
autocmd BufRead,BufNewFile *.less setf less
autocmd BufRead,BufNewFile *conkyrc set filetype=conkyrc
autocmd BufRead,BufNewFile */vimwiki/* set filetype=vimwiki
" autocmd vimenter * if argc() == 0 && !exists("s:std_in") | NERDTree ~/Dropbox/mysite/contents/wiki | endif
" }}}

" Lexmed {{{
augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init()
  autocmd FileType org call lexical#init()
augroup END
" }}}

function! HelpFileMode()
  "wincmd _ " Maximze the help on open
  nnoremap <buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
  nnoremap <buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
  nnoremap <buffer> <cr> <c-]>
  nnoremap <buffer> <bs> <c-T>
  nnoremap <buffer> q :q<CR>
  setlocal nonumber
endfunction
autocmd filetype help call HelpFileMode()
