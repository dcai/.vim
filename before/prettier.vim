command! Prettier %!NODE_TLS_REJECT_UNAUTHORIZED=1 npx prettier --stdin-filepath %
command! -range=% -nargs=1 PrettierSelected <line1>,<line2>!prettier --stdin-filepath fakefile.<args>
