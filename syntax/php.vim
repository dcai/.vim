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
" Options:  php_sql_query = 1  for SQL syntax highlighting inside strings
"           php_htmlInStrings = 1  for HTML syntax highlighting inside strings
"           php_asp_tags = 1  for highlighting ASP-style short tags
"           php_parent_error_close = 1  for highlighting parent error ] or )
"           php_parent_error_open = 1  for skipping an php end tag, if there exists an open ( or [ without a closing one
"           php_oldStyle = 1  for using old colorstyle
"           php_noShortTags = 1  don't sync <? ?> as php
"           php_folding = 1  for folding classes and functions
"           php_folding = 2  for folding all { } regions
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

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

if version < 600
  unlet! php_folding
  if exists("php_sync_method") && !php_sync_method
    let php_sync_method=-1
  endif
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
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

syn cluster htmlPreproc add=phpRegion,phpRegionAsp,phpRegionSc

if version < 600
  syn include @sqlTop <sfile>:p:h/sql.vim
else
  syn include @sqlTop syntax/sql.vim
endif
syn sync clear
unlet b:current_syntax
syn cluster sqlTop remove=sqlString,sqlComment
if exists( "php_sql_query")
  syn cluster phpAddStrings contains=@sqlTop
endif

if exists( "php_htmlInStrings")
  syn cluster phpAddStrings add=@htmlTop
endif

syn case match

" Env Variables
syn keyword phpEnvVar GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI contained

" Internal Variables
syn keyword phpIntVar GLOBALS PHP_ERRMSG PHP_SELF HTTP_GET_VARS HTTP_POST_VARS HTTP_COOKIE_VARS HTTP_POST_FILES HTTP_ENV_VARS HTTP_SERVER_VARS HTTP_SESSION_VARS HTTP_RAW_POST_DATA HTTP_STATE_VARS _GET _POST _COOKIE _FILES _SERVER _ENV _SERVER _REQUEST _SESSION  contained

" Constants
syn keyword phpCoreConstant PHP_VERSION PHP_OS DEFAULT_INCLUDE_PATH PEAR_INSTALL_DIR PEAR_EXTENSION_DIR PHP_EXTENSION_DIR PHP_BINDIR PHP_LIBDIR PHP_DATADIR PHP_SYSCONFDIR PHP_LOCALSTATEDIR PHP_CONFIG_FILE_PATH PHP_OUTPUT_HANDLER_START PHP_OUTPUT_HANDLER_CONT PHP_OUTPUT_HANDLER_END E_ERROR E_WARNING E_PARSE E_NOTICE E_CORE_ERROR E_CORE_WARNING E_COMPILE_ERROR E_COMPILE_WARNING E_USER_ERROR E_USER_WARNING E_USER_NOTICE E_ALL  contained

syn case ignore

syn keyword phpConstant  __LINE__ __FILE__ __FUNCTION__ __METHOD__ __CLASS__  contained


" Function and Methods ripped from php_manual_de.tar.gz Jan 2003
syn keyword phpMethods  name specified value create_attribute create_cdata_section create_comment create_element_ns create_element create_entity_reference create_processing_instruction create_text_node doctype document_element dump_file dump_mem get_element_by_id get_elements_by_tagname html_dump_mem xinclude entities internal_subset name notations public_id system_id get_attribute_node get_attribute get_elements_by_tagname has_attribute remove_attribute set_attribute tagname add_namespace append_child append_sibling attributes child_nodes clone_node dump_node first_child get_content has_attributes has_child_nodes insert_before is_blank_node last_child next_sibling node_name node_type node_value owner_document parent_node prefix previous_sibling remove_child replace_child replace_node set_content set_name set_namespace unlink_node data target process result_dump_file result_dump_mem contained
syn keyword phpMethods  key langdepvalue value values checkin checkout children mimetype read content copy dbstat dcstat dstanchors dstofsrcanchors count reason find ftstat hwstat identify info insert insertanchor insertcollection insertdocument link lock move assign attreditable count insert remove title value object objectbyanchor parents description type remove replace setcommitedversion srcanchors srcsofdst unlock user userlist contained
syn keyword phpMethods  getHeight getWidth addAction addShape setAction setdown setHit setOver setUp addColor move moveTo multColor remove Rotate rotateTo scale scaleTo setDepth setName setRatio skewX skewXTo skewY skewYTo moveTo rotateTo scaleTo skewXTo skewYTo getwidth addEntry getshape1 getshape2 add nextframe output remove save setbackground setdimension setframes setrate streammp3 addFill drawCurve drawCurveTo drawLine drawLineTo movePen movePenTo setLeftFill setLine setRightFill add nextframe remove setframes addString getWidth moveTo setColor setFont setHeight setSpacing addstring align setbounds setcolor setFont setHeight setindentation setLeftMargin setLineSpacing setMargins setname setrightMargin contained
syn keyword phpMethods  attributes children get_attr get_nodes has_children has_siblings is_asp is_comment is_html is_jsp is_jste is_text is_xhtml is_xml next prev tidy_node contained

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
syn keyword phpStructure  extends implements instanceof parent self contained

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
syn keyword phpInclude  include require include_once require_once contained

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
if version >= 600
  syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=phpTodo
  syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=phpTodo
else
  syn match phpComment  "#.\{-}$" contained contains=phpTodo
  syn match phpComment  "#.\{-}?>"me=e-2  contained contains=phpTodo
  syn match phpComment  "//.\{-}$"  contained contains=phpTodo
  syn match phpComment  "//.\{-}?>"me=e-2 contained contains=phpTodo
endif

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
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
  syn region  phpHereDoc  matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=@sqlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar keepend extend
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
  if exists("php_noShortTags")
    syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop
  else
    syn region   phpRegion  matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop
  endif
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop
  if exists("php_asp_tags")
    syn region   phpRegionAsp matchgroup=Delimiter start="<%\(=\)\=" end="%>" contains=@phpClTop
  endif
else
  if exists("php_noShortTags")
    syn region   phpRegion  matchgroup=Delimiter start="<?php" end="?>" contains=@phpClTop keepend
  else
    syn region   phpRegion  matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop keepend
  endif
  syn region   phpRegionSc  matchgroup=Delimiter start=+<script language="php">+ end=+</script>+  contains=@phpClTop keepend
  if exists("php_asp_tags")
    syn region   phpRegionAsp matchgroup=Delimiter start="<%\(=\)\=" end="%>" contains=@phpClTop keepend
  endif
endif

" Fold
if exists("php_folding") && php_folding==1
" match one line constructs here and skip them at folding
  syn keyword phpSCKeyword  abstract final private protected public static  contained
  syn keyword phpFCKeyword  function  contained
  syn keyword phpStorageClass global  contained
  syn match phpDefine "\(\s\|^\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\(\s\+.*[;}]\)\@="  contained contains=phpSCKeyword
  syn match phpStructure  "\(\s\|^\)\(abstract\s\+\|final\s\+\)*class\(\s\+.*}\)\@="  contained
  syn match phpStructure  "\(\s\|^\)interface\(\s\+.*}\)\@="  contained
  syn match phpException  "\(\s\|^\)try\(\s\+.*}\)\@="  contained
  syn match phpException  "\(\s\|^\)catch\(\s\+.*}\)\@="  contained

  set foldmethod=syntax
  syn region  phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region  phpFoldFunction matchgroup=Storageclass start="^\z(\s*\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\s\([^};]*$\)\@="rs=e-9 matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldHtmlInside,phpFCKeyword contained transparent fold extend
  syn region  phpFoldFunction matchgroup=Define start="^function\s\([^};]*$\)\@=" matchgroup=Delimiter end="^}" contains=@phpClFunction,phpFoldHtmlInside contained transparent fold extend
  syn region  phpFoldClass  matchgroup=Structure start="^\z(\s*\)\(abstract\s\+\|final\s\+\)*class\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction,phpSCKeyword contained transparent fold extend
  syn region  phpFoldInterface  matchgroup=Structure start="^\z(\s*\)interface\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region  phpFoldCatch  matchgroup=Exception start="^\z(\s*\)catch\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region  phpFoldTry  matchgroup=Exception start="^\z(\s*\)try\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
elseif exists("php_folding") && php_folding==2
  syn keyword phpDefine function  contained
  syn keyword phpStructure  abstract class interface  contained
  syn keyword phpException  catch throw try contained
  syn keyword phpStorageClass final global private protected public static  contained

  set foldmethod=syntax
  syn region  phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region  phpParent matchgroup=Delimiter start="{" end="}"  contained contains=@phpClFunction,phpFoldHtmlInside transparent fold
else
  syn keyword phpDefine function  contained
  syn keyword phpStructure  abstract class interface  contained
  syn keyword phpException  catch throw try contained
  syn keyword phpStorageClass final global private protected public static  contained
endif

" ================================================================
" Peter Hodge - June 9, 2006
" Some of these changes (highlighting isset/unset/echo etc) are not so
" critical, but they make things more colourful. :-)

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

" Highlighting for PHP5's user-definable magic class methods
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier
  \ __construct __destruct __call __toString __sleep __wakeup __set __get __unset __isset __clone __set_state
" Highlighting for __autoload slightly different from line above
syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar
  \ __autoload
highlight link phpSpecialFunction phpOperator

" Highlighting for PHP5's built-in classes
" - built-in classes harvested from get_declared_classes() in 5.1.4
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
  \ SplFileInfo SplFileObject SplTempFileObject SplObjectStorage
  \ XMLWriter LibXMLError XMLReader SimpleXMLElement SimpleXMLIterator
  \ DOMException DOMStringList DOMNameList DOMDomError DOMErrorHandler
  \ DOMImplementation DOMImplementationList DOMImplementationSource
  \ DOMNode DOMNameSpaceNode DOMDocumentFragment DOMDocument DOMNodeList DOMNamedNodeMap
  \ DOMCharacterData DOMAttr DOMElement DOMText DOMComment DOMTypeinfo DOMUserDataHandler
  \ DOMLocator DOMConfiguration DOMCdataSection DOMDocumentType DOMNotation DOMEntity
  \ DOMEntityReference DOMProcessingInstruction DOMStringExtend DOMXPath
highlight link phpClasses phpFunctions

" Highlighting for PHP5's built-in interfaces
" - built-in classes harvested from get_declared_interfaces() in 5.1.4
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
    " - compact()/extract() directly manipulate variables in the local scope where
    "   regular functions would not be able to.
    " - eval() is the token 'make_your_code_twice_as_complex()' function for PHP.
    " - user_error()/trigger_error() can be overloaded by set_error_handler and also
    "   have the capacity to terminate your script when type is E_USER_ERROR.
    syntax keyword phpSpecialFunction containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle
  \ user_error trigger_error isset unset eval extract compact empty
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
  if exists("php_noShortTags")
    syn sync match phpRegionSync grouphere phpRegion "^\s*<?php\s*$"
  else
    syn sync match phpRegionSync grouphere phpRegion "^\s*<?\(php\)\=\s*$"
  endif
  syn sync match phpRegionSync grouphere phpRegionSc +^\s*<script language="php">\s*$+
  if exists("php_asp_tags")
    syn sync match phpRegionSync grouphere phpRegionAsp "^\s*<%\(=\)\=\s*$"
  endif
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
  "syn sync match phpRegionSync grouphere NONE "/\i*>\s*$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  exec "syn sync fromstart"
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_php_syn_inits")
  if version < 508
    let did_php_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink   phpConstant  Constant
  HiLink   phpCoreConstant  Constant
  HiLink   phpComment Comment
  HiLink   phpException Exception
  HiLink   phpBoolean Boolean
  HiLink   phpStorageClass  StorageClass
  HiLink   phpSCKeyword StorageClass
  HiLink   phpFCKeyword Define
  HiLink   phpStructure Structure
  HiLink   phpStringSingle  String
  HiLink   phpStringDouble  String
  HiLink   phpBacktick  String
  HiLink   phpNumber  Number
  HiLink   phpFloat Float
  HiLink   phpMethods Function
  HiLink   phpFunctions Function
  HiLink   phpBaselib Function
  HiLink   phpRepeat  Repeat
  HiLink   phpConditional Conditional
  HiLink   phpLabel Label
  HiLink   phpStatement Statement
  HiLink   phpKeyword Statement
  HiLink   phpType  Type
  HiLink   phpInclude Include
  HiLink   phpDefine  Define
  HiLink   phpSpecialChar SpecialChar
  HiLink   phpParent  Delimiter
  HiLink   phpIdentifierConst Delimiter
  HiLink   phpParentError Error
  HiLink   phpOctalError  Error
  HiLink   phpTodo  Todo
  HiLink   phpMemberSelector  Structure
  if exists("php_oldStyle")
  hi  phpIntVar guifg=Red ctermfg=DarkRed
  hi  phpEnvVar guifg=Red ctermfg=DarkRed
  hi  phpOperator guifg=SeaGreen ctermfg=DarkGreen
  hi  phpVarSelector guifg=SeaGreen ctermfg=DarkGreen
  hi  phpRelation guifg=SeaGreen ctermfg=DarkGreen
  hi  phpIdentifier guifg=DarkGray ctermfg=Brown
  hi  phpIdentifierSimply guifg=DarkGray ctermfg=Brown
  else
  HiLink  phpIntVar Identifier
  HiLink  phpEnvVar Identifier
  HiLink  phpOperator Operator
  HiLink  phpVarSelector  Operator
  HiLink  phpRelation Operator
  HiLink  phpIdentifier Identifier
  HiLink  phpIdentifierSimply Identifier
  endif

  delcommand HiLink
endif

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab
