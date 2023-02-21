let s:current_script_path = expand('<sfile>:p:h')

exec "source " . s:current_script_path . "/vimrc"

let g:python3_host_prog = FindExecutable(['/opt/homebrew/bin/python3', '/usr/bin/python3'])
call IncludeDir('$HOME/' . g:vimrc . '/neovim/*.lua')

nnoremap <leader>ff <cmd>lua require('fzf-lua').git_files()<CR>
nnoremap <leader>fr <cmd>lua require('fzf-lua').oldfiles()<CR>
nnoremap <leader>ll <cmd>lua require('fzf-lua').buffers()<CR>
nnoremap <leader>.  <cmd>lua require('fzf-lua').live_grep()<CR>
nnoremap <leader>/  <cmd>lua require('fzf-lua').builtin()<CR>
nnoremap <silent> K <cmd>lua require('fzf-lua').grep_cword()<CR>
