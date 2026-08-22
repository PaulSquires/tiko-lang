'' 'extern import NAME alias "..." as T' -- a DLL-imported variable, which is how the
'' CRT headers declare every one of theirs. ctype.bi and stdlib.bi have eight between
'' them, and every corpus file that reaches the C runtime through either failed on them.
''
'' Two separate gaps, and the declaration came out UNTYPED either way:
''   IMPORT was read as the variable's NAME and the real name as its type.
''   ALIAS on a VARIABLE was not accepted at all -- only a procedure had one.
extern import _ctype alias "_ctype" as ushort ptr ptr
extern import _pctype alias "_pctype" as ushort ptr ptr
extern export ex1 as long
'' ...and the plain forms it must not have broken.
extern plain1 as long
extern plain2 alias "other" as long
