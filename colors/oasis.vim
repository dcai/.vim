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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cterm and gui attr list
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bold
" underline
" undercurl	curly underline
" underdouble	double underline
" underdotted	dotted underline
" underdashed	dashed underline
" strikethrough
" reverse
" inverse		same as reverse
" italic
" standout
" altfont
" nocombine	override attributes instead of combining them
" NONE		no attributes used (used to reset it)

let s:none          = 'NONE'
let s:bold          = 'bold'
let s:italic        = 'italic'
let s:underline     = 'underline'
let s:reverse       = 'reverse'

let s:termguicolors = &termguicolors

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

if s:termguicolors
  let s:blue        = 'lightblue'
  let s:green       = 'lightgreen'
  let s:yellow      = 'lightyellow'
endif

let s:defaultbg     = s:none
let s:defaultfg     = s:white
let s:defaultguibg  = '#012619'
let s:comment       = {'fg': s:gray, 'cterm': s:italic}
let s:identifier    = {'fg': s:yellow, 'bg': s:none}
let s:repeat        = {'fg': s:yellow}
let s:conditional   = {'fg': s:cyan, 'bg': s:darkgray}
let s:boolean       = {'fg': s:blue}
let s:number        = {'fg': s:yellow}
let s:function      = {'fg': s:green, 'bg': s:none}
let s:variable      = {'fg': s:darkyellow, 'bg': s:none}
let s:special       = {'fg': s:red, 'bg': s:none}
let s:search        = {'fg': s:black, 'bg': s:darkyellow, 'cterm': 'bold'}
let s:string        = {'fg': s:darkgray}
let s:field         = {'fg': s:yellow, 'bg': s:none}
" = > semicolon brackets
let s:delimiter     = {'fg': s:yellow, 'bg': s:none}
" + - / * =
let s:operator      = {'fg': s:red}
let s:type          = {'fg': s:darkyellow, 'bg': s:none}
let s:keywordfg     = s:cyan
let s:keywordbg     = s:black
let s:exceptionfg   = s:red

function! s:get_or(value, key, default)
  return has_key(a:value, a:key) ? a:value[a:key] : a:default
endfunction

function! s:keyvalue(value, key, default)
  return a:key . "=" . s:get_or(a:value, a:key, a:default)
endfunction

function! s:hi(group, value)
  let l:fgcolor = s:get_or(a:value, 'fg', s:defaultfg)
  let l:bgcolor = s:get_or(a:value, 'bg', s:defaultbg)
  let l:attrlist = s:get_or(a:value, 'cterm', s:none)

  let l:ctermbg = "ctermbg=" . l:bgcolor
  let l:ctermfg = "ctermfg=" . l:fgcolor

  let l:guifg = s:keyvalue(a:value, 'guifg', l:fgcolor)
  let l:guibg = s:keyvalue(a:value, 'guibg', l:bgcolor)
  let l:cterm = 'term=' . l:attrlist
  let l:gui = 'gui=' . l:attrlist

  let l:cmd = join(["hi", a:group, l:cterm, l:ctermbg, l:ctermfg, l:guifg, l:guibg, l:gui], " ")
  exe l:cmd
endfunction

function! s:apply(table)
  for [group, value] in items(a:table)
      call s:hi(group, value)
  endfor
endfunction

let s:normal = {'fg': s:defaultfg, 'guibg': s:defaultguibg}
let s:normal_v = {'bg': s:black}
let s:normal_c = {'fg': s:darkgreen}

let s:ui = {
    \ 'Normal':       s:normal,
    \ 'NormalFloat':  {'bg': s:darkgreen, 'fg': s:white},
    \ 'NormalNC':     {'fg': s:gray},
    \ 'ColorColumn':  {'bg': s:none},
    \ 'DiffAdd':      {'bg': s:green, 'fg': s:black},
    \ 'DiffChange':   {'bg': s:yellow, 'fg': s:black},
    \ 'DiffDelete':   {'bg': s:red, 'fg': s:black},
    \ 'DiffText':     {'bg': s:blue, 'fg': s:black},
    \ 'Directory':    {'fg': s:darkcyan},
    \ 'ErrorMsg':     {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'FloatBorder':  {'fg': s:blue},
    \ 'FoldColumn':   {'fg': s:darkgray},
    \ 'Folded':       {'fg': s:darkgray},
    \ 'IncSearch':    s:search,
    \ 'LineNr':       {'fg': s:green, 'bg': s:none},
    \ 'MatchParen':   {'bg': s:none, 'fg': s:red},
    \ 'ModeMsg':      {'fg': s:yellow},
    \ 'MoreMsg':      {'fg': s:darkgreen},
    \ 'Noise':        {'fg': s:gray},
    \ 'NonText':      {'fg': s:darkcyan, 'cterm': 'bold'},
    \ 'Pmenu':        {'bg': s:blue, 'fg': s:blue},
    \ 'PmenuSbar':    {'bg': s:blue},
    \ 'PmenuSel':     {'bg': s:red, 'fg': s:red},
    \ 'PmenuThumb':   {'bg': s:yellow},
    \ 'Question':     {'fg': s:green},
    \ 'Quote':        {'fg': s:yellow},
    \ 'Search':       s:search,
    \ 'SignColumn':   {'bg': s:none},
    \ 'SpellBad':     {'fg': s:darkyellow, 'cterm': s:underline},
    \ 'SpellCap':     {'fg': s:darkyellow, 'cterm': s:underline},
    \ 'SpellLocal':   {'fg': s:darkyellow, 'cterm': s:underline},
    \ 'SpellRare':    {'fg': s:darkyellow, 'cterm': s:underline},
    \ 'Title':        {'fg': s:green, 'bg': s:darkgray},
    \ 'Underlined':   {'cterm': s:underline},
    \ 'VertSplit':    {'fg': s:green},
    \ 'Visual':       {'cterm': s:reverse},
    \ 'VisualNOS':    {'cterm': s:underline},
    \ 'WarningMsg':   {'fg': s:yellow},
\ }
call s:apply(s:ui)

let s:syntax = {
    \ 'Boolean':      s:boolean,
    \ 'Number':       s:number,
    \ 'Function':     s:function,
    \ 'Identifier':   s:identifier,
    \ 'Character':    {'fg': s:red},
    \ 'Comment':      s:comment,
    \ 'Conditional':  s:conditional,
    \ 'Constant':     {'fg': s:darkgreen},
    \ 'Debug':        {'fg': s:gray},
    \ 'Define':       {'bg': s:red},
    \ 'Delimiter':    s:delimiter,
    \ 'Error':        {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
    \ 'Exception':    {'fg': s:red, 'bg': s:none},
    \ 'Ignore':       {'fg': s:darkgray, 'cterm': 'bold'},
    \ 'Include':      {'fg': s:darkgray, 'bg': s:none},
    \ 'Keyword':      {'fg': s:keywordfg,  'bg': s:keywordbg},
    \ 'Label':        {'fg': s:green},
    \ 'Macro':        {'fg': s:red},
    \ 'Operator':     s:operator,
    \ 'PreCondit':    {'fg': s:keywordfg},
    \ 'PreProc':      {'fg': s:keywordfg},
    \ 'Repeat':       s:repeat,
    \ 'Special':      s:special,
    \ 'SpecialKey':   s:special,
    \ 'Statement':    {'fg': s:darkyellow},
    \ 'StorageClass': {'fg': s:darkred},
    \ 'String':       s:string,
    \ 'Structure':    {'fg': s:red},
    \ 'Tag':          {'fg': s:red},
    \ 'Todo':         {'fg': s:red},
    \ 'Type':         s:type,
    \ 'Typedef':      {'fg': s:red},
\ }
call s:apply(s:syntax)

let s:custom = {
    \ 'ALEVirtualTextError':        {'fg': s:darkgray, 'bg': s:none, 'cterm': s:italic},
    \ 'ALEVirtualTextWarning':      {'fg': s:darkgray, 'bg': s:none},
    \ 'ALEVirtualTextInfo':         {'fg': s:darkgray, 'bg': s:none},
    \ 'ALEError':                   {'fg': s:none, 'bg': s:red, 'cterm': s:underline},
    \ 'ALEErrorSign':               {'bg': s:darkred},
    \ 'ALEWarning':                 {'fg': s:none, 'bg': s:yellow, 'cterm': s:underline},
    \ 'ALEWarningSign':             {'bg': s:yellow, 'fg': s:black},
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
call s:apply(s:custom)

" javascript syntax definitions:
" https://github.com/pangloss/vim-javascript/blob/1.2.5.1/syntax/javascript.vim#L243-L363
let s:js = {
    \ 'jsxTagName':  {'fg': s:green},
    \ 'tsxTagName':  {'fg': s:green},
    \ 'jsxElement':  {'fg': s:red},
    \ 'jsFuncArgs':  {'fg': s:yellow},
    \ 'jsObjectKey': {'fg': s:red, 'bg': s:darkgreen},
\ }
call s:apply(s:js)

"" !!! READ !!! Cursor color is controlled by iterm color scheme
" hi Cursor       cterm=none       ctermbg=red      ctermfg=white
" hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
" hi CursorLine   cterm=none       ctermbg=red

if has('nvim')
  let s:neovim_only = {
      \ 'MsgArea': {'fg': s:white, 'bg': s:darkgreen},
  \ }
  call s:apply(s:neovim_only)
  let s:cmp = {
      \ 'CmpItemAbbrDeprecated': {'fg': s:green, 'bg': s:none},
      \ 'CmpItemAbbrMatch':      {'fg': s:black, 'bg': s:green},
      \ 'CmpItemMenu':           {'fg': s:green, 'bg': s:none},
      \ 'CmpItemKind':           {'fg': s:yellow, 'bg': s:none},
      \ 'CmpItemKindFunction':   {'fg': s:blue, 'bg': s:none},
      \ 'CmpItemKindMethod':     {'fg': s:magenta, 'bg': s:none},
      \ 'CmpItemKindKeyword':    {'fg': s:red, 'bg': s:none},
      \ 'CmpItemKindVariable':   {'fg': s:cyan, 'bg': s:none},
  \ }
  call s:apply(s:cmp)
  " https://neovim.io/doc/user/treesitter.html#treesitter-highlight
  let s:treesitter = {
      \ '@boolean':          s:boolean,
      \ '@function':         s:function,
      \ '@identifier':       s:identifier,
      \ '@attribute':        {'fg': s:red},
      \ '@repeat':           s:repeat,
      \ '@keyword':          {'fg': s:keywordfg},
      \ '@keyword.function': {'fg': s:yellow},
      \ '@keyword.return':   {'fg': s:blue},
      \ '@keyword.operator': s:operator,
      \ '@conditional':      s:conditional,
      \ '@variable':         s:variable,
      \ '@field':            s:field,
      \ '@parameter':        {'fg': s:blue, 'bg': s:none},
      \ '@string':           s:string,
      \ '@exception':        {'fg': s:exceptionfg},
  \ }
  call s:apply(s:treesitter)
endif

let s:statusline_active = {
      \'fg': s:black,
      \'bg': s:darkyellow,
      \'cterm': 'none',
      \'gui': 'none'
      \}
let s:statusline_inactive = {
      \'fg': s:white,
      \'bg': s:darkgray,
      \}
let s:statusline_insertmode = {
      \'fg': s:white,
      \'bg': s:darkgreen,
      \'cterm': 'none'
      \}
let s:statusline_v = {'bg': s:magenta, 'fg': s:black}

let s:mode_statusline = {
      \'n': s:statusline_active,
      \'i': s:statusline_insertmode,
      \'V': s:statusline_v,
      \'v': s:statusline_v,
      \}

let s:mode_normal = {
      \'n': s:normal,
      \'V': s:normal_v,
      \'v': s:normal_v,
      \'c': s:normal_c,
      \}

call s:hi('statusline', s:statusline_active)
call s:hi('statuslineNC', s:statusline_inactive)

" function! s:InsertLeave()
"   call s:hi('statusline', s:statusline_active)
" endfunction
"
" function! s:InsertEnter(mode)
"     if a:mode == 'n'
"         call s:hi('statusline', s:statusline_insertmode)
"     endif
"     if a:mode == 'r'
"         call s:hi('statusline', s:statusline_insertmode)
"     endif
" endfunction
"
function! s:ModeChanged()
   let l:stldefault = s:get_or(s:mode_statusline, 'n', {})
   let l:mode = mode()
   echom "mode: " . l:mode
   let l:stlhl  = has_key(s:mode_statusline, l:mode) ? s:mode_statusline[l:mode] : l:stldefault
   call s:hi('statusline', l:stlhl)

   let l:normal = s:get_or(s:mode_normal, 'n', {})
   let l:normalhl  = has_key(s:mode_normal, l:mode) ? s:mode_normal[l:mode] : l:normal
   call s:hi('Normal', l:normalhl)
endfunction

augroup ModeChangeGroup
    autocmd!
    " autocmd InsertEnter  * call s:InsertEnter(v:insertmode)
    " autocmd InsertChange * call s:InsertEnter(v:insertmode)
    " autocmd InsertLeave  * call s:InsertLeave()
    autocmd ModeChanged  * call s:ModeChanged()
augroup END
