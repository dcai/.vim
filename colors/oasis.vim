""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Oasis color scheme
"
" environment variables
" - VIM_OASIS_COLORSCHEME_DISABLE_MODE_CHANGE=true
" - VIM_OASIS_COLORSCHEME_STL_FG='#FFFFFF'
" - VIM_OASIS_COLORSCHEME_STL_BG='#333333'
" - VIM_OASIS_COLORSCHEME_STL_BG_NC='#000000'
"     This disables mode change
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
let s:env_name_stl_fg='VIM_OASIS_COLORSCHEME_STL_FG'
let s:env_name_stl_bg='VIM_OASIS_COLORSCHEME_STL_BG'
let s:env_name_stl_bg_nc='VIM_OASIS_COLORSCHEME_STL_BG_NC'
let s:env_name_disable_mode_change='VIM_OASIS_COLORSCHEME_DISABLE_MODE_CHANGE'

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

let s:none           = 'NONE'
let s:bold           = 'bold'
let s:italic         = 'italic'
let s:underline      = 'underline'
let s:reverse        = 'reverse'

let s:termguicolors  = &termguicolors

let s:lightblue      = 'LightBlue'
let s:blue           = 'Blue'
let s:darkblue       = 'DarkBlue'

let s:lightgreen     = 'LightGreen'
let s:green          = 'Green'
let s:darkgreen      = 'DarkGreen'

let s:lightred       = 'LightRed'
let s:red            = 'Red'
let s:darkred        = 'DarkRed'

let s:lightcyan      = 'LightCyan'
let s:cyan           = 'Cyan'
let s:darkcyan       = 'DarkCyan'

let s:lightmagenta   = 'LightMagenta'
let s:magenta        = 'Magenta'
let s:darkmagenta    = 'DarkMagenta'

let s:lightgray      = 'LightGray'
let s:gray           = 'Gray'
let s:darkgray       = 'DarkGray'

let s:lightyellow    = 'LightYellow'
let s:yellow         = 'Yellow'
let s:darkyellow     = 'DarkYellow'

let s:brown          = 'Brown'
let s:black          = 'Black'
let s:white          = 'White'

if s:termguicolors
  let s:blue         = s:lightblue
  let s:green        = s:lightgreen
  let s:yellow       = s:lightyellow
endif

let s:niceblack      = '#0F0F0F'
let s:beige          = '#f5f5dc'
let s:ivory          = '#fffff0'
let s:olive          = '#808000'
let s:niceyellow     = '#F0D000'
let s:nicedarkgreen  = '#012619'
let s:nicemidgreen   = '#295535'
let s:nicelightgreen = '#A6CC57'
let s:nicered        = '#B30000'
let s:niceblue       = '#87ceeb'
let s:nicegray       = '#8F8F8F'
let s:nicepurple     = '#ca5cdd'
let s:deeppurple     = '#36013f'
let s:russianviolet  = '#32174d'
let s:slategray      = '#708090'
let s:darkslategray  = '#2F4F4F'
let s:seagreen       = '#2E8B57'
let s:limegreen      = '#32CD32'
let s:lime           = '#00FF00'
let s:forestgreen    = '#228B22'
let s:teal           = '#008080'

let s:keywordfg      = s:cyan
let s:keywordguifg   = s:niceblue
let s:keywordguibg   = s:none
let s:exceptionfg    = s:red

let s:defaultctermbg = s:none
let s:defaultctermfg = s:white
let s:defaultguifg   = s:beige
let s:defaultguibg   = s:nicedarkgreen

let s:comment_hl       = {'guifg':s:darkslategray,'cterm': s:italic}
" let s:identifier    = {'fg': s:magenta, 'guifg': s:nicepurple, 'bg': s:none}
let s:identifier_hl    = {'fg': s:green, 'guifg': s:nicelightgreen, 'bg': s:none}
let s:repeat_hl        = {'fg': s:yellow}
let s:conditional_hl   = {'fg': s:cyan, 'bg': s:darkgray}
let s:boolean_hl       = {'fg': s:blue}
let s:number_hl        = {'fg': s:darkyellow, 'guifg': s:lime}
let s:function_hl      = {'fg': s:green, 'bg': s:none}
let s:variable_hl      = {'fg': s:darkyellow, 'guifg':s:niceyellow, 'bg': s:none}
let s:special_hl       = {'fg': s:red, 'bg': s:none}
let s:search_hl        = {'fg': s:white, 'bg': s:darkmagenta, 'cterm': 'bold'}
let s:string_hl        = {'fg': s:white,'guifg':s:ivory}
let s:field_hl         = {'fg': s:green, 'bg': s:none}
let s:badspell_hl      = {'fg': s:darkgray, 'cterm': s:underline}
" = > semicolon brackets
let s:delimiter_hl     = {'fg': s:yellow, 'bg': s:none}
" + - / * =
let s:operator_hl      = {'fg': s:magenta,'guifg':s:nicepurple}
" public, protected, private, abstract
let s:modifier_hl      = {'fg': s:gray}
let s:type_hl          = {'fg': s:darkyellow, 'bg': s:none}

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

let s:normal_text_highlight = {
      \'bg': s:none,
      \'fg': s:white,
      \'guifg': s:defaultguifg,
      \}
let s:normal_text_highlight_visualmode = {'fg': s:red}
let s:normal_text_highlight_cmdmode = {'fg': s:darkgreen}

let s:dict_visual_selection = {
      \'bg': s:green,
      \'guibg': s:nicelightgreen,
      \'fg': s:darkgreen
      \}

let s:floatnormalbg = s:nicemidgreen
let s:popupmenubg = s:darkslategray
let s:ui = {
      \ 'Cursor'          : {'fg': s:red,    'bg':s:none},
      \ 'CursorColumn'    : {'fg': s:red,    'bg':s:none},
      \ 'CursorLine'      : {'fg': s:red,    'bg':s:none},
      \ 'Normal'          : s:normal_text_highlight,
      \ 'NormalNC'        : {'fg': s:gray},
      \ 'NormalFloat'     : {'fg': s:green,  'bg':s:black, 'guibg':s:floatnormalbg},
      \ 'FloatTitle'      : {'fg': s:green,  'bg':s:black, 'guibg':s:floatnormalbg},
      \ 'FloatBorder'     : {'fg': s:green,  'bg':s:black, 'guibg':s:floatnormalbg},
      \ 'ColorColumn'     : {'bg': s:none},
      \ 'Directory'       : {'fg': s:darkcyan},
      \ 'ErrorMsg'        : {'fg': s:red,  'bg':s:yellow},
      \ 'FoldColumn'      : {'fg': s:darkgray},
      \ 'Folded'          : {'fg': s:darkgray},
      \ 'LineNr'          : {'fg': s:green,  'bg':    s:none},
      \ 'MatchParen'      : {'bg': s:none,   'fg':    s:red},
      \ 'ModeMsg'         : {'fg': s:yellow},
      \ 'MoreMsg'         : {'fg': s:darkgreen},
      \ 'Noise'           : {'fg': s:gray},
      \ 'NonText'         : {'fg': s:darkcyan},
      \ 'Pmenu'           : {'bg': s:darkgreen,  'fg':    s:white, 'guibg': s:popupmenubg},
      \ 'PmenuSel'        : {'bg': s:blue,       'fg':    s:black},
      \ 'PmenuSbar'       : {'bg': s:darkcyan},
      \ 'PmenuThumb'      : {'bg': s:yellow},
      \ 'Question'        : {'fg': s:green},
      \ 'Quote'           : {'fg': s:yellow},
      \ 'Search'          : s:search_hl,
      \ 'IncSearch'       : s:search_hl,
      \ 'CurSearch'       : s:search_hl,
      \ 'TabLine'         : {'bg': s:darkblue},
      \ 'TabLineSel'      : {'bg': s:white, 'fg': s:black},
      \ 'SignColumn'      : {'bg': s:none},
      \ 'Title'           : {'fg': s:green,  'bg':    s:none},
      \ 'Underlined'      : {'fg': s:blue,   'cterm': s:underline},
      \ 'VertSplit'       : {'fg': s:green},
      \ 'Visual'          : s:dict_visual_selection,
      \ 'VisualNOS'       : {'fg': s:gray,   'cterm': s:underline},
      \ 'WarningMsg'      : {'fg': s:yellow},
      \ }

let s:spell = {
      \ 'SpellBad'   : s:badspell_hl,
      \ 'SpellCap'   : s:badspell_hl,
      \ 'SpellLocal' : s:badspell_hl,
      \ 'SpellRare'  : s:badspell_hl,
      \}
call s:apply(s:spell)

call s:apply(s:ui)
let s:user = {
      \ 'User1' : {'guibg': s:niceyellow,     'guifg':s:nicedarkgreen},
      \ 'User2' : {'guibg': s:darkyellow,     'guifg':s:nicedarkgreen},
      \ 'User3' : {'guibg': s:nicelightgreen, 'guifg':s:nicedarkgreen},
      \ 'User4' : {'guibg': s:niceblue,       'guifg':s:nicedarkgreen},
      \ 'User5' : {'guibg': s:niceblack,      'guifg':s:nicedarkgreen},
      \ 'User6' : {'guibg': s:nicegray,       'guifg':s:nicedarkgreen},
      \ }
call s:apply(s:user)

let s:syntax = {
      \ 'Boolean'         : s:boolean_hl,
      \ 'Character'       : {'fg': s:red},
      \ 'Comment'         : s:comment_hl,
      \ 'Conditional'     : s:conditional_hl,
      \ 'Constant'        : {'fg': s:darkgreen},
      \ 'Debug'           : {'fg': s:gray},
      \ 'Define'          : {'bg': s:red},
      \ 'Delimiter'       : s:delimiter_hl,
      \ 'DiagnosticError' : {'bg': s:none,      'fg':    s:red},
      \ 'DiagnosticHint'  : {'bg': s:none,      'fg':    s:blue},
      \ 'DiagnosticInfo'  : {'bg': s:none,      'fg':    s:blue},
      \ 'DiagnosticOk'    : {'bg': s:none,      'fg':    s:green},
      \ 'DiagnosticWarn'  : {'bg': s:none,      'fg':    s:yellow},
      \ 'DiffAdd'         : {'bg': s:green,     'fg':    s:black},
      \ 'DiffChange'      : {'bg': s:yellow,    'fg':    s:black},
      \ 'DiffDelete'      : {'bg': s:red,       'fg':    s:black},
      \ 'DiffText'        : {'bg': s:blue,      'fg':    s:black},
      \ 'Error'           : {'fg': s:gray,      'bg':    s:red,          'cterm': 'bold'},
      \ 'Exception'       : {'fg': s:red,       'bg':    s:none},
      \ 'Function'        : s:function_hl,
      \ 'Identifier'      : s:identifier_hl,
      \ 'Ignore'          : {'fg': s:darkgray},
      \ 'Include'         : {'fg': s:darkgray,  'bg':    s:none},
      \ 'Keyword'         : {'fg': s:keywordfg, 'guifg': s:keywordguifg, 'bg':    s:none},
      \ 'Label'           : {'fg': s:green},
      \ 'Macro'           : {'fg': s:red},
      \ 'Number'          : s:number_hl,
      \ 'Operator'        : s:operator_hl,
      \ 'PreCondit'       : {'fg': s:keywordfg},
      \ 'PreProc'         : {'fg': s:keywordfg},
      \ 'Repeat'          : s:repeat_hl,
      \ 'Special'         : s:special_hl,
      \ 'SpecialKey'      : s:special_hl,
      \ 'Statement'       : {'fg': s:darkyellow},
      \ 'StorageClass'    : {'fg': s:darkred},
      \ 'String'          : s:string_hl,
      \ 'Structure'       : {'fg': s:red},
      \ 'Tag'             : {'fg': s:red},
      \ 'Todo'            : {'bg': s:red,       'guibg': s:red},
      \ 'Type'            : s:type_hl,
      \ 'Typedef'         : {'fg': s:magenta},
      \ }
call s:apply(s:syntax)

let s:custom = {
      \ 'StatusLineAccent'           : {'guibg': s:niceyellow,     'guifg':s:nicedarkgreen},
      \ 'StatusLineProjectAccent'    : {'guibg': s:nicelightgreen, 'guifg':s:nicedarkgreen},
      \ 'StatusLineHighlight'        : {'guibg': s:nicelightgreen, 'guifg':s:nicedarkgreen},
      \ 'NotificationInfo'           : {'bg': s:blue,     'guibg': s:darkslategray},
      \ 'NotificationWarning'        : {'bg': s:yellow,     'guibg': s:darkslategray},
      \ 'NotificationError'          : {'bg': s:red,     'guibg': s:darkslategray},
      \ 'ALEError'                   : {'fg': s:none,     'bg':    s:red},
      \ 'ALEErrorSign'               : {'bg': s:darkred},
      \ 'ALEVirtualTextError'        : {'fg': s:darkgray, 'bg':    s:none},
      \ 'ALEVirtualTextInfo'         : {'fg': s:darkgray, 'bg':    s:none},
      \ 'ALEVirtualTextWarning'      : {'fg': s:darkgray, 'bg':    s:none},
      \ 'ALEWarning'                 : {'fg': s:none,     'bg':    s:yellow},
      \ 'ALEWarningSign'             : {'bg': s:yellow,   'fg':    s:black},
      \ 'CocErrorFloat'              : {'fg': s:red},
      \ 'CocHighlightText'           : {'bg': s:red,      'fg':    s:white},
      \ 'CocHintFloat'               : {'fg': s:black},
      \ 'CocInfoFloat'               : {'fg': s:blue},
      \ 'CocMenuSel'                 : {'bg': s:red},
      \ 'CocSearch'                  : {'fg': s:darkblue},
      \ 'CocWarningFloat'            : {'fg': s:red},
      \ 'CodeiumSuggestion'          : {'fg': s:blue,     'guifg': s:slategray},
      \ 'MiniNotifyBorder'           : {'bg': s:blue,     'guibg': s:darkslategray},
      \ 'MiniNotifyNormal'           : {'bg': s:blue,     'guibg': s:darkslategray},
      \ 'SignifySignAdd'             : {'fg': s:green},
      \ 'SignifySignChange'          : {'fg': s:yellow},
      \ 'SignifySignDelete'          : {'fg': s:darkred},
      \ 'SignifySignDeleteFirstLine' : {'fg': s:darkred},
      \ 'FzfLuaNormal'               : {'guibg':s:darkslategray,'guifg':s:white},
      \ 'MasonNormal'                : {'guibg':s:teal,'guifg':s:white},
      \ 'MasonHeader'                : {'guibg':s:white,'guifg':s:black},
      \ 'MasonHeading'               : {'guifg':s:yellow},
      \ 'MasonError'                 : {'guifg':s:yellow},
      \ 'MasonWarning'               : {'guifg':s:black},
      \ 'MasonHighlight'             : {'guifg':s:green},
      \ 'MasonHighlightBlock'        : {'guifg':s:green},
      \ 'MasonHighlightBlockBold'    : {'guifg':s:green},
      \ 'MasonHighlightSecondary'    : {'guifg':s:blue},
      \ 'MasonLink'                  : {'guifg':s:black},
      \ 'MasonMuted'                 : {'guifg':s:yellow},
      \ 'MasonMutedBlock'            : {'guifg':s:yellow},
      \ 'MasonMutedBlockBold'        : {'guifg':s:black},
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
        \ 'MsgArea': {'bg':s:none,'fg':s:green,'guifg':s:nicelightgreen}
        \ }
  call s:apply(s:neovim_only)

  let s:whichkeybg=s:darkslategray
  let s:whichkey = {
        \ 'WhichKeyTitle': {'fg': s:white,'guibg': s:whichkeybg},
        \ 'WhichKeyBorder': {'fg': s:white,'guibg': s:whichkeybg},
        \ 'WhichKeyNormal': {'fg': s:darkgray,'guibg': s:whichkeybg}
        \ }
  call s:apply(s:whichkey)

  let s:cmp = {
        \ 'CmpItemAbbr':           {'fg': s:darkgray,  'bg': s:none},
        \ 'CmpItemAbbrDeprecated': {'fg': s:green,  'bg': s:none},
        \ 'CmpItemAbbrMatch':      {'fg': s:blue,   'bg': s:none},
        \ 'CmpItemMenu':           {'fg': s:black,  'bg': s:green, 'guibg':s:nicelightgreen},
        \ 'CmpItemKind':           {'fg': s:yellow, 'bg': s:none},
        \ 'CmpItemKindCodeium':    {'fg': s:yellow, 'bg': s:red},
        \ 'CmpItemKindFunction':   {'fg': s:blue,   'bg': s:none},
        \ 'CmpItemKindMethod':     {'fg': s:white,  'bg': s:magenta},
        \ 'CmpItemKindKeyword':    {'fg': s:red,    'bg': s:none},
        \ 'CmpItemKindVariable':   {'fg': s:cyan,   'bg': s:none},
        \ }
  call s:apply(s:cmp)
  " https://neovim.io/doc/user/treesitter.html#treesitter-highlight
  let s:treesitter = {
        \ '@attribute'             : s:field_hl,
        \ '@boolean'               : s:boolean_hl,
        \ '@comment.error'         : {'guifg':s:red},
        \ '@comment.todo'          : {'guifg':s:white},
        \ '@comment.note'          : {'guifg':s:white},
        \ '@comment.warning'       : {'guifg':s:yellow},
        \ '@conditional'           : s:conditional_hl,
        \ '@constant'              : {'guifg':s:darkgreen},
        \ '@character'             : {'guifg':s:darkgreen},
        \ '@exception'             : {'guifg':s:exceptionfg},
        \ '@function'              : s:function_hl,
        \ '@keyword'               : {'guifg':s:keywordguifg},
        \ '@keyword.function'      : {'guifg':s:yellow},
        \ '@keyword.modifier'      : s:modifier_hl,
        \ '@keyword.operator'      : s:operator_hl,
        \ '@keyword.return'        : {'guifg':s:blue},
        \ '@lsp.type.class'        : {'guifg':s:nicepurple},
        \ '@lsp.type.property'     : s:field_hl,
        \ '@lsp.type.comment'      : s:comment_hl,
        \ '@lsp.type.string'       : s:string_hl,
        \ '@lsp.type.enum'         : {'guifg':s:olive},
        \ '@lsp.type.interface'    : {'guifg':s:beige},
        \ '@lsp.type.namespace'    : {'guifg':s:niceblue},
        \ '@lsp.type.struct'       : {'guifg':s:red},
        \ '@module'                : {'guifg':s:lime},
        \ '@number'                : s:number_hl,
        \ '@operator'              : s:operator_hl,
        \ '@parameter'             : {'guifg':s:blue},
        \ '@punctuation.delimiter' : {'guifg':s:ivory},
        \ '@punctuation.bracket'   : {'guifg':s:ivory},
        \ '@punctuation.special'   : {'guifg':s:ivory},
        \ '@property'              : s:field_hl,
        \ '@repeat'                : s:repeat_hl,
        \ '@string'                : s:string_hl,
        \ '@tag'                   : {'guifg':s:teal},
        \ '@type'                  : s:type_hl,
        \ '@type.definition'       : s:type_hl,
        \ '@variable'              : s:variable_hl,
        \ }
  call s:apply(s:treesitter)
endif

let s:statusline_fg=g:EnvVar(s:env_name_stl_fg, s:nicelightgreen)
let s:statusline_bg=g:EnvVar(s:env_name_stl_bg, s:darkgreen)
let s:statusline_bg_nc=g:EnvVar(s:env_name_stl_bg_nc, s:black)

let s:statusline_n = {
      \ 'fg': s:black,
      \ 'bg': s:green,
      \ 'guifg': s:statusline_fg,
      \ 'guibg': s:statusline_bg,
      \ }
let s:statuslineNC = {
      \ 'fg': s:gray,
      \ 'guibg': s:statusline_bg_nc,
      \ }
let s:statusline_i = {
      \ 'fg': s:white,
      \ 'bg': s:darkgreen,
      \ }
let s:statusline_v = {
      \ 'fg': s:black,
      \ 'bg': s:green,
      \ 'guibg': s:nicelightgreen,
      \ }
let s:mode_statusline = {
      \ 'n': s:statusline_n,
      \ 'i': s:statusline_i,
      \ 'V': s:statusline_v,
      \ 'v': s:statusline_v,
      \ }

" Apply to 'Normal' highlight group
let s:default_text_highlight = {
      \ 'n': s:normal_text_highlight,
      \ 'V': s:normal_text_highlight_visualmode,
      \ 'v': s:normal_text_highlight_visualmode,
      \ 'c': s:normal_text_highlight_cmdmode,
      \ }
call s:hi('StatusLine', s:statusline_n)
call s:hi('statuslineNC', s:statuslineNC)

function! s:ModeChanged()
  if g:IsEnvVarTrue(s:env_name_disable_mode_change)
    return
  endif
  if g:colors_name != s:name
    return
  endif
  let l:mode = mode()

  let l:stlhl  = has_key(s:mode_statusline, l:mode) ? s:mode_statusline[l:mode] : s:statusline_n
  call s:hi('StatusLine', l:stlhl)

  let l:normalhl  = has_key(s:default_text_highlight, l:mode) ? s:default_text_highlight[l:mode] : s:normal_text_highlight
  call s:hi('Normal', l:normalhl)
endfunction

augroup ModeChangeGroup
  autocmd!
  autocmd ModeChanged * call s:ModeChanged()
augroup END
