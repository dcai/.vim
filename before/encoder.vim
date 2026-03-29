command! -range=% B64D <line1>,<line2>!base64 -d
command! -range=% B64E <line1>,<line2>!base64
command! -range=% URLE <line1>,<line2>!enc.py urlencode
command! -range=% URLD <line1>,<line2>!enc.py urldecode
command! -range=% JWT <line1>,<line2>!enc.py jwt
