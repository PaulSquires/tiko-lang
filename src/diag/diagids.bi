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
    DIAG( TKO0104, SEV_ERROR,   "32-bit targets are not supported; x86-64 only" )
    DIAG( TKO0105, SEV_WARNING, "unknown diagnostic id '%0'" )
    DIAG( TKO0106, SEV_ERROR,   "'%0' is not a recognised value for '%1'" )
    DIAG( TKO0107, SEV_WARNING, "ignoring unsupported option '%0'" )
    '' A resource script only means something on Windows. Reported rather than
    '' skipped: a '.rc' on a Linux command line is a mistake, and silently dropping
    '' it is how a program ships with its icon and version block missing.
    DIAG( TKO0108, SEV_ERROR,   "'%0' is a Windows resource script; the target is not Windows" )
    DIAG( TKO0109, SEV_ERROR,   "no resource compiler: %0" )
    DIAG( TKO0110, SEV_ERROR,   "compiling resource '%0' failed (exit %1)" )
    '' THE TOOLCHAIN'S FAILURES. These were printed straight to stderr as 'tiko: ...'
    '' lines, outside the engine, so nothing that reads diagnostics -- an editor's
    '' --diagnostics-file above all -- ever saw a build fail at clang or at the link.
    '' They are location-less, and the driver still exits with the TOOL's code (3 or
    '' 5), not EXIT_USER_ERROR: see ToolFail_ in driver.bas.
    DIAG( TKO0111, SEV_ERROR,   "no usable toolchain: %0" )
    DIAG( TKO0112, SEV_ERROR,   "cannot write intermediate file '%0'" )
    DIAG( TKO0113, SEV_ERROR,   "clang failed on '%0' (exit %1)" )
    DIAG( TKO0114, SEV_ERROR,   "'%0' is a %1 object, but target triple '%2' links the other format" )
    DIAG( TKO0115, SEV_ERROR,   "archiving failed (exit %0)" )
    DIAG( TKO0116, SEV_ERROR,   "link failed (exit %0)" )
    DIAG( TKO0117, SEV_ERROR,   "cannot write the diagnostics file '%0'" )
    '' C HEADER IMPORT (D16). The -cimport driver's own failures; #cinclude's are 03xx.
    DIAG( TKO0118, SEV_ERROR,   "-cimport needs -cimport-out <file>: the binding has to go somewhere" )
    DIAG( TKO0119, SEV_ERROR,   "importing a C header needs libclang: %0" )
    DIAG( TKO0120, SEV_ERROR,   "unable to import C header %0" )
    DIAG( TKO0121, SEV_ERROR,   "cannot write the binding '%0'" )
    DIAG( TKO0122, SEV_ERROR,   "the binding generated for %0 does not compile; this is a bug in the C importer" )
    '' The build graph of ADR 0017. The rest of the 0140-0151 block lands with its phase.
    DIAG( TKO0140, SEV_ERROR,   "cannot find module '%0' (searched: %1)" )
    DIAG( TKO0141, SEV_ERROR,   "import cycle: %0" )
    DIAG( TKO0142, SEV_ERROR,   "relative import '%0' leaves the package root '%1'" )
    DIAG( TKO0144, SEV_ERROR,   "malformed tiko.toml: %0" )
    DIAG( TKO0145, SEV_ERROR,   "'%0' is in module directory '%1' but does not begin with '#module'" )
    DIAG( TKO0146, SEV_ERROR,   "dependency '%0': %1" )
    DIAG( TKO0147, SEV_ERROR,   "module directory '%0' contains no .tiko or .bas files" )
    DIAG( TKO0148, SEV_ERROR,   "package name '%0' is reserved for the toolchain" )
    DIAG( TKO0149, SEV_ERROR,   "two packages named '%0': %1 and %2" )
    DIAG( TKO0150, SEV_WARNING, "module cache disabled: %0" )
    DIAG( TKO0153, SEV_ERROR,   "'%0' was compiled against module object '%1', which is not there; compile it again with -c" )
    DIAG( TKO0152, SEV_ERROR,   "'--emit-tki' writes a module's interface, and needs one module directory as its input" )
    '' An '#import''s alias (RFC-0002 §2). The rest of the 0860-0870 block lands with its phase.
    DIAG( TKO0860, SEV_ERROR,   "'%0' is not public in module '%1'" )
    DIAG( TKO0862, SEV_ERROR,   "alias '%0' is already bound in this file (by '#import ""%1""')" )
    DIAG( TKO0863, SEV_ERROR,   "alias '%0' conflicts with a declaration of the same name" )
    DIAG( TKO0867, SEV_ERROR,   "constant definitions form a cycle: %0" )
    DIAG( TKO0869, SEV_ERROR,   "'%0' is initialised from '%1', which is declared later" )
    DIAG( TKO0870, SEV_ERROR,   "public '%0' has the same name as its module '%1'" )

    '' --------------------------------------------------------------------- lexer
    DIAG( TKO0201, SEV_WARNING, "missing closing quote in string literal" )
    DIAG( TKO0202, SEV_ERROR,   "unterminated block comment" )
    DIAG( TKO0203, SEV_ERROR,   "'%0' is not followed by any digits" )
    DIAG( TKO0204, SEV_ERROR,   "unexpected character %0 in source" )
    DIAG( TKO0205, SEV_ERROR,   "numeric literal is too large for any integer type" )
    '' fbc's warning 44, "Suffix ignored in '<what was written>'". A '$ % & ! #' on a
    '' RESERVED WORD -- 'end% scope%', 'for% i as% integer' -- is accepted and dropped,
    '' and this is the whole of what says so. Lexical, hence the number; emitted from
    '' the preprocessor, because that is the first place that knows a token is LIVE.
    '' Measured (fbc-modern win64, -w all): nothing is warned inside a false '#if'
    '' branch, and a suffix inside a '#macro' body warns ONCE PER EXPANSION -- fbc puts
    '' each at the invocation's line, this at the body's own.
    DIAG( TKO0206, SEV_WARNING, "suffix ignored in '%0'" )

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
    '' fbc's error 17, which it reports as a bare "Syntax error in '#inclib'". The
    '' name of the thing that is missing costs nothing to say and is what the reader
    '' needs, so this says it.
    DIAG( TKO0326, SEV_ERROR,   "'#%0' takes a library name in quotes" )
    '' fbc's errors 17, 376, 377 and 378, which are #foreignlib's whole diagnostic
    '' surface (RFC-0005).
    DIAG( TKO0327, SEV_ERROR,   "expected a name, STATIC or DYNAMIC, then a quoted spec after #foreignlib" )
    DIAG( TKO0328, SEV_ERROR,   "expected STATIC or DYNAMIC after the #foreignlib name, %0" )
    DIAG( TKO0329, SEV_ERROR,   "#foreignlib found no matching library file: %0; tried: %1" )
    DIAG( TKO0330, SEV_ERROR,   "#foreignlib name already bound to a different library set, %0" )
    '' fbc's error 17 for a missing or non-literal number, and its error 3 for
    '' anything after the optional quoted name. Measured: '#line -3' is error 17 at
    '' the '-', so the number is a LITERAL and not an expression, and
    '' '#line 10 foo.bas' is error 3 -- the name has to be quoted.
    DIAG( TKO0331, SEV_ERROR,   "#line takes a line number, then an optional quoted file name" )
    DIAG( TKO0332, SEV_ERROR,   "unexpected token after #line" )
    '' fbc's error 17 for a missing or non-string argument to '#cmdline', and its
    '' error 3 for a second string: '#cmdline "-d A" "-d B"' reads 'Expected
    '' End-of-Line, found '-d B''. Both measured against fbc 1.20.0.
    DIAG( TKO0333, SEV_ERROR,   "#cmdline takes one quoted argument string" )
    '' fbc's warning 46, "#cmdline ignored". Only the FIRST source file of a compile
    '' can restart it; the directive in any later one is read, warned about and
    '' dropped. Measured 2026-09-16.
    DIAG( TKO0334, SEV_WARNING, "#cmdline is ignored outside the first source file" )
    '' '#cinclude' (D16): the C importer, at the directive. See driver/cinclude.bas.
    DIAG( TKO0335, SEV_ERROR,   "#cinclude needs libclang: %0" )
    DIAG( TKO0336, SEV_ERROR,   "unable to import C header %0" )
    DIAG( TKO0337, SEV_ERROR,   "the binding generated for %0 does not compile; this is a bug in the C importer" )
    DIAG( TKO0338, SEV_ERROR,   "%0 defines '%1', which an earlier #cinclude in this unit left opaque; #cinclude %0 first" )
    DIAG( TKO0339, SEV_WARNING, "#cinclude could not write its cache entry under '%0'; the binding is used from memory" )
    '' '#module', '#import', '#export' (ADR 0017, src/pp/ppmodule.bas).
    DIAG( TKO0360, SEV_ERROR,   "'#module' must be the first directive in the file" )
    DIAG( TKO0361, SEV_ERROR,   "'#module ""%0""' does not match its directory '%1'" )
    DIAG( TKO0362, SEV_ERROR,   "'#import' must come before any code, in the compiled file" )
    DIAG( TKO0363, SEV_ERROR,   "the condition around '#import' uses '%0', which is not predefined" )
    DIAG( TKO0364, SEV_ERROR,   "malformed '%0': %1" )
    DIAG( TKO0365, SEV_ERROR,   "'#export %0': no macro of that name is defined here" )
    DIAG( TKO0366, SEV_ERROR,   "%0 is not allowed in a module file" )
    DIAG( TKO0367, SEV_ERROR,   "'%0' is part of module '%1' and cannot be #included" )
    DIAG( TKO0369, SEV_ERROR,   "%0 is allowed only in a module file" )

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
    '' fbc's error 3, "Expected End-of-Line": tokens left over after a whole statement.
    DIAG( TKO0420, SEV_ERROR,   "expected the end of the statement" )
    '' fbc's error 107, "NEXT without FOR". 'next x, y' closes the loop of x and then
    '' the one around it; a name with no FOR left open to close is this.
    DIAG( TKO0421, SEV_ERROR,   "'next' without a 'for': no loop is open for '%0'" )
    '' fbc's error 189, "Invalid priority attribute". Measured: 101 and 65535 are
    '' accepted, 100, 0 and 65536 are refused.
    DIAG( TKO0422, SEV_ERROR,   "a module constructor or destructor priority must be from 101 to 65535" )

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
    '' fbc's error 67. Too FEW is legal and fills with zero; only too many is refused.
    DIAG( TKO0618, SEV_ERROR,   "too many expressions in the initializer for '%0'" )
    '' fbc's error 263. A method inside a procedure would need a nested procedure.
    DIAG( TKO0619, SEV_ERROR,   "'%0' is declared inside a procedure and cannot have methods" )
    '' fbc's error 306. The vtable already knows: an abstract slot has no procedure.
    DIAG( TKO0620, SEV_ERROR,   "'%0' has an abstract type, which cannot be instantiated" )
    '' fbc's error 223. 'override' is a promise, and this is it not being kept.
    DIAG( TKO0621, SEV_ERROR,   "'%0' is marked 'override' but overrides no virtual method" )
    '' fbc's 225, 229/230 and 231. The parameter TYPES matched; these did not.
    DIAG( TKO0622, SEV_ERROR,   "'%0' overrides a virtual method with a different return type" )
    DIAG( TKO0623, SEV_ERROR,   "'%0' and the virtual method it overrides disagree about 'const'" )
    DIAG( TKO0624, SEV_ERROR,   "'%0' overrides a virtual method with a different parameter mode" )
    '' fbc's error 202.
    DIAG( TKO0625, SEV_ERROR,   "'%0' is not accessible here" )
    '' fbc's error 58, and 99 for the overloaded ones.
    DIAG( TKO0626, SEV_ERROR,   "'%0' takes a string" )
    '' fbc's errors 300, 302 and 303, which are one rule underneath.
    DIAG( TKO0627, SEV_ERROR,   "a pointer to a derived type casts only along its own chain" )
    '' fbc's error 87. It is the STORAGE that decides, not the scope.
    DIAG( TKO0628, SEV_ERROR,   "var-len string '%0' has static storage and cannot be initialized" )
    '' fbc's error 28.
    DIAG( TKO0629, SEV_ERROR,   "'delete' takes a pointer" )
    '' fbc's error 265, and 28 / 24 the other way. '.' and '->' are not interchangeable.
    DIAG( TKO0630, SEV_ERROR,   "'.' reaches a member of a value; this is a pointer, so use '->'" )
    DIAG( TKO0631, SEV_ERROR,   "'->' reaches a member through a pointer to a type; this is not one" )
    '' fbc's error 99. Only for a genuine overload SET: see the call site.
    DIAG( TKO0632, SEV_ERROR,   "no overload of '%0' matches these arguments" )
    '' fbc's errors 204 and 206. Declaring the type is what calls them.
    DIAG( TKO0633, SEV_ERROR,   "'%0' needs a constructor or destructor that is not accessible here" )
    '' fbc's error 20 for both. There is no element size to scale by, and nothing to read.
    DIAG( TKO0634, SEV_ERROR,   "a procedure pointer cannot be dereferenced or used in arithmetic" )
    '' fbc's error 20. '&=' concatenates.
    DIAG( TKO0635, SEV_ERROR,   "'&=' concatenates, so its target must be a string" )
    '' fbc's errors 324 and 59. A fixed-length string has no parameter form at all.
    DIAG( TKO0636, SEV_ERROR,   "parameter '%0' cannot be a fixed-length string" )
    '' fbc's error 73.
    DIAG( TKO0637, SEV_ERROR,   "an array is not a subscript" )
    '' fbc's error 264. 'nested' means inside a PROCEDURE and nothing else.
    DIAG( TKO0638, SEV_ERROR,   "static member '%0' is only allowed in a top-level type" )
    '' fbc's error 3. A byref result is spelled 'function f( ) BYREF as T'.
    DIAG( TKO0639, SEV_ERROR,   "'byref' belongs before 'as', not after the return type" )
    '' fbc's error 272. A default is evaluated at the CALL SITE.
    DIAG( TKO0640, SEV_ERROR,   "a parameter default cannot name '%0', which has automatic storage" )
    '' fbc's error 58. What it is passed is a DESCRIPTOR, and an element has none.
    DIAG( TKO0641, SEV_ERROR,   "this parameter takes a whole array, not an element" )
    '' fbc's errors 24 and 119. 'swap' exchanges two STORAGE LOCATIONS.
    DIAG( TKO0642, SEV_ERROR,   "'swap' needs two variables, not a literal or a constant" )
    '' fbc's error 24. A byref binding needs something with an ADDRESS.
    DIAG( TKO0643, SEV_ERROR,   "'%0' is byref, so its initializer needs an address" )
    '' fbc's error 320. And it needs one at all.
    DIAG( TKO0644, SEV_ERROR,   "'%0' is byref and must be bound where it is declared" )
    '' fbc's error 221. Only a type that extends OBJECT has a vtable.
    DIAG( TKO0645, SEV_ERROR,   "'%0' is virtual, but its type does not extend 'object'" )
    '' fbc's error 224. The declaration says there is nothing to call.
    DIAG( TKO0646, SEV_ERROR,   "'%0' is abstract and cannot have a body" )
    '' fbc's error 233. They allocate the object; there is no receiver to dispatch through.
    DIAG( TKO0647, SEV_ERROR,   "'operator new' and 'operator delete' are implicitly static and cannot be virtual" )
    '' fbc's error 17. A PUT mode is a WORD; the quotes are the whole mistake.
    DIAG( TKO0648, SEV_ERROR,   "a 'put' blend mode is a word, not a string" )
    '' fbc's error 73. The bare name is legal where a DESCRIPTOR is wanted, not a value.
    DIAG( TKO0649, SEV_ERROR,   "an array name without a subscript is not a value" )
    '' fbc's error 272. The frame the reference points into is gone by the time it is read.
    DIAG( TKO0650, SEV_ERROR,   "a byref result cannot return a local" )
    '' fbc's error 20, and it is symmetric: either half may be the one that is wrong.
    DIAG( TKO0651, SEV_ERROR,   "the definition of '%0' disagrees with its declaration about 'byref'" )
    '' fbc's error 24. A literal has no storage to write into.
    DIAG( TKO0652, SEV_ERROR,   "a literal cannot be assigned to" )
    '' fbc's errors 20 and 24. A constant may not cross the string/number divide.
    DIAG( TKO0653, SEV_ERROR,   "'%0' and its initializer disagree about being a string" )
    '' fbc's errors 186 and 188. There is nothing the derived construction can call.
    DIAG( TKO0654, SEV_ERROR,   "the base of '%0' has no constructor that takes no argument" )
    '' fbc's error 24. 'iif' returns ONE type, so its arms may not disagree.
    DIAG( TKO0655, SEV_ERROR,   "the two arms of 'iif' have incompatible types" )
    '' fbc's error 135. The storage belongs to another module.
    DIAG( TKO0656, SEV_ERROR,   "'%0' is extern or common and cannot be initialized" )
    '' fbc's error 183. Nothing to call, and no initialiser naming what to call instead.
    DIAG( TKO0657, SEV_ERROR,   "the type of '%0' has no constructor that takes no argument" )
    '' fbc's error 36. As many subscripts as the array has dimensions, or none at all.
    DIAG( TKO0658, SEV_ERROR,   "'%0' is indexed with the wrong number of subscripts" )
    '' fbc's error 162. A union's members overlap; a descriptor has to be owned by one.
    DIAG( TKO0659, SEV_ERROR,   "dynamic array '%0' cannot be a member of a union" )
    '' fbc's error 98. Guarded exactly as TKO0632 is, and for the same reasons.
    DIAG( TKO0660, SEV_ERROR,   "the call to '%0' matches more than one overload" )
    '' fbc's error 147.
    DIAG( TKO0661, SEV_ERROR,   "'%0' was not declared as a static member variable" )
    '' fbc's errors 207 and 208.
    DIAG( TKO0662, SEV_ERROR,   "'%0' cannot reach its base type's private default constructor" )
    DIAG( TKO0663, SEV_ERROR,   "'%0' cannot reach its base type's private destructor" )
    '' fbc's errors 119, 276 and 18, inside or about a CONST method.
    DIAG( TKO0664, SEV_ERROR,   "'%0' cannot be written from a const method" )
    DIAG( TKO0665, SEV_ERROR,   "a const method cannot call the non-const method '%0'" )
    DIAG( TKO0666, SEV_ERROR,   "the type declares no '%0' to call" )
    '' fbc's error 318.
    DIAG( TKO0667, SEV_ERROR,   "a byref result must be assigned something of exactly its type" )
    '' fbc's error 272, over an INITIALISER. Was reported as TKO0640, whose wording is
    '' about a PARAMETER DEFAULT and was wrong for this shape.
    DIAG( TKO0668, SEV_ERROR,   "a shared initialiser cannot reference '%0', which is not shared" )
    '' fbc's errors 158 and 131.
    DIAG( TKO0669, SEV_ERROR,   "'%0' adds a new name to a namespace from outside it" )
    '' fbc's errors 181 and 100.
    DIAG( TKO0670, SEV_ERROR,   "a pointer and a floating-point value do not convert into each other" )
    DIAG( TKO0671, SEV_ERROR,   "division by a constant zero" )
    '' fbc's errors 304 and 305.
    DIAG( TKO0672, SEV_ERROR,   "the ALIAS name string is empty" )
    DIAG( TKO0673, SEV_ERROR,   "the LIB name string is empty" )
    '' fbc's error 11, over an LBOUND or UBOUND in a CONST initialiser.
    DIAG( TKO0674, SEV_ERROR,   "this array bound is not known at compile time" )
    '' fbc's error 42, in a PARAMETER DEFAULT.
    DIAG( TKO0675, SEV_ERROR,   "a parameter default names '%0', which is not declared" )
    '' fbc's errors 178 and 179.
    DIAG( TKO0676, SEV_ERROR,   "'%0' mixes RETURN with 'FUNCTION =' over a result type that has constructors" )
    '' fbc's error 4, over two overloads with one signature.
    DIAG( TKO0677, SEV_ERROR,   "'%0' is already declared with these parameter types" )
    '' fbc's errors 17, 219, and 210/211/212 -- VIRTUAL and ABSTRACT, misplaced.
    DIAG( TKO0678, SEV_ERROR,   "nothing may follow VIRTUAL or ABSTRACT but the procedure keyword" )
    DIAG( TKO0679, SEV_ERROR,   "VIRTUAL and ABSTRACT belong to a member of a type" )
    DIAG( TKO0680, SEV_ERROR,   "VIRTUAL and ABSTRACT belong to the declaration, not to the body" )
    DIAG( TKO0681, SEV_ERROR,   "a structor cannot be declared this way" )
    '' fbc's errors 259, 258, 234 and 78.
    DIAG( TKO0682, SEV_ERROR,   "CONST is for a member procedure, which has a THIS to be const" )
    DIAG( TKO0683, SEV_ERROR,   "STATIC is for a member procedure" )
    DIAG( TKO0684, SEV_ERROR,   "this operator is implicitly STATIC and cannot be CONST" )
    DIAG( TKO0685, SEV_ERROR,   "the bitfield '%0' is wider than its type" )
    '' fbc's error 181, over POINTERS.
    DIAG( TKO0686, SEV_ERROR,   "these pointer types do not convert into each other" )
    '' fbc's error 58.
    DIAG( TKO0687, SEV_ERROR,   "a bydesc parameter takes an array of exactly its element type" )
    '' fbc's error 342, which it reports for a USTRING as "Type is not iterable". A narrow
    '' string IS walked, by both compilers, and yields its bytes; a ustring holds UTF-16 code
    '' units, and what one iteration of it should hand back has not been decided. Saying so
    '' beats the silence this replaced: Check accepted the loop, lowering declined it, and the
    '' program ran zero iterations with no diagnostic at all (tiko-book T17).
    DIAG( TKO0688, SEV_ERROR,   "'for each' cannot walk a ustring; index it with 'for' and 'mid' instead" )
    '' fbc's errors 275, 77, 237 and 67.
    DIAG( TKO0690, SEV_ERROR,   "the dynamic array field '%0' cannot have a const element type" )
    DIAG( TKO0691, SEV_ERROR,   "the array field '%0' cannot take an ellipsis bound" )
    DIAG( TKO0692, SEV_ERROR,   "the array '%0' cannot have a const element type" )
    DIAG( TKO0693, SEV_ERROR,   "base( ) is given more values than the base type has fields" )
    '' fbc's errors 147/3 and 63.
    DIAG( TKO0694, SEV_ERROR,   "'%0' names neither a namespace nor a type" )
    DIAG( TKO0695, SEV_ERROR,   "'%0' is not an array and cannot be redimensioned" )
    '' fbc's errors 217/218, 152, and 24/58 at a call.
    DIAG( TKO0696, SEV_ERROR,   "%0 is written on this definition but not on its declaration" )
    DIAG( TKO0697, SEV_ERROR,   "operator '%0' must be a member of a type" )
    DIAG( TKO0698, SEV_ERROR,   "this argument does not convert to the parameter's type" )
    '' fbc's errors 181 (const to non-const byref) and 28 ([] without a pointer).
    DIAG( TKO0699, SEV_ERROR,   "a const value cannot be passed to a non-const byref parameter" )
    DIAG( TKO0700, SEV_ERROR,   "'[ ]' indexes a pointer, and this is not one" )
    '' fbc's errors 3 and 17, over a trailing 'constructor' / 'destructor'.
    DIAG( TKO0701, SEV_ERROR,   "only a module-level definition or a static member can be a module constructor" )
    '' fbc's errors 181 (string/number by assignment), 232 and 68.
    DIAG( TKO0702, SEV_ERROR,   "a string and a number do not convert into each other" )
    DIAG( TKO0703, SEV_ERROR,   "operator [] cannot be STATIC" )
    DIAG( TKO0704, SEV_ERROR,   "operator [] needs an explicit result type" )
    '' fbc's errors 28, 201 and 20, over NEW and NOT.
    DIAG( TKO0705, SEV_ERROR,   "'new' of a bare zstring or wstring allocates nothing" )
    DIAG( TKO0706, SEV_ERROR,   "'new' cannot allocate a fixed-length string" )
    DIAG( TKO0707, SEV_ERROR,   "'not' over a pointer; compare it with 0 instead" )
    '' fbc's errors 28 and 99, over a graphics statement's image target.
    DIAG( TKO0708, SEV_ERROR,   "the image target of a graphics statement must be a pointer" )
    DIAG( TKO0709, SEV_ERROR,   "this type has no conversion to a pointer for a graphics statement to draw into" )
    '' fbc's errors 316, 24/3 and 311, over a BYREF result and an ALIAS.
    DIAG( TKO0710, SEV_ERROR,   "the byref function '%0' never sets its result" )
    DIAG( TKO0711, SEV_ERROR,   "a byref result must be assigned something with an address" )
    DIAG( TKO0712, SEV_ERROR,   "the alias on the definition of '%0' does not match its declaration" )
    '' fbc's error 18, over a nested type reached through an instance.
    DIAG( TKO0713, SEV_ERROR,   "'%0' is a type, not a member with a value" )
    '' fbc's error 24, over a CASE value and a WITH subject.
    DIAG( TKO0714, SEV_ERROR,   "this case value is not the kind the select subject is" )
    DIAG( TKO0715, SEV_ERROR,   "'with' takes a UDT value, not a number or a pointer" )
    '' fbc's errors 28, 307 and 268.
    DIAG( TKO0716, SEV_ERROR,   "'->' through a value of a type that has no operator ->" )
    DIAG( TKO0717, SEV_ERROR,   "'base.%0( )' calls an abstract method, which has no body" )
    DIAG( TKO0718, SEV_ERROR,   "a union cannot be unpacked by let( )" )
    '' fbc's errors 174/175/176, 20 and 9.
    DIAG( TKO0719, SEV_ERROR,   "'erase' over this array needs a plain parameterless cdecl constructor and destructor" )
    DIAG( TKO0720, SEV_ERROR,   "no operator %0 compares this type" )
    DIAG( TKO0721, SEV_ERROR,   "the dynamic array field '%0' must write its rank: '(any)'" )
    '' fbc's error 168.
    DIAG( TKO0722, SEV_ERROR,   "the type '%0' never declared this constructor, destructor or property" )
    '' fbc's errors 54 and 7.
    DIAG( TKO0723, SEV_ERROR,   "only a var-len array can be redimensioned" )
    DIAG( TKO0724, SEV_ERROR,   "a union is initialised with one value, not a group" )
    '' fbc's errors 11 and 96/61.
    DIAG( TKO0725, SEV_ERROR,   "'%0' has static storage and must be initialised from a constant, not a variable" )
    DIAG( TKO0726, SEV_ERROR,   "'%0' is shared, which belongs at module level, not inside a block or procedure" )
    '' fbc's errors 37 and 36, over an EXTERN.
    DIAG( TKO0727, SEV_ERROR,   "the bounds of '%0' disagree with its EXTERN declaration" )
    DIAG( TKO0728, SEV_ERROR,   "'%0' is declared EXTERN with a different number of dimensions" )
    '' fbc's errors 24 and 11, over a BYREF variable.
    DIAG( TKO0729, SEV_ERROR,   "'%0' is byref and its initializer must have exactly its type" )
    DIAG( TKO0730, SEV_ERROR,   "'%0' is a static reference and cannot be bound to a local" )
    '' fbc's errors 68/17, 24, 59, 314/315 and 120.
    DIAG( TKO0731, SEV_ERROR,   "a byref procedure type must be a 'function' with an explicit result type" )
    DIAG( TKO0732, SEV_ERROR,   "'%0' returns 'any', which is not a value" )
    DIAG( TKO0733, SEV_ERROR,   "every parameter of a definition needs a name" )
    DIAG( TKO0734, SEV_ERROR,   "CONST is not needed on a constructor or destructor" )
    DIAG( TKO0735, SEV_ERROR,   "'base' must be followed by '.' or an argument list" )
    '' fbc's errors 184, 183, 181/24 and 18.
    DIAG( TKO0736, SEV_ERROR,   "the result type of '%0' has no default constructor" )
    DIAG( TKO0737, SEV_ERROR,   "'erase' over this array needs a default constructor" )
    DIAG( TKO0738, SEV_ERROR,   "no conversion between these two types" )
    DIAG( TKO0739, SEV_ERROR,   "'%0' has no member named '%1'" )
    '' fbc's errors 231/223, 17, 20, 42, 58 and 8.
    DIAG( TKO0740, SEV_ERROR,   "'%0' overrides a virtual method with an array parameter of a different rank" )
    DIAG( TKO0741, SEV_ERROR,   "a field name cannot carry a type suffix" )
    DIAG( TKO0742, SEV_ERROR,   "'on ... goto' needs a numeric selector, not a string" )
    DIAG( TKO0743, SEV_ERROR,   "'%0' is not declared" )
    DIAG( TKO0744, SEV_ERROR,   "'%0' cannot be sized by 'ubound' inside its own initializer" )
    DIAG( TKO0745, SEV_ERROR,   "the namespace '%0' has no member named '%1'" )
    '' fbc's errors 202, 204 and 205 -- an implicitly invoked member.
    DIAG( TKO0746, SEV_ERROR,   "the %0 of '%1' is private or protected and cannot be reached from here" )
    '' fbc's error 181 for a pointer that loses a pointee's CONST.
    DIAG( TKO0747, SEV_ERROR,   "this drops a pointee's 'const'" )
    '' fbc's error 24 for a CONST of a type that cannot be one.
    DIAG( TKO0748, SEV_ERROR,   "a constant cannot have the type of '%0'" )
    '' fbc's errors 289 and 288, over THREADCALL.
    DIAG( TKO0749, SEV_ERROR,   "'threadcall' runs a SUB; '%0' is not one" )
    DIAG( TKO0750, SEV_ERROR,   "'threadcall' cannot run '%0': %1" )
    '' fbc's errors 147 and 63, over REDIM.
    DIAG( TKO0751, SEV_ERROR,   "a REDIM that declares '%0' must write its type" )
    DIAG( TKO0752, SEV_ERROR,   "REDIM needs the array's bounds: '%0( ... )'" )
    '' fbc's errors 24 (a bitfield has no address) and 51.
    DIAG( TKO0753, SEV_ERROR,   "'%0' is a bitfield and has no address to bind byref" )
    DIAG( TKO0754, SEV_ERROR,   "the type '%0' is too big" )
    '' fbc's error 71 -- an incomplete type where a complete one is needed.
    DIAG( TKO0755, SEV_ERROR,   "'%0' is byref with a default, which needs a complete type" )
    '' fbc's error 28 for a cast to a string type with no size.
    DIAG( TKO0756, SEV_ERROR,   "a cast needs a SIZED string type, as in 'zstring * n'" )
    '' fbc's error 24 for what an aggregate initialiser cannot fill.
    DIAG( TKO0757, SEV_ERROR,   "'%0' holds a var-len string, which an initializer list cannot fill" )
    DIAG( TKO0758, SEV_ERROR,   "'%0' has static storage and holds a bitfield, which its initializer cannot fill" )
    '' fbc's error 20 -- SWAP exchanges storage and converts nothing.
    DIAG( TKO0759, SEV_ERROR,   "'swap' needs two operands of the same kind" )

    '' fbc 226. The CONVENTIONS THAT COINCIDE ON THIS TARGET are not a mismatch:
    '' 'stdcall' overriding 'cdecl' is accepted on win64 and refused on 32-bit, which is
    '' fbc's own rule and measured both ways round.
    DIAG( TKO0767, SEV_ERROR,   "'%0' overrides a virtual method with a different calling convention" )

    '' fbc 227. The derived type declares NO destructor, so the one it gets is implicit
    '' and has the DEFAULT convention -- which cannot override a base destructor
    '' declared 'pascal'. Declaring one explicitly with the base's convention is the fix.
    DIAG( TKO0768, SEV_ERROR,   "'%0' inherits a virtual destructor whose calling convention an implicit one cannot match" )

    '' fbc 4, reached a different way: the name was taken out of circulation by
    '' '#pragma reserve' before anything tried to declare it. Only the PLAIN form does
    '' that -- '( asm )' and '( extern )' reserve the name for the assembler and the
    '' linker, and fbc still lets the source declare it. Measured, all four spellings.
    DIAG( TKO0769, SEV_ERROR,   "'%0' is reserved by '#pragma reserve' and cannot be declared" )

    '' fbc 325, "Illegal use of reserved symbol". ANY appearance of the name, not just
    '' the 'sizeof( symbol )' the survey recorded: measured, 'print foo', 'foo = 1',
    '' 'sizeof( foo )' and 'dim as integer x = foo' are all 325.
    ''
    '' SAFE WHERE THE GENERAL RULE WAS NOT. fbc answers 42 for an UNDECLARED name and
    '' TKO0743 was withdrawn for exactly that -- "unbound" is not "undeclared" -- until
    '' it came back as a report after Check (symbols/undeclared.bas). A RESERVED name
    '' carries no such doubt: it is on a list the source itself wrote.
    DIAG( TKO0770, SEV_ERROR,   "'%0' is reserved by '#pragma reserve' and cannot be used" )
    '' fbc's error 24, "Invalid data types". A fixed-length string and a ustring are
    '' both accepted with '= any'; only a var-len STRING, or an array of one, is not.
    DIAG( TKO0771, SEV_ERROR,   "'%0' is a var-len string, which cannot be declared '= any'" )
    '' fbc's errors 3, 7, 24, 73 and 1 -- one per context -- for '(x)(1)', 'P(3)(1)',
    '' '(array)(1)' and '(procname)(1)': only a procedure pointer is called that way.
    DIAG( TKO0772, SEV_ERROR,   "this expression is not a procedure pointer and cannot be called" )
    '' fbc's error 1, "Argument count mismatch" (7 when the pointer takes none), for a
    '' call through a procedure pointer.
    DIAG( TKO0773, SEV_ERROR,   "this call passes %0 argument(s), but the procedure pointer takes %1" )
    DIAG( TKO0774, SEV_ERROR,   "argument %0 is left out, and the procedure pointer's declaration gives it no default" )
    '' ...and the same two for a procedure called by name.
    DIAG( TKO0775, SEV_ERROR,   "this call passes %0 argument(s), but '%1' takes %2" )
    DIAG( TKO0776, SEV_ERROR,   "argument %0 of '%1' is left out, and it has no default" )
    '' fbc's error 274. The limit is EIGHT, counted through typedefs.
    DIAG( TKO0760, SEV_ERROR,   "too many levels of pointer indirection (the limit is 8)" )
    '' fbc's error 158, twice over.
    DIAG( TKO0761, SEV_ERROR,   "'%0' is declared SHARED from outside its namespace" )
    DIAG( TKO0762, SEV_ERROR,   "'%0' is already defined from outside" )
    '' fbc's errors 7 and 4, over '#pragma reserve'.
    DIAG( TKO0763, SEV_ERROR,   "'#pragma reserve' takes 'asm' or 'extern', not '%0'" )
    DIAG( TKO0764, SEV_ERROR,   "'%0' is already reserved for that use" )
    '' fbc's errors 9 and 94, over an array declaration.
    DIAG( TKO0765, SEV_ERROR,   "'%0' mixes 'any' with written bounds; use one or the other" )
    DIAG( TKO0766, SEV_ERROR,   "a type's array field is declared with 'dim', not 'redim'" )
    '' fbc's error 4 (120 for a type with a static member): a value named like a TYPE
    '' WITH MEMBERS OR A BASE. A plain-data type may share its name -- see collectdecl.bas.
    DIAG( TKO0777, SEV_ERROR,   "'%0' is already the name of a type with members, which no value may share" )
    '' fbc's error 11 for a STATIC-STORAGE initialiser computed at run time -- a call, a
    '' load, a dereference -- over a type no constructor fills. TKO0725 is the
    '' bare-variable half of the same rule.
    DIAG( TKO0778, SEV_ERROR,   "'%0' has static storage and must be initialised from a constant expression" )
    '' fbc's error 123, "Symbols defined inside namespaces cannot be removed": an '#undef'
    '' of a name whose declaration sits in a NAMESPACE, however it was reached -- from
    '' inside, through a 'using', or spelled 'ns.name'.
    DIAG( TKO0779, SEV_ERROR,   "'%0' is declared in a namespace and cannot be removed with #undef" )
    '' fbc's error 143, "Vararg parameters are not allowed in overloaded functions" --
    '' reported as its error 4 for anything but a constructor. A procedure with '...' may
    '' not be OVERLOAD, may not join an overload set, and no set may grow around it.
    DIAG( TKO0780, SEV_ERROR,   "'%0' takes '...' and cannot be overloaded" )
    '' fbc's error 312, "vararg parameters are only allowed in CDECL procedures". %0 is
    '' the convention the procedure ended up with, written or defaulted.
    DIAG( TKO0781, SEV_ERROR,   "'...' needs a 'cdecl' procedure, and this one is '%0'" )
    '' fbc's error 313, "the first parameter in a procedure may not be vararg".
    DIAG( TKO0782, SEV_ERROR,   "'...' cannot be the first parameter" )
    '' fbc's error 8, "Undefined symbol" -- what 'procptr' of an undeclared name is,
    '' where every other use of one is error 42 (TKO0743).
    DIAG( TKO0783, SEV_ERROR,   "'%0' is not declared, so 'procptr' has no procedure to take" )
    '' fbc's errors 14, 59 and 17 -- one per context -- for a TYPE named above its own
    '' declaration, which fbc has not reached yet.
    DIAG( TKO0784, SEV_ERROR,   "the type '%0' is used above its declaration" )
    '' fbc's error 24, "Invalid data types" (209 for a field): what 'procptr' takes has
    '' to BE a procedure.
    DIAG( TKO0785, SEV_ERROR,   "'%0' is not a procedure, so 'procptr' cannot take it" )
    '' fbc's errors 190, 191 and 213 -- the shapes a PROPERTY may have.
    DIAG( TKO0786, SEV_ERROR,   "a property getter takes no parameter, or one index" )
    DIAG( TKO0787, SEV_ERROR,   "a property setter takes its value, and at most one index before it" )
    DIAG( TKO0788, SEV_ERROR,   "a property cannot be static" )
    '' fbc's error 1, "Argument count mismatch", over an OPERATOR's own parameters.
    DIAG( TKO0789, SEV_ERROR,   "operator '%0' takes %1 parameter(s) here" )
    '' fbc's error 153, "Operator cannot be a member function".
    DIAG( TKO0790, SEV_ERROR,   "operator '%0' cannot be a member of a type" )
    '' fbc's error 8 for a 'procptr' operand that is no name at all -- a literal, '@f'.
    DIAG( TKO0791, SEV_ERROR,   "'procptr' takes the name of a procedure" )
    '' fbc's error 157, "Expected operator": the short-circuit forms are not overloadable.
    DIAG( TKO0792, SEV_ERROR,   "'%0' cannot be overloaded" )
    '' fbc's errors 40, 1, 58 and 158: a DEFINITION held to its declaration -- the result,
    '' the parameter count, each parameter, and for a member the overload it defines.
    DIAG( TKO0793, SEV_ERROR,   "the result of '%0' does not match its declaration" )
    DIAG( TKO0794, SEV_ERROR,   "'%0' was declared with %1 parameter(s)" )
    DIAG( TKO0795, SEV_ERROR,   "parameter %0 of '%1' does not match its declaration" )
    DIAG( TKO0796, SEV_ERROR,   "no declaration of '%0' matches this definition" )
    '' NO fbc COUNTERPART. THREADCALL compiles, and at run time the handle is 0 and the SUB
    '' never runs -- in fbc-modern's runtime too, which is built without libffi (measured,
    '' lib/rt/src/thread/call.bas). Said here so the difference is not found as a thread
    '' that never ran. Decision 0015 (D15), section 6.3.
    DIAG( TKO0797, SEV_WARNING, "'threadcall' is not supported: '%0' will not run, and the thread handle is 0" )
    '' fbc's errors 298, 297 and 299 over 'x IS T', the RTTI type test -- see CheckIsTest_.
    DIAG( TKO0798, SEV_ERROR,   "'is %0' needs a type derived from '%1', and '%0' is not one" )
    DIAG( TKO0799, SEV_ERROR,   "'is' needs run-time type information, and '%0' has none: it does not extend 'object'" )
    DIAG( TKO0800, SEV_ERROR,   "'is' needs an object and a type that extends 'object', not '%0'" )
    '' fbc's errors 1 and 99 over a RUNTIME BUILTIN claimed by its spelling -- 'wait 1',
    '' 'stop 1, 2', 'hex' -- when no form of it takes the arguments written. Check lets
    '' these names through unbound (symbols/undeclared.bas), so lowering is the first to
    '' know the call is wrong, and it dropped the statement with no diagnostic.
    DIAG( TKO0801, SEV_ERROR,   "'%0' does not take these arguments" )
    '' fbc's error 20 over 'cast( string, x )' with x WIDE, and its error 28 for the same
    '' operand written 'cptr' -- see CheckCastStringSize_. %0 is the spelling used.
    DIAG( TKO0802, SEV_ERROR,   "'%0( string, ... )' cannot take a wide string; 'str( ... )' converts one" )
    '' The same two errors over 'cast' or 'cptr' of anything but a var-len STRING that is
    '' not a constant, or a UDT casting to one -- see CastStrOperandWhy_.
    DIAG( TKO0803, SEV_ERROR,   "'%0( string, ... )' needs a var-len STRING, and this is %1" )
    '' fbc's error 28 over a cast BETWEEN A POINTER AND SOMETHING THAT IS NOT ONE. Either
    '' side may be the wrong one, so there are two -- see CheckCastPtrPair_.
    DIAG( TKO0804, SEV_ERROR,   "'%0' to a pointer needs a pointer or a pointer-sized integer, and this is %1" )
    DIAG( TKO0805, SEV_ERROR,   "'%0' of a pointer needs a pointer or a pointer-sized integer type, and this names %1" )
    '' fbc's error 24 over 'dim as T t = u' where T's only way in is a 'zstring ptr': a
    '' constructor is resolved as an overload set, and in one a ustring does not reach
    '' 'zstring ptr'. The call form, 'T( u )', is fbc's 99 and reports TKO0632.
    '' fbc's error 14 (17 for an enum, 4 for some namespaces): a keyword cannot name a type,
    '' a typedef, an enum or a namespace -- see KwTypeName_ in symbols/collectkw.bas.
    '' fbc's error 14 for 'dim as Foo a', 71 for 'type X as Foo', 59 for a parameter, 8 for
    '' a qualified name inside a namespace it knows: a TYPE NAME NOTHING DECLARES.
    '' fbc's error 340: a generic called without parentheses, or one with a type parameter
    '' no parameter names, has nothing to infer its type arguments from.
    '' fbc's error 71, "Incomplete type": a forward type -- 'type X as Foo', Foo declared
    '' nowhere -- used as an object rather than behind a pointer.
    '' ...and the same error 71 for a forward type COMPLETED BELOW the use: fbc reads top to
    '' bottom, so 'type X as Foo', 'dim as X a', 'type Foo' is incomplete at the DIM.
    '' fbc's error 358, "SPAWN cannot pass a BYREF parameter": ANY byref parameter of the
    '' first-declared procedure of the name, written or by default -- see resolvesynth.bas.
    '' fbc's errors 370, 266 and 371: DESTRUCTURING with the wrong number of names or targets,
    '' or over something that is not a tuple -- see symbols/checkeach.bas.
    DIAG( TKO0825, SEV_ERROR,   "the tuple has %0 elements, and %1 are written" )
    DIAG( TKO0826, SEV_ERROR,   "a tuple is expected here, and '%0' is not one" )
    '' fbc's errors 349 and 347: a forward GOTO past a 'defer' whose scope holds the label,
    '' and a 'defer' at the end of a line -- see symbols/resolvedefer.bas, parser/defer.bas.
    DIAG( TKO0827, SEV_ERROR,   "the jump to '%0' crosses a 'defer', which would still run when its scope ends" )
    DIAG( TKO0828, SEV_ERROR,   "'defer' needs a statement on the same line" )
    '' fbc's error 339 past -maxinstdepth, and tiko's stop for a runaway -- symbols/generic.bas.
    DIAG( TKO0829, SEV_ERROR,   "generic instantiation of '%0' is too deep (the limit is %1; -maxinstdepth raises it)" )
    '' fbc's warning 4, "Suspicious pointer assignment" -- see symbols/ptrwarn.bas.
    DIAG( TKO0830, SEV_WARNING, "suspicious pointer assignment: a '%0' from a '%1'" )
    '' fbc's errors 24 and 181 over a tuple element -- see symbols/tupleconv.bas.
    DIAG( TKO0831, SEV_ERROR,   "a '%0' does not convert to the tuple element '%1'" )
    '' fbc's error 58 over 'string( n, x )' and 'wstring( n, x )' -- see latesweeps4.bas.
    DIAG( TKO0832, SEV_ERROR,   "'%0( n, x )' takes a character code or a %1 string as x, not %2" )
    '' fbc's warning 3, "Passing different pointer types" -- see symbols/ptrwarn.bas.
    DIAG( TKO0833, SEV_WARNING, "passing different pointer types: a '%1' for a '%0' parameter" )
    '' fbc's error 120, "Expected period ('.')": the name is read as the enum, which wants
    '' '.member' after it. See ClassNameTaken_ in symbols/collectdecl.bas.
    DIAG( TKO0834, SEV_ERROR,   "'%0' is already the name of an enum, which no variable may share" )
    '' fbc's error 265, "Symbol not a CLASS, ENUM, TYPE or UNION type": 'v.EB' over a
    '' variable or parameter of an enum type. See symbols/check.bas, the enum-member arm.
    DIAG( TKO0835, SEV_ERROR,   "'%0' is a value of an enum type, not the enum, so it has no members" )
    '' fbc's error 24, "Invalid data types", over a PRINT, WRITE or str( ) of a value with no
    '' printable form -- see latesweeps4.bas.
    DIAG( TKO0871, SEV_ERROR,   "a '%0' has no printable form; '%1' cannot take it" )
    '' fbc's error 6, "Expected '('": a builtin function named with no argument list.
    DIAG( TKO0872, SEV_ERROR,   "'%0' needs an argument list" )
    '' fbc's error 17: a SUB called where a value is wanted -- see latesweeps4.bas.
    DIAG( TKO0873, SEV_ERROR,   "'%0' is a sub and has no value" )
    '' fbc's error 10, "Expected '='": a value alone as a statement -- see valuestmt.bas.
    DIAG( TKO0874, SEV_ERROR,   "a value alone is not a statement; expected '='" )
    '' fbc's error 9: 'obj.P( )' opening a statement -- see valuestmt.bas.
    DIAG( TKO0875, SEV_ERROR,   "property '%0' opens a statement with empty parentheses; expected an argument" )
    '' fbc's error 256: a TYPE or UNION with no field, an ENUM with no member -- see declempty.bas.
    DIAG( TKO0876, SEV_ERROR,   "this %0 cannot be empty" )
    '' fbc's error 17: an anonymous 'union' directly in a UNION, a 'type' directly in a TYPE.
    DIAG( TKO0877, SEV_ERROR,   "an anonymous %0 cannot sit directly inside a %0; they must alternate" )
    '' fbc's 88 (24 from a nested type): a field of the type being declared -- see recursivetype.bas.
    DIAG( TKO0878, SEV_ERROR,   "'%0' cannot hold itself: it is still being declared, and only a pointer to it may be a field" )
    '' fbc's 17, 205 and 206: a member as a module constructor or destructor -- see collectproc.bas.
    DIAG( TKO0879, SEV_ERROR,   "'%0' cannot be a module %1: it is %2, and only a public static member may be one" )
    '' fbc's error 105: a GOTO over a definition that needs constructing -- see branchcross.bas.
    DIAG( TKO0880, SEV_ERROR,   "the jump to '%0' crosses the definition of '%1', which needs constructing" )
    '' ...and the same over a TEMPORARY a SELECT CASE or a FOR defines -- branchcross.bas.
    DIAG( TKO0881, SEV_ERROR,   "the jump to '%0' crosses the temporary holding %1, which needs constructing" )
    '' fbc's error 24: IIF over a UDT with neither a default nor a copy constructor -- iifudt.bas.
    DIAG( TKO0882, SEV_ERROR,   "iif cannot build a '%0': it has constructors, but neither a default nor a copy one" )
    '' fbc's error 28: a graphics GET's buffer as an element reached through a call -- constout.bas.
    DIAG( TKO0883, SEV_ERROR,   "GET cannot fill an array element reached through a function call; expected a pointer" )
    '' fbc's error 156: a STATIC member of an anonymous union or type -- declempty.bas.
    DIAG( TKO0884, SEV_ERROR,   "a static member cannot be declared in an anonymous %0" )
    '' fbc's error 24: 'new string( any )' and 'new string[n] { any }' -- proccheck.bas.
    DIAG( TKO0885, SEV_ERROR,   "'any' cannot leave a new STRING uninitialized" )
    '' fbc's error 131: a qualified declaration inside a namespace that is not nested in it -- latesweeps3.bas.
    DIAG( TKO0886, SEV_ERROR,   "'%0' cannot be declared here: only a namespace nested inside this one may be named" )
    '' fbc's error 182: a fixed array's lower bound above its upper -- resolvesize.bas.
    DIAG( TKO0887, SEV_ERROR,   "invalid array subscript in '%0': a lower bound is above its upper bound" )
    '' fbc's error 11: a shared or static reference bound to what has no fixed address -- latesweeps2.bas.
    DIAG( TKO0888, SEV_ERROR,   "'%0' is a shared or static reference: it must be bound to a variable, or to a constant element of a fixed array" )
    '' fbc's errors 20 and 131: a static member defined with another type, or byref where it was not -- staticdef.bas.
    DIAG( TKO0889, SEV_ERROR,   "the definition of '%0' does not match its declaration in the type" )
    '' fbc's error 20: a conversion intrinsic over a pointer or a UDT it cannot convert -- staticdef.bas.
    DIAG( TKO0890, SEV_ERROR,   "'%0' cannot convert a '%1'" )
    '' fbc's error 7: 'base( args )' that no constructor of the base takes -- assigncheck.bas.
    DIAG( TKO0891, SEV_ERROR,   "no constructor of the base takes %0 argument(s)" )
    '' fbc's error 9: an empty 'base( )' over a base that has nothing to construct -- assigncheck.bas.
    DIAG( TKO0892, SEV_ERROR,   "base( ) needs a value: the base type has no constructor" )
    '' fbc's error 14: 'type T as dim' -- a reserved word is no type name -- decltype.bas.
    DIAG( TKO0893, SEV_ERROR,   "'%0' is a keyword and cannot name a type" )
    '' fbc's error 136: 'common array(0)' -- declshape.bas.
    DIAG( TKO0894, SEV_ERROR,   "'%0' is a COMMON array, which is dynamic and cannot be given bounds" )
    '' fbc's error 281: an ellipsis bound with no initializer to count -- declshape.bas.
    DIAG( TKO0895, SEV_ERROR,   "'%0' has an ellipsis bound, which needs an initializer to count" )
    '' fbc's error 76: an ellipsis bound on a REDIM -- declshape.bas.
    DIAG( TKO0896, SEV_ERROR,   "'%0' is dynamic: a REDIM cannot take an ellipsis bound" )
    '' fbc's error 237: 'dim as const integer foo = any' -- declshape.bas.
    DIAG( TKO0897, SEV_ERROR,   "'%0' is const, so it needs a value: '= any' leaves it unset" )
    '' fbc's error 24: 'dim x as any' -- declshape.bas.
    DIAG( TKO0898, SEV_ERROR,   "'%0' cannot be of type ANY: only a pointer to it can" )
    '' fbc's errors 24 and 71: 'type t as t' then a variable of it -- declshape.bas.
    DIAG( TKO0899, SEV_ERROR,   "'%0' is a typedef defined in terms of itself" )
    '' fbc's error 169: 'constructor( ... )' after the first statement -- declshape.bas.
    DIAG( TKO0908, SEV_ERROR,   "a constructor( ) chain call must be the first statement of the constructor" )
    '' fbc's error 141: a global 'operator ->' whose result is not a UDT -- declshape.bas.
    DIAG( TKO0909, SEV_ERROR,   "operator -> must return a UDT, by value or byref" )
    '' fbc's errors 24 and 181: a pointer into an integer of another size -- declshape.bas.
    DIAG( TKO0910, SEV_ERROR,   "a pointer does not fit in a '%0'; only a pointer-sized integer takes one" )
    '' fbc's error 9: an empty 'type<T>( )' over a type with nothing to construct -- declshape.bas.
    DIAG( TKO0911, SEV_ERROR,   "type<%0>( ) needs values: the type has no constructor to call" )
    '' fbc's error 99: 'type<T>( ... )' over a type that extends OBJECT and declares no constructor -- declshape.bas.
    DIAG( TKO0912, SEV_ERROR,   "no constructor of '%0' takes these values: a type that extends OBJECT is not filled field by field" )
    '' fbc's errors 172 and 175: an array of a type whose destructor is stdcall or pascal -- declshape.bas.
    DIAG( TKO0913, SEV_ERROR,   "'%0' is an array of '%1', whose destructor is not cdecl; an array can only destroy through a cdecl one" )
    '' fbc's error 73: a whole array as the data of a file GET or PUT -- declshape.bas.
    DIAG( TKO0914, SEV_ERROR,   "'%0' is an array: GET # and PUT # take an element, or the whole array written '%0( )'" )
    '' fbc's error 5: 'open scrn "name"' -- SCRN, CONS and ERR take no name -- parser/intrinsics.bas.
    DIAG( TKO0915, SEV_ERROR,   "'%0' takes no name: the next thing is FOR or AS" )
    '' fbc's error 98: a graphics target UDT with two casts to a pointer -- proccheck.bas.
    DIAG( TKO0916, SEV_ERROR,   "this type has more than one conversion to a pointer, so the graphics statement cannot choose one" )
    '' fbc's error 42: 'UDT( )' over a type with nothing to construct -- declshape.bas.
    DIAG( TKO0917, SEV_ERROR,   "'%0' has no constructor, so '%0( ... )' is no call" )
    '' fbc's error 24: '*@type<T>( ... ) = x' -- declshape.bas.
    DIAG( TKO0918, SEV_ERROR,   "a store through the address of a temporary: the value is gone at the end of the statement" )
    '' fbc's error 255: a name two usings both reach -- declshape.bas.
    DIAG( TKO0919, SEV_ERROR,   "'%0' is ambiguous: more than one USING in effect declares it; qualify it" )
    '' fbc's error 96: '#pragma reserve (asm)' inside a block -- parser/declempty.bas.
    DIAG( TKO0920, SEV_ERROR,   "'#pragma reserve (asm)' belongs at module level, not inside a block" )
    '' fbc's error 59: a capturing lambda's parameter typed by the enclosing generic's parameter -- declshape.bas.
    DIAG( TKO0921, SEV_ERROR,   "the capturing lambda's parameter '%0' cannot be of the generic's type parameter '%1'" )
    '' fbc's error 160: 'property UDT.foo' where UDT is not visible from here -- latesweeps.bas.
    DIAG( TKO0922, SEV_ERROR,   "'%0' is not visible here: it is declared inside a namespace; qualify it" )
    '' fbc's error 8: 'using nosuch' -- a USING of what is no namespace declared above -- resolve.bas.
    DIAG( TKO0923, SEV_ERROR,   "'%0' is no namespace declared before this USING" )
    '' fbc's error 89: '#define A A+1' -- a macro's body naming the macro itself -- pp/macro.bas.
    DIAG( TKO0924, SEV_ERROR,   "recursive #define: '%0' names itself in its own body" )
    '' fbc's error 71: a bare 'type( ... )' with no single type to build -- declshape.bas.
    DIAG( TKO0925, SEV_ERROR,   "type( ... ) has no type to build here: write type<T>( ... )" )
    '' fbc's errors 188 and 185: a base with no default constructor -- symbols/basector.bas.
    DIAG( TKO0926, SEV_ERROR,   "'%0' needs a copy constructor: its base has no constructor that takes no argument, so none can be made for it" )
    DIAG( TKO0927, SEV_ERROR,   "this constructor of '%0' must call base( ... ): its base has no constructor that takes no argument" )
    '' fbc's error 14 for 'extends (long, long)': a tuple written as a base -- decltype.bas.
    DIAG( TKO0824, SEV_ERROR,   "a tuple cannot be a base type; name a type after 'extends'" )
    '' fbc's errors 367, 368 and 369: a tuple TYPE with fewer than two elements, a duplicated
    '' element name, or an element that cannot be stored -- see parser/typeref.bas.
    DIAG( TKO0821, SEV_ERROR,   "a tuple needs at least two elements" )
    DIAG( TKO0822, SEV_ERROR,   "the tuple element name '%0' is used twice" )
    DIAG( TKO0823, SEV_ERROR,   "a tuple element cannot be 'any' or a fixed-length string" )
    '' fbc's error 20 for arithmetic or logic on a UDT that no operator takes -- see
    '' symbols/proccheck.bas, CheckUdtCompare_.
    DIAG( TKO0820, SEV_ERROR,   "no operator '%0' takes these operand types" )
    '' fbc's error 346: 'next v' naming a FOR EACH variable, or naming anything -- see
    '' parser/parserend.bas, AcceptNext_.
    DIAG( TKO0819, SEV_ERROR,   "'next' cannot name a FOR EACH variable: it is scoped to the loop body" )
    '' fbc's error 345: 'for each byref' over an iterator whose Value( ) returns by value --
    '' there is no element to bind to. See symbols/checkeach.bas.
    DIAG( TKO0818, SEV_ERROR,   "'for each byref' needs a byref Value( ), and '%0.Value( )' returns by value" )
    '' fbc's error 341: a generic member's out-of-line '( of ... )' list differs from the
    '' type's, in count or in a name -- see symbols/resolvestmt.bas.
    DIAG( TKO0817, SEV_ERROR,   "the type parameters written for '%0' do not match its declaration, 'of %1'" )
    '' fbc's errors 335 and 336: a GENERIC type named without its type arguments, or with the
    '' wrong number of them -- see symbols/resolvetype.bas, GenericArgsCheck_.
    DIAG( TKO0815, SEV_ERROR,   "'%0' is generic; write its type arguments, as '%0( of ... )'" )
    DIAG( TKO0816, SEV_ERROR,   "'%0' takes %1 type argument(s), and %2 are written here" )
    '' fbc's error 348: 'defer' directly at module level or in a namespace -- resolvestmt.bas.
    DIAG( TKO0814, SEV_ERROR,   "'defer' is not allowed at module level; put it in a procedure or a block" )
    '' fbc's error 4, "Duplicated definition", for a declaration named like a runtime procedure
    '' fbc predeclares -- 'sub Run( )', 'dim as long timer' -- see symbols/resolvertl.bas.
    DIAG( TKO0813, SEV_ERROR,   "'%0' is already declared by the runtime library" )
    DIAG( TKO0812, SEV_ERROR,   "'spawn %0' cannot pass its byref parameter '%1'; a string or UDT parameter is byref unless it is written 'byval'" )
    DIAG( TKO0811, SEV_ERROR,   "'%0' is still incomplete here: it is declared below this use, and only a pointer to it may be used above that" )
    DIAG( TKO0810, SEV_ERROR,   "'%0' is an incomplete type: nothing declares it, so only a pointer to it may be used here" )
    DIAG( TKO0809, SEV_ERROR,   "cannot infer the type arguments of '%0'; write them, as '%0( of ... )( ... )'" )
    DIAG( TKO0808, SEV_ERROR,   "the type '%0' is not declared" )
    DIAG( TKO0807, SEV_ERROR,   "'%0' is a keyword and cannot name %1" )
    DIAG( TKO0806, SEV_ERROR,   "'%0' cannot be initialized from a ustring: no constructor of '%1' takes one, and a ustring does not convert to 'zstring ptr' here" )

    '' -------------------------------------------------------------------- notes
    DIAG( TKO0900, SEV_NOTE,    "%0" )
    DIAG( TKO0901, SEV_NOTE,    "declared here" )
    DIAG( TKO0902, SEV_NOTE,    "expanded from macro '%0'" )
    DIAG( TKO0903, SEV_NOTE,    "in instantiation of '%0'" )
    DIAG( TKO0904, SEV_NOTE,    "required from here" )
    DIAG( TKO0905, SEV_NOTE,    "unclosed '%0' opened here" )
    DIAG( TKO0906, SEV_NOTE,    "imported here" )
    '' Beside TKO0743 for a name that is a SEGMENT of an import's path but not its alias:
    '' '#import "std/strings"' binds 'strings', so 'std.replace' named nothing.
    DIAG( TKO0907, SEV_NOTE,    "did you mean '%0'? '#import ""%1""' binds the name '%0'" )

    '' ---------------------------------------------------------- compiler / limits
    DIAG( TKO0990, SEV_ERROR,   "too many errors; stopping" )
    DIAG( TKO0991, SEV_ERROR,   "input exceeds a compiler limit: %0" )
    DIAG( TKO0992, SEV_ERROR,   "not implemented in this build: %0" )
    '' An emission failure: the compiler could not emit something it accepted. It was
    '' 'emit: ICE: ...' on STDOUT -- where under --emit-ir it landed inside the .ll.
    DIAG( TKO0993, SEV_ERROR,   "internal compiler error in emission: %0" )

#endmacro

enum DiagId
    DIAG_NONE = 0
    #define DIAG( d_id, d_sev, d_fmt ) d_id,
    TKO_DIAG_LIST( DIAG )
    #undef DIAG
    DIAG_COUNT
end enum

#endif
