function! HelpFileMode()
  "wincmd _ " Maximize the help on open
  nnoremap <buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
  nnoremap <buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
  nnoremap <buffer> <cr> <c-]>
  nnoremap <buffer> <bs> <c-T>
  nnoremap <buffer> q :q<CR>
  setlocal nonumber
endfunction


" 1. Select the group with ":augroup {name}".
" 2. Delete any old autocommands with ":au!".
" 3. Define the autocommands.
" 4. Go back to the default group with "augroup END".

"""""""""""""""""""""""""""""""
" default file type
"""""""""""""""""""""""""""""""
augroup defaultFiletypeGroup
  " Remove all group autocommands
  autocmd!
  " if no filetype specified, set ft=text
  autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif
augroup END

"""""""""""""""""""""""""""""""
" helpfile
"""""""""""""""""""""""""""""""
augroup helpFiletypeGroup
  " Remove all group autocommands
  autocmd!
  autocmd filetype help call HelpFileMode()
augroup END

" Ensure 'q' closes Fugitive blame windows
augroup fugitive_q_close
  autocmd!
  autocmd FileType fugitiveblame nnoremap <buffer> q :q<CR>
augroup END

"""""""""""""""""""""""""""""""
" NFO
"""""""""""""""""""""""""""""""

" Common code for encodings, used by *.nfo files
function! SetFileEncodings(encodings)
  let b:myfileencodingsbak=&fileencodings
  let &fileencodings=a:encodings
endfunction

function! RestoreFileEncodings()
  let &fileencodings=b:myfileencodingsbak
  unlet b:myfileencodingsbak
endfunction

" Grouped syntax highlighting autocmds
augroup syntaxHighlighting
  autocmd!
  autocmd FileType gitconfig syntax on
  autocmd FileType gitrebase syntax on
  autocmd FileType gitcommit syntax on
  autocmd FileType dockerfile syntax on
  autocmd FileType jsonc syntax on
  autocmd FileType conf syntax on
augroup END

augroup nfoFiletypeGroup
  autocmd!
  autocmd BufReadPre  *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
  autocmd BufReadPost *.nfo call RestoreFileEncodings()
augroup END

augroup aleCheckers
  autocmd!
  autocmd FileType sh let b:ale_sh_shellcheck_exclusions = 'SC1090,SC1091,SC2034,SC2154,SC2164'
augroup END

augroup filetypeGroup
  autocmd!
  autocmd BufRead,BufNewFile *.hurl set filetype=hurl
  autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy
  autocmd BufRead,BufNewFile *.templ set filetype=templ
  autocmd BufRead,BufNewFile *conkyrc set filetype=conkyrc
  autocmd BufRead,BufNewFile */vimwiki/* set filetype=vimwiki

  " direnv
  autocmd BufRead,BufNewFile *.envrc set filetype=sh

  " dotenv
  autocmd BufRead,BufNewFile .env.*,.env set filetype=sh

  " markdown
  autocmd BufRead,BufNewFile *.mdx set filetype=markdown

  " dokuwiki
  autocmd BufRead,BufNewFile *.dokuwiki set filetype=dokuwiki

  " NGINX
  autocmd BufRead,BufNewfile nginx.conf set filetype=nginx
  autocmd BufRead,BufNewFile */nginx/* set filetype=nginx

  " toml
  autocmd BufRead,BufNewFile */ghostty/* set filetype=toml

  " dosini
  autocmd BufRead,BufNewFile *npmrc* set filetype=dosini
  autocmd BufRead,BufNewFile /etc/supervisor/conf.d/* set filetype=dosini
  autocmd BufRead,BufNewFile supervisord.conf set filetype=dosini
  autocmd BufRead,BufNewFile */.weechat/*.conf set filetype=dosini
  autocmd BufRead,BufNewFile editorconfig set filetype=dosini

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

  " json
  autocmd BufRead,BufNewFile .swift-format set filetype=json
  autocmd BufRead,BufNewFile .swcrc set filetype=json
  autocmd BufRead,BufNewFile .jscsrc set filetype=json
  autocmd BufRead,BufNewFile .babelrc set filetype=json
  autocmd BufRead,BufNewFile .jshintrc set filetype=json
  autocmd BufRead,BufNewFile .tern-config set filetype=json
  autocmd BufRead,BufNewFile *.code-workspace set filetype=json

  " jsonc
  autocmd BufRead,BufNewFile *.jsonc set filetype=jsonc

  " json5
  autocmd BufRead,BufNewFile tsconfig.json set filetype=json5
  autocmd BufRead,BufNewFile tsconfig.app.json set filetype=json5
  autocmd BufRead,BufNewFile tsconfig.app.json set filetype=json5
  autocmd BufRead,BufNewFile turbo.json set filetype=json5
  autocmd BufRead,BufNewFile repomix.config.json set filetype=json5
  autocmd BufRead,BufNewFile .eslintrc set filetype=json5
  autocmd BufRead,BufNewFile */mdk/config-dist.json set filetype=json5

  " mojo
  autocmd BufRead,BufNewFile *.mojo set filetype=mojo

  " graphql
  autocmd BufNewFile,BufRead *.prisma set filetype=graphql

  " git
  autocmd BufRead,BufNewFile *gitconfig* set filetype=gitconfig
  autocmd BufRead,BufNewFile */git/config set filetype=gitconfig
  autocmd BufRead,BufNewFile */.git/config set filetype=gitconfig
  autocmd BufRead,BufNewFile */gitconfig.d/* set filetype=gitconfig

  " zmk
  autocmd BufRead,BufNewFile *zmk*/**/*.keymap set filetype=dts

  " terraform
  autocmd BufRead,BufNewFile *.tf set filetype=terraform

  " ruby
  autocmd BufRead,BufNewFile Podfile set filetype=ruby
augroup END
