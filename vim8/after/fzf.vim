"""""""""""""""""""""""""""""""""""""""
""" FZF
"""""""""""""""""""""""""""""""""""""""
let g:fzf_command_prefix = 'Fzf'

" You can toggle file preview with ctrl-/.
" It will show on the right with 50% width, but if the width is smaller
" than 70 columns, it will show above the candidate list
" let g:fzf_preview_window = ['right,50%,<70(up,40%)', 'ctrl-/']

" Empty value to disable preview window altogether
let g:fzf_preview_window = []

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" Customize fzf colors to match your color scheme
" let g:fzf_colors =
"       \ {
"         \ 'fg':      ['fg', 'Normal'],
"         \ 'bg':      ['bg', 'Normal'],
"         \ 'hl':      ['fg', 'Comment'],
"         \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"         \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"         \ 'hl+':     ['fg', 'Statement'],
"         \ 'info':    ['fg', 'PreProc'],
"         \ 'border':  ['fg', 'Ignore'],
"         \ 'prompt':  ['fg', 'Conditional'],
"         \ 'pointer': ['fg', 'Exception'],
"         \ 'marker':  ['fg', 'Keyword'],
"         \ 'spinner': ['fg', 'Label'],
"         \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/fzf-history'

" let g:fzf_layout = { 'down': '~30%' }
let g:fzf_layout = {
    \   'window': {
    \     'width': 1.0, 'height': 0.6, 'yoffset': 1.0, 'border': 'top'
    \   }
    \ }

let s:fzf_base_options = extend({'options': ''}, g:fzf_layout)

function! s:extend(base, extra)
  let base = copy(a:base)
  if has_key(a:extra, 'options')
    let extra = copy(a:extra)
    let extra.extra_options = remove(extra, 'options')
    return extend(base, extra)
  endif
  return extend(base, a:extra)
endfunction

function! s:with_git_root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  return v:shell_error ? {} : {'dir': root}
endfunction

" Ag search in current dir
function! s:ag_in_dir(...)
  call fzf#vim#ag(
        \ join(a:000[1:], ' '),
        \ extend({'dir': a:1}, s:fzf_base_options))
endfunction

function! s:ag_search_word_in_git()
  execute 'AgGitRoot ' expand('<cword>')
endfunction

" Create vim command `AgInDir` to search in dir
command! -nargs=+ -complete=dir AgInDir
      \ call s:ag_in_dir(<f-args>)
" Create Ag search command `AgGitRoot` in git root
command! -nargs=* AgGitRoot
      \ call fzf#vim#ag(<q-args>, extend(s:with_git_root(), s:fzf_base_options))

function! s:rg_raw(command_suffix, ...)
  if !executable('rg')
    return s:warn('rg is not found')
  endif
  let s:cmd='rg --column --line-number --no-heading --color=always --smart-case -- ' .
        \ a:command_suffix
  return call('fzf#vim#grep', extend([s:cmd, 1], a:000))
endfunction

function! s:rg(query, ...)
  let query = empty(a:query) ? '' : a:query
  let args = copy(a:000)
  return call('s:rg_raw', insert(args, fzf#shellescape(query), 0))
endfunction

function! s:rg_in_dir(...)
  call s:rg(join(a:000[1:], ' '), extend({'dir': a:1}, s:fzf_base_options))
endfunction

function! RgSearchWordGit()
  execute 'RgGitRoot ' expand('<cword>')
endfunction

command! -bang -nargs=* Rg call s:rg(<q-args>, s:fzf_base_options)
command! -nargs=+ -complete=dir RgInDir call s:rg_in_dir(<f-args>)
command! -bang -nargs=* RgGitRoot call
      \ s:rg(<q-args>, extend(s:with_git_root(), s:fzf_base_options))

"""""""""""""""""""""""""""""""""""""""
""" fzf spell
"""""""""""""""""""""""""""""""""""""""
" https://coreyja.com/vim-spelling-suggestions-fzf/
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  " google autosuggest
  " let suggestions = systemlist('gg ' . expand("<cword>"))
  return fzf#run(extend(
        \ {'source': suggestions, 'sink': function("FzfSpellSink")},
        \ s:fzf_base_options))
endfunction

if !has('nvim')
  nnoremap z= :call FzfSpell()<CR>

  " apt install wbritish
  " use wamerican for american spelling
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)

  nnoremap <silent> <leader>ll :FzfBuffers<cr>
  nnoremap <silent> <leader>fb :FzfBuffers<cr>
  nnoremap <silent> <leader>fd :FzfFiles<cr>
  nnoremap <silent> <leader>ff :FzfGFiles<cr>
  nnoremap <silent> <leader>fr :FzfHistory<CR>
  nnoremap <silent> <leader>/ :RgGitRoot<CR>
  nnoremap <silent> <leader>. :call RgSearchWordGit()<CR>
  nnoremap <silent> <leader>; :FzfCommands<cr>
  nnoremap <silent> <leader>\ :RgInDir .<CR>
endif
