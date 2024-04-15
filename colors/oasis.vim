""""""""""""""""""""""""""""""""""""""""""""
" Oasis color scheme
"
""""""""""""""""""""""""""""""""""""""""""""
set background=dark

hi clear
hi clear statusline
hi clear statuslineNC
hi clear Normal
hi clear Visual

if exists("syntax_on")
  syntax reset
endif

let s:name='oasis'
let g:colors_name=s:name

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

let s:niceblack = '#0F0F0F'
let s:nicewhite = '#F0F0F0'
let s:niceyellow = '#F0D000'
let s:nicedarkgreen = '#012619'
let s:nicemidgreen =  '#295535'
let s:nicelightgreen = '#A6CC57'
let s:nicered = '#B30000'
let s:niceblue = '#0040FF'
let s:nicegray = '#8F8F8F'
let s:nicepurple = '#ca5cdd'

let s:defaultctermbg = s:none
let s:defaultctermfg = s:white
let s:defaultguifg   = s:nicewhite
let s:defaultguibg   = s:nicedarkgreen

let s:comment       = {'fg': s:gray, 'cterm': s:italic}
" let s:identifier    = {'fg': s:magenta, 'guifg': s:nicepurple, 'bg': s:none}
let s:identifier    = {'fg': s:green, 'guifg': s:nicelightgreen, 'bg': s:none}
let s:repeat        = {'fg': s:yellow}
let s:conditional   = {'fg': s:cyan, 'bg': s:darkgray}
let s:boolean       = {'fg': s:blue}
let s:number        = {'fg': s:darkyellow}
let s:function      = {'fg': s:green, 'bg': s:none}
let s:variable      = {'fg': s:darkyellow, 'guifg':s:niceyellow, 'bg': s:none}
let s:special       = {'fg': s:red, 'bg': s:none}
let s:search        = {'fg': s:black, 'bg': s:darkyellow, 'cterm': 'bold'}
let s:string        = {'fg': s:darkgray}
let s:field         = {'fg': s:yellow, 'bg': s:none}
" = > semicolon brackets
let s:delimiter     = {'fg': s:yellow, 'bg': s:none}
" + - / * =
let s:operator      = {'fg': s:magenta,'guifg':s:nicepurple}
" public, protected, private, abstract
let s:modifier      = {'fg': s:gray}
let s:type          = {'fg': s:darkyellow, 'bg': s:none}
let s:keywordfg     = s:cyan
let s:keywordbg     = s:black
let s:keywordguifg  = s:niceyellow
let s:keywordguibg  = s:none
let s:exceptionfg   = s:red

function! s:get_or(value, key, default)
  return has_key(a:value, a:key) ? a:value[a:key] : a:default
endfunction

function! s:make_kv(value, key, default)
  return a:key . "=" . s:get_or(a:value, a:key, a:default)
endfunction

function! s:hi(group, value)
  let l:fgcolor = s:get_or(a:value, 'fg', s:defaultctermfg)
  let l:bgcolor = s:get_or(a:value, 'bg', s:defaultctermbg)
  let l:attrlist = s:get_or(a:value, 'cterm', s:none)

  let l:ctermbg = "ctermbg=" . l:bgcolor
  let l:ctermfg = "ctermfg=" . l:fgcolor

  let l:guifg = s:make_kv(a:value, 'guifg', l:fgcolor)
  let l:guibg = s:make_kv(a:value, 'guibg', l:bgcolor)
  let l:cterm = 'term=' . l:attrlist
  let l:gui = 'gui=' . l:attrlist

  let l:cmd = join(
        \[
        \  "hi",
        \  a:group,
        \  l:cterm,
        \  l:ctermbg,
        \  l:ctermfg,
        \  l:guifg,
        \  l:guibg,
        \  l:gui
        \], " ")
  exe l:cmd
endfunction

function! s:apply(table)
  for [group, value] in items(a:table)
    call s:hi(group, value)
  endfor
endfunction

let s:normal = {
      \'cterm': s:none,
      \'gui': s:none,
      \'bg': s:defaultctermbg,
      \'guifg': s:defaultguifg,
      \'guibg': s:defaultguibg,
      \}
let s:normal_v = {
      \'cterm': s:none,
      \'gui': s:none,
      \'bg': s:black,
      \}
let s:normal_c = {
      \'cterm': s:none,
      \'gui': s:none,
      \'fg': s:darkgreen
      \}

let s:visual = {
      \'cterm': s:none,
      \'gui': s:none,
      \'bg': s:blue,
      \'fg': s:darkgreen
      \}

let s:ui = {
      \ 'Cursor':       {'fg': s:red, 'bg':s:none},
      \ 'CursorColumn': {'fg': s:red, 'bg':s:none},
      \ 'CursorLine':   {'fg': s:red, 'bg':s:none},
      \ 'Normal':       s:normal,
      \ 'NormalFloat':  {'bg': s:darkgreen, 'fg': s:white},
      \ 'FloatTitle':   {'bg': s:white, 'fg': s:darkgreen},
      \ 'FloatBorder':  {'fg': s:green},
      \ 'NormalNC':     {'fg': s:gray},
      \ 'ColorColumn':  {'bg': s:none},
      \ 'DiffAdd':      {'bg': s:green, 'fg': s:black},
      \ 'DiffChange':   {'bg': s:yellow, 'fg': s:black},
      \ 'DiffDelete':   {'bg': s:red, 'fg': s:black},
      \ 'DiffText':     {'bg': s:blue, 'fg': s:black},
      \ 'Directory':    {'fg': s:darkcyan},
      \ 'ErrorMsg':     {'fg': s:gray, 'bg': s:red, 'cterm': 'bold'},
      \ 'FoldColumn':   {'fg': s:darkgray},
      \ 'Folded':       {'fg': s:darkgray},
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
      \ 'IncSearch':    s:search,
      \ 'SignColumn':   {'bg': s:none},
      \ 'SpellBad':     {'fg': s:darkyellow, 'cterm': s:underline},
      \ 'SpellCap':     {'fg': s:darkyellow, 'cterm': s:underline},
      \ 'SpellLocal':   {'fg': s:darkyellow, 'cterm': s:underline},
      \ 'SpellRare':    {'fg': s:darkyellow, 'cterm': s:underline},
      \ 'Title':        {'fg': s:green, 'bg': s:darkgray},
      \ 'Underlined':   {'cterm': s:underline},
      \ 'VertSplit':    {'fg': s:green},
      \ 'Visual':       s:visual,
      \ 'VisualNOS':    {'cterm': s:underline},
      \ 'WarningMsg':   {'fg': s:yellow},
      \ 'User1':        {'guibg':s:nicelightgreen,'guifg':s:nicedarkgreen},
      \ 'User2':        {'guibg':s:nicelightgreen,'guifg':s:nicedarkgreen},
      \ 'User3':        {'guibg':s:nicelightgreen,'guifg':s:nicedarkgreen},
      \ 'User4':        {'guibg':s:nicelightgreen,'guifg':s:nicedarkgreen},
      \ 'User5':        {'guibg':s:nicelightgreen,'guifg':s:nicedarkgreen},
      \ 'User6':        {'guibg':s:niceyellow,'guifg':s:nicedarkgreen},
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
      \ 'Keyword':      {'fg': s:keywordfg,'guifg':s:keywordguifg,'bg': s:keywordbg},
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
      \ 'Todo':         {'bg': s:red, 'guibg': s:red},
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

let s:statusline = {
      \ 'fg': s:black,
      \ 'bg': s:green,
      \ 'guifg': s:nicelightgreen,
      \ 'guibg': s:nicemidgreen,
      \ 'cterm': s:none,
      \ 'gui': s:none
      \ }
let s:statuslineNC = {
      \ 'fg': s:white,
      \ 'bg': s:darkgreen,
      \ 'guibg': s:nicedarkgreen,
      \ 'cterm': s:none,
      \ 'gui': s:none
      \ }
let s:statusline_i = {
      \ 'fg': s:white,
      \ 'bg': s:darkgreen,
      \ 'cterm': s:none,
      \ 'gui': s:none
      \ }
let s:statusline_v = {
      \ 'bg': s:magenta,
      \ 'fg': s:black,
      \ 'cterm': s:none,
      \ 'gui': s:none
      \ }

let s:mode_statusline = {
      \ 'n': s:statusline,
      \ 'i': s:statusline_i,
      \ 'V': s:statusline_v,
      \ 'v': s:statusline_v,
      \ }

let s:mode_normal = {
      \ 'n': s:normal,
      \ 'V': s:normal_v,
      \ 'v': s:normal_v,
      \ 'c': s:normal_c,
      \ }

call s:hi('statusline', s:statusline)
call s:hi('statuslineNC', s:statuslineNC)

if has('nvim')
  let s:neovim_only = {
        \ 'MsgArea': s:statuslineNC
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
        \ '@attribute':          {'guifg':s:nicered},
        \ '@boolean':            s:boolean,
        \ '@comment.error':      {'guibg':s:red},
        \ '@comment.todo':       {'guibg':s:white},
        \ '@comment.warning':    {'guibg':s:yellow},
        \ '@conditional':        s:conditional,
        \ '@exception':          {'guifg':s:exceptionfg},
        \ '@field':              s:field,
        \ '@function':           s:function,
        \ '@identifier':         s:identifier,
        \ '@keyword':            {'guifg':s:keywordguifg},
        \ '@keyword.function':   {'guifg':s:yellow},
        \ '@keyword.modifier':   s:modifier,
        \ '@keyword.operator':   s:operator,
        \ '@keyword.return':     {'fg':s:blue},
        \ '@lsp.type.class':     {'guifg':s:nicepurple},
        \ '@lsp.type.namespace': {'guifg':s:niceblue},
        \ '@lsp.type.interface': {'guifg':s:nicewhite},
        \ '@parameter':          {'guifg':s:blue},
        \ '@repeat':             s:repeat,
        \ '@string':             s:string,
        \ '@variable':           s:variable,
        \ }
  call s:apply(s:treesitter)
endif

function! s:ModeChanged()
  if g:colors_name != s:name
    return
  endif
  let l:mode = mode()

  let l:stlhl  = has_key(s:mode_statusline, l:mode) ? s:mode_statusline[l:mode] : s:statusline
  call s:hi('statusline', l:stlhl)

  let l:normalhl  = has_key(s:mode_normal, l:mode) ? s:mode_normal[l:mode] : s:normal
  call s:hi('Normal', l:normalhl)
endfunction

augroup ModeChangeGroup
  autocmd!
  autocmd ModeChanged * call s:ModeChanged()
augroup END
