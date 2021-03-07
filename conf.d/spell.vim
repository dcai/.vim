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

command! -nargs=0 EnableSpell call lexical#init()

augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init()
  autocmd FileType org call lexical#init()
  autocmd FileType gitcommit call lexical#init()
  autocmd FileType vimwiki call lexical#init()
augroup END

let g:enable_spelunker_vim = 0
function! SpelaunkerConfig()
  " Enable spelunker.vim. (default: 1)
  let g:enable_spelunker_vim = 1

  " Enable spelunker.vim on readonly files or buffer. (default: 0)
  let g:enable_spelunker_vim_on_readonly = 0
  " Check spelling for words longer than set characters. (default: 4)
  let g:spelunker_target_min_char_len = 4

  " Max amount of word suggestions. (default: 15)
  let g:spelunker_max_suggest_words = 15

  " Max amount of highlighted words in buffer. (default: 100)
  let g:spelunker_max_hi_words_each_buf = 100

  " Spellcheck type: (default: 1)
  " 1: File is checked for spelling mistakes when opening and saving. This
  " may take a bit of time on large files.
  " 2: Spellcheck displayed words in buffer. Fast and dynamic. The waiting time
  " depends on the setting of CursorHold `set updatetime=1000`.
  let g:spelunker_check_type = 1

  " Highlight type: (default: 1)
  " 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
  " 2: Highlight only SpellBad.
  " FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
  let g:spelunker_highlight_type = 1

  " Option to disable word checking.
  " Disable URI checking. (default: 0)
  let g:spelunker_disable_uri_checking = 1

  " Disable email-like words checking. (default: 0)
  let g:spelunker_disable_email_checking = 1

  " Disable account name checking, e.g. @foobar, foobar@. (default: 0)
  " NOTE: Spell checking is also disabled for JAVA annotations.
  let g:spelunker_disable_account_name_checking = 1

  " Disable acronym checking. (default: 0)
  let g:spelunker_disable_acronym_checking = 1

  " Disable checking words in backtick/backquote. (default: 0)
  let g:spelunker_disable_backquoted_checking = 1

  " Disable default autogroup. (default: 0)
  let g:spelunker_disable_auto_group = 1

  " Create own custom autogroup to enable spelunker.vim for specific filetypes.
  augroup spelunker
    autocmd!
    " Setting for g:spelunker_check_type = 1:
    autocmd BufWinEnter,BufWritePost *.vim,*.js,*.jsx,*.json,*.md,*.php call spelunker#check()

    " Setting for g:spelunker_check_type = 2:
    autocmd CursorHold *.vim,*.js,*.jsx,*.json,*.md,*.php call spelunker#check_displayed_words()
  augroup END

  " Override highlight group name of incorrectly spelled words.
  let g:spelunker_spell_bad_group = 'SpellBad'

  " Override highlight group name of complex or compound words.
  let g:spelunker_complex_or_compound_word_group = 'SpelunkerComplexOrCompoundWord'

  " Override highlight setting.
  " highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE
endfunction

" call SpelaunkerConfig()
