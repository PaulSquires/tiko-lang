'' A UDT ARGUMENT OF AN UNRELATED UDT TYPE is fbc's error 58, byval and byref alike, on lines
'' 34 to 38 (fbc-modern 1.20). tiko passed B's bytes as an A. Lines 40 to 45 are accepted: the
'' same type, a derived one, one with an 'operator cast', and a constructor that takes it.
type A
    x as long
end type
type B
    y as long
end type
type D extends A
    z as long
end type
type C
    x as long
    declare operator cast( ) as A
end type
operator C.cast( ) as A : return type<A>( 7 ) : end operator
type E
    x as long
    declare constructor( byref b as B )
end type
constructor E( byref b as B ) : x = b.y : end constructor
sub T1( byval p as A ) : end sub
sub T2( byref p as A ) : end sub
sub T4( p as A ) : end sub
sub T6( byval p as E ) : end sub
function F1( byval p as A ) as long : return p.x : end function
dim as A va
dim as B vb
dim as D vd
dim as C vc
dim as long n

T1( vb )
T2( vb )
T4( vb )
n = F1( vb )
T1( type<B>( 9 ) )

T1( va )
T1( vd )
T2( vd )
T1( vc )
T2( vc )
T6( vb )
