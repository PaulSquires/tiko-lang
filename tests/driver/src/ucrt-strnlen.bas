'' strnlen, linked from the C runtime's import library: the length of a string, but never
'' more than the limit given. See ucrt-strnlen.test.
declare function strnlen cdecl alias "strnlen" _
    ( byval s as const zstring ptr, byval maxlen as uinteger ) as uinteger

print strnlen( "hello", 3 ); " "; strnlen( "hello", 99 )
