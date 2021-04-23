" Vim syntax file
" Language: php PHP 3/4/5
" Maintainer: Peter Hodge <toomuchphp-vim@yahoo.com>
" Last Change:  June 9, 2006
" URL: http://www.vim.org/scripts/script.php?script_id=1571
"
" Former Maintainer:  Debian VIM Maintainers <pkg-vim-maintainers@lists.alioth.debian.org>
" Former URL: http://svn.debian.org/wsvn/pkg-vim/trunk/runtime/syntax/php.vim?op=file&rev=0&sc=0
"
" Note: If you are using a colour terminal with dark background, you will probably find
"       the 'elflord' colorscheme is much better for PHP's syntax than the default
"       colourscheme, because elflord's colours will better highlight the break-points
"       (Statements) in your code.
"
" Options:
"           php_parent_error_close = 1  for highlighting parent error ] or )
"           php_parent_error_open = 1  for skipping an php end tag, if there exists an open ( or [ without a closing one
"           php_sync_method = x
"                             x=-1 to sync by search ( default )
"                             x>0 to sync at least x lines backwards
"                             x=0 to sync from start
"
"       Added by Peter Hodge On June 9, 2006:
"           php_special_functions = 1|0 to highlight functions with abnormal behaviour
"           php_alt_comparisons = 1|0 to highlight comparison operators in an alternate colour
"           php_alt_assignByReference = 1|0 to highlight '= &' in an alternate colour
"
"           Note: these all default to 1 (On), so you would set them to '0' to turn them off.
"                 E.g., in your .vimrc or _vimrc file:
"                   let php_special_functions = 0
"                   let php_alt_comparisons = 0
"                   let php_alt_assignByReference = 0
"                 Unletting these variables will revert back to their default (On).
"
"
" Note:
" Setting php_folding=1 will match a closing } by comparing the indent
" before the class or function keyword with the indent of a matching }.
" Setting php_folding=2 will match all of pairs of {,} ( see known
" bugs ii )

" Known Bugs:
"  - setting  php_parent_error_close  on  and  php_parent_error_open  off
"    has these two leaks:
"     i) A closing ) or ] inside a string match to the last open ( or [
"        before the string, when the the closing ) or ] is on the same line
"        where the string started. In this case a following ) or ] after
"        the string would be highlighted as an error, what is incorrect.
"    ii) Same problem if you are setting php_folding = 2 with a closing
"        } inside an string on the first line of this string.
"
"  - A double-quoted string like this:
"      "$foo->someVar->someOtherVar->bar"
"    will highight '->someOtherVar->bar' as though they will be parsed
"    as object member variables, but PHP only recognizes the first
"    object member variable ($foo->someVar).
"
"

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

" accept old options
if !exists("php_sync_method")
  if exists("php_minlines")
    let php_sync_method=php_minlines
  else
    let php_sync_method=-1
  endif
endif

if exists("php_parentError") && !exists("php_parent_error_open") && !exists("php_parent_error_close")
  let php_parent_error_close=1
  let php_parent_error_open=1
endif

syn cluster htmlPreproc add=phpRegion,phpRegionSc

syn case match

" Env Variables
syn keyword phpEnvVar GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI contained

" Internal Variables
syn keyword phpIntVar GLOBALS PHP_ERRMSG PHP_SELF HTTP_GET_VARS HTTP_POST_VARS HTTP_COOKIE_VARS HTTP_POST_FILES HTTP_ENV_VARS HTTP_SERVER_VARS HTTP_SESSION_VARS HTTP_RAW_POST_DATA HTTP_STATE_VARS _GET _POST _COOKIE _FILES _SERVER _ENV _SERVER _REQUEST _SESSION  contained

" Constants
syn keyword phpCoreConstant PHP_VERSION PHP_OS DEFAULT_INCLUDE_PATH PEAR_INSTALL_DIR PEAR_EXTENSION_DIR PHP_EXTENSION_DIR PHP_BINDIR PHP_LIBDIR PHP_DATADIR PHP_SYSCONFDIR PHP_LOCALSTATEDIR PHP_CONFIG_FILE_PATH PHP_OUTPUT_HANDLER_START PHP_OUTPUT_HANDLER_CONT PHP_OUTPUT_HANDLER_END E_ERROR E_WARNING E_PARSE E_NOTICE E_CORE_ERROR E_CORE_WARNING E_COMPILE_ERROR E_COMPILE_WARNING E_USER_ERROR E_USER_WARNING E_USER_NOTICE E_ALL  contained

syn case ignore

syn keyword phpConstant  __LINE__ __DIR__ __FILE__ __FUNCTION__ __METHOD__ __CLASS__  contained

syn keyword phpMethods  attributes children get_attr get_nodes has_children has_siblings is_comment is_html is_jsp is_jste is_text is_xhtml is_xml next prev tidy_node contained
syn keyword phpFunctions in_array array_merge error_log contained

" Conditional
syn keyword phpConditional  declare else enddeclare endswitch elseif endif if switch  contained

" Repeat
syn keyword phpRepeat as do endfor endforeach endwhile for foreach while  contained

" Repeat
syn keyword phpLabel  case default switch contained

" Statement
syn keyword phpStatement  return break continue exit  contained

" Keyword
syn keyword phpKeyword  var const contained

" Type
syn keyword phpType bool[ean] int[eger] real double float string array object NULL  contained

" Structure
syn keyword phpStructure extends implements instanceof parent self contained

" Operator
syn match phpOperator "[-=+%^&|*!.~?:]" contained display
syn match phpOperator "[-+*/%^&|.]="  contained display
syn match phpOperator "/[^*/]"me=e-1  contained display
syn match phpOperator "\$"  contained display
syn match phpOperator "&&\|\<and\>" contained display
syn match phpOperator "||\|\<x\=or\>" contained display
syn match phpRelation "[!=<>]=" contained display
syn match phpRelation "[<>]"  contained display
syn match phpMemberSelector "->"  contained display
syn match phpVarSelector  "\$"  contained display

" Identifier
syn match phpIdentifier "$\h\w*"  contained contains=phpEnvVar,phpIntVar,phpVarSelector display
syn match phpIdentifierSimply "${\h\w*}"  contains=phpOperator,phpParent  contained display
syn region  phpIdentifierComplex  matchgroup=phpParent start="{\$"rs=e-1 end="}"  contains=phpIdentifier,phpMemberSelector,phpVarSelector,phpIdentifierComplexP contained extend
syn region  phpIdentifierComplexP matchgroup=phpParent start="\[" end="]" contains=@phpClInside contained

" Methoden
syn match phpMethodsVar "->\h\w*" contained contains=phpMethods,phpMemberSelector display

" Include
syn keyword phpInclude  use include require include_once require_once contained

" Peter Hodge - added 'clone' keyword
" Define
syn keyword phpDefine new clone contained

" Boolean
syn keyword phpBoolean  true false  contained

" Number
syn match phpNumber "-\=\<\d\+\>" contained display
syn match phpNumber "\<0x\x\{1,8}\>"  contained display

" Float
syn match phpFloat  "\(-\=\<\d+\|-\=\)\.\d\+\>" contained display

" SpecialChar
syn match phpSpecialChar  "\\[abcfnrtyv\\]" contained display
syn match phpSpecialChar  "\\\d\{3}"  contained contains=phpOctalError display
syn match phpSpecialChar  "\\x\x\{2}" contained display

" Error
syn match phpOctalError "[89]"  contained display
if exists("php_parent_error_close")
  syn match phpParentError  "[)\]}]"  contained display
endif

" Todo
syn keyword phpTodo todo fixme xxx  contained

" Comment
if exists("php_parent_error_open")
  syn region  phpComment  start="/\*" end="\*/" contained contains=phpTodo
else
  syn region  phpComment  start="/\*" end="\*/" contained contains=phpTodo extend
endif

syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=phpTodo
syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=phpTodo

" String
if exists("php_parent_error_open")
  syn region  phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained keepend
  syn region  phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained keepend
  syn region  phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings contained keepend
else
  syn region  phpStringDouble matchgroup=None start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained extend keepend
  syn region  phpBacktick matchgroup=None start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex contained extend keepend
  syn region  phpStringSingle matchgroup=None start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@phpAddStrings contained keepend extend
endif

" HereDoc
if version >= 600
  syn case match
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\I\i*\)$" end="^\z1\(;\=$\)\@=" contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
" including HTML,JavaScript,SQL even if not enabled via options
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlJavascript,phpIdentifierSimply,phpIdentifier,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn case ignore
endif

" Parent
if exists("php_parent_error_close") || exists("php_parent_error_open")
  syn match phpParent "[{}]"  contained
  syn region  phpParent matchgroup=Delimiter start="(" end=")"  contained contains=@phpClInside transparent
  syn region  phpParent matchgroup=Delimiter start="\[" end="\]"  contained contains=@phpClInside transparent
  if !exists("php_parent_error_close")
    syn match phpParent "[\])]" contained
  endif
else
  syn match phpParent "[({[\]})]" contained
endif

syn cluster phpClConst  contains=phpFunctions,phpIdentifier,phpConditional,phpRepeat,phpStatement,phpOperator,phpRelation,phpStringSingle,phpStringDouble,phpBacktick,phpNumber,phpFloat,phpKeyword,phpType,phpBoolean,phpStructure,phpMethodsVar,phpConstant,phpCoreConstant,phpException
syn cluster phpClInside contains=@phpClConst,phpComment,phpLabel,phpParent,phpParentError,phpInclude,phpHereDoc
syn cluster phpClFunction contains=@phpClInside,phpDefine,phpParentError,phpStorageClass
syn cluster phpClTop  contains=@phpClFunction,phpFoldFunction,phpFoldClass,phpFoldInterface,phpFoldTry,phpFoldCatch

" Php Region
if exists("php_parent_error_open")
  syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop
else
  syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop keepend
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop keepend
endif

syn keyword phpDefine function  contained
syn keyword phpStructure  abstract class interface  contained
syn keyword phpException  catch throw try contained
syn keyword phpStorageClass final global private protected public static  contained

" corrected highlighting for an escaped '\$' inside a double-quoted string
syn match phpSpecialChar  "\\\$"  contained display

" highlight object variables inside strings
syn match phpMethodsVar "->\h\w*" contained contains=phpMethods,phpMemberSelector display containedin=phpStringDouble

" highlight constant E_STRICT
syntax case match
syntax keyword phpCoreConstant E_STRICT contained
syntax case ignore

" different syntax highlighting for 'echo', 'print', 'switch', 'die' and 'list' keywords
" to better indicate what they are.
syntax keyword phpDefine echo print contained
syntax keyword phpStructure list contained
syntax keyword phpConditional switch contained
syntax keyword phpStatement die contained

" Highlighting for PHP's user-definable magic class methods
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier
  \ __construct __destruct __call __toString __sleep __wakeup __set __get __unset __isset __clone __set_state
" Highlighting for __autoload slightly different from line above
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ __autoload
highlight link phpSpecialFunction phpOperator

" Highlighting for PHP's built-in classes
syntax keyword phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ stdClass __PHP_Incomplete_Class php_user_filter Directory ArrayObject
  \ Exception ErrorException LogicException BadFunctionCallException BadMethodCallException DomainException
  \ RecursiveIteratorIterator IteratorIterator FilterIterator RecursiveFilterIterator ParentIterator LimitIterator
  \ CachingIterator RecursiveCachingIterator NoRewindIterator AppendIterator InfiniteIterator EmptyIterator
  \ ArrayIterator RecursiveArrayIterator DirectoryIterator RecursiveDirectoryIterator
  \ InvalidArgumentException LengthException OutOfRangeException RuntimeException OutOfBoundsException
  \ OverflowException RangeException UnderflowException UnexpectedValueException
  \ PDO PDOException PDOStatement PDORow
  \ Reflection ReflectionFunction ReflectionParameter ReflectionMethod ReflectionClass
  \ ReflectionObject ReflectionProperty ReflectionExtension ReflectionException
  \ DOMException DOMStringList DOMNameList DOMDomError DOMErrorHandler
highlight link phpClasses phpFunctions

" Highlighting for PHP's built-in interfaces
syntax keyword phpInterfaces containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ Iterator IteratorAggregate RecursiveIterator OuterIterator SeekableIterator
  \ Traversable ArrayAccess Serializable Countable SplObserver SplSubject Reflector
highlight link phpInterfaces phpConstant

" option defaults:
if ! exists('php_special_functions')
    let php_special_functions = 1
endif
if ! exists('php_alt_comparisons')
    let php_alt_comparisons = 1
endif
if ! exists('php_alt_assignByReference')
    let php_alt_assignByReference = 1
endif

if php_special_functions
    " Highlighting for PHP built-in functions which exhibit special behaviours
    " - isset()/unset()/empty() are not real functions.
    syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle
  \ user_error trigger_error isset unset eval extract compact empty error_log
endif

if php_alt_assignByReference
    " special highlighting for '=&' operator
    syntax match phpAssignByRef /=\s*&/ containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle
    highlight link phpAssignByRef Type
endif

if php_alt_comparisons
  " highlight comparison operators differently
  syntax match phpComparison "\v[=!]\=\=?" contained containedin=phpRegion
  syntax match phpComparison "\v[=<>-]@<![<>]\=?[<>]@!" contained containedin=phpRegion

  " highlight the 'instanceof' operator as a comparison operator rather than a structure
  syntax case ignore
  syntax keyword phpComparison instanceof contained containedin=phpRegion

  hi link phpComparison Statement
endif

" ================================================================

" Sync
if php_sync_method==-1
  syn sync match phpRegionSync grouphere phpRegion "^\s*<?php\s*$"
  syn sync match phpRegionSync grouphere phpRegionSc +^\s*<script language="php">\s*$+
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
  "syn sync match phpRegionSync grouphere NONE "/\i*>\s*$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  exec "syn sync fromstart"
endif

hi def link phpConstant  Constant
hi def link phpCoreConstant  Constant
hi def link phpComment Comment
hi def link phpException Exception
hi def link phpBoolean Boolean
hi def link phpStorageClass StorageClass
hi def link phpSCKeyword StorageClass
hi def link phpFCKeyword Define
hi def link phpStructure Structure
hi def link phpStringSingle String
hi def link phpStringDouble String
hi def link phpBacktick String
hi def link phpNumber  Number
hi def link phpFloat Number
hi def link phpMethods Function
hi def link phpFunctions Function
hi def link phpRepeat  Repeat
hi def link phpConditional Conditional
hi def link phpLabel Label
hi def link phpStatement Statement
hi def link phpKeyword Statement
hi def link phpType  Type
hi def link phpInclude Include
hi def link phpDefine  Define
hi def link phpSpecialChar SpecialChar
hi def link phpParent  Delimiter
hi def link phpIdentifierConst Delimiter
hi def link phpParentError Error
hi def link phpOctalError  Error
hi def link phpTodo  Todo
hi def link phpMemberSelector  Structure
hi def link phpIntVar Identifier
hi def link phpEnvVar Identifier
hi def link phpOperator Operator
hi def link phpVarSelector  Operator
hi def link phpRelation Operator
hi def link phpIdentifier Identifier
hi def link phpIdentifierSimply Identifier

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab
