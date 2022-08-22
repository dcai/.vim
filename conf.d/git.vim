command! Greview      :Git diff
nnoremap <leader>gg        :Git<CR> " git status
nnoremap <leader>gw   :Gwrite<CR><CR>
nnoremap <leader>gcv  :Git commit -v<cr>
nnoremap <leader>gcf  :Git commit --no-verify --fixup HEAD -a<cr>
nnoremap <leader>gpr  :Dispatch! git pull --rebase<CR>
nnoremap <leader>gpf  :Dispatch! git push --force-with-lease<CR>
nnoremap <leader>gps  :Dispatch! git push<CR>
nnoremap <leader>gr   :Git rebase -i origin/master<CR>
" nnoremap <leader>psf :Git push --force<CR>

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
