'' A generic named without its type arguments (fbc's 335) or with the wrong number (336),
'' on lines 21 to 32 (fbc-modern 1.20); lines 34 and 35 are accepted.
type Box( of T )
    v as T
end type
type Pair( of K, V )
    k as K
    v as V
end type
function Mk( of T )( byval x as T ) as T
    return x
end function
type U
    f as Box( of long )
end type
sub S( byval b as Box( of long ) )
end sub
dim as long n
dim as any ptr q

dim b1 as Box
dim p1 as Pair( of long )
dim b2 as Box( of long, long )
dim b3 as Box ptr
type A as Box
type Bad extends Box
    z as long
end type
n = sizeof( Box )
q = new Box
n = Mk( of long, long )( 1 )
dim b4 as Box( of Box )

dim b5 as Box( of long )
dim p2 as Pair( of long, string ) ptr
