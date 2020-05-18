" Improved desert.vim
" by Dongsheng Cai <d@tux.im>

""""""""""""""""""""""""""""""""""""""""""""
" Vim color file
" Maintainer:	Hans Fugal <hans@fugal.net>
" Last Change:	$Date: 2004/06/13 19:30:30 $
" Last Change:	$Date: 2004/06/13 19:30:30 $
" URL:		http://hans.fugal.net/vim/colors/desert.vim
" Version:	$Id: desert.vim,v 1.1 2004/06/13 19:30:30 vimboss Exp $

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors
""""""""""""""""""""""""""""""""""""""""""""

set background=dark
if version > 580
  " no guarantees for version 5.8 and below, but this makes it stop
  " complaining
  hi clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name='desert2'

hi clear ALEWarning
hi clear ALEError
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
" hi ALEWarningLine ctermbg=darkgrey
" hi ALEErrorLine ctermbg=darkgrey
hi ALEWarning cterm=underline ctermbg=blue ctermfg=white
hi ALEError cterm=underline ctermbg=darkred ctermfg=yellow

""""""""""""""""""""""""""""
" TERM          definitions
""""""""""""""""""""""""""""
hi Comment      ctermfg=darkgrey
hi Constant     ctermfg=brown
hi Cursor       cterm=none       ctermbg=red      ctermfg=white
hi CursorColumn cterm=NONE       ctermbg=green    ctermfg=white
hi CursorLine   cterm=NONE       ctermbg=darkblue ctermfg=white
hi clear DiffAdd
hi clear DiffChange
hi clear DiffDelete
hi clear DiffText

hi Directory    ctermfg=darkcyan
hi Error        cterm=bold       ctermfg=7        ctermbg=1
hi ErrorMsg     cterm=bold       ctermfg=7        ctermbg=1
hi FoldColumn   ctermfg=darkgrey ctermbg=NONE
hi Folded       ctermfg=darkgrey ctermbg=NONE
" js: import/export
hi Identifier   ctermfg=yellow
hi Ignore       cterm=bold       ctermfg=darkgrey
hi IncSearch    cterm=NONE       ctermfg=green    ctermbg=darkgreen
hi LineNr       ctermfg=darkyellow
hi ModeMsg      cterm=NONE       ctermfg=brown
hi MoreMsg      ctermfg=darkgreen
hi NonText      cterm=bold       ctermfg=darkblue
hi Normal       ctermfg=lightblue
" const/let and markup attributes
hi PreProc      ctermfg=LightCyan
hi Question     ctermfg=green
hi Search       cterm=NONE       ctermfg=black    ctermbg=green
hi Special      ctermfg=red
hi SpjcialKey   ctermfg=darkgreen
hi SpellBad     ctermfg=red
hi SpellCap     ctermfg=cyan
" jsx markup
hi Statement    ctermfg=lightmagenta
hi StatusLine   cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi Title        ctermfg=green
hi Type         ctermfg=darkgreen
hi Underlined   cterm=underline  ctermfg=5
hi VertSplit    cterm=reverse
hi Visual       cterm=reverse
hi VisualNOS    cterm=bold,underline
hi WarningMsg   ctermfg=darkblue
hi WildMenu     ctermfg=0        ctermbg=3
hi SignColumn   ctermbg=black

""""""""""""""""""""""""""""
" GUI definitions
""""""""""""""""""""""""""""
hi Comment      guifg=SkyBlue
hi Constant     guifg=#ffa0a0
hi FoldColumn   guibg=grey30    guifg=tan
hi Folded       guibg=grey30    guifg=gold
hi Identifier   guifg=palegreen
hi Ignore       guifg=grey40
hi ModeMsg      guifg=goldenrod
hi MoreMsg      guifg=SeaGreen
hi NonText      guifg=LightBlue guibg=grey30
hi Normal       guifg=White     guibg=grey20
hi PreProc      guifg=indianred
hi Question     guifg=springgreen
hi Special      guifg=navajowhite
hi SpecialKey   guifg=yellowgreen
hi Statement    guifg=khaki
hi StatusLine   guibg=#c2bfa5   guifg=black  gui=none
hi StatusLineNC guibg=#c2bfa5   guifg=grey50 gui=none
hi Title        guifg=indianred
hi Todo         guifg=orangered guibg=yellow2
hi Type         guifg=darkkhaki
hi VertSplit    guibg=#c2bfa5   guifg=grey50 gui=none
hi Visual       gui=none        guifg=khaki  guibg=olivedrab
hi WarningMsg   guifg=salmon
"hi Directory
"hi ErrorMsg
"hi LineNr
"hi Menu
"hi Scrollbar
"hi Tooltip
"hi VisualNOS
"hi WildMenu
"hi Underlined
"hi Error
"vim: sw=4
