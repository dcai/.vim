syntax keyword LOGLEVEL INFO DEBUG WARN ERROR FATAL

" Dates and Times
"---------------------------------------------------------------------------
" Matches 2018-03-12T or 12/03/2018 or 12/Mar/2018
syn match logDate '\d\{2,4}[-\/]\(\d\{2}\|Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\)[-\/]\d\{2,4}T\?'
" Matches 8 digit numbers at start of line starting with 20
syn match logDate '^20\d\{6}'
" Matches Fri Jan 09 or Feb 11 or Apr  3 or Sun 3
syn keyword logDate Mon Tue Wed Thu Fri Sat Sun Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec nextgroup=logDateDay
syn match logDateDay '\s\{1,2}\d\{1,2}' contained

" Matches 12:09:38 or 00:03:38.129Z or 01:32:12.102938 +0700
syn match logTime '\d\{2}:\d\{2}:\d\{2}\(\.\d\{2,6}\)\?\(\s\?[-+]\d\{2,4}\|Z\)\?\>' nextgroup=logTimeZone,logSysColumns skipwhite

" Follows logTime, matches UTC or PDT 2019 or 2019 EDT
syn match logTimeZone '[A-Z]\{2,5}\>\( \d\{4}\)\?' contained
syn match logTimeZone '\d\{4} [A-Z]\{2,5}\>' contained

syn match logFilePath   '\<\w:\\[^\n|,; ()'"\]{}]\+'
syn match logFilePath   '[^a-zA-Z0-9"']\@<=\/\w[^\n|,; ()'"\]{}]\+'

hi def link logTime Identifier
hi def link logDate Identifier
hi def link LOGLEVEL Keyword
hi def link logFilePath Label
