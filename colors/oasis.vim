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

let s:defaultbg     = s:none
let s:defaultfg     = s:white

let s:aleerrorbg    = s:red
let s:aleerrorfg    = s:white
let s:alewarnbg     = s:yellow
let s:alewarnfg     = s:red
let s:commentfg     = s:darkgray
let s:functionargs  = s:yellow
" js function class name, import/export name, function/method name
" variable names
let s:identifierfg  = s:darkyellow
let s:identifierbg  = s:darkgray

let s:variablefg  = s:blue
let s:variablebg  = s:black

let s:fieldfg  = s:yellow
let s:fieldbg  = s:none

" import is operator too
let s:includefg     = s:darkgray
let s:includebg     = s:none
let s:keyword       = s:cyan
" for/while
let s:repeatfg      = s:yellow
" if/else, ifelse, ternary operator
let s:conditionalfg = s:cyan
let s:conditionalbg = s:darkgray

let s:searchbg      = s:darkyellow
let s:searchfg      = s:black
" js 'this' reference
let s:specialfg     = s:red
let s:specialbg     = s:white
" for regular vim: jsxmarkup/async/await/return/vim's let
let s:statementfg   = s:yellow
" js string literal
let s:stringfg      = s:gray
let s:constantfg    = s:darkgreen
let s:boolean       = s:blue
let s:labelfg       = s:green
let s:functionfg    = s:green
let s:functionbg    = s:darkgray
" imported object/class/enum
let s:typefg        = s:darkyellow
let s:typebg        = s:none
" export/const/await/async/new/as
let s:keywordfg     = s:cyan
let s:keywordbg     = s:black
" = > semicolon brackets
let s:delimiterfg   = s:yellow
let s:delimiterbg   = s:none
" + - / * =
let s:operatorfg    = s:red
let s:exceptionfg   = s:red

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
  let l:fgcolor = has_key(a:value, 'fg') ? a:value.fg : s:defaultfg
  let l:bgcolor = has_key(a:value, 'bg') ? a:value.bg : s:defaultbg

  let l:ctermbg = join(["ctermbg", l:bgcolor], "=")
  let l:ctermfg = join(["ctermfg", l:fgcolor], "=")

  let l:guifg = has_key(a:value, 'guifg') ? join(["guifg", a:value.guifg], "=") : join(['guifg', l:fgcolor], '=')
  let l:guibg = has_key(a:value, 'guibg') ? join(["guibg", a:value.guibg], "=") : join(['guibg', l:bgcolor], '=')

  let l:cterm = has_key(a:value, 'cterm') ? join(["cterm", a:value.cterm], "=") : ""

  let l:cmd = join(["hi", a:group, l:cterm, l:ctermbg, l:ctermfg, l:guifg, l:guibg], " ")
  exe l:cmd
endfunction

let s:ui = {
    \ 'ColorColumn':                {'bg': s:none},
    \ 'DiffAdd':                    {'bg': s:green, 'fg': s:black},
    \ 'DiffChange':                 {'bg': s:yellow, 'fg': s:black},
    \ 'DiffDelete':                 {'bg': s:red, 'fg': s:black},
    \ 'DiffText':                   {'bg': s:blue, 'fg': s:black},
    \ 'Directory':                  {'fg': s:darkcyan},
    \ 'ErrorMsg':                   {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'FloatBorder':                {'fg': s:blue},
    \ 'FoldColumn':                 {'fg': s:darkgray},
    \ 'Folded':                     {'fg': s:darkgray},
    \ 'IncSearch':                  {'fg': s:searchfg, 'bg': s:searchbg, 'cterm': 'bold'},
    \ 'LineNr':                     {'fg': s:green, 'bg': s:none},
    \ 'MatchParen':                 {'bg': s:none, 'fg': s:red},
    \ 'ModeMsg':                    {'fg': s:yellow},
    \ 'MoreMsg':                    {'fg': s:darkgreen},
    \ 'Noise':                      {'fg': s:gray},
    \ 'NonText':                    {'fg': s:darkcyan, 'cterm': 'bold'},
    \ 'Normal':                     {'fg': s:defaultfg, 'guibg': s:black},
    \ 'NormalFloat':                {'bg': s:darkgray, 'fg': s:green},
    \ 'NormalNC':                   {'fg': s:gray},
    \ 'Pmenu':                      {'bg': s:blue, 'fg': s:blue},
    \ 'PmenuSbar':                  {'bg': s:blue},
    \ 'PmenuSel':                   {'bg': s:red, 'fg': s:red},
    \ 'PmenuThumb':                 {'bg': s:yellow},
    \ 'Question':                   {'fg': s:green},
    \ 'Quote':                      {'fg': s:yellow},
    \ 'Search':                     {'fg': s:searchfg, 'bg': s:searchbg},
    \ 'SignColumn':                 {'bg': s:none},
    \ 'SpellBad':                   {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellCap':                   {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellLocal':                 {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'SpellRare':                  {'fg': s:darkyellow, 'cterm': 'underline'},
    \ 'Title':                      {'fg': s:green, 'bg': s:darkgray},
    \ 'Underlined':                 {'cterm': 'underline'},
    \ 'VertSplit':                  {'fg': s:green},
    \ 'Visual':                     {'cterm': 'reverse', 'guibg': s:darkgreen, 'guifg': s:white},
    \ 'VisualNOS':                  {'cterm': 'bold,underline'},
    \ 'WarningMsg':                 {'fg': s:yellow},
\ }

for [group, value] in items(s:ui)
    call s:hi(group, value)
endfor

let s:syntax = {
    \ 'Boolean':                    {'fg': s:boolean},
    \ 'Character':                  {'fg': s:red},
    \ 'Comment':                    {'fg': s:commentfg},
    \ 'Conditional':                {'fg': s:conditionalfg, 'bg': s:conditionalbg},
    \ 'Constant':                   {'fg': s:constantfg},
    \ 'Debug':                      {'fg': s:gray},
    \ 'Define':                     {'bg': s:red},
    \ 'Delimiter':                  {'fg': s:delimiterfg, 'bg': s:delimiterbg},
    \ 'Error':                      {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'Exception':                  {'fg': s:red, 'bg': s:none},
    \ 'Function':                   {'fg': s:functionfg, 'bg': s:functionbg},
    \ 'Identifier':                 {'fg': s:identifierfg, 'bg': s:identifierbg},
    \ 'Ignore':                     {'fg': s:darkgray, 'cterm': 'bold'},
    \ 'Include':                    {'fg': s:includefg, 'bg': s:includebg},
    \ 'Keyword':                    {'fg': s:keywordfg,  'bg': s:keywordbg},
    \ 'Label':                      {'fg': s:labelfg},
    \ 'Macro':                      {'fg': s:red},
    \ 'Number':                     {'fg': s:blue},
    \ 'Operator':                   {'fg': s:operatorfg},
    \ 'PreCondit':                  {'fg': s:keyword},
    \ 'PreProc':                    {'fg': s:keyword},
    \ 'Repeat':                     {'fg': s:repeatfg},
    \ 'Special':                    {'fg': s:specialfg, 'bg': s:specialbg},
    \ 'SpecialKey':                 {'fg': s:specialfg, 'bg': s:specialbg},
    \ 'Statement':                  {'fg': s:statementfg},
    \ 'StorageClass':               {'fg': s:darkred},
    \ 'String':                     {'fg': s:stringfg},
    \ 'Structure':                  {'fg': s:red},
    \ 'Tag':                        {'fg': s:red},
    \ 'Todo':                       {'fg': s:red},
    \ 'Type':                       {'fg': s:typefg, 'bg': s:typebg},
    \ 'Typedef':                    {'fg': s:red},
\ }

for [group, value] in items(s:syntax)
    call s:hi(group, value)
endfor

let s:custom = {
    \ 'ALEVirtualTextError':        {'fg': s:darkgray, 'bg': s:none, 'cterm': 'italic'},
    \ 'ALEVirtualTextWarning':      {'fg': s:darkgray, 'bg': s:none},
    \ 'ALEVirtualTextInfo':         {'fg': s:darkgray, 'bg': s:none},
    \ 'ALEError':                   {'fg': s:none, 'bg': s:aleerrorbg, 'cterm': 'bold,underline'},
    \ 'ALEErrorSign':               {'bg': s:darkred, 'cterm': 'bold'},
    \ 'ALEWarning':                 {'fg': s:none, 'bg': s:alewarnbg, 'cterm': 'underline'},
    \ 'ALEWarningSign':             {'bg': s:yellow, 'fg': s:black, 'cterm': 'bold'},
    \ 'CocErrorFloat':              {'fg': s:red},
    \ 'CocHighlightText':           {'bg': s:red, 'fg': s:white},
    \ 'CocHintFloat':               {'fg': s:black},
    \ 'CocInfoFloat':               {'fg': s:blue},
    \ 'CocMenuSel':                 {'bg': s:red},
    \ 'CocSearch':                  {'fg': s:darkblue},
    \ 'CocWarningFloat':            {'fg': s:red},
    \ 'SignifySignAdd':             {'fg': s:green},
    \ 'SignifySignChange':          {'fg': s:yellow},
    \ 'SignifySignDelete':          {'fg': s:darkred},
    \ 'SignifySignDeleteFirstLine': {'fg': s:darkred},
\ }

for [group, value] in items(s:custom)
    call s:hi(group, value)
endfor

let s:cmp = {
    \ 'CmpItemAbbrDeprecated':  {'fg': s:green, 'bg': s:none},
    \ 'CmpItemAbbrMatch':  {'fg': s:black, 'bg': s:green},
    \ 'CmpItemMenu':  {'fg': s:green, 'bg': s:none},
    \ 'CmpItemKind':  {'fg': s:yellow, 'bg': s:none},
    \ 'CmpItemKindFunction':  {'fg': s:blue, 'bg': s:none},
    \ 'CmpItemKindMethod':  {'fg': s:magenta, 'bg': s:none},
    \ 'CmpItemKindKeyword':  {'fg': s:red, 'bg': s:none},
    \ 'CmpItemKindVariable':  {'fg': s:cyan, 'bg': s:none},
\ }
for [group, value] in items(s:cmp)
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

let s:active = {'fg': s:black, 'bg': s:yellow, 'cterm': 'none'}
let s:inactive = {'fg': s:white, 'bg': s:darkgray, 'cterm': 'none'}
let s:insertmode = {'fg': s:white, 'bg': s:darkred, 'cterm': 'none'}

call s:hi('statusline', s:active)
call s:hi('statuslineNC', s:inactive)

" https://neovim.io/doc/user/treesitter.html#treesitter-highlight
let s:treesitter = {
    \ '@boolean':          {'fg': s:boolean},
    \ '@attribute':        {'fg': s:red},
    \ '@repeat':           {'fg': s:repeatfg},
    \ '@keyword':          {'fg': s:keyword},
    \ '@keyword.function': {'fg': s:yellow},
    \ '@keyword.return':   {'fg': s:blue},
    \ '@keyword.operator': {'fg': s:operatorfg},
    \ '@function':         {'fg': s:functionfg, 'bg': s:functionbg},
    \ '@conditional':      {'fg': s:conditionalfg, 'bg': s:conditionalbg},
    \ '@identifier':       {'fg': s:identifierfg, 'bg': s:identifierbg},
    \ '@variable':         {'fg': s:variablefg, 'bg': s:variablebg},
    \ '@field':            {'fg': s:fieldfg, 'bg': s:fieldbg},
    \ '@parameter':        {'fg': s:blue, 'bg': s:fieldbg},
    \ '@string':           {'fg': s:stringfg},
    \ '@exception':        {'fg': s:exceptionfg},
\ }

for [group, value] in items(s:treesitter)
    call s:hi(group, value)
endfor

"" !!! READ !!! Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red
