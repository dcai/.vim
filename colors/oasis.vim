""""""""""""""""""""""""""""""""""""""""""""
" Oasis color scheme
"
""""""""""""""""""""""""""""""""""""""""""""

let g:colors_name='oasis'

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

let s:is_light = (&background == 'light')
if s:is_light
  set background=light
  let s:bgcolor       = "none"
  let s:fgcolor       = "darkgreen"
  let s:statementfg   = "darkyellow"
  let s:datatypefg    = "darkgreen"
  let s:identifierfg  = "darkgreen"
  let s:conditionalfg = "darkgreen"
  let s:repeatfg      = "darkyellow"
  let s:preprocfg     = 'darkcyan'
  let s:stringfg      = "darkgray"
else
  set background=dark
  let s:bgcolor       = "none"
  let s:fgcolor       = "green"
  let s:statementfg   = "lightyellow" " jsxmarkup/async/await/return
  let s:datatypefg    = "green"       " const/let/types
  let s:identifierfg  = "lightgreen"  " js function class name, import/export, function/method name
  let s:conditionalfg = "lightgreen"  " if/else
  let s:repeatfg      = "lightyellow" " for/while
  let s:preprocfg     = 'cyan'
  let s:stringfg      = "red"        " js string literal, boolean
endif

let s:valuefg       = "darkgreen"   " js string literal, boolean
let s:commentfg     = "darkgray"
let s:identifierbg  = s:bgcolor     " js function class name, import/export, function/method name
let s:specialfg     = "darkred"     " js 'this' reference
let s:operatorfg    = "blue"        " + - / *, new is operator too
let s:highlightbg   = 'darkgray'
let s:black         = 'black'
let s:blue          = 'blue'
let s:brown         = 'brown'
let s:darkcyan      = 'darkcyan'
let s:darkgray      = 'darkgray'
let s:darkgreen     = 'darkgreen'
let s:darkred       = 'darkred'
let s:green         = 'green'
let s:lightgray     = 'lightgray'
let s:none          = 'none'
let s:red           = 'red'
let s:white         = 'white'
let s:yellow        = 'yellow'

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
    \ 'ALEError':                   {'cterm': 'bold,underline'},
    \ 'ALEErrorSign':               {'bg': s:darkred, 'cterm': 'bold'},
    \ 'ALEWarning':                 {'cterm': 'underline'},
    \ 'ALEWarningSign':             {'bg': s:yellow, 'fg': s:black, 'cterm': 'bold'},
    \ 'Boolean':                    {'fg': s:valuefg},
    \ 'ColorColumn':                {'bg': s:red},
    \ 'Comment':                    {'fg': s:commentfg},
    \ 'Conditional':                {'fg': s:conditionalfg, 'bg': s:highlightbg},
    \ 'Constant':                   {'fg': s:valuefg},
    \ 'Define':                     {'fg': s:operatorfg},
    \ 'DiffAdd':                    {'bg': s:green, 'fg': s:white},
    \ 'DiffChange':                 {'bg': s:yellow, 'fg': s:black},
    \ 'DiffDelete':                 {'bg': s:red, 'fg': s:white},
    \ 'DiffText':                   {'bg': s:blue, 'fg': s:white},
    \ 'Directory':                  {'fg': s:darkcyan},
    \ 'Error':                      {'fg': s:lightgray, 'bg': s:red, 'cterm': 'bold'},
    \ 'ErrorMsg':                   {'fg': s:lightgray, 'bg': s:red, 'cterm': 'bold'},
    \ 'Exception':                  {'fg': s:red, 'bg': s:highlightbg},
    \ 'FoldColumn':                 {'fg': s:darkgray},
    \ 'Folded':                     {'fg': s:darkgray},
    \ 'Function':                   {'fg': s:operatorfg},
    \ 'Identifier':                 {'fg': s:identifierfg, 'bg': s:identifierbg, 'cterm': "bold"},
    \ 'Ignore':                     {'fg': s:darkgray, 'cterm': 'bold'},
    \ 'IncSearch':                  {'fg': s:green, 'bg': s:darkgreen, 'cterm': 'bold'},
    \ 'Include':                    {'fg': s:operatorfg},
    \ 'Label':                      {'fg': s:operatorfg},
    \ 'LineNr':                     {'fg': s:lightgray},
    \ 'ModeMsg':                    {'fg': s:brown},
    \ 'MoreMsg':                    {'fg': s:darkgreen},
    \ 'Noise':                      {'fg': s:darkred},
    \ 'NonText':                    {'fg': s:darkcyan, 'cterm': 'bold'},
    \ 'Normal':                     {'bg': s:bgcolor, 'fg': s:fgcolor},
    \ 'NormalFloat':                {'bg': s:white},
    \ 'Pmenu':                      {'bg': s:yellow, 'fg': s:black},
    \ 'Number':                     {'fg': s:valuefg},
    \ 'Operator':                   {'fg': s:operatorfg},
    \ 'PreProc':                    {'fg': s:preprocfg},
    \ 'Question':                   {'fg': s:green},
    \ 'Repeat':                     {'fg': s:repeatfg, 'bg': s:highlightbg},
    \ 'Search':                     {'fg': s:black, 'bg': s:green},
    \ 'SignColumn':                 {'bg': s:none},
    \ 'SignifySignAdd':             {'fg': s:green},
    \ 'SignifySignChange':          {'fg': s:yellow},
    \ 'SignifySignDelete':          {'fg': s:darkred},
    \ 'SignifySignDeleteFirstLine': {'fg': s:darkred},
    \ 'StorageClass':               {'fg': s:darkred},
    \ 'Special':                    {'fg': s:specialfg},
    \ 'SpecialChar':                {'fg': s:specialfg},
    \ 'SpecialKey':                 {'fg': s:darkgreen},
    \ 'SpellBad':                   {'bg': s:red, 'fg': s:white, 'cterm': 'underline'},
    \ 'SpellCap':                   {'bg': s:red, 'fg': s:white, 'cterm': 'underline'},
    \ 'SpellLocal':                 {'bg': s:red, 'fg': s:white, 'cterm': 'underline'},
    \ 'SpellRare':                  {'bg': s:red, 'fg': s:white, 'cterm': 'underline'},
    \ 'Statement':                  {'fg': s:statementfg},
    \ 'String':                     {'fg': s:stringfg},
    \ 'Title':                      {'fg': s:green},
    \ 'Type':                       {'fg': s:datatypefg},
    \ 'Underlined':                 {'cterm': 'underline'},
    \ 'VertSplit':                  {'fg': s:green},
    \ 'Visual':                     {'cterm': 'reverse'},
    \ 'VisualNOS':                  {'cterm': 'bold,underline'},
    \ 'WarningMsg':                 {'fg': s:brown},
    \ 'jsFuncArgs':                 {'fg': s:blue},
    \ 'jsObjectKey':                {'fg': s:green, 'bg': s:highlightbg},
    \ 'CocErrorFloat':              {'fg': s:red},
    \ 'CocWarningFloat':            {'fg': s:red},
    \ 'CocInfoFloat':               {'fg': s:blue},
    \ 'CocHintFloat':               {'fg': s:black},
\ }

for [group, value] in items(s:definition)
    call s:hi(group, value)
endfor

"" Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red
