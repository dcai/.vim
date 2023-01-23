command! Greview      :Git diff
nnoremap <leader>gs   :Git<CR> " git status
nnoremap <leader>gw   :Gwrite<CR><CR>
nnoremap <leader>gcf  :Dispatch! git commit --no-verify --fixup HEAD -a<cr>
nnoremap <leader>gcc  :Git commit<cr>
nnoremap <leader>gpr  :Dispatch! git pull --tags --rebase<CR>
nnoremap <leader>gpf  :Dispatch! git push --tags --force-with-lease<CR>
nnoremap <leader>gp   :Dispatch! git push<CR>
nnoremap <leader>gr   :Git rebase -i --committer-date-is-author-date origin/HEAD<CR>

" Tig
nnoremap <leader>gg   :TigOpenProjectRootDir<CR>
nnoremap <leader>gm   :TigBlame<CR>

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
