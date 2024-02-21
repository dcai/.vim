command! Greview      :Git diff

nnoremap <leader>gs   :Git<CR>
nnoremap <leader>gw   :Gwrite<CR><CR>
nnoremap <leader>gcc  :Git commit<cr>
" the `!` is to run in the background
nnoremap <leader>gcf  :Dispatch! git commit --no-verify --fixup HEAD -a<cr>
nnoremap <leader>gpr  :Dispatch! git pull --tags --rebase<CR>
nnoremap <leader>gpf  :Dispatch! git push --tags --force-with-lease<CR>
nnoremap <leader>gps  :Dispatch! git push<CR>
nnoremap <leader>grb  :Git rebase -i --committer-date-is-author-date origin/HEAD~5<CR>

nnoremap <leader>gds :Gvdiffsplit!<CR>
nnoremap <leader>gdl :diffget //2<CR>
nnoremap <leader>gdr :diffget //3<CR>

" Tig
" nnoremap <leader>gg   :TigOpenProjectRootDir<CR>
" nnoremap <leader>gm   :TigBlame<CR>

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
