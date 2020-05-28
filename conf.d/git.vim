command Greview      :Git! diff --staged
nnoremap <leader>gr  :Greview<cr>
nnoremap <leader>gw  :Gwrite<CR><CR>
nnoremap <leader>st  :Git<CR>
nnoremap <leader>cF  :Git commit --no-verify --fixup HEAD -a<cr>
" nnoremap <leader>ps  :Dispatch! git push<CR>
" nnoremap <leader>psf :Dispatch! git push --force<CR>
" nnoremap <leader>pr  :Dispatch! git pull --rebase<CR>
nnoremap <leader>ps  :Git push --force-with-lease<CR>
nnoremap <leader>psf :Git push --force<CR>
nnoremap <leader>rb  :Git rebase -i origin/master~1<CR>

function! GitFileMode()
  nnoremap <buffer> n <c-n>
  nnoremap <buffer> p <c-p>
  nnoremap <buffer> q :q<CR>

  setlocal nonumber
endfunction
autocmd filetype fugitive call GitFileMode()
autocmd filetype git call GitFileMode()
