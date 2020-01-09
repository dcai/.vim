"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
"""""""""""""""""""""""""""""""""""""""


let g:VIMSPELLDIR='$HOME/.local/vim/spell'
let g:MTHESAURFILE=VIMSPELLDIR . '/mthesaur.txt'

" if empty(glob(expand(MTHESAURFILE)))
  " execute '!mkdir -p ' . expand(VIMSPELLDIR)
  " execute '!curl -fLo ' . MTHESAURFILE . ' https://www.gutenberg.org/files/3202/files/mthesaur.txt'
" endif

let g:lexical#spell = 1
let g:lexical#thesaurus = ["~/.vim/thesaurus/mthesaur.txt",]
let g:lexical#dictionary = ["/usr/share/dict/words",]
let g:lexical#spellfile = ["~/.vim/spell/en.utf-8.add",]
let g:lexical#spelllang = ["en_us","en_au",]
let g:lexical#thesaurus_key = '<leader>tt'
let g:lexical#spell_key = '<leader>ss'
let g:lexical#dictionary_key = '<leader>dd'
