" don't know why but shell should be defined in this script
" if move to config.vim, it slows the neovim a lot.
" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh

let g:vim_home = expand('<sfile>:p:h')

let g:vim_data = '$HOME/.local/share/vim'
if has('nvim')
  let g:vim_data = '$HOME/.local/share/nvim'
endif

if has('win64') || has('win32') || has('win16')
  let g:osuname = 'Windows'
  let g:vimrc = 'vimfiles'
  let g:wsl = 0
else
  let g:osuname = substitute(system('uname'), "\n", '', '')
  let g:vimrc ='.vim'
  let g:wsl = matchstr(g:osuname, 'microsoft')
endif

function! IncludeScript(scriptname)
  execute 'source ' . g:vim_home . '/' . a:scriptname
endfunction

function! IncludeDir(dirname)
  for f in split(glob(a:dirname), '\n')
    exe 'source' f
  endfor
endfunction

function! FindExecutable(paths)
  for p in a:paths
    if executable(p)
      return p
    endif
  endfor
endfunction

function! IsEnvVarSet(name)
  return !empty(getenv(a:name))
endfunction

" this must load before others
call IncludeScript('core.vim')

if has('gui_running')
  call IncludeScript('gui.vim')
endif

if g:osuname ==? 'Linux'
  call IncludeScript('os/linux.vim')
elseif g:osuname ==? 'Darwin'
  call IncludeScript('os/macos.vim')
elseif g:osuname ==? 'Windows'
  call IncludeScript('os/windows.vim')
endif

if g:wsl ==? 'Microsoft'
  call IncludeScript('os/wsl.vim')
endif


call IncludeDir(g:vim_home . '/before/*.vim')
""""""""""""""""""""""""""""""""""""""""
" load vim-plug
" should load after config
""""""""""""""""""""""""""""""""""""""""
call IncludeScript('plug/plug.vim')

if !exists('g:lightline')
  call IncludeScript('statusline.vim')
endif
