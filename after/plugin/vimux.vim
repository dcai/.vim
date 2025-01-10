"""""""""""""""""""""""""""""""""""""""
" Vimux plugin

"""""""""""""""""""""""""""""""""""""""

let g:VimuxHeight = "40"
let g:VimuxOrientation = "h" " h|v
" let g:VimuxRunnerName = "vimuxout"
let g:VimuxUseNearest = 0
let g:VimuxRunnerType = "window" " pane|window
" let g:VimuxCloseOnExit = 1

function! LastPath()
  " 1. select right pane
  " 2. capture pane text and grep last path printed by mocha test
  " 3. select the original pane again, the path is available to vim
  let parts = [
        \ 'tmux select-pane -R && tmux capture-pane -pJ -S -',
        \ "rg --color never -o '[[:alnum:]_.$&+=/@-]*:[0-9]*:[0-9]*'",
        \ "tail -n 1 && tmux select-pane -L"
        \]

  let cmd = join(parts, ' | ')
  let lastfile = trim(system(cmd))
  let tokens = split(lastfile, ':')
  let fullpath = get(tokens, 0)
  " for mocha, run it with `--full-trace` argument to print full path
  if filereadable(fullpath)
    exe 'e ' . fullpath
    call cursor(str2nr(tokens[1]), str2nr(tokens[2]))
  else
    echo "LastPath(): File not found: " . lastfile
  endif
endfunction

function! Terminal(cmd)
  call VimuxRunCommand(a:cmd)
  call system('tmux select-pane -t ' . g:VimuxRunnerIndex)
endfunction

let s:project_root=''
function! FindNodejsProjectRoot() abort
  " reset to empty
  let s:project_root = ''
  let l:current_dir = expand('%:p:h')

  function! RecurseFindRoot(dir, rootFile) abort
    if filereadable(a:dir . '/' . a:rootFile)
      let s:project_root = a:dir
      return
    endif
    let l:parent_dir = fnamemodify(a:dir, ':h')
    if l:parent_dir ==# a:dir
      return
    endif
    call RecurseFindRoot(l:parent_dir, a:rootFile)
  endfunction

  call RecurseFindRoot(l:current_dir, 'package.json')

  return s:project_root
endfunction

function s:cd(dir)
  return 'cd ' . a:dir
endfunction

function s:and(...)
  return join(a:000, ' && ')
endfunction

function! s:jest(env, path)
  return 'npx jest --runInBand --silent=false --coverage=false --watch --env=' . a:env . ' --runTestsByPath ' . a:path
endfunction

function! s:mocha(path)
  return 'npx mocha --full-trace --watch ' . a:path
endfunction

function! TestCurrentFileWithMocha()
  " let root = systemlist('git rev-parse --show-toplevel')[0]
  " let dir = expand('%:p:h')
  " let filepath = bufname("%")
  let root = FindNodejsProjectRoot()
  let filepath = expand('%:p')
  let testrunner = s:and(s:cd(root), s:mocha(filepath))
  call VimuxRunCommand(testrunner)
endfunction

function! TestCurrentFileWithJestNode()
  let filepath = expand('%:p')
  let root = FindNodejsProjectRoot()
  let testrunner = s:and(s:cd(root), s:jest('node', filepath))
  call VimuxRunCommand(testrunner)
endfunction

function! TestCurrentFileWithJestJsdom()
  let root = FindNodejsProjectRoot()
  let filepath = expand('%:p')
  let testrunner = s:and(s:cd(root), s:jest('jsdom', filepath))
  call VimuxRunCommand(testrunner)
endfunction

command! TestMocha     :call TestCurrentFileWithMocha()
command! TestJestNode  :call TestCurrentFileWithJestNode()
command! TestJestJsdom :call TestCurrentFileWithJestJsdom()

if !has('nvim')
  map <leader>tp :VimuxPromptCommand<cr>
  map <leader>tl :VimuxRunLastCommand<cr>
  map <leader>ti :VimuxInspectRunner<cr>
  map <leader>tq :VimuxCloseRunner<cr>
  map <leader>tx :VimuxInterruptRunner<cr>
  map <leader>tz :call VimuxZoomRunner()<cr>
  map <leader>tf :call LastPath()<cr>
endif
