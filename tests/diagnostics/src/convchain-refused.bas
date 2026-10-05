'' A SOURCE'S CAST THAT DOES NOT CONVERT TO THE CONSTRUCTOR'S PARAMETER. Measured on fbc-modern,
'' S casting to STRING and T constructible from a long: lines 20-23 are errors 58, 58, 24 and
'' 181, and 'T( s1 )' and 'T( ww )' on lines 25-26 are 99.
type S
    as long k
    declare operator cast( ) as string
end type
operator S.cast( ) as string : return str( k * 10 ) : end operator
type T
    as double v
    declare constructor( )
    declare constructor( byval x as long )
end type
constructor T( ) : end constructor
constructor T( byval x as long ) : v = x : end constructor
type W : as long k : end type
sub take( byval x as T ) : end sub
sub takeR( byref x as T ) : end sub
dim as S s1 : dim as W ww
take( s1 )
takeR( s1 )
dim as T q = s1
q = s1
dim as T q2 = T( 5 )
dim as T w = T( s1 )
dim as T w2 = T( ww )
