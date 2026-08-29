'' 'typeof( type<T>( ... ) )' -- TYPEOF OVER AN ANONYMOUS TYPE LITERAL.
''
'' A type literal NAMES ITS OWN TYPE, in the list's TARGET, so this needs no expression
'' typing at all. The typeof resolver handled a TYPEREF operand and a bare NAME and
'' nothing else, so the literal fell to the expression walk, stayed unresolved, and the
'' declaration around it declined. structs/anon-intrinsic.bas writes it nested twice.
''
'' The nesting resolves itself: the inner literal's target is a TYPEREF, which may
'' itself be a 'typeof', and that is the function being written.
dim as integer i1 = type<integer>( 3 )
dim as integer i2 = type<typeof( i1 )>( 3 )
dim as integer i3 = type<typeof( type<integer>( 1.5 ) )>( 3 )
dim as integer i4 = type<typeof( type<typeof( i4 )>( 1.5 ) )>( 3 )
print i1, i2, i3, i4

'' ...and over a UDT, where the literal's target names a declared type.
type P
    x as integer
    y as integer
end type
dim p1 as P = type<P>( 1, 2 )
dim p2 as typeof( type<P>( 3, 4 ) ) = type<P>( 5, 6 )
print p1.x, p1.y, p2.x, p2.y
