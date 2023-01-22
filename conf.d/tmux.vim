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
  let lastfile = system(cmd)
  let tokens = split(lastfile, ':')
  let fullpath = get(tokens, 0)
  if filereadable(fullpath)
    exe 'e ' . fullpath
    call cursor(str2nr(tokens[1]), str2nr(tokens[2]))
  else
    echo "LastPath(): File not found " . lastfile
  endif
endfunction

function! Terminal(cmd)
   call VimuxRunCommand(a:cmd)
   call system('tmux select-pane -t ' . g:VimuxRunnerIndex)
endfunction

function! StartTestsWatch()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  let filepath = expand('%:p')
  let testrunner = 'npx mocha --full-trace --watch ' . filepath
  let cmd = "tmux split-window -h -c '" . root . "' '" . testrunner . "'"
  " let result = system(cmd)
  " call VimuxRunCommand(testrunner)
endfunction

map <leader>ttt :call Terminal('pwd')<cr>
map <leader>ttf :call LastPath()<cr>
map <leader>ttc :call VimuxCloseRunner()<cr>
map <leader>utw :call StartTestsWatch()<cr>
