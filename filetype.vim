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
autocmd BufEnter /etc/nginx/* :%s/\s\+$//e
autocmd BufEnter /etc/nginx/* :%s/[ \t\r]\+$//e
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
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
"autocmd BufEnter *.py :%s/\s\+$//e
"autocmd BufEnter *.py :%s/[ \t\r]\+$//e

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
autocmd BufEnter *.php :%s/\s\+$//e
autocmd BufEnter *.php :%s/[ \t\r]\+$//e
au BufRead /tmp/mutt-* set tw=72
autocmd BufRead,BufNewFile *.phps set filetype=php
" Drupal files
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.module set filetype=php
""""""""""""""""""""""""""""""
" Javascript
""""""""""""""""""""""""""""""
autocmd BufEnter *.js :%s/\s\+$//e
autocmd BufEnter *.js :%s/[ \t\r]\+$//e
autocmd BufEnter *.jsx :%s/\s\+$//e
autocmd BufEnter *.jsx :%s/[ \t\r]\+$//e
""""""""""""""""""""""""""""""
" Typescript
""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.ts set filetype=typescript

""""""""""""""""""""""""""""""
" OBJC
"""""""""""""""""""""""""""""""
autocmd BufEnter *.h :%s/\s\+$//e
autocmd BufEnter *.h :%s/[ \t\r]\+$//e

autocmd BufEnter *.m :%s/\s\+$//e
autocmd BufEnter *.m :%s/[ \t\r]\+$//e
""""""""""""""""""""""""""""""
" markdown
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.md set filetype=markdown

""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.scala set filetype=scala
autocmd BufNewFile,BufRead *.less setf less
autocmd BufRead,BufNewFile *.json set filetype=javascript
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
