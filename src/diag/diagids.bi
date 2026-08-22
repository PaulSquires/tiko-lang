'' diagids.bi -- THE diagnostic table.
''
'' Every diagnostic fbx can emit is one row here, and nothing else in the compiler may
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

#ifndef __FBX_DIAGIDS_BI__
#define __FBX_DIAGIDS_BI__

#macro FBX_DIAG_LIST( DIAG )

    '' ---------------------------------------------------- source and file handling
    DIAG( FBX0001, SEV_ERROR,   "cannot open source file '%0': %1" )
    DIAG( FBX0002, SEV_ERROR,   "source file '%0' is empty" )
    DIAG( FBX0003, SEV_WARNING, "source file '%0' is not valid UTF-8; bytes preserved verbatim" )

    '' -------------------------------------------------------- driver / command line
    DIAG( FBX0100, SEV_ERROR,   "unknown option '%0'" )
    DIAG( FBX0101, SEV_ERROR,   "option '%0' requires an argument" )
    DIAG( FBX0102, SEV_ERROR,   "no input files" )
    DIAG( FBX0103, SEV_ERROR,   "unknown target '%0'" )
    DIAG( FBX0104, SEV_ERROR,   "32-bit is supported on Windows only" )
    DIAG( FBX0105, SEV_WARNING, "unknown diagnostic id '%0'" )
    DIAG( FBX0106, SEV_ERROR,   "'%0' is not a recognised value for '%1'" )
    DIAG( FBX0107, SEV_WARNING, "ignoring unsupported option '%0'" )

    '' --------------------------------------------------------------------- lexer
    DIAG( FBX0201, SEV_WARNING, "missing closing quote in string literal" )
    DIAG( FBX0202, SEV_ERROR,   "unterminated block comment" )
    DIAG( FBX0203, SEV_ERROR,   "'%0' is not followed by any digits" )
    DIAG( FBX0204, SEV_ERROR,   "unexpected character %0 in source" )
    DIAG( FBX0205, SEV_ERROR,   "numeric literal is too large for any integer type" )

    '' -------------------------------------------------------------- preprocessor
    DIAG( FBX0300, SEV_ERROR,   "unknown directive '#%0'" )
    DIAG( FBX0301, SEV_ERROR,   "cannot open include file '%0'" )
    DIAG( FBX0302, SEV_ERROR,   "'#%0' without a matching '#if'" )
    DIAG( FBX0303, SEV_ERROR,   "'#if' has no matching '#endif'" )
    DIAG( FBX0304, SEV_ERROR,   "preprocessor nesting exceeded %0 levels" )
    DIAG( FBX0305, SEV_ERROR,   "macro '%0' is already defined" )
    DIAG( FBX0306, SEV_ERROR,   "macro '%0' takes %1 argument(s)" )
    DIAG( FBX0307, SEV_ERROR,   "unterminated argument list for macro '%0'" )
    DIAG( FBX0308, SEV_ERROR,   "invalid expression in '#%0'" )
    DIAG( FBX0309, SEV_ERROR,   "#error: %0" )
    DIAG( FBX0310, SEV_ERROR,   "'#%0' is not implemented in this build" )
    DIAG( FBX0311, SEV_ERROR,   "'#macro' without '#endmacro'" )
    DIAG( FBX0312, SEV_WARNING, "unknown '#pragma %0'" )
    DIAG( FBX0313, SEV_ERROR,   "assertion failed" )
    DIAG( FBX0314, SEV_ERROR,   "builtin macro '%0' is not implemented in this build" )
    DIAG( FBX0315, SEV_NOTE,    "#print %0" )
    DIAG( FBX0316, SEV_ERROR,   "expected an identifier after '#%0'" )
    DIAG( FBX0317, SEV_ERROR,   "unsupported language mode '%0'; fbx implements ""fb"" only" )
    DIAG( FBX0318, SEV_ERROR,   "cannot pop '#pragma %0': the stack is empty" )
    DIAG( FBX0319, SEV_ERROR,   "__FB_UNIQUEID_POP__( %0 ) has no matching push" )
    DIAG( FBX0320, SEV_ERROR,   "'%0' has no type; fbx implements #lang ""fb"" only, where default types and suffixes are not valid" )
    DIAG( FBX0321, SEV_ERROR,   "expected a type parameter name" )
    DIAG( FBX0322, SEV_ERROR,   "duplicated type parameter '%0'" )
    DIAG( FBX0323, SEV_ERROR,   "'%0' does not name a type here, so it cannot own this constructor or destructor" )
    DIAG( FBX0324, SEV_ERROR,   "argument %0 of '%1' must be an integer constant" )

    '' -------------------------------------------------------------------- parser
    DIAG( FBX0400, SEV_ERROR,   "expected an expression" )
    DIAG( FBX0401, SEV_ERROR,   "expected '%0'" )
    DIAG( FBX0402, SEV_ERROR,   "expected a member name after '.' or '->'" )
    DIAG( FBX0403, SEV_ERROR,   "expression nesting exceeded %0 levels" )
    DIAG( FBX0404, SEV_ERROR,   "unexpected token after expression" )
    DIAG( FBX0405, SEV_ERROR,   "expected 'end %0'" )
    DIAG( FBX0406, SEV_ERROR,   "expected an identifier" )
    DIAG( FBX0407, SEV_ERROR,   "inline assembly is not supported; compile that module with fbc" )
    DIAG( FBX0408, SEV_ERROR,   "expected a statement" )
    DIAG( FBX0409, SEV_ERROR,   "'%0' is not available in the fb dialect" )

    '' ------------------------------------------------------------------ semantic
    DIAG( FBX0600, SEV_ERROR,   "'%0' is already declared in this scope" )
    DIAG( FBX0601, SEV_ERROR,   "'%0' is undefined" )
    DIAG( FBX0602, SEV_ERROR,   "'%0' is a %1, not a procedure" )
    DIAG( FBX0603, SEV_ERROR,   "calling convention does not match the declaration of '%0'" )
    DIAG( FBX0604, SEV_ERROR,   "#assert condition failed" )
    DIAG( FBX0605, SEV_ERROR,   "expected a constant expression" )

    '' -------------------------------------------------------------------- notes
    DIAG( FBX0900, SEV_NOTE,    "%0" )
    DIAG( FBX0901, SEV_NOTE,    "declared here" )
    DIAG( FBX0902, SEV_NOTE,    "expanded from macro '%0'" )
    DIAG( FBX0903, SEV_NOTE,    "in instantiation of '%0'" )
    DIAG( FBX0904, SEV_NOTE,    "required from here" )
    DIAG( FBX0905, SEV_NOTE,    "unclosed '%0' opened here" )

    '' ---------------------------------------------------------- compiler / limits
    DIAG( FBX0990, SEV_ERROR,   "too many errors; stopping" )
    DIAG( FBX0991, SEV_ERROR,   "input exceeds a compiler limit: %0" )
    DIAG( FBX0992, SEV_ERROR,   "not implemented in this build: %0" )

#endmacro

enum DiagId
    DIAG_NONE = 0
    #define DIAG( d_id, d_sev, d_fmt ) d_id,
    FBX_DIAG_LIST( DIAG )
    #undef DIAG
    DIAG_COUNT
end enum

#endif
