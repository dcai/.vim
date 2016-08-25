""""""""""""""""""""""""""""""
" Spelling
"""""""""""""""""""""""""""""""
" Git commits.
autocmd FileType gitcommit setlocal spell
" Subversion commits.
autocmd FileType svn       setlocal spell
" Mercurial commits.
autocmd FileType asciidoc  setlocal spell
autocmd FileType markdown  setlocal spell
autocmd FileType vimwiki   setlocal spell
autocmd FileType text      setlocal spell
autocmd FileType help      setlocal nospell

""""""""""""""""""""""""""""""
" vimwiki
"""""""""""""""""""""""""""""""
au! BufRead,BufNewFile */wiki/* set filetype=vimwiki
au! BufRead,BufNewFile */vimwiki/* set filetype=vimwiki
au! BufRead,BufNewFile */mysite/* set nospell

""""""""""""""""""""""""""""""
" NFO
"""""""""""""""""""""""""""""""

autocmd BufReadPre  *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
autocmd BufReadPost *.nfo call RestoreFileEncodings()
""""""""""""""""""""""""""""""
" NGINX
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile /etc/nginx/* set ft=nginx
autocmd BufRead,BufNewfile nginx.conf set ft=nginx
autocmd BufRead,BufNewFile /private/etc/nginx/* set ft=nginx
autocmd BufEnter /etc/nginx/* call TrimWhiteSpace()
autocmd BufRead,BufNewFile */nginx/* set ft=nginx
""""""""""""""""""""""""""""""
" supervisor
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile /etc/supervisor/conf.d/* set ft=dosini
autocmd BufRead,BufNewFile supervisord.conf set filetype=dosini

""""""""""""""""""""""""""""""
" PYTHON
""""""""""""""""""""""""""""""
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
"autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufEnter *.py call TrimWhiteSpace()

""""""""""""""""""""""""""""""
" PHP
""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile php-fpm.conf set filetype=dosini
autocmd BufRead,BufNewFile www.conf set filetype=dosini
" highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
autocmd FileType php let php_sql_query=1
" does exactly that. highlights html inside of php strings
"autocmd FileType php let php_htmlInStrings=1
" discourages use oh short tags. c'mon its deprecated remember
autocmd FileType php let php_noShortTags=1
autocmd BufEnter *.php call TrimWhiteSpace()


autocmd BufRead,BufNewFile *.phps set filetype=php
" Drupal files
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.module set filetype=php
""""""""""""""""""""""""""""""
" Javascript
""""""""""""""""""""""""""""""
autocmd BufEnter *.js call TrimWhiteSpace()
autocmd BufEnter *.jsx call TrimWhiteSpace()
""""""""""""""""""""""""""""""
" Typescript
""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.ts set filetype=typescript

""""""""""""""""""""""""""""""
" OBJC
"""""""""""""""""""""""""""""""
autocmd BufEnter *.h call TrimWhiteSpace()
autocmd BufEnter *.m call TrimWhiteSpace()

""""""""""""""""""""""""""""""
" markdown
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.md set filetype=markdown

""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""
au BufRead /tmp/mutt-* set tw=72
autocmd BufRead,BufNewFile *.scala set filetype=scala
autocmd BufNewFile,BufRead *.less setf less
"autocmd BufRead,BufNewFile *.json set filetype=javascript
autocmd BufRead,BufNewFile .eslintrc set filetype=javascript
autocmd BufNewFile,BufRead *conkyrc set filetype=conkyrc
autocmd BufRead,BufNewFile *.go :set filetype:go
autocmd stdinreadpre * let s:std_in=1
"autocmd vimenter     * if argc() == 0 && !exists("s:std_in") | NERDTree ~/Dropbox/mysite/contents/wiki | endif

augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init()
  "autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

function! HelpFileMode()
  "wincmd _ " Maximze the help on open
  nnoremap <buffer> <tab> :call search('\|.\{-}\|', 'w')<cr>:noh<cr>2l
  nnoremap <buffer> <S-tab> F\|:call search('\|.\{-}\|', 'wb')<cr>:noh<cr>2l
  nnoremap <buffer> <cr> <c-]>
  nnoremap <buffer> <bs> <c-T>
  nnoremap <buffer> q :q<CR>
  setlocal nonumber
endfunction
au filetype help call HelpFileMode()
