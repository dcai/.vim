function! HelpFileMode()
  "wincmd _ " Maximze the help on open
  nnoremap <buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
  nnoremap <buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
  nnoremap <buffer> <cr> <c-]>
  nnoremap <buffer> <bs> <c-T>
  nnoremap <buffer> q :q<CR>
  setlocal nonumber
endfunction


""""""""""""""""""""""""""""""
" NFO
"""""""""""""""""""""""""""""""
augroup nfoFiletypeGroup
  autocmd!
  autocmd BufReadPre  *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
  autocmd BufReadPost *.nfo call RestoreFileEncodings()
augroup end

augroup filetypeGroup
  autocmd!

  " if no filetype specified, set ft=text
  autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif

  autocmd filetype help call HelpFileMode()

  autocmd BufRead,BufNewFile Jenkinsfile* setf groovy

  " dokuwiki
  autocmd BufRead,BufNewFile *.dokuwiki setf dokuwiki

  " NGINX
  autocmd BufRead,BufNewfile nginx.conf set ft=nginx
  autocmd BufRead,BufNewFile */nginx/* set ft=nginx

  " dosini
  autocmd BufRead,BufNewFile /etc/supervisor/conf.d/* set ft=dosini
  autocmd BufRead,BufNewFile supervisord.conf set filetype=dosini
  autocmd BufRead,BufNewFile */.weechat/*.conf set filetype=dosini
  autocmd BufRead,BufNewFile .env* set filetype=dosini

  " php-fpm config
  autocmd BufRead,BufNewFile php-fpm.conf set filetype=dosini
  autocmd BufRead,BufNewFile www.conf set filetype=dosini

  " PHP
  autocmd BufRead,BufNewFile *.phps set filetype=php
  autocmd BufRead,BufNewFile *.php_cs set filetype=php
  autocmd BufRead,BufNewFile php_cs set filetype=php
  " Drupal files
  autocmd BufRead,BufNewFile *.install set filetype=php
  autocmd BufRead,BufNewFile *.module set filetype=php

  " Javascript
  autocmd BufRead,BufNewFile .jscsrc set filetype=json
  autocmd BufRead,BufNewFile .babelrc set filetype=json
  autocmd BufRead,BufNewFile .jshintrc set filetype=json
  autocmd BufRead,BufNewFile .tern-config set filetype=json
  autocmd BufRead,BufNewFile tsconfig.json set filetype=json5
  autocmd BufRead,BufNewFile .eslintrc set filetype=json5
  autocmd BufRead,BufNewFile */mdk/config-dist.json set filetype=json5

  " graphql
  autocmd BufNewFile,BufRead *.prisma setfiletype graphql

  " git
  autocmd BufRead,BufNewFile *gitconfig* set filetype=gitconfig
  autocmd BufRead,BufNewFile */.git/* set filetype=gitconfig

  "others
  autocmd BufRead,BufNewFile *conkyrc set filetype=conkyrc
  autocmd BufRead,BufNewFile */vimwiki/* set filetype=vimwiki
augroup end
