" credit: https://www.reddit.com/r/neovim/comments/10s5oou/toggle_markdown_checkbox/
" lua version: https://github.com/opdavies/toggle-checkbox.nvim/blob/main/lua/toggle-checkbox.lua
function s:toggle(pattern, dict, ...)
  let view = winsaveview()
  execute 'keeppatterns s/' . a:pattern . '/\=get(a:dict, submatch(0), a:0 ? a:1 : " ")/e'
  return view
endfunction

nnoremap <buffer> <silent> = :call winrestview(<SID>toggle('^\s*-\s*\[\zs.\ze\]', {' ': 'x', 'x': ' '}))<cr>
highlight Special ctermbg=none ctermfg=yellow guifg=yellow
