'' diagids.bi -- THE diagnostic table.
''
'' Every diagnostic tiko-lang can emit is one row here, and nothing else in the compiler may
'' invent a message (docs/plan/12 section 5). The single list drives:
''
''     - the DiagId enum
''     - the stable id spelling used by -Wno-<id> and by the reject tests
''     - the default severity
''     - the format string
''     - (later) the generated diagnostic reference page
''
'' Adding a diagnostic is one row. A diagnostic without a test in tests/diagnostics/
'' does not land.
''
'' NUMBERING. The number is stable forever once released; retiring a diagnostic
'' leaves its row in place marked obsolete rather than reusing the number.
''     0001-0099   source and file handling
''     0100-0199   driver and command line
''     0200-0299   lexer
''     0300-0399   preprocessor
''     0400-0599   parser
''     0600-0899   semantic
''     0900-0989   notes
''     0990-0999   compiler-level (limits, internal)
''
'' FORMAT STRINGS use %0, %1, %2 for the arguments passed to Report( ). A '%' that is
'' not followed by a digit is literal.
''
'' This file is included only from diagnostic.bi, which declares Severity first.
'' Macro parameters are d_-prefixed because FreeBASIC substitutes a macro parameter
'' name even after a '.', so a parameter called 'sev' would rewrite '.sev' too.

#ifndef __TKO_DIAGIDS_BI__
#define __TKO_DIAGIDS_BI__

#macro TKO_DIAG_LIST( DIAG )

    '' ---------------------------------------------------- source and file handling
    DIAG( TKO0001, SEV_ERROR,   "cannot open source file '%0': %1" )
    DIAG( TKO0002, SEV_ERROR,   "source file '%0' is empty" )
    DIAG( TKO0003, SEV_WARNING, "source file '%0' is not valid UTF-8; bytes preserved verbatim" )

    '' -------------------------------------------------------- driver / command line
    DIAG( TKO0100, SEV_ERROR,   "unknown option '%0'" )
    DIAG( TKO0101, SEV_ERROR,   "option '%0' requires an argument" )
    DIAG( TKO0102, SEV_ERROR,   "no input files" )
    DIAG( TKO0103, SEV_ERROR,   "unknown target '%0'" )
    DIAG( TKO0104, SEV_ERROR,   "32-bit is supported on Windows only" )
    DIAG( TKO0105, SEV_WARNING, "unknown diagnostic id '%0'" )
    DIAG( TKO0106, SEV_ERROR,   "'%0' is not a recognised value for '%1'" )
    DIAG( TKO0107, SEV_WARNING, "ignoring unsupported option '%0'" )

    '' --------------------------------------------------------------------- lexer
    DIAG( TKO0201, SEV_WARNING, "missing closing quote in string literal" )
    DIAG( TKO0202, SEV_ERROR,   "unterminated block comment" )
    DIAG( TKO0203, SEV_ERROR,   "'%0' is not followed by any digits" )
    DIAG( TKO0204, SEV_ERROR,   "unexpected character %0 in source" )
    DIAG( TKO0205, SEV_ERROR,   "numeric literal is too large for any integer type" )

    '' -------------------------------------------------------------- preprocessor
    DIAG( TKO0300, SEV_ERROR,   "unknown directive '#%0'" )
    DIAG( TKO0301, SEV_ERROR,   "cannot open include file '%0'" )
    DIAG( TKO0302, SEV_ERROR,   "'#%0' without a matching '#if'" )
    DIAG( TKO0303, SEV_ERROR,   "'#if' has no matching '#endif'" )
    DIAG( TKO0304, SEV_ERROR,   "preprocessor nesting exceeded %0 levels" )
    DIAG( TKO0305, SEV_ERROR,   "macro '%0' is already defined" )
    DIAG( TKO0306, SEV_ERROR,   "macro '%0' takes %1 argument(s)" )
    DIAG( TKO0307, SEV_ERROR,   "unterminated argument list for macro '%0'" )
    DIAG( TKO0308, SEV_ERROR,   "invalid expression in '#%0'" )
    DIAG( TKO0309, SEV_ERROR,   "#error: %0" )
    DIAG( TKO0310, SEV_ERROR,   "'#%0' is not implemented in this build" )
    DIAG( TKO0311, SEV_ERROR,   "'#macro' without '#endmacro'" )
    DIAG( TKO0312, SEV_WARNING, "unknown '#pragma %0'" )
    DIAG( TKO0313, SEV_ERROR,   "assertion failed" )
    DIAG( TKO0314, SEV_ERROR,   "builtin macro '%0' is not implemented in this build" )
    DIAG( TKO0315, SEV_NOTE,    "#print %0" )
    DIAG( TKO0316, SEV_ERROR,   "expected an identifier after '#%0'" )
    DIAG( TKO0317, SEV_ERROR,   "unsupported language mode '%0'; tiko-lang implements ""fb"" only" )
    DIAG( TKO0318, SEV_ERROR,   "cannot pop '#pragma %0': the stack is empty" )
    DIAG( TKO0319, SEV_ERROR,   "__FB_UNIQUEID_POP__( %0 ) has no matching push" )
    DIAG( TKO0320, SEV_ERROR,   "'%0' has no type; tiko-lang implements #lang ""fb"" only, where default types and suffixes are not valid" )
    DIAG( TKO0321, SEV_ERROR,   "expected a type parameter name" )
    DIAG( TKO0322, SEV_ERROR,   "duplicated type parameter '%0'" )
    DIAG( TKO0323, SEV_ERROR,   "'%0' does not name a type here, so it cannot own this constructor or destructor" )
    DIAG( TKO0324, SEV_ERROR,   "argument %0 of '%1' must be an integer constant" )
    DIAG( TKO0325, SEV_ERROR,   "argument of '%0' must be a constant expression" )

    '' -------------------------------------------------------------------- parser
    DIAG( TKO0400, SEV_ERROR,   "expected an expression" )
    DIAG( TKO0401, SEV_ERROR,   "expected '%0'" )
    DIAG( TKO0402, SEV_ERROR,   "expected a member name after '.' or '->'" )
    DIAG( TKO0403, SEV_ERROR,   "expression nesting exceeded %0 levels" )
    DIAG( TKO0404, SEV_ERROR,   "unexpected token after expression" )
    DIAG( TKO0405, SEV_ERROR,   "expected 'end %0'" )
    DIAG( TKO0406, SEV_ERROR,   "expected an identifier" )
    DIAG( TKO0407, SEV_ERROR,   "inline assembly is not supported; compile that module with fbc" )
    DIAG( TKO0408, SEV_ERROR,   "expected a statement" )
    DIAG( TKO0409, SEV_ERROR,   "'%0' is not available in the fb dialect" )
    DIAG( TKO0410, SEV_ERROR,   "'for each' with a name list takes no 'as' clause; each name is typed by its own element" )
    DIAG( TKO0411, SEV_ERROR,   "'for each byref' cannot take a name list; bind the whole element byref instead" )
    DIAG( TKO0412, SEV_ERROR,   "'for each' with a name list needs at least two names" )
    DIAG( TKO0413, SEV_ERROR,   "every lambda capture needs an explicit 'byval' or 'byref'" )
    DIAG( TKO0414, SEV_ERROR,   "'select channel' needs at least one case" )
    DIAG( TKO0415, SEV_ERROR,   "expected receive, send, timeout or else after 'case'" )
    DIAG( TKO0416, SEV_ERROR,   "expected '%0' in this 'select channel' case" )
    DIAG( TKO0417, SEV_ERROR,   "only one 'case timeout' and one 'case else' are allowed" )
    '' fbc's error 34: every SELECT, plain or AS CONST, needs a case.
    DIAG( TKO0418, SEV_ERROR,   "'select case' needs at least one 'case'" )
    '' fbc's error 9. AS CONST builds a jump table, and a relation is not an index.
    DIAG( TKO0419, SEV_ERROR,   "'is' is not allowed in a 'select case as const'" )

    '' ------------------------------------------------------------------ semantic
    DIAG( TKO0600, SEV_ERROR,   "'%0' is already declared in this scope" )
    DIAG( TKO0601, SEV_ERROR,   "'%0' is undefined" )
    DIAG( TKO0602, SEV_ERROR,   "'%0' is a %1, not a procedure" )
    DIAG( TKO0603, SEV_ERROR,   "calling convention does not match the declaration of '%0'" )
    DIAG( TKO0604, SEV_ERROR,   "#assert condition failed" )
    DIAG( TKO0605, SEV_ERROR,   "expected a constant expression" )
    DIAG( TKO0606, SEV_ERROR,   "'%0' cannot be walked by 'for each': it has no GetIterator( )" )
    DIAG( TKO0607, SEV_ERROR,   "'%0' is not an iterator: it has no '%1'" )
    DIAG( TKO0608, SEV_ERROR,   "'for each' over a multi-dimensional array has no defined order" )
    DIAG( TKO0609, SEV_ERROR,   "'for each' cannot walk a fixed-length string: it carries no length" )
    DIAG( TKO0610, SEV_ERROR,   "'for each' with a name list needs a tuple element; '%0' is not one" )
    DIAG( TKO0611, SEV_ERROR,   "'for each' binds %0 names but the element has %1" )
    '' fbc's error 75, in its own words. A DYNAMIC array has no storage at the point
    '' of declaration, so there is nothing for an initialiser to write into.
    DIAG( TKO0612, SEV_ERROR,   "var-len array '%0' cannot be initialized" )
    '' fbc's error 50. The limit is on TOTAL BYTES and it is 2147483647 exactly.
    DIAG( TKO0613, SEV_ERROR,   "array '%0' is too big" )
    '' fbc's error 11: AS CONST indexes a table, so every case must fold.
    DIAG( TKO0614, SEV_ERROR,   "'select case as const' needs a constant case value" )
    '' fbc's error 323.
    DIAG( TKO0615, SEV_ERROR,   "invalid 'case' range: the start value is greater than the end value" )
    '' fbc's error 69. The span is min..max ACROSS THE WHOLE STATEMENT, not per case.
    DIAG( TKO0616, SEV_ERROR,   "'select case as const' spans more than %0 values" )
    '' fbc's error 119.
    DIAG( TKO0617, SEV_ERROR,   "cannot modify '%0': it is a constant" )

    '' -------------------------------------------------------------------- notes
    DIAG( TKO0900, SEV_NOTE,    "%0" )
    DIAG( TKO0901, SEV_NOTE,    "declared here" )
    DIAG( TKO0902, SEV_NOTE,    "expanded from macro '%0'" )
    DIAG( TKO0903, SEV_NOTE,    "in instantiation of '%0'" )
    DIAG( TKO0904, SEV_NOTE,    "required from here" )
    DIAG( TKO0905, SEV_NOTE,    "unclosed '%0' opened here" )

    '' ---------------------------------------------------------- compiler / limits
    DIAG( TKO0990, SEV_ERROR,   "too many errors; stopping" )
    DIAG( TKO0991, SEV_ERROR,   "input exceeds a compiler limit: %0" )
    DIAG( TKO0992, SEV_ERROR,   "not implemented in this build: %0" )

#endmacro

enum DiagId
    DIAG_NONE = 0
    #define DIAG( d_id, d_sev, d_fmt ) d_id,
    TKO_DIAG_LIST( DIAG )
    #undef DIAG
    DIAG_COUNT
end enum

#endif
