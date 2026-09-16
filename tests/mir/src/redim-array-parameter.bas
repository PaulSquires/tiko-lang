'' A REDIM OVER AN ARRAY PARAMETER REDIMS THE PARAMETER. AfxGlut.inc's
'' AfxGlutCircleTable writes 'sub AfxGlutCircleTable( sint( ) as double, cost( ) as
'' double, byval n as long )' and then 'redim sint( nSize ) as double' in its body.
'' Declaring a local instead made every assignment land on something that died at END
'' SUB -- the same silent shape as the FIELD case before it.
sub fill( arr( ) as double, byval n as long )
    redim arr( n ) as double
    arr( 0 ) = 1.5
end sub

dim as double a( 0 to 0 )
fill( a( ), 3 )
print a( 0 )
