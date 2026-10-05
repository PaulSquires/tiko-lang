type S
    as long k
    declare operator cast( ) as string
end type
operator S.cast( ) as string : print "[c]"; : return str( k * 10 ) : end operator
type T
    as double v
    declare constructor( )
    declare constructor( byref x as string )
end type
constructor T( ) : end constructor
constructor T( byref x as string ) : v = val( str( x ) ) : print "[k]"; : end constructor
sub take( byval x as T ) : print " take"; x.v : end sub
sub takeR( byref x as T ) : print " takeR"; x.v : end sub
dim as S s1 : s1.k = 3
take( s1 )
takeR( s1 )
dim as T q = s1 : print " q"; q.v
