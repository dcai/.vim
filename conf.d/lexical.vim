"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
""" https://github.com/reedes/vim-lexical
"""""""""""""""""""""""""""""""""""""""

set spelllang=en,cjk
set nospell
set spellcapcheck=

let s:vimspelldir='$HOME/.local/vim/spell'
let s:mthesaurfile=s:vimspelldir . '/mthesaur.txt'
" let s:spellfile=s:vimspelldir . '/en.utf-8.add'
let s:spellfile='$HOME/Library/CloudStorage/Dropbox/en.utf-8.add'

if empty(glob(expand(s:vimspelldir)))
  execute '!mkdir -p ' . expand(s:vimspelldir)
endif

function! DownloadMthesaurfile()
  execute '!curl -fLo ' . s:mthesaurfile . ' https://www.gutenberg.org/files/3202/files/mthesaur.txt'
endfunction

let g:lexical#spell = 1
let g:lexical#thesaurus = [s:mthesaurfile]
let g:lexical#dictionary = ["/usr/share/dict/words",]
let g:lexical#spellfile = [s:spellfile,]
let g:lexical#spelllang = ["en_us","en_au",]

function! EnableLexical(v)
  if !exists('g:loaded_lexical')
    return
  endif
  call lexical#init({'spell': a:v})
endfunction

command! -nargs=0 EnableSpell call EnableLexical(1)
command! -nargs=0 DisableSpell call EnableLexical(0)

augroup lexical
  autocmd!
  autocmd FileType * call EnableLexical(0)
  autocmd FileType markdown call EnableLexical(1)
  autocmd FileType text call EnableLexical(1)
  autocmd FileType typescript call EnableLexical(1)
  autocmd FileType javascript call EnableLexical(1)
augroup END
