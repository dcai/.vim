""""""""""""""""""""""""""""""""""""""""""""
" Oasis color scheme
"
""""""""""""""""""""""""""""""""""""""""""""

let g:colors_name='oasis'
set background=dark

if exists("syntax_on")
  syntax reset
endif

"""""""""""""""""""""""""""""""""""""
" color reference: https://jonasjacek.github.io/colors/

"""""""""""""""""""""""""""""""""""""
" Black
" DarkBlue
" DarkGreen
" DarkCyan
" DarkRed
" DarkMagenta
" Brown, DarkYellow
" LightGray, LightGrey, Gray, Grey
" DarkGray, DarkGrey
" Blue, LightBlue
" Green, LightGreen
" Cyan, LightCyan
" Red, LightRed
" Magenta, LightMagenta
" Yellow, LightYellow
" White
"""""""""""""""""""""""""""""""""""""

let s:bgcolor="239"
let s:fgcolor="yellow"
let s:valuefg="darkgreen" " js string literal, boolean
let s:commentfg="grey"
let s:datatypefg="green"    " const/let/types
let s:datatypebg="darkgrey" " const/let/types
let s:identifierfg="lightyellow" " js function class name, import/export, function/method name
let s:identifierbg=s:bgcolor     " js function class name, import/export, function/method name
let s:specialfg="darkred"        " js 'this' reference
let s:operatorfg="darkcyan"
let s:operatorbg="239"
let s:statementfg="lightyellow" " jsxmarkup/async/await/return
let s:statementbg="darkgrey"   " jsxmarkup/async/await/return
let s:repeatbg="darkgrey"    " for/while
let s:repeatfg="lightyellow" " for/while
let s:exceptionbg="darkgrey"    " try/catch
let s:exceptionfg="red" " try/catch
let s:conditionalfg="lightgreen" " if/else
let s:conditionalbg="darkgrey"   " if/else

hi clear
hi clear ALEWarning
hi clear ALEError
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
hi clear DiffAdd
hi clear DiffChange
hi clear DiffDelete
hi clear DiffText

function! s:hi(group, value)
  let l:ctermbg = has_key(a:value, 'bg') ? join(["ctermbg", a:value.bg], "=") : ""
  let l:ctermfg = has_key(a:value, 'fg') ? join(["ctermfg", a:value.fg], "=") : ""
  let l:cterm = has_key(a:value, 'cterm') ? join(["cterm", a:value.cterm], "=") : ""
  let l:cmd = join(["hi", a:group, l:cterm, l:ctermbg, l:ctermfg], " ")
  exe l:cmd
endfunction

let s:definition =
\ {
    \ 'Normal': {'bg': s:bgcolor, 'fg': s:fgcolor},
    \ 'Identifier': {'fg': s:identifierfg, 'bg': s:identifierbg, 'cterm': "bold"},
    \ 'Constant': {'fg': s:valuefg},
    \ 'Special': {'fg': s:specialfg},
    \ 'Comment': {'fg': s:commentfg},
    \ 'Type': {'fg': s:datatypefg, 'bg': s:datatypebg},
    \ 'Operator': {'fg': s:operatorfg, 'bg': s:operatorbg},
    \ 'Statement': {'fg': s:statementfg, 'bg': s:statementbg},
    \ 'Repeat': {'fg': s:repeatfg, 'bg': s:repeatbg},
    \ 'Exception': {'fg': s:exceptionfg, 'bg': s:exceptionbg},
    \ 'Conditional': {'fg': s:conditionalfg, 'bg': s:conditionalbg},
    \ 'Directory': {'fg': 'darkcyan'},
    \ 'Error': { 'fg': 'lightgrey', 'bg': 'red', 'cterm': 'bold'},
    \ 'ErrorMsg': {'fg': 'lightgrey', 'bg': 'red', 'cterm': 'bold'},
    \ 'SignColumn': {'bg': 'none'},
    \ 'FoldColumn': {'fg': 'darkgrey' },
    \ 'Folded': {'fg': 'darkgrey'},
    \ 'Ignore': {'fg': 'darkgrey', 'cterm': 'bold'},
    \ 'IncSearch': {'fg': 'green', 'bg': 'darkgreen', 'cterm': 'bold'},
    \ 'ModeMsg': {'fg': 'brown'},
    \ 'MoreMsg': {'fg': 'darkgreen'},
    \ 'NonText':{ 'fg': 'darkblue', 'cterm': 'bold'},
    \ 'PreProc': { 'fg': 'LightCyan' },
    \ 'Question': { 'fg': 'green' },
    \ 'Search': { 'fg': 'black', 'bg': 'green' },
    \ 'SpecialKey': { 'fg': 'darkgreen' },
    \ 'SpellBad': {'fg':'red'},
    \ 'SpellCap': {'fg':'cyan'},
    \ 'Title': { 'fg': 'green'},
    \ 'Underlined': {'cterm': 'underline'},
    \ 'Visual': {'cterm': 'reverse'},
    \ 'VisualNOS': {'cterm': 'bold,underline'},
    \ 'WarningMsg': {'fg': 'darkyellow'},
    \ 'ColorColumn': {'bg':'red'},
    \ 'VertSplit': {'fg': 'lightgreen'},
    \ 'Noise': {'fg': 'red'},
    \ 'jsFuncArgs': {'fg': 'blue'},
    \ 'jsObjectKey': {'fg': 'Magenta'},
    \ 'LineNr': {'fg': 'lightgrey'}
\ }

for [group, value] in items(s:definition)
    call s:hi(group, value)
endfor

"" vim-signify
" hi SignifySignAdd             ctermbg=green
" hi SignifySignChange          ctermbg=yellow ctermfg=darkgrey
" hi SignifySignDelete          ctermbg=red
" hi SignifySignDeleteFirstLine ctermbg=red
"" Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red
"" ALE
" hi ALEWarningLine ctermbg=darkgrey
" hi ALEErrorLine ctermbg=darkgrey
" hi ALEWarning ctermfg=white
" hi ALEError   ctermfg=yellow
