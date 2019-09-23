" Spelling {{{
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

" PYTHON {{{
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
autocmd BufWritePre *.py call TrimWhiteSpace()
" }}}

" PHP {{{
" highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
autocmd FileType php let php_sql_query=1
" does exactly that. highlights html inside of php strings
"autocmd FileType php let php_htmlInStrings=1
" discourages use oh short tags. c'mon its deprecated remember
autocmd FileType php let php_noShortTags=1
autocmd FileType php let b:delimitMate_matchpairs = "(:),[:],{:}"
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
" }}}


au BufNewFile,BufRead *.prisma setfiletype graphql

""""""""""""""""""""""""""""""
" Typescript
""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.ts set filetype=typescript

""""""""""""""""""""""""""""""
" markdown
"""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.md set filetype=markdown

" Misc {{{
autocmd BufRead /tmp/mutt-* set tw=72
autocmd BufRead,BufNewFile *.scala set filetype=scala
autocmd BufRead,BufNewFile *gitconfig* set filetype=gitconfig
autocmd BufRead,BufNewFile */git/* set filetype=gitconfig
autocmd BufRead,BufNewFile *.less setf less
autocmd BufRead,BufNewFile *conkyrc set filetype=conkyrc
autocmd BufRead,BufNewFile *.go :set filetype:go
autocmd stdinreadpre * let s:std_in=1
autocmd BufRead,BufNewFile */vimwiki/* set filetype=vimwiki
" autocmd vimenter * if argc() == 0 && !exists("s:std_in") | NERDTree ~/Dropbox/mysite/contents/wiki | endif
" }}}

" Lexmed {{{
if exists(':LexMed')
  augroup lexical
    autocmd!
    autocmd FileType markdown,mkd call lexical#init()
    autocmd FileType textile call lexical#init()
    autocmd FileType text call lexical#init()
    "autocmd FileType text call lexical#init({ 'spell': 0 })
  augroup END
endif
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
