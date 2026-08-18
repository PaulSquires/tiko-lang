' TEST_MODE : COMPILE_AND_RUN_OK

'' VAL must read an &H/&O/&B string the way QB does: a value that fits in
'' 16 bits IS a 16bit signed INTEGER, so "&hffff" is -1, not 65535.  A
'' trailing '&' (the LONG type suffix) widens it to 32bit signed instead.
''
'' This is the same rule the lexer already applied to literals written in
'' the source text; before fb_VALQB() existed the runtime disagreed with
'' the compiler about the very same characters.

#define ASSERT(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)


'' ---- hex ----------------------------------------------------------------

assert( val("&hffff") = -1 )
assert( val("&hFFFF") = -1 )
assert( val("&Hffff") = -1 )
assert( val("&h8000") = -32768 )
assert( val("&h7fff") = 32767 )
assert( val("&h0") = 0 )
assert( val("&h") = 0 )

'' leading zeroes do not make it wider
assert( val("&h0000ffff") = -1 )

'' 17 bits or more - a 32bit LONG, exactly as QB reads it
assert( val("&h10000") = 65536 )
assert( val("&h7fffffff") = 2147483647 )
assert( val("&h80000000") = (-2147483647 - 1) )
assert( val("&hffffffff") = -1 )

'' the runtime and the lexer must agree about the same characters
assert( val("&hffff") = &hffff )
assert( val("&h8000") = &h8000 )
assert( val("&hffffffff") = &hffffffff )
assert( val("&h10000") = &h10000 )


'' ---- the '&' (LONG) suffix ----------------------------------------------

assert( val("&hffff&") = 65535 )
assert( val("&h8000&") = 32768 )
assert( val("&hffffffff&") = -1 )
assert( val("&hffff&") = &hffff& )

'' '%' is the INTEGER suffix, which is what it already is
assert( val("&hffff%") = -1 )


'' ---- octal --------------------------------------------------------------

assert( val("&o177777") = -1 )
assert( val("&O177777") = -1 )
assert( val("&o177777&") = 65535 )
assert( val("&o100000") = -32768 )
assert( val("&o37777777777") = -1 )

'' '&' with no radix letter is octal
assert( val("&177777") = -1 )
assert( val("&177777&") = 65535 )


'' ---- binary -------------------------------------------------------------

assert( val("&b1111111111111111") = -1 )
assert( val("&B1111111111111111") = -1 )
assert( val("&b1111111111111111&") = 65535 )
assert( val("&b1000000000000000") = -32768 )
assert( val("&b11111111111111111111111111111111") = -1 )


'' ---- decimal is untouched -----------------------------------------------

assert( val("65535") = 65535 )
assert( val("-1") = -1 )
assert( val("123.5") = 123.5 )
assert( val("1e3") = 1000 )
assert( val("") = 0 )


'' ---- stops at the first character that is not a digit -------------------

assert( val("  &hffff") = -1 )
assert( val("&hffffZ") = -1 )
assert( val("&haxxxxf") = 10 )
assert( val("&o179") = 15 )
assert( val("&b10114") = 11 )
assert( val("&hzz") = 0 )


'' ---- wider than QB could express: left alone, not mangled ---------------

assert( val("&hffffffffff") = 1099511627775.0 )


'' ---- __val is the FB reading, still reachable in -lang qb ---------------

assert( __val("&hffff") = 65535 )
assert( __val("&hffffffff") = 4294967295.0 )
