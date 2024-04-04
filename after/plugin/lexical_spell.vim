"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
""" https://github.com/reedes/vim-lexical
"""""""""""""""""""""""""""""""""""""""

set spelllang=en,cjk
set nospell
set spellcapcheck=

let s:dropboxspelldir=g:dropbox_home . '/src/vimspell'
let s:mthesaurfile=expand(s:dropboxspelldir . '/mthesaur.txt')
let s:spellfile=expand(s:dropboxspelldir . '/en.utf-8.add')

function! DownloadMthesaurfile()
  execute '!curl -fLo ' . s:mthesaurfile . ' https://www.gutenberg.org/files/3202/files/mthesaur.txt'
endfunction

let g:lexical#spell = 1
let g:lexical#dictionary = ["/usr/share/dict/words",]
let g:lexical#spelllang = ["en_us","en_au",]

if filereadable(s:mthesaurfile)
  let g:lexical#thesaurus = [s:mthesaurfile]
endif

if filereadable(s:spellfile)
  let g:lexical#spellfile = [s:spellfile,]
endif

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
  " disable all by default
  autocmd FileType * call EnableLexical(0)
  " enable below
  autocmd FileType go call EnableLexical(1)
  autocmd FileType javascript call EnableLexical(1)
  autocmd FileType javascriptreact call EnableLexical(1)
  autocmd FileType lua call EnableLexical(1)
  autocmd FileType org call EnableLexical(1)
  autocmd FileType python call EnableLexical(1)
  autocmd FileType text call EnableLexical(1)
  autocmd FileType typescript call EnableLexical(1)
  autocmd FileType typescriptreact call EnableLexical(1)
  autocmd FileType vim call EnableLexical(1)
augroup END
