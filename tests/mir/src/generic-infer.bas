'' A FREE GENERIC PROCEDURE exists so its type parameter comes off the ARGUMENT:
'' fb/optional.bi writes 'Some( r )', never 'Some( of long )( r )'. Nothing inferred
'' the type arguments, so every one of those calls declined -- 88 statements in every
'' file that includes fb/optional.bi or fb/mathint.bi.
''
'' THE RULE IS POSITIONAL AND SHALLOW: a type parameter is inferred from a procedure
'' parameter declared as THAT NAME AND NOTHING ELSE. Unifying through 'T ptr' or
'' 'Box( of T )' is a different feature, and guessing at it would instantiate at the
'' wrong type with nothing to say so.
type Box( of T )
    as T v
end type

function Wrap( of T )( byval x as T ) as Box( of T )
    dim as Box( of T ) r
    r.v = x
    return r
end function

'' A NAME, a PARAMETER, a LITERAL and a CAST are the four argument shapes that carry
'' enough type to infer from without asking Check -- which has not run yet.
dim as long n = 7
dim as Box( of long ) a = Wrap( n )
dim as Box( of integer ) b = Wrap( 3 )
dim as Box( of ubyte ) c = Wrap( cast( ubyte, n ) )

sub P( byval q as double )
    dim as Box( of double ) d = Wrap( q )
end sub

'' Written out still works, and reaches the SAME instantiation as the inferred call --
'' the cache is keyed on the argument types, not on how they were spelled.
dim as Box( of long ) e = Wrap( of long )( n )
