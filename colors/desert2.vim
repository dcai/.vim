" Slightly improved desert.vim
" by Dongsheng Cai <d@tux.im>

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

set background=dark
if version > 580
  " no guarantees for version 5.8 and below, but this makes it stop
  " complaining
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name="desert2"

""""""""""""""""""""""""""""
" TERM          definitions
""""""""""""""""""""""""""""
hi Normal	ctermfg=lightblue
hi SpecialKey   ctermfg=darkgreen
hi NonText      cterm=bold ctermfg=darkblue
hi Directory    ctermfg=darkcyan
hi ErrorMsg     cterm=bold ctermfg=7 ctermbg=1
hi IncSearch    cterm=NONE ctermfg=yellow ctermbg=darkgrey
hi Search       cterm=NONE ctermfg=white ctermbg=darkgrey
hi MoreMsg      ctermfg=darkgreen
hi ModeMsg      cterm=NONE ctermfg=brown
hi LineNr       ctermfg=darkyellow
hi Question     ctermfg=green
hi StatusLine   cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit    cterm=reverse
hi Title        ctermfg=green
hi Visual       cterm=reverse
hi VisualNOS    cterm=bold,underline
hi WarningMsg   ctermfg=darkblue
hi WildMenu     ctermfg=0 ctermbg=3
hi Folded       ctermfg=darkgrey ctermbg=NONE
hi FoldColumn   ctermfg=darkgrey ctermbg=NONE
hi DiffAdd      ctermbg=4
hi DiffChange   ctermbg=5
hi DiffDelete   cterm=bold ctermfg=4 ctermbg=6
hi DiffText     cterm=bold ctermbg=1
hi Comment      ctermfg=darkgrey
hi Constant     ctermfg=brown
hi Special      ctermfg=red
" jsx markup
hi Identifier   ctermfg=yellow
hi Statement    ctermfg=lightmagenta
" js: import/export
hi PreProc      ctermfg=LightCyan
" const/let and markup attributes
hi Type         ctermfg=yellow
hi Underlined   cterm=underline ctermfg=5
hi Ignore       cterm=bold ctermfg=darkgrey
hi Error        cterm=bold ctermfg=7 ctermbg=1
hi clear        SpellBad
hi SpellBad     cterm=underline
hi CursorLine   cterm=NONE ctermbg=darkblue ctermfg=white
hi CursorColumn cterm=NONE ctermbg=green ctermfg=white


""""""""""""""""""""""""""""
" GUI definitions
""""""""""""""""""""""""""""
hi Normal	guifg=White guibg=grey20

"   highlight groups
hi Cursor	guibg=khaki guifg=slategrey
hi CursorLine   guibg=darkred guifg=white
hi CursorColumn guibg=darkred guifg=white
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded	guibg=grey30 guifg=gold
hi FoldColumn	guibg=grey30 guifg=tan
hi IncSearch	guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg	guifg=goldenrod
hi MoreMsg	guifg=SeaGreen
hi NonText	guifg=LightBlue guibg=grey30
hi Question	guifg=springgreen
hi Search	guibg=peru guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
hi Title	guifg=indianred
hi Visual	gui=none guifg=khaki guibg=olivedrab
"hi VisualNOS
hi WarningMsg	guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip

" syntax highlighting groups
hi Comment	guifg=SkyBlue
hi Constant	guifg=#ffa0a0
hi Identifier	guifg=palegreen
hi Statement	guifg=khaki
hi PreProc	guifg=indianred
hi Type		guifg=darkkhaki
hi Special	guifg=navajowhite
"hi Underlined
hi Ignore	guifg=grey40
"hi Error
hi Todo		guifg=orangered guibg=yellow2
"vim: sw=4
