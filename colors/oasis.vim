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

" hi ALEWarningLine ctermbg=darkgrey
" hi ALEErrorLine ctermbg=darkgrey
" hi ALEWarning ctermfg=white
" hi ALEError   ctermfg=yellow

""""""""""""""""""""""""""""
" TERM          definitions
""""""""""""""""""""""""""""
" js: variable names
hi Normal       ctermfg=LightYellow
hi Comment      ctermfg=darkgrey
" js: string literal
hi Constant     ctermfg=darkyellow
hi Cursor       cterm=none       ctermbg=red      ctermfg=white
hi CursorColumn cterm=none       ctermbg=green    ctermfg=white
hi CursorLine   cterm=none       ctermbg=darkblue ctermfg=white
hi Directory    ctermfg=darkcyan
hi Error        cterm=bold       ctermfg=7        ctermbg=1
hi ErrorMsg     cterm=bold       ctermfg=7        ctermbg=1
hi FoldColumn   ctermfg=darkgrey ctermbg=none
hi Folded       ctermfg=darkgrey ctermbg=none
" js: import/export, function/method name
hi Identifier   cterm=bold       ctermfg=brown
hi Ignore       cterm=bold       ctermfg=darkgrey
hi IncSearch    cterm=none       ctermfg=green    ctermbg=darkgreen
hi LineNr       ctermfg=darkyellow
hi ModeMsg      cterm=none       ctermfg=brown
hi MoreMsg      ctermfg=darkgreen
hi NonText      cterm=bold       ctermfg=darkblue
" markup attributes
hi PreProc      ctermfg=LightCyan
hi Question     ctermfg=green
hi Search       cterm=none       ctermfg=black    ctermbg=green
hi Special      ctermfg=red
hi SpjcialKey   ctermfg=darkgreen
hi SpellBad     ctermfg=red
hi SpellCap     ctermfg=cyan
" jsx markup, if else async await return
hi Statement    ctermfg=lightgreen
hi StatusLine   cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi Title        ctermfg=green
" js: const/let
hi Type         ctermfg=green
hi Underlined   cterm=underline  ctermfg=5
hi VertSplit    cterm=reverse
hi Visual       cterm=reverse
hi VisualNOS    cterm=bold,underline
hi WarningMsg   ctermfg=darkblue
hi WildMenu     ctermfg=0        ctermbg=3
hi SignColumn   ctermbg=black
