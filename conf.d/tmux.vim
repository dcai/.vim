function! OpenFailingTest()
  " 1. select left pane
  " 2. capture left pane text and grep last path printed by mocha test
  " 3. select the right pane again, the path is available to vim
  let lastFile = system("tmux select-pane -L && tmux capture-pane -pJ -S - | rg --color never -o '[[:alnum:]_.$&+=/@-]*:[0-9]*:[0-9]*' | tail -n 1 && tmux select-pane -R")
  let path = split(lastFile, ':')
  echom path[0]
  if filereadable(path[0])
    exe 'e ' . path[0]
    call cursor(str2nr(path[1]), str2nr(path[2]))
  else
    echo "OpenFailingTest: File not found: " . lastFile
  endif
endfunction

map <leader>ut :call OpenFailingTest()<cr>
