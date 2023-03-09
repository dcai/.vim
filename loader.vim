" don't know why but shell should be defined in this script
" if move to config.vim, it slows the neovim a lot.
" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh

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
  execute 'source $HOME/' . g:vimrc . '/' . a:scriptname
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

call IncludeScript('config.vim')
call IncludeScript('keymap.vim')

if has('gui_running')
  call IncludeScript('gui.vim')
else
  call IncludeScript('term.vim')
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

call IncludeDir('$HOME/' . g:vimrc . '/conf.d/*.vim')


""""""""""""""""""""""""""""""""""""""""
" load vim-plug
" should load after config
""""""""""""""""""""""""""""""""""""""""
call IncludeScript('plug/plug.vim')

" if !exists('g:lightline')
  call IncludeScript('statusline.vim')
" endif
