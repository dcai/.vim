"""""""""""""""""""""""""""""""""""""""
""" vimwiki
"""""""""""""""""""""""""""""""""""""""
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_use_mouse = 1
let g:vimwiki_CJK_length = 1
let g:mainwiki = {
      \ 'auto_export':      0,
      \ 'custom_wiki2html': '~/Dropbox/src/php/phpvimwiki/main.php',
      \ 'path':             '~/Dropbox/mysite/contents/wiki/',
      \ 'path_html':        '~/Dropbox/mysite/output/wiki/',
      \ 'template_path':    '~/Dropbox/mysite/contents/wiki/templates',
      \ 'template_default': 'default',
      \ 'template_ext':     '.tpl',
      \ 'syntax':           'markdown',
      \ 'ext':              '.md',
      \ 'css_name':         'wikistyle.css',
      \ 'list_margin':      0,
      \ 'diary_rel_path':   'diary/',
      \ }
let g:vimwiki_list = [mainwiki]
":map <leader>ww <Nop>
":map <leader>wt <Nop>
map <Leader>wwi <Plug>VimwikiDiaryIndex
