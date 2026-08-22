'' A GENERIC PROCEDURE IS NOT CODE.
''
'' 'function Ok( of T, E )( ... )' has type parameters the parser still DISCARDS, so
'' nothing downstream could tell it from an ordinary procedure -- and its body lowered
'' with every 'as T' standing for nothing: aggregates of SIZE ZERO, stores into void
'' slots, and a whole function emitted under a name no call site will ever use. It
'' counted as fully lowered while it did that.
''
'' ~200,000 instructions of the corpus were exactly this. Declining says what is true.
''
'' NOTE ON THE COUNT: a whole procedure now declines as ONE statement where its body
'' used to decline several. The decline number therefore UNDER-states what is owed here
'' -- the instantiation of generic procedures is still entirely missing, and one number
'' per procedure is all that says so.

type Box( of T )
    v as T
end type

function MakeBox( of T )( byval x as T ) as Box( of T )
    dim as Box( of T ) b
    b.v = x
    return b
end function

sub P( )
    '' The call site is not instantiated either, so it declines as well. The point of
    '' this test is what is NOT in the output: no 'func' for MAKEBOX at all.
    dim as long n = 1
end sub
