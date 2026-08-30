'' THE USTRING INTRINSIC FAMILY, which is the third beside the narrow set and the wide
'' one. A ustring reaching either of the others is a MISCOMPILE rather than a decline:
'' 'ucase( u )' used to emit fb_StrUcase2( &U$0, 0 ) -- the NARROW entry point handed an
'' FBUSTRING and reading it as a byte string. Verifier clean, "0 statements not
'' lowered", and the answer was whatever the UTF-16 bytes happened to spell. Eight names
'' did it.
''
'' Each entry point takes its descriptor as a (pointer, length) PAIR where the narrow
'' twin takes a bare descriptor -- a ustring may be fixed-length and the length says so.
'' instr and instrrev put their start position differently again:
''
''     fb_UStrInstr   ( start, haystack, hlen, needle, nlen )
''     fb_UStrInstrRev( haystack, hlen, needle, nlen, start )
sub go()
    dim as ustring u = "Hello World", v = "lo"
    dim as ustring r
    dim as long i
    r = ucase( u )  : r = lcase( u )
    r = trim( u )   : r = ltrim( u )    : r = rtrim( u )
    r = mid( u, 2, 3 ) : r = left( u, 3 ) : r = right( u, 3 )
    i = instr( u, v ) : i = instrrev( u, v )
    print r; i
end sub

'' THE NARROW FAMILY BESIDE IT IS UNCHANGED -- the routing is by the first argument's
'' type and nothing else.
sub narrow()
    dim as string s = "Hello World", t = "lo"
    dim as string r
    dim as long i
    r = ucase( s ) : r = trim( s ) : r = mid( s, 2, 3 )
    i = instr( s, t )
    print r; i
end sub

go()
narrow()
