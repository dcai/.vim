"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
"""""""""""""""""""""""""""""""""""""""


let s:vimspelldir='$HOME/Dropbox/src/vimspell'
let s:mthesaurfile=s:vimspelldir . '/mthesaur.txt'
let s:spellfile=s:vimspelldir . '/en.utf-8.add'

if empty(glob(expand(s:vimspelldir)))
  execute '!mkdir -p ' . expand(s:vimspelldir)
  " execute '!curl -fLo ' . s:mthesaurfile . ' https://www.gutenberg.org/files/3202/files/mthesaur.txt'
endif

let g:lexical#spell = 1
let g:lexical#thesaurus = [s:mthesaurfile]
let g:lexical#dictionary = ["/usr/share/dict/words",]
let g:lexical#spellfile = [s:spellfile,]
let g:lexical#spelllang = ["en_us","en_au",]
let g:lexical#thesaurus_key = '<leader>lt'
let g:lexical#spell_key = '<leader>ls'
let g:lexical#dictionary_key = '<leader>ld'
