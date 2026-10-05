'' A BYREF NUMBER GIVEN ANOTHER TYPE'S LVALUE, IN AN OVERLOAD SET. Measured on fbc-modern: over
'' r( byref long ) and r( byval double ), an INTEGER and a SHORT variable choose the long one -- the
'' closer type -- and are refused, error 58 (lines 12-13); a long, a constant and a double are fine.
sub r overload ( byref x as long ) : end sub
sub r overload ( byval x as double ) : end sub
dim as long l
dim as double d
dim as integer i
dim as short sh
r( l )
r( 5 )
r( i )
r( sh )
r( d )
