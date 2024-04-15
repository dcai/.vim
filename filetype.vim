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

""""""""""""""""""""""""""""""""""""
" Set ale fix on save conditionally
""""""""""""""""""""""""""""""""""""
function! UpdateAleFixOnSave()
  let l:dir = expand('%:p:h')
  let l:file = expand('%:p')

  let g:ale_fix_on_save = 0

  if match(l:file, 'html\|twig\|jinja2') > -1
    " disable auto fix for html
    let g:ale_fix_on_save = 0
  endif

  if match(l:file, 'php\|phps') > -1
    " disable auto fix for php
    let g:ale_fix_on_save = 0
  endif

  " Install moodle coding style:
  "   > phpcs --config-set installed_paths /home/vagrant/projects/moodle/local/codechecker/moodle
  " Above command add moodle coding style to
  "   /home/vagrant/.config/composer/vendor/squizlabs/php_codesniffer/CodeSniffer.conf
  " let s:php_coding_standard = 'moodle'
  " let s:php_coding_standard = 'WordPress-Core'
  let l:php_coding_standard = 'PSR12'
  if l:dir =~ 'moodle'
    let g:ale_fix_on_save = 0
    let l:php_coding_standard = 'moodle'
  endif
  let g:ale_php_phpcs_standard = l:php_coding_standard
  let g:ale_php_phpcbf_standard = l:php_coding_standard

  unlet l:php_coding_standard
  unlet l:file
  unlet l:dir
endfunction

augroup aleGlobalOptionsGroup
  autocmd!
  autocmd BufEnter * call UpdateAleFixOnSave()
augroup END

"""""""""""""""""""""""""""""""
" helpfile
"""""""""""""""""""""""""""""""
augroup helpFiletypeGroup
  " Remove all group autocommands
  autocmd!
  autocmd filetype help call HelpFileMode()
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

augroup nfoFiletypeGroup
  autocmd!
  autocmd BufReadPre  *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
  autocmd BufReadPost *.nfo call RestoreFileEncodings()
augroup END

augroup filetypeGroup
  autocmd!
  autocmd BufRead,BufNewFile Jenkinsfile* setf groovy
  autocmd BufRead,BufNewFile *npmrc* setf dosini

  " direnv
  autocmd BufRead,BufNewFile *.envrc setf sh

  " dotenv
  autocmd BufRead,BufNewFile *.env setf dosini
  autocmd BufRead,BufNewFile env.* setf dosini

  " dokuwiki
  autocmd BufRead,BufNewFile *.dokuwiki setf dokuwiki

  " NGINX
  autocmd BufRead,BufNewfile nginx.conf set ft=nginx
  autocmd BufRead,BufNewFile */nginx/* set ft=nginx

  " dosini
  autocmd BufRead,BufNewFile /etc/supervisor/conf.d/* set ft=dosini
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

  " Javascript
  autocmd BufRead,BufNewFile .jscsrc set filetype=json
  autocmd BufRead,BufNewFile .babelrc set filetype=json
  autocmd BufRead,BufNewFile .jshintrc set filetype=json
  autocmd BufRead,BufNewFile .tern-config set filetype=json
  autocmd BufRead,BufNewFile tsconfig.json set filetype=json5
  autocmd BufRead,BufNewFile .eslintrc set filetype=json5
  autocmd BufRead,BufNewFile */mdk/config-dist.json set filetype=json5

  " mojo
  autocmd BufRead,BufNewFile *.mojo set filetype=mojo

  " graphql
  autocmd BufNewFile,BufRead *.prisma setfiletype graphql

  " git
  autocmd BufRead,BufNewFile *gitconfig* set filetype=gitconfig
  autocmd BufRead,BufNewFile */.git/config set filetype=gitconfig
  autocmd BufRead,BufNewFile */gitconfig.d/* set filetype=gitconfig

  "others
  autocmd BufRead,BufNewFile *conkyrc set filetype=conkyrc
  autocmd BufRead,BufNewFile */vimwiki/* set filetype=vimwiki

  " zmk
  autocmd BufRead,BufNewFile *zmk*/**/*.keymap set filetype=dts
  autocmd BufRead,BufNewFile *.tf set filetype=terraform
augroup END
