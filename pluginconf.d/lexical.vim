"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
"""""""""""""""""""""""""""""""""""""""
let g:lexical#spell = 1
let g:lexical#thesaurus = ['~/.vim/thesaurus/mthesaur.txt',]
let g:lexical#dictionary = ['/usr/share/dict/words',]
" vim spellfile must end with .{encoding}.add
"set spellfile=~/Dropbox/etc/user.dict.utf-8.add
let g:lexical#spellfile = ['~/.vim/spell/en.utf-8.add',]
let g:lexical#spelllang = ['en_us','en_au',]
let g:lexical#thesaurus_key = '<leader>tt'
let g:lexical#spell_key = '<leader>ss'
let g:lexical#dictionary_key = '<leader>dd'
