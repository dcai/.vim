" Optional installer only; this does not activate vim-plug.
function! s:InstallVimPlug() abort
  if has('nvim')
    let l:root = stdpath('config')
  else
    let l:root = get(g:, 'vim_home', expand(has('win32') ? '~/vimfiles' : '~/.vim'))
  endif
  let l:target = l:root . '/autoload/plug.vim'
  if filereadable(l:target)
    echomsg 'vim-plug is already installed: ' . l:target
    return
  endif
  if !executable('curl')
    echoerr 'InstallVimPlug requires curl.'
    return
  endif

  call mkdir(fnamemodify(l:target, ':h'), 'p')
  let l:temporary = l:target . '.tmp.' . getpid()
  let l:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let l:output = system(shellescape(exepath('curl'))
        \ . ' --fail --location --silent --show-error --output '
        \ . shellescape(l:temporary) . ' ' . shellescape(l:url))
  if v:shell_error != 0
    call delete(l:temporary)
    echoerr 'InstallVimPlug download failed: ' . l:output
    return
  endif
  if rename(l:temporary, l:target) != 0
    call delete(l:temporary)
    echoerr 'InstallVimPlug could not save: ' . l:target
    return
  endif
  echomsg 'Installed vim-plug: ' . l:target . ' (not activated)'
endfunction

command! InstallVimPlug call <SID>InstallVimPlug()
