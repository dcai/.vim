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
" color reference:
"   - https://jonasjacek.github.io/colors/
"   - https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

""" :h color-xterm
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" | NR-16 | NR-8 |             COLORNAME              |
" |  --   |  --  |                 --                 |
" |   0   |  0   |               Black                |
" |   1   |  4   |              DarkBlue              |
" |   2   |  2   |             DarkGreen              |
" |   3   |  6   |              DarkCyan              |
" |   4   |  1   |              DarkRed               |
" |   5   |  5   |            DarkMagenta             |
" |   6   |  3   |         Brown, DarkYellow          |
" |   7   |  7   | LightGray, LightGrey,   Gray, Grey |
" |   8   |  0*  |         DarkGray, DarkGrey         |
" |   9   |  4*  |          Blue, LightBlue           |
" |  10   |  2*  |         Green, LightGreen          |
" |  11   |  6*  |          Cyan, LightCyan           |
" |  12   |  1*  |           Red, LightRed            |
" |  13   |  5*  |       Magenta, LightMagenta        |
" |  14   |  3*  |        Yellow, LightYellow         |
" |  15   |  7*  |               White                |
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:bgcolor="none"
let s:fgcolor="yellow"
let s:valuefg="darkgreen" " js string literal, boolean
let s:commentfg="gray"
let s:datatypefg="green"    " const/let/types
let s:identifierfg="lightyellow" " js function class name, import/export, function/method name
let s:identifierbg=s:bgcolor     " js function class name, import/export, function/method name
let s:specialfg="darkred"        " js 'this' reference
let s:operatorfg="blue"          " + - / *, new is operator too
let s:statementfg="lightyellow" " jsxmarkup/async/await/return
let s:repeatfg="lightyellow" " for/while
let s:conditionalfg="lightgreen" " if/else
let s:highlightbg='darkgray'

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
    \ 'Type': {'fg': s:datatypefg},
    \ 'Operator': {'fg': s:operatorfg, 'bg': s:highlightbg},
    \ 'Statement': {'fg': s:statementfg},
    \ 'Repeat': {'fg': s:repeatfg, 'bg': s:highlightbg},
    \ 'Exception': {'fg': 'red', 'bg': s:highlightbg},
    \ 'Conditional': {'fg': s:conditionalfg, 'bg': s:highlightbg},
    \ 'Directory': {'fg': 'darkcyan'},
    \ 'Error': {'fg': 'lightgray', 'bg': 'red', 'cterm': 'bold'},
    \ 'ErrorMsg': {'fg': 'lightgray', 'bg': 'red', 'cterm': 'bold'},
    \ 'SignColumn': {'bg': 'none'},
    \ 'FoldColumn': {'fg': 'darkgray'},
    \ 'Folded': {'fg': 'darkgray'},
    \ 'Ignore': {'fg': 'darkgray', 'cterm': 'bold'},
    \ 'IncSearch': {'fg': 'green', 'bg': 'darkgreen', 'cterm': 'bold'},
    \ 'ModeMsg': {'fg': 'brown'},
    \ 'MoreMsg': {'fg': 'darkgreen'},
    \ 'NonText':{'fg': 'darkblue', 'cterm': 'bold'},
    \ 'PreProc': {'fg': 'LightCyan'},
    \ 'Question': {'fg': 'green'},
    \ 'Search': {'fg': 'black', 'bg': 'green'},
    \ 'SpecialKey': {'fg': 'darkgreen'},
    \ 'SpellBad': {'bg':'red', 'fg': 'white', 'cterm': 'underline' },
    \ 'SpellCap': {'bg':'red', 'fg': 'white', 'cterm': 'underline' },
    \ 'SpellRare': {'bg':'red', 'fg': 'white', 'cterm': 'underline' },
    \ 'SpellLocal': {'bg':'red', 'fg': 'white', 'cterm': 'underline' },
    \ 'Title': { 'fg': 'green'},
    \ 'Underlined': {'cterm': 'underline'},
    \ 'Visual': {'cterm': 'reverse'},
    \ 'VisualNOS': {'cterm': 'bold,underline'},
    \ 'WarningMsg': {'fg': 'brown'},
    \ 'ColorColumn': {'bg':'red'},
    \ 'VertSplit': {'fg': 'lightgreen'},
    \ 'Noise': {'fg': 'darkred'},
    \ 'jsFuncArgs': {'fg': 'blue'},
    \ 'jsObjectKey': {'fg': 'lightgreen', 'bg': s:highlightbg},
    \ 'LineNr': {'fg': 'lightgray'},
    \ 'DiffAdd':  {'bg': 'green', 'fg': 'white'},
    \ 'DiffChange':  {'bg': 'yellow', 'fg': 'black'},
    \ 'DiffDelete':  {'bg': 'red', 'fg': 'white'},
    \ 'DiffText':  {'bg': 'blue', 'fg': 'white'},
    \ 'SignifySignAdd': {'bg': 'green', 'fg': 'black'},
    \ 'SignifySignChange': {'bg':'yellow', 'fg': 'darkgray'},
    \ 'SignifySignDelete': {'bg': 'DarkRed'},
    \ 'SignifySignDeleteFirstLine': {'bg': 'DarkRed'}
\ }

for [group, value] in items(s:definition)
    call s:hi(group, value)
endfor

"" Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red
"" ALE
" hi ALEWarningLine ctermbg=darkgray
" hi ALEErrorLine ctermbg=darkgray
" hi ALEWarning ctermfg=white
" hi ALEError   ctermfg=yellow
