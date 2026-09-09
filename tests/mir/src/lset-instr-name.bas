'' THREE SPELLINGS THAT WERE BEING DROPPED, each in a different layer.
''
'' 1. 'lset x, y' -- THE COMMA FORM. Measured: fbc emits the SAME call for all three
''    spellings, byte for byte 'fb_StrLset( &X$0, (FBSTRING*)&Y$0 )':
''
''        lset x, y        lset x = y        lset x => y
''
''    The '=' form parses as one N_BINARY and always worked; the arrow was given a
''    case when it turned out to be dropped silently. The COMMA was left out of that
''    fix, so it lost its SOURCE the same way -- the expression stopped at 'x' and
''    ', y' was never parsed. A FIXED-length destination is a different entry point,
''    'fb_StrLsetANA( (void*)FX, taggedLen, tempDesc )', and reaches it through the
''    same node.
''
'' 2. 'instr( start, text, pattern )' -- THE THREE-ARGUMENT FORM had no TYPE. The
''    acceptance test read slot ZERO whatever the form, and a start position is not a
''    string, so the call came out untyped: 'dim as integer n = instr( 1, s, "le" )'
''    is typed by its DESTINATION and lowered, while 'print instr( 1, s, "le" )'
''    declined for want of anything to classify. Where the text sits differs between
''    the two -- slot one for INSTR's three-argument form, slot zero for INSTRREV's.
''
'' 3. 'name( old, new )' AS A VALUE. Measured: '#print typeof( name( "a", "b" ) )' is
''    LONG and fbc emits 'int32 vr = rename( ... )' -- the same call the STATEMENT
''    makes, with its result kept rather than discarded.
dim as string x = "abcdef", y = "12"
dim as string * 10 fx, fy
dim as string s = "hello"

lset x, y
rset x, y

fx = "abcdef" : fy = "12"
lset fx, fy
rset fx, fy

print instr( 1, s, "le" )
print instr( 1, s, any "le" )
print instr( s, any "le" )
print instrrev( s, "l", 3 )

print name( "zzmissing1.tmp", "zzmissing2.tmp" )
