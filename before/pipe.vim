command! Prettier %!NODE_TLS_REJECT_UNAUTHORIZED=1 npx prettier --stdin-filepath %
command! -range=% -nargs=1 PrettierSelected <line1>,<line2>!prettier --stdin-filepath fakefile.<args>
command! -range=% B64D <line1>,<line2>!base64 -d
command! -range=% B64E <line1>,<line2>!base64
command! -range=% JWT <line1>,<line2>!enc.py jwt
