let s:current_script_path = expand('<sfile>:p:h')

exec "source " . s:current_script_path . "/vimrc"

let g:python3_host_prog = FindExecutable(['/opt/homebrew/bin/python3', '/usr/local/bin/python3', '/usr/bin/python3'])
