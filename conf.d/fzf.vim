"""""""""""""""""""""""""""""""""""""""
""" FZF
"""
""" Credit:
""" https://github.com/zenbro/dotfiles/blob/master/.nvimrc
"""""""""""""""""""""""""""""""""""""""
let g:fzf_layout = { 'down': '~40%' }
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

map <c-l> :Buffers<cr>
nmap <leader>bb :Buffers<cr>
nmap <leader>ff :GitFiles<cr>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>\ :execute 'Ag ' . input('Ag/')<CR>
" Search in current dir
nnoremap <silent> <leader>. :AgInDir .<CR>
nnoremap <silent> <leader>/ :call SearchWordWithAgInGit()<CR>
nnoremap <silent> <leader>sc :Commits<CR>
" commits for current bufffer
nnoremap <silent> <leader>sbc :BCommits<CR>
nnoremap <silent> <leader>sft :Filetypes<CR>
vnoremap <silent> <leader>ss :call SearchVisualSelectionWithAg()<CR>

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

" Ag search in git root
function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

" Ag search in current dir
function! SearchWithAgInDirectory(...)
  call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf_layout))
endfunction

" Create vim command `AgInDir` to search in dir
command! -nargs=+ -complete=dir AgInDir call SearchWithAgInDirectory(<f-args>)

function! SearchWordWithAgInGit()
  execute 'AgGitRoot ' expand('<cword>')
endfunction

" Create Ag search command `AgGitRoot` in git root
command! -nargs=* AgGitRoot
      \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), g:fzf_layout))


" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore
            \ --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>),
            \ 1,
            \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
            \ <bang>0)
