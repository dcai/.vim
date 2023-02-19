set nocompatible
" this enables filetype specific plugin and indent files
" run :filetype see status
filetype plugin indent on

if exists('syntax_on')
  syntax reset
else
  syntax on
endif

" set shell=/bin/bash\ --norc\ --noprofile
set shell=/bin/sh

if has('win64') || has('win32') || has('win16')
  let g:osuname = 'Windows'
  let g:vimrc = 'vimfiles'
  let g:wsl = 0
else
  let g:osuname = substitute(system('uname'), "\n", '', '')
  let g:vimrc ='.vim'
  let g:wsl = matchstr(substitute(system('uname -r'), "\n", '', ''), 'microsoft')
endif

function! IncludeScript(scriptname)
  execute 'source $HOME/' . g:vimrc . '/' . a:scriptname
endfunction

function! IncludeDir(dirname)
  for f in split(glob(a:dirname), '\n')
    exe 'source' f
  endfor
endfunction
call IncludeScript('plug/plug.vim')
call IncludeScript('local.vim')
call IncludeScript('keybindings.vim')

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

if has('nvim')
  call IncludeScript('nvim.vim')
  call IncludeDir('$HOME/' . g:vimrc . '/lua/*.lua')
endif

if !has('nvim')
  call IncludeScript('coc.vim')
endif

" if !exists('g:lightline')
call IncludeScript('statusline.vim')
" endif
