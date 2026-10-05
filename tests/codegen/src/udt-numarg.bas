type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : print "[c]"; : return q : end operator
dim as M1 a : a.q = 3
print space( a ) & "|"
print string( a, "x" )
print string( 2, a + 62 )
print left( "abcde", a ); "|"; right( "abcde", a ); "|"; mid( "abcde", a ); "|"; mid( "abcde", 1, a )
print ucase( "abc", a )
dim as string s = space( a ) : print len( s )
