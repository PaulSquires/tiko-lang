'' 'get #f, 1, s' AND 'get #f, 1, a()' -- a STRING and an ARRAY destination, both of
'' which were refused outright: the byte-count entry point was the only one lowered, and
'' neither of these uses it. file/get.bas is twelve of them.
''
'' Measured, and each takes a DIFFERENT runtime function:
''
''   fb_FileGetStrLarge( F$0, 1ll, (void*)&S$0, -1ll );
''   fb_FileGetArrayLarge( F$0, 1ll, (struct $7FBARRAYIvE*)&tmp$3$0 );
''
'' -- the string form passing the DESCRIPTOR and a trailing -1, which is "as many bytes
'' as the string already holds", and the array form passing the array's FBARRAY
'' descriptor, the same one ERASE builds for a fixed array.
''
'' THE ARRAY IS SPELLED 'a()' -- an EMPTY CALL over a name whose type is an array, not
'' an identifier, so asking the argument node for an array type answered nothing.
'' ArrayDescArg_ is what already recognises that shape.
''
'' Two rows decline rather than being approximated: a USTRING destination, because
'' fb_FileGetStrLarge would fill a UTF-16 descriptor with bytes, and a DYNAMIC array,
'' whose descriptor tiko-lang does not build -- passing whatever its slot holds would
'' hand the runtime a wild pointer.
dim as string s = "abcd"
dim as long a(0 to 3)
dim as long f = freefile

open "tests-file-get.tmp" for binary as #f
put #f, 1, s
put #f, 1, a()
get #f, 1, s
get #f, 1, a()
close #f
kill "tests-file-get.tmp"

print s, a(0)
