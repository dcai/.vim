command! Greview :Git diff
let g:fugitive_pty = 0
let g:fugitive_dynamic_colors = 1

function! GitFileMode()
  nmap <buffer> n )
  nmap <buffer> p (
  nmap <c-j> :lnext<CR>
  nmap <c-k> :lprev<CR>
  nmap <buffer> q :q<CR>
  nmap <buffer> <tab> =
  setlocal nonumber
  setlocal foldmethod=syntax
  setlocal foldlevelstart=0
  setlocal foldlevel=0
endfunction

augroup fugitiveGroup
  autocmd!
  autocmd filetype fugitive call GitFileMode()
  autocmd filetype git call GitFileMode()
augroup end

if !has('nvim')
  nnoremap <leader>gs :Git<CR>
  nnoremap <leader>gw :Gwrite<CR><CR>
  nnoremap <leader>gc :Git commit -a<cr>
  " the `!` is to run in the background
  nnoremap <leader>gf :Dispatch! git commit --no-verify --fixup HEAD -a<cr>
  nnoremap <leader>gg :Dispatch! git pull --tags --rebase<CR>
  nnoremap <leader>gp :Dispatch! git push --tags --force-with-lease --no-verify<CR>
  nnoremap <leader>gP :Dispatch! git push -uf --no-verify<CR>
  nnoremap <leader>gr :Git rebase -i --committer-date-is-author-date origin/HEAD~5<CR>
  nnoremap <leader>gv :Gvdiffsplit!<CR>
  nnoremap <leader>g2 :diffget //2<CR>
  nnoremap <leader>g3 :diffget //3<CR>
endif
