" BD is vim-bufkill plugin command
if exists(':BD')
  nnoremap X :BD<cr>
else
  nnoremap X :bd<cr>
endif
