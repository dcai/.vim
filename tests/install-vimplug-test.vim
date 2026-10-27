" POSIX test: nvim --headless -u NONE -i NONE -S tests/install-vimplug-test.vim
" Also run with: vim -Nu NONE -i NONE -n -es -S tests/install-vimplug-test.vim
let s:root = tempname() . ' with spaces'
call mkdir(s:root . '/bin', 'p')
call writefile([
      \ '#!/bin/sh',
      \ 'while [ "$1" != "--output" ]; do shift; done',
      \ 'printf ''" vim-plug fixture\n'' > "$2"',
      \ 'if [ "$INSTALL_VIMPLUG_FAIL" = 1 ]; then echo download-failed >&2; exit 22; fi',
      \ ], s:root . '/bin/curl')
call setfperm(s:root . '/bin/curl', 'rwx------')
let s:path = $PATH
let $PATH = s:root . '/bin:' . s:path
let g:vim_home = s:root . '/vim-config'
let $XDG_CONFIG_HOME = s:root . '/nvim-config'
execute 'source ' . fnameescape(getcwd() . '/before/vim-plug-install.vim')
let s:config = has('nvim') ? stdpath('config') : g:vim_home
if stridx(s:config, s:root) != 0
  echoerr 'Installer test must use an isolated configuration directory'
  cquit 1
endif
let s:target = s:config . '/autoload/plug.vim'
call assert_false(filereadable(s:target), 'startup must not install vim-plug')
InstallVimPlug
call assert_equal(['" vim-plug fixture'], readfile(s:target))
call assert_equal(0, exists(':PlugInstall'), 'installation must not activate vim-plug')
call writefile(['existing manager'], s:target)
InstallVimPlug
call assert_equal(['existing manager'], readfile(s:target), 'do not overwrite existing files')

call delete(s:target)
let $INSTALL_VIMPLUG_FAIL = '1'
let v:errmsg = ''
silent! InstallVimPlug
call assert_match('download failed', v:errmsg)
call assert_false(filereadable(s:target), 'failed downloads must not leave partial files')
call assert_equal([], glob(s:target . '.tmp.*', 0, 1))
let $INSTALL_VIMPLUG_FAIL = '0'
let $PATH = s:root . '/empty-bin'
let v:errmsg = ''
silent! InstallVimPlug
call assert_match('requires curl', v:errmsg)
let $PATH = s:path
call delete(s:root, 'rf')
if !empty(v:errors)
  call writefile(v:errors, '/dev/stderr')
  cquit 1
endif
echomsg 'InstallVimPlug: editor detection, safe download and failure cleanup passed'
qa!
