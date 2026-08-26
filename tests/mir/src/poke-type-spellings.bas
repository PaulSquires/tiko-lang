'' POKE'S TYPE ARGUMENT HAS THREE SPELLINGS, and only the first was handled -- while the
'' identical PEEK beside it handled all three. quirk/peek-poke.bas writes each spelling
'' on both sides, which is what made the asymmetry visible at all.
''
''   poke ubyte, p, 5                 a TYPE KEYWORD, which parses as a NAME
''   poke typeof( b ), p, 5           a TYPEOF, which in an argument list arrives as a
''                                    CALL, so the type is on its OPERAND
''   type t as ubyte : poke t, p, 5   a NAMED TYPE -- and it may be SHADOWED by a
''                                    variable of the same spelling, where only the
''                                    POSITION says which one is meant
''
'' The resolution is one helper now, used by both, which is where it should have been:
'' PEEK grew the second and third spellings on its own and POKE was left with the first.
dim as ubyte b
dim as ubyte ptr pb = @b

#macro check( pokeargs... )
    b = 0
    poke pokeargs, 123
    print b
#endmacro

check( @b )
check( pb )
check( ubyte, pb )
check( typeof( b ), pb )

'' ...and a named type, including one a variable shadows
type pb2 as ubyte
check( pb2, @b )

print peek( typeof( b ), pb ), peek( pb2, pb )
