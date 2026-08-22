'' INSTANTIATING A GENERIC PROCEDURE.
''
'' 'function Ok( of T, E )( ... )' had its type parameters DISCARDED by the parser, so
'' nothing downstream could tell it from an ordinary procedure -- and its body lowered
'' with every 'as T' standing for nothing: aggregates of SIZE ZERO, stores into void
'' slots, and a whole function emitted under a name no call site would ever use, all of
'' it counting as fully lowered. Two hundred thousand instructions of the corpus were
'' that.
''
'' NO INFERENCE IS NEEDED. Every call site writes the arguments out --
'' 'Ok( of Decimal, FinanceError )( v )' is how every runtime header spells it -- so the
'' instantiation's whole input is on the call, and the parser now keeps it.
''
'' What to read below: MK appears ONCE, as MK<n>, with a concrete parameter type and a
'' concrete aggregate return -- and the TEMPLATE itself appears not at all, which is
'' also what fbc emits.
''
'' The template is NOT counted as a decline. Not emitting it is the RIGHT answer, not a
'' gap: a template nobody instantiates needs no instantiation, and one that is
'' instantiated shows up as the instantiation. A MISSING instantiation looks like a CALL
'' that bound to nothing, and that is counted where it happens.

type Box( of T )
    v as T
end type

function Mk( of T )( byval x as T ) as Box( of T )
    dim as Box( of T ) b
    b.v = x
    return b
end function

sub P( )
    dim as Box( of long ) a = Mk( of long )( 7 )
    dim as Box( of double ) d = Mk( of double )( 2.5 )
    '' THE SAME INSTANTIATION TWICE must reach ONE function, or the module would carry
    '' two definitions under one mangled name.
    dim as Box( of long ) a2 = Mk( of long )( 9 )
end sub
