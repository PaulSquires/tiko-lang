'' A FIELD DECLARATION ENDS ITS LINE.
''
'' Measured against fbc-modern 1.20.0, 2026-09-19. Bounds belong to the NAME, not to the
'' type, in both field spellings:
''
''     b as ubyte( 0 to 3 )        error 3,  Expected End-of-Line, found '('
''     b as ubyte junk             error 3,  Expected End-of-Line, found 'junk'
''     as long a junk              error 3,  Expected End-of-Line, found 'junk'
''     as ubyte( 0 to 3 ) b        error 14, Expected identifier, found '('
''
'' EndOfStatement discards whatever it walks past, so all four COMPILED: the first as a
'' scalar ubyte with its bounds thrown away, the last with the field missing altogether
'' and the type a field short. Nothing was said at the declaration and nothing at the
'' use -- 'h.b(0)' over the scalar lowered no load and no store -- so a program fbc
'' refuses to build ran and printed an empty column.
''
'' ONE PER TYPE, not one per field: p.silent is cleared per STATEMENT and a TYPE body's
'' members are parsed inside one, so the first bad field in a body speaks for it.

type A
    b as ubyte( 0 to 3 )
    n as long
end type

type B
    b as ubyte junk
    n as long
end type

type C
    as long a junk
    as long n
end type

type D
    as ubyte( 0 to 3 ) b
    as long n
end type

'' -- ACCEPTED, and every one of these is why the check is not simply "no '(' after a
'' field's type": the bounds before the 'as', a fixed-length string, a procedure
'' pointer's parameter list, a field default, a bitfield width, and the comma list.
type Ok
    b( 0 to 3 ) as ubyte
    z as zstring * 8
    pf as sub( byval x as long )
    n as long = 5
    w : 3 as ulong
    as long p, q
end type

sub P( )
    dim as Ok o
    o.b(0) = 1
    o.n = 2
    o.p = 3
end sub
