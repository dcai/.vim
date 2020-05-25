set termencoding=utf-8
set t_Co=256

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

" allows cursor change in tmux mode
" https://dougblack.io/words/a-good-vimrc.html#colors
let s:cursor_si = "\<Esc>]50;CursorShape=1\x7"
let s:cursor_ei = "\<Esc>]50;CursorShape=0\x7"

let &t_SI = WrapForTmux(s:cursor_si)
let &t_EI = WrapForTmux(s:cursor_ei)
