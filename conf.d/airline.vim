"""""""""""""""""""""""""""""""""""""""
""" vim-airline
"""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
"let g:airline_theme='jellybeans'
let g:airline_theme='papercolor'
let g:Powerline_symbols = 'fancy'
""" Number of colors
set fillchars+=stl:\ ,stlnc:\

" let g:airline_section_b => (hunks, branch)
"let g:airline_section_b = '%{getcwd()}'
let g:airline_section_b = "%{fnamemodify(getcwd(), ':t')}"
let g:airline_section_error = ""
let g:airline_section_warning = ""

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'

