"""""""""""""""""""""""""""""""""""""""
""" FZF
"""""""""""""""""""""""""""""""""""""""
let g:fzf_layout = { 'down': '~40%' }
let s:fzf_base_options = extend({'options': '--delimiter : --nth 4..'}, g:fzf_layout)
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

""" Credit:
""" https://github.com/zenbro/dotfiles/blob/master/.nvimrc
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
  call fzf#vim#ag(
        \ join(a:000[1:], ' '),
        \ extend({'dir': a:1}, s:fzf_base_options))
endfunction
" Create vim command `AgInDir` to search in dir
command! -nargs=+ -complete=dir AgInDir
      \ call SearchWithAgInDirectory(<f-args>)


function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

" Create Ag search command `AgGitRoot` in git root
command! -nargs=* AgGitRoot
      \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), s:fzf_base_options))

function! SearchWordWithAgInGit()
  execute 'AgGitRoot ' expand('<cword>')
endfunction

" apt install wbritish
" use wamerican for american spelling
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
imap <c-x><c-s> <esc>:Snippets<CR>

vnoremap <silent> <leader>agsv
      \ :call SearchVisualSelectionWithAg()<CR>
map <c-l> :Buffers<cr>
nmap <leader>bb :Buffers<cr>
nmap <leader>ff :GitFiles<cr>
nnoremap <silent> <leader>fr :History<CR>
nnoremap <silent> <leader>sc :Commits<CR>
nnoremap <silent> <leader>sft :Filetypes<CR>
nnoremap <silent> <leader>sp :Snippets<CR>
nnoremap <silent> <leader>. :AgGitRoot<CR>
" Search in current dir
nnoremap <silent> <leader>/ :AgInDir .<CR>
" commits for current bufffer
nnoremap <silent> <leader>sbc :BCommits<CR>

function! s:extend(base, extra)
  let base = copy(a:base)
  if has_key(a:extra, 'options')
    let extra = copy(a:extra)
    let extra.extra_options = remove(extra, 'options')
    return extend(base, extra)
  endif
  return extend(base, a:extra)
endfunction

" WIP
function! CompleteWord(...)
  return fzf#vim#complete(s:extend({
    \ 'source': 'gg'},
    \ get(a:000, 0, fzf#wrap())))
endfunction

inoremap <expr> <plug>(my-fzf-complete-word) CompleteWord()
imap <c-x><c-d> <plug>(my-fzf-complete-word)
