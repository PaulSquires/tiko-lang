type S
    as long k
    declare operator cast( ) as long
    declare operator cast( ) as string
end type
operator S.cast( ) as long : print "[cL]"; : return k : end operator
operator S.cast( ) as string : print "[cS]"; : return str( k * 10 ) : end operator
type T
    as double v
    declare constructor( )
    declare constructor( byval n as long )
    declare constructor( byref s as string )
end type
constructor T( ) : v = 0 : end constructor
constructor T( byval n as long ) : v = n : print "[L]"; : end constructor
constructor T( byref s as string ) : v = val( s ) : print "[S]"; : end constructor
operator + ( byref a as T, byref b as T ) as T
    return T( a.v + b.v )
end operator
sub take( byval x as T ) : print " take"; x.v : end sub
sub takeR( byref x as T ) : print " takeR"; x.v : end sub
dim as S s1 : s1.k = 3
dim as T t1 = 1
print
take( s1 )
takeR( s1 )
dim as T r = t1 + s1 : print " r"; r.v
dim as T q = s1 : print " q"; q.v
dim as T w = T( s1 ) : print " w"; w.v
