autocmd BufNewFile,BufRead * if search('{{ block .\+}}', 'nw') | setlocal filetype=gotmpl | endif
