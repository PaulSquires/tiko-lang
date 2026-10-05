type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : print "[l]"; : return q : end operator
type M2
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator M2.cast( ) as long : print "[l2]"; : return q : end operator
operator M2.cast( ) as double : print "[d2]"; : return q + 0.25 : end operator
dim as M1 a : a.q = 3
dim as M2 b : b.q = 4
print asc( "abcd", a )
dim as string q = "abcdef" : mid( q, a, 1 ) = "Z" : print q
redim as long dyn( 1 to a ) : print lbound( dyn ); ubound( dyn )
print using "##"; a
print using "##.##"; b
