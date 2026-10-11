'' See tests/diagnostics/unbuildable-arg.test.
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

dim as string x = "abc"
dim as B.E y
dim as Q q
dim as double d = 2.5
print FR( x )
print FV( x )
print FR( y )
print FV( y )
print FR( q )
print FR( "lit" )
print GR( q )
print GR( d )
print HR( x )
print HR( q )
