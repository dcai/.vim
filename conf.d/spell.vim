"""""""""""""""""""""""""""""""""""""""
""" vim-lexical
""" https://github.com/reedes/vim-lexical
"""""""""""""""""""""""""""""""""""""""

set spelllang=en
set nospell

let s:vimspelldir='$HOME/.local/vim/spell'
let s:mthesaurfile=s:vimspelldir . '/mthesaur.txt'
let s:spellfile=s:vimspelldir . '/en.utf-8.add'

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
  autocmd FileType markdown,mkd call EnableLexical(1)
  autocmd FileType textile call EnableLexical(1)
  autocmd FileType text call EnableLexical(1)
  autocmd FileType org call EnableLexical(1)
  autocmd FileType gitcommit call EnableLexical(1)
  autocmd FileType vimwiki call EnableLexical(1)

  autocmd FileType vim call EnableLexical(0)
  autocmd FileType javascript call EnableLexical(0)
  autocmd FileType python call EnableLexical(0)
  autocmd FileType php call EnableLexical(0)
  autocmd FileType lua call EnableLexical(0)
  autocmd FileType fish call EnableLexical(0)
augroup END

"""""""""""""""""""""""""""""""""""""""
""" fzf spell
"""""""""""""""""""""""""""""""""""""""
" https://coreyja.com/vim-spelling-suggestions-fzf/
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  " google autosuggest
  " let suggestions = systemlist('gg ' . expand("<cword>"))
  return fzf#run(extend(
        \ {'source': suggestions, 'sink': function("FzfSpellSink")},
        \ s:fzf_base_options))
endfunction
nnoremap z= :call FzfSpell()<CR>
