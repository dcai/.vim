if exists('b:current_syntax')
  finish
endif

syn keyword ldlBoolean true false NULL_VALUE
syn keyword ldlBooleanOperator AND OR NOT
syn keyword ldlFunction CAST REGEXP_EXTRACT SEARCH TIME_ZONE
syn keyword ldlFunction cast ip_in_net log_id regexp_extract sample source
syn keyword ldlType BOOL DURATION FLOAT64 INT64 STRING TIMESTAMP

syn keyword ldlField httpRequest insertId jsonPayload labels logName metadata operation
syn keyword ldlField protoPayload receiveTimestamp resource severity sourceLocation spanId
syn keyword ldlField textPayload timestamp trace
syn keyword ldlField cacheFillBytes cacheHit cacheLookup cacheValidatedWithOriginServer latency
syn keyword ldlField protocol referer remoteIp requestMethod requestSize requestUrl responseSize
syn keyword ldlField serverIp status userAgent first id last producer type file function line
syn keyword ldlField systemLabels userLabels

syn keyword ldlSeverity DEFAULT DEBUG INFO NOTICE WARNING ERROR CRITICAL ALERT EMERGENCY
syn match ldlComment '--.*$'
syn region ldlString start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match ldlNumber '\<[+-]\=\d\+\%(\.\d\+\)\=\%([eE][+-]\=\d\+\)\=\>'
syn match ldlNumber '\<\%(NaN\|Infinity\)\>'
syn match ldlOperator '\(!=\|!\~\|=\~\|>=\|<=\|=\|:\|>\|<\)'
syn match ldlOperator '\(^\|\s\)\zs-\ze\h'
syn match ldlDelimiter '[(),]'

hi def link ldlBoolean Boolean
hi def link ldlBooleanOperator Keyword
hi def link ldlComment Comment
hi def link ldlDelimiter Delimiter
hi def link ldlField Identifier
hi def link ldlFunction Function
hi def link ldlNumber Number
hi def link ldlOperator Operator
hi def link ldlSeverity Constant
hi def link ldlString String
hi def link ldlType Type

let b:current_syntax = 'ldl'
