"""""""""""""""""""""""""""""""""""""""
""" FZF
"""
""" Credit:
""" https://github.com/zenbro/dotfiles/blob/master/.nvimrc
"""""""""""""""""""""""""""""""""""""""
map <c-l> :Buffers<cr>
nmap <leader>ff :GitFiles<cr>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
" Search in current dir
nnoremap <silent> <leader>. :AgIn .<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>
nnoremap <silent> KK :call SearchWordWithAg()<CR>

" insert mode
imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)


function! SearchVisualSelectionWithAg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Ag' selection
endfunction

" Ag search in current dir
function! SearchWithAgInDirectory(...)
  call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1},
        \ g:fzf#vim#default_layout))
endfunction

" Create vim command to search in dir
command! -nargs=+ -complete=dir AgIn
      \ call SearchWithAgInDirectory(<f-args>)

" Ag search in git root
function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

function! SearchWordWithAg()
  execute 'AgGitRoot ' expand('<cword>')
endfunction

" Create Ag search in git root
command! -nargs=* AgGitRoot
      \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(),
      \ g:fzf#vim#default_layout))
