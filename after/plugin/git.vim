command! Greview      :Git diff

if !has('nvim')
  nnoremap <leader>gs   :Git<CR>
  nnoremap <leader>gw   :Gwrite<CR><CR>
  nnoremap <leader>gc  :Git commit -a<cr>
  " the `!` is to run in the background
  nnoremap <leader>gf  :Dispatch! git commit --no-verify --fixup HEAD -a<cr>
  nnoremap <leader>gr  :Dispatch! git pull --tags --rebase<CR>
  nnoremap <leader>gp  :Dispatch! git push --tags --force-with-lease --no-verify<CR>
  nnoremap <leader>gP  :Dispatch! git push -uf --no-verify<CR>
  nnoremap <leader>gr  :Git rebase -i --committer-date-is-author-date origin/HEAD~5<CR>
  " nnoremap <leader>gds :Gvdiffsplit!<CR>
  " nnoremap <leader>gdl :diffget //2<CR>
  " nnoremap <leader>gdr :diffget //3<CR>
endif

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
