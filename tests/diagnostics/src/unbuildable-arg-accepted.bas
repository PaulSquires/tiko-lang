'' See tests/diagnostics/unbuildable-arg-accepted.test.
namespace A
    type E
        as long c
        declare constructor( )
        declare constructor( byval k as long )
    end type
    constructor E( ) : end constructor
    constructor E( byval k as long ) : c = k : end constructor
end namespace
namespace B
    type E
        as long c
        declare constructor( )
        declare constructor( byval k as long )
    end type
    constructor E( ) : end constructor
    constructor E( byval k as long ) : c = k : end constructor
end namespace
type S
    as long c
    declare constructor( byref t as string )
end type
constructor S( byref t as string ) : c = len( t ) : end constructor
type L
    as long c
    declare constructor( byval k as long )
    declare operator let( byref t as string )
end type
constructor L( byval k as long ) : c = k : end constructor
operator L.let( byref t as string ) : c = len( t ) : end operator
type Q
    as long c
end type

function FR( byref v as A.E ) as long : return v.c : end function
function FV( byval v as A.E ) as long : return v.c : end function
function GR( byref v as S ) as long : return v.c : end function
function HR( byref v as L ) as long : return v.c : end function

type QS
    as long c
    declare operator cast( ) as string
end type
operator QS.cast( ) as string : return "four" : end operator

dim as string x = "abc"
dim as long n = 7
dim as double d = 2.5
dim as A.E e = A.E( 9 )
dim as QS w
print FR( n ); FV( n ); FR( 5 ); FR( d ); FV( d ); FR( e ); FV( e )
print GR( x ); GR( "lit!" ); GR( w )
print HR( n ); HR( d )
