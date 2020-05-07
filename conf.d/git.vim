command Greview :Git! diff --staged
nnoremap <leader>gr :Greview<cr>
nnoremap <leader>cF :Git commit --no-verify --fixup HEAD -a<cr>
nnoremap <leader>ps :Dispatch! git push<CR>
nnoremap <leader>pr :Dispatch! git pull --rebase<CR>
nnoremap <leader>st :Git<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>rb :Git rebase -i origin/master~5<CR>
