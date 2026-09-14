'' FORWARDING AN ARRAY PARAMETER -- 'sub f( a( ) as T ) : g( a( ) )'. fbc accepts it, and
'' it is how every recursive sort is written; tiko-lang refused it with TKO0641 because
'' the whole-array spelling was recognised over a VARIABLE only. Measured, fbc-modern:
''
''     sub fwd( a( ) as P1 ) : takeP1( a( ) )       OK
''     sub fwd( a( ) as integer ) : takeI( a( ) )   OK
''     sub fwd( a( ) as P1 ) : takeP2( a( ) )       error 58, at parameter 1
''     sub fwd( a( ) as integer ) : takeD( a( ) )   error 58, at parameter 1
''
'' The element rule holds through a parameter exactly as through a variable.
type P1
    as long v
end type
type P2
    as long v
end type

declare sub takeP1( a( ) as P1 )
declare sub takeP2( a( ) as P2 )
declare sub takeI( a( ) as integer )
declare sub takeD( a( ) as double )

'' -- accepted -----------------------------------------------------------------
sub fwdP1( a( ) as P1 )
    takeP1( a( ) )
end sub

sub fwdI( a( ) as integer )
    takeI( a( ) )
    fwdI( a( ) )
end sub

'' -- refused ------------------------------------------------------------------
sub badP( a( ) as P1 )
    takeP2( a( ) )
end sub

sub badD( a( ) as integer )
    takeD( a( ) )
end sub
