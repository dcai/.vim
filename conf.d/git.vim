command Greview      :Git! diff --staged
nnoremap <c-g>       :Git<CR> " git status
nnoremap <leader>gr  :Greview<cr>
nnoremap <leader>gw  :Gwrite<CR><CR>
nnoremap <leader>ci  :Git commit -v<cr>
nnoremap <leader>cF  :Git commit --no-verify --fixup HEAD -a<cr>
nnoremap <leader>pr  :Dispatch! git pull --rebase<CR>
nnoremap <leader>pf  :Dispatch! git push --force-with-lease<CR>
nnoremap <leader>ps  :Dispatch! git push<CR>
" nnoremap <leader>psf :Git push --force<CR>
nnoremap <leader>rb  :Git rebase -i origin/master~1<CR>

function! GitFileMode()
  nnoremap <buffer> n <c-n>
  nnoremap <buffer> p <c-p>
  nnoremap <buffer> q :q<CR>
  setlocal nonumber
endfunction
augroup fugitiveGroup
  autocmd!
  autocmd filetype fugitive call GitFileMode()
  autocmd filetype git call GitFileMode()
augroup end
