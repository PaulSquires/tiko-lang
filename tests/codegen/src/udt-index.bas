type M2
    as long q
    declare operator cast( ) as long
end type
operator M2.cast( ) as long : return 3 : end operator
dim shared as M2 m
dim as long ar2( 5 ) : ar2( 3 ) = 7
print ar2( m )
ar2( m ) = 9 : print ar2( 3 )
