'' Four STRING INITIALISER gaps that shared nothing but their size.
''
'' A WIDE TERM IN A USTRING DESTINATION IS A USTRING TERM. 'dim as ustring u = "caf" &
'' wchr( &hE9 )' has no ustring-TYPED term at all -- a narrow literal and a wide call --
'' so the chain was refused, and the narrow fallback then pushed the wide term at narrow
'' width and failed too. Fourteen corpus statements, every one in a DECLARATION, which is
'' what made it look like an initialiser gap rather than a chain one.
''
'' ADJACENT LITERALS ARE ONE STRING. '"a" "1"' is a single literal in FreeBASIC, folded
'' before it reaches any call -- measured, fbc emits 'fb_StrAssign( B$0, 5ll, "a1", 3ll,
'' 0 )'. Only the CONCATENATION path knew that, so a fixed-length initialiser, an
'' assignment and a PRINT all declined while 'dim as string c = "a" "1"' beside them
'' worked.
''
'' A 'wstring * N' ARRAY belongs with the other three fixed-string flavours. It was
'' omitted from the test, so it fell through to the aggregate path, was not a UDT, and
'' declined -- while the narrow twin one line away lowered. And a MULTI-DIMENSIONAL one
'' is written in rows over one flat run in row-major order, the same rule the scalar path
'' follows; this walked only the top-level children, so every row arrived as a nested
'' initialiser the element assignment had nothing to make of.
''
'' AND THE ELEMENTS THE INITIALISER DID NOT NAME ARE ZEROED. A fixed-length string is raw
'' storage, not a descriptor, so an unwritten one held whatever the frame held. Measured:
'' fbc emits an explicit memset over the rest, per row and for the whole tail. A STATIC
'' one is a byte image instead, and 'string * N' fills with SPACES where the other two
'' fill with NUL -- it has no terminator, so its N bytes ARE its value.
'' AND 'lcase( s, 1 )' / 'ucase( s, 1 )' FOLD -- with the MODE argument and only when it
'' is 1. Measured, by asking fbc to accept each as a constant initialiser: the two-
'' argument form with mode 1 is a constant, and the one-argument form and mode 0 are
'' both fbc error 11. Mode 1 is the locale-independent one, which is the only one whose
'' answer is knowable at compile time. A blanket 'exactly one argument' guard at the top
'' of the fold had excluded every two-argument form outright.
const CZ1 = lcase( "XYZ123", 1 )
const CZ2 = ucase( "xyz123", 1 )

sub s1( )
    dim as ustring u = "caf" & wchr( &hE9 )
    print u

    dim as zstring * 5 b = "a" "1"
    dim as string c = "a" "1"
    dim as wstring * 5 w = wstr( "a" "1" )
    dim as zstring * 5 d
    d = "a" "1"
    print b, c, w, d
    print "a" "1"

    dim z1( 0 to 2 ) as zstring * 10 => { "abc", "def" }
    dim z2( 0 to 1, 0 to 1 ) as zstring * 10 => { {"abc","def"}, {"ghi","jkl"} }
    dim w1( 0 to 2 ) as wstring * 6 => { "123", "456" }
    print z1(0), z1(2), z2(1,0), w1(0)

    static s1z( 0 to 1 ) as zstring * 4 => { "ab", "cd" }
    static s1f( 0 to 1 ) as string * 5 => { "xx", "yy" }
    static s1w( 0 to 1 ) as wstring * 6 => { "123", "456" }
    print s1z(1), s1f(0), s1w(1)

    print CZ1, CZ2, lcase( CZ2, 1 )
end sub

s1( )
