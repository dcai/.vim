
exec "source ./vimrc"

let g:python3_host_prog = FindExecutable(['/opt/homebrew/bin/python3', '/usr/bin/python3'])
call IncludeDir('$HOME/' . g:vimrc . '/neovim/*.lua')
