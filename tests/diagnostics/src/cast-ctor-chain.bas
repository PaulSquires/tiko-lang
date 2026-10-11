'' See tests/diagnostics/cast-ctor-chain.test.
type E
    as long c
    declare constructor( )
    declare constructor( byval k as long )
end type
constructor E( ) : end constructor
constructor E( byval k as long ) : c = k : end constructor
type P
    as long c
    declare constructor( )
    declare constructor( byval p as any ptr )
end type
constructor P( ) : end constructor
constructor P( byval p as any ptr ) : c = 1 : end constructor
type QL
    as long c
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator QL.cast( ) as long : return 5 : end operator
operator QL.cast( ) as double : return 5 : end operator
type QA
    as long c
    declare operator cast( ) as long ptr
end type
operator QA.cast( ) as long ptr : return 0 : end operator
operator <> ( byref a as E, byref b as E ) as boolean : return a.c <> b.c : end operator
function FR( byref v as E ) as long : return v.c : end function
function FV( byval v as E ) as long : return v.c : end function
function FP( byref v as P ) as long : return v.c : end function

dim as QL x
dim as QA y
dim as E e0
print FR( x )
print FV( x )
print e0 <> x
dim as E e1 = x
print FR( E( x ) )
print FP( y )
function G( ) as E
    dim as QL z
    return z
end function
