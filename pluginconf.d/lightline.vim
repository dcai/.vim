"""""""""""""""""""""""""""""""""""""""
""" lightline
"""""""""""""""""""""""""""""""""""""""
" let g:lightline = {
" \ 'colorscheme': 'seoul256',
" \ 'component': {
" \   'readonly': '%{&readonly?"":""}',
" \ },
" \ 'separator': { 'left': '', 'right': '' },
" \ 'subseparator': { 'left': '', 'right': '' }
" \ }

" separator': { 'left': '▓▒░', 'right': '░▒▓' },

"" Available color scheme
" 16color
" Dracula
" PaperColor
" PaperColor_dark
" PaperColor_light
" Tomorrow
" Tomorrow_Night
" Tomorrow_Night_Blue
" Tomorrow_Night_Bright
" Tomorrow_Night_Eighties
" darcula
" default
" jellybeans
" landscape
" molokai
" one
" powerline
" seoul256
" solarized
" wombat
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste' ],
      \             [ 'fugitive', 'gitgutter' ],
      \             [ 'filename' ]
      \   ],
      \   'right': [
      \              [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'gitgutter': 'LightLineGitGutter',
      \   'readonly': 'LightLineReadonly',
      \   'modified': 'LightLineModified',
      \   'mode': 'LightlineMode',
      \   'filename': 'LightLineFilepath'
      \ },
      \ 'separator': { 'left': '▓▒░', 'right': '░▒▓' },
      \ 'subseparator': { 'left': '|', 'right': '•' }
      \ }
function! LightlineMode()
  return winwidth(0) > 80 ? strpart(lightline#mode(), 0, 1) : ''
endfunction

function! LightLineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightLineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "RO"
  else
    return ""
  endif
endfunction

function! LightLineFugitive()
  let l:limit = 10
  let l:content = exists('*fugitive#head') ? fugitive#head() : ''
  return strlen(l:content) < l:limit ? l:content : strpart(l:content,
        \ strlen(l:content) - l:limit)
endfunction

function! LightLineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added,
        \ g:gitgutter_sign_modified,
        \ g:gitgutter_sign_removed
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFilepath()
  let l:line = expand('%:p')
  let l:line = substitute(l:line, '/Users/dcai', '~', '')
  let l:line = substitute(l:line, 'salt-developer/code/api/author', 'author', '')
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != expand('%:p') ? l:line : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction
