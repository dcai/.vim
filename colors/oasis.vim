""""""""""""""""""""""""""""""""""""""""""""
" Oasis color scheme
"
""""""""""""""""""""""""""""""""""""""""""""

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name='oasis'

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
" let s:is_light = (&background == 'light')

let s:blue          = 'blue'
let s:darkblue      = 'darkblue'

let s:green         = 'Green'
let s:darkgreen     = 'DarkGreen'

let s:red           = 'Red'
let s:darkred       = 'DarkRed'

let s:cyan          = 'cyan'
let s:darkcyan      = 'darkcyan'

let s:magenta       = 'Magenta'
let s:darkmagenta   = 'DarkMagenta'

let s:darkgray      = 'darkgray'
let s:gray          = 'Gray'

let s:yellow        = 'yellow'
let s:darkyellow    = 'darkyellow'

let s:black         = 'black'
let s:white         = 'white'

let s:none          = 'NONE'

let s:aleerrorbg    = s:red
let s:aleerrorfg    = s:white
let s:alewarnbg     = s:yellow
let s:alewarnfg     = s:red
let s:bgcolor       = s:black
let s:commentfg     = s:darkgray
let s:conditionalbg = s:green     " if/else, ifelse
let s:conditionalfg = s:black     " if/else, ifelse
let s:datatypefg    = s:green     " const/let/types
let s:fgcolor       = s:green
let s:functionargs  = s:yellow
let s:highlightbg   = s:gray
let s:identifierbg  = s:black     " js function class name, import/export name, function/method name
let s:identifierfg  = s:green     " js function class name, import/export name, function/method name
let s:operatorfg    = s:gray      " + - / *, new is operator too
let s:preprocfg     = s:cyan
let s:repeatfg      = s:yellow    " for/while
let s:searchbg      = s:yellow
let s:searchfg      = s:black
let s:specialfg     = s:darkred   " js 'this' reference
let s:statementfg   = s:yellow    " jsxmarkup/async/await/return/vim's let
let s:stringfg      = s:gray      " js string literal, boolean
let s:valuefg       = s:darkgreen " js string literal, boolean
let s:functionfg    = s:blue
let s:functionbg    = s:black

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
hi clear LineNr
hi clear SignColumn

function! s:hi(group, value)
  let l:defaultfg = has_key(a:value, 'fg') ? a:value.fg : s:magenta
  let l:defaultbg = has_key(a:value, 'bg') ? a:value.bg : s:none

  let l:ctermbg = join(["ctermbg", l:defaultbg], "=")
  let l:ctermfg = join(["ctermfg", l:defaultfg], "=")

  let l:guifg = has_key(a:value, 'guifg') ? join(["guifg", a:value.guifg], "=") : join(['guifg', l:defaultfg], '=')
  let l:guibg = has_key(a:value, 'guibg') ? join(["guibg", a:value.guibg], "=") : join(['guibg', l:defaultbg], '=')

  let l:cterm = has_key(a:value, 'cterm') ? join(["cterm", a:value.cterm], "=") : ""

  let l:cmd = join(["hi", a:group, l:cterm, l:ctermbg, l:ctermfg, l:guifg, l:guibg], " ")
  exe l:cmd
endfunction

let s:standard = {
    \ 'Boolean':                    {'fg': s:valuefg},
    \ 'FloatBorder':                {'fg': s:yellow},
    \ 'ColorColumn':                {'bg': s:none},
    \ 'Comment':                    {'fg': s:commentfg},
    \ 'Conditional':                {'fg': s:conditionalfg, 'bg': s:conditionalbg},
    \ 'Constant':                   {'fg': s:valuefg},
    \ 'Define':                     {'fg': s:operatorfg},
    \ 'DiffAdd':                    {'bg': s:green, 'fg': s:black},
    \ 'DiffChange':                 {'bg': s:yellow, 'fg': s:black},
    \ 'DiffDelete':                 {'bg': s:red, 'fg': s:black},
    \ 'DiffText':                   {'bg': s:blue, 'fg': s:black},
    \ 'Directory':                  {'fg': s:darkcyan},
    \ 'Error':                      {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'ErrorMsg':                   {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'Exception':                  {'fg': s:red, 'bg': s:highlightbg},
    \ 'FoldColumn':                 {'fg': s:darkgray},
    \ 'Folded':                     {'fg': s:darkgray},
    \ 'Function':                   {'fg': s:functionfg, 'bg': s:functionbg},
    \ 'Identifier':                 {'fg': s:identifierfg, 'bg': s:identifierbg, 'cterm': "bold"},
    \ 'Ignore':                     {'fg': s:darkgray, 'cterm': 'bold'},
    \ 'IncSearch':                  {'fg': s:searchfg, 'bg': s:searchbg, 'cterm': 'bold'},
    \ 'Include':                    {'fg': s:operatorfg},
    \ 'Label':                      {'fg': s:operatorfg},
    \ 'LineNr':                     {'fg': s:green, 'bg': s:none},
    \ 'ModeMsg':                    {'fg': s:yellow},
    \ 'MoreMsg':                    {'fg': s:darkgreen},
    \ 'Noise':                      {'fg': s:darkred},
    \ 'NonText':                    {'fg': s:darkcyan, 'cterm': 'bold'},
    \ 'Normal':                     {'fg': s:fgcolor, 'guibg': s:black},
    \ 'NormalFloat':                {'bg': s:darkgray},
    \ 'Number':                     {'fg': s:valuefg},
    \ 'Operator':                   {'fg': s:operatorfg},
    \ 'Pmenu':                      {'bg': s:yellow, 'fg': s:black},
    \ 'PreProc':                    {'fg': s:preprocfg},
    \ 'Question':                   {'fg': s:green},
    \ 'Repeat':                     {'fg': s:repeatfg, 'bg': s:highlightbg},
    \ 'Search':                     {'fg': s:searchfg, 'bg': s:searchbg},
    \ 'SignColumn':                 {'bg': s:none},
    \ 'Special':                    {'fg': s:specialfg},
    \ 'SpecialChar':                {'fg': s:specialfg},
    \ 'SpecialKey':                 {'fg': s:darkgreen},
    \ 'SpellBad':                   {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellCap':                   {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellLocal':                 {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellRare':                  {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'Statement':                  {'fg': s:statementfg},
    \ 'StorageClass':               {'fg': s:darkred},
    \ 'String':                     {'fg': s:stringfg},
    \ 'Title':                      {'fg': s:green},
    \ 'Type':                       {'fg': s:datatypefg},
    \ 'Underlined':                 {'cterm': 'underline'},
    \ 'VertSplit':                  {'fg': s:green},
    \ 'Visual':                     {'cterm': 'reverse', 'guibg': s:darkgreen, 'guifg': s:white},
    \ 'VisualNOS':                  {'cterm': 'bold,underline'},
    \ 'WarningMsg':                 {'fg': s:yellow},
\ }

for [group, value] in items(s:standard)
    call s:hi(group, value)
endfor

let s:custom = {
    \ 'FzfLuaNormal':               {'fg': s:yellow},
    \ 'ALEError':                   {'fg': s:aleerrorfg, 'bg': s:aleerrorbg, 'cterm': 'bold,underline'},
    \ 'ALEErrorSign':               {'bg': s:darkred, 'cterm': 'bold'},
    \ 'ALEWarning':                 {'fg': s:alewarnfg, 'bg': s:alewarnbg, 'cterm': 'underline'},
    \ 'ALEWarningSign':             {'bg': s:yellow, 'fg': s:black, 'cterm': 'bold'},
    \ 'CocErrorFloat':              {'fg': s:red},
    \ 'CocHighlightText':           {'bg': s:red, 'fg': s:white},
    \ 'CocHintFloat':               {'fg': s:black},
    \ 'CocInfoFloat':               {'fg': s:blue},
    \ 'CocWarningFloat':            {'fg': s:red},
    \ 'CocMenuSel':                 {'bg': s:red},
    \ 'CocSearch':                  {'fg': s:darkblue},
    \ 'SignifySignAdd':             {'fg': s:green},
    \ 'SignifySignChange':          {'fg': s:yellow},
    \ 'SignifySignDelete':          {'fg': s:darkred},
    \ 'SignifySignDeleteFirstLine': {'fg': s:darkred},
\ }

for [group, value] in items(s:custom)
    call s:hi(group, value)
endfor

" javascript syntax definitions:
" https://github.com/pangloss/vim-javascript/blob/1.2.5.1/syntax/javascript.vim#L243-L363
let s:js = {
    \ 'jsxTagName':  {'fg': s:green},
    \ 'tsxTagName':  {'fg': s:green},
    \ 'jsxElement':  {'fg': s:red},
    \ 'jsFuncArgs':  {'fg': s:functionargs},
    \ 'jsObjectKey': {'fg': s:red, 'bg': s:darkgreen},
\ }
for [group, value] in items(s:js)
    call s:hi(group, value)
endfor


"" Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red
