"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
""" https://github.com/reedes/vim-lexical
"""""""""""""""""""""""""""""""""""""""

set spelllang=en

let s:vimspelldir='$HOME/.local/vim/spell'
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

augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init()
  autocmd FileType org call lexical#init()
augroup END
