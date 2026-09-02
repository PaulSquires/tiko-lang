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
