if exists('b:current_syntax')
  finish
endif

syn keyword dqlCommand append data dedup describe expand fetch fields fieldsAdd fieldsFlatten
syn keyword dqlCommand fieldsKeep fieldsRemove fieldsRename fieldsSnapshot fieldsSummary filter
syn keyword dqlCommand filterOut jsonExtract join joinNested limit load lookup makeTimeseries
syn keyword dqlCommand metrics parse search smartscapeEdges smartscapeNodes sort summarize
syn keyword dqlCommand timeseries traverse

syn keyword dqlBoolean true false null
syn keyword dqlBooleanOperator and or xor not in
syn keyword dqlParameter as by default else execution from interval on prefix rename source
syn keyword dqlParameter timeframe to
syn keyword dqlType array binary boolean double duration ipAddress long record smartscapeId
syn keyword dqlType string timeframe timestamp uid

syn keyword dqlFunction abs array arrayAvg arrayContains arrayDistinct arrayFilter arrayFirst
syn keyword dqlFunction arrayFlatten arrayLast arrayMap arrayMax arrayMedian arrayMin arrayPercentile
syn keyword dqlFunction arrayRemoveNulls arrayReverse arraySize arraySort arraySum arrayToString
syn keyword dqlFunction arrayUnion avg ceil coalesce collectArray collectDistinct concat contains
syn keyword dqlFunction correlation count countDistinct countDistinctApprox countDistinctExact countIf
syn keyword dqlFunction decodeUrl duration endsWith exp floor if indexOf ipInRange isNull
syn keyword dqlFunction jsonField jsonPath lastIndexOf like log levenshteinDistance lower matchesPattern
syn keyword dqlFunction matchesPhrase matchesValue max median min now parseAll percentile percentiles
syn keyword dqlFunction percentRank record replacePattern replaceString round splitByPattern splitString
syn keyword dqlFunction startsWith stringLength substring sum takeAny takeFirst takeLast takeMax takeMin
syn keyword dqlFunction timeframe toArray toBoolean toDouble toDuration toIpAddress toLong toString
syn keyword dqlFunction toTimestamp toUid trim truncate upper variance

syn keyword dqlField content dt.entity.host dt.entity.process_group_instance dt.entity.service
syn keyword dqlField log.level log.source span_id timestamp trace_id
syn match dqlNumber '\<0x\x\+\>'
syn match dqlNumber '\<[+-]\=\d\+\%(\.\d\+\)\=\%([eE][+-]\=\d\+\)\=\>'
syn match dqlOperator '==\|!=\|<=\|>=\|[+\-*/%@~<>|=]'
syn match dqlDelimiter '[,;:()[\]{}]'
syn match dqlField '\<[A-Za-z_][A-Za-z0-9_]*\%(\.[A-Za-z_][A-Za-z0-9_]*\)\+\>'
syn match dqlComment '//.*$'
syn region dqlString start=+"+ skip=+\\\\\|\\"+ end=+"+
syn region dqlString start=+"""+ end=+"""+
syn region dqlField start=+`+ skip=+\\\\\|\\`+ end=+`+
syn match dqlDuration '\<[+-]\=\d\+\%(\.\d\+\)\=\%(ns\|ms\|s\|m\|h\|d\|w\|M\|q\|y\)\>'

hi def link dqlBoolean Boolean
hi def link dqlBooleanOperator Keyword
hi def link dqlCommand Statement
hi def link dqlComment Comment
hi def link dqlDelimiter Delimiter
hi def link dqlDuration Constant
hi def link dqlField Identifier
hi def link dqlFunction Function
hi def link dqlNumber Number
hi def link dqlOperator Operator
hi def link dqlParameter Keyword
hi def link dqlString String
hi def link dqlType Type

let b:current_syntax = 'dql'
