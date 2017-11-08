"""""""""""""""""""""""""""""""""""""""
""" ctrl-p/ctrlp
"""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_root_markers = [
            \ '.git',
            \ 'pom.xml',
            \ 'Makefile',
            \ 'package.json'
            \]
"let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_mruf_exclude = '/tmp/.*\|/var/tmp/.*|COMMIT_EDITMSG'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn|CVS|node_modules|vendor)$',
      \ 'file': '\v\.(exe|so|dll|jar|pdf|doc|pyc|class|jpg|png|gif)$',
      \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
      \ }
let g:ctrlp_use_caching = 1
let g:cachedir=$HOME . "/.ctrlp_cache"
if !isdirectory(expand(cachedir))
  call mkdir(expand(cachedir))
endif
let g:ctrlp_cache_dir = cachedir


" Use rg/ag in CtrlP for listing files. Lightning fast and respects .gitignore
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  if executable('ag')
    " Use Ag over Grep
    " Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
    " set grepprg=ag\ --vimgrep\ --nogroup\ --nocolor
    " set grepprg=ag\ --vimgrep\ $*
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
  endif
endif
"t - in a new tab.
"h - in a new horizontal split.
"v - in a new vertical split.
"r - in the current window.
let g:ctrlp_open_new_file = 'r'
