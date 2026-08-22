'' SIZEOF IS NOT LEN.
''
'' It is ALWAYS the type's size and never a runtime call. Measured: 'sizeof( s )' over a
'' var-length string is 24 -- the descriptor -- and 'sizeof( z )' over a 'zstring * 8' is
'' 8, where 'len' of either is fb_StrLen over the TEXT. Sharing one function with 'len'
'' is right, because everything after the string branches is identical; sharing the
'' string branches would have made sizeof measure the text.
''
'' It was TYPED and never LOWERED, so every sizeof declined -- silently, inside a DIM
'' initialiser, including 'callocate( sizeof( long ) * 3 )', which is how the corpus
'' writes an allocation.
''
'' The expected constants, in order: 4 24 8 16 16 8 8, then the two fb_StrLen calls, then
'' 16 for len over a UDT. Every one of them is what fbc's own C says.

type T
    a as long
    b as double
end type
sub P( )
    dim as string s
    dim as zstring * 8 z
    dim as T t
    dim as long n
    n = sizeof( long ) : n = sizeof( s ) : n = sizeof( z ) : n = sizeof( t )
    n = sizeof( T ) : n = sizeof( integer ) : n = sizeof( any ptr )
    n = len( s ) : n = len( z ) : n = len( t )
end sub
