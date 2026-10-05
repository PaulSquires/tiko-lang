type S
    as long k
    declare operator cast( ) as double
end type
operator S.cast( ) as double : print "[c]"; : return k * 10 + 0.5 : end operator
type T
    as double v
    declare constructor( )
    declare constructor( byval x as long )
end type
constructor T( ) : end constructor
constructor T( byval x as long ) : v = x : print "[k]"; : end constructor
sub take( byval x as T ) : print " t"; x.v; : end sub
dim as S s1 : s1.k = 3
dim as T w = T( s1 ) : print w.v;
dim as T q = s1 : print q.v;
take( s1 ) : print
