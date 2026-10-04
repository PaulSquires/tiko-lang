'' A shared or static UDT whose initialiser mixes addresses with data: a byte image with
'' a relocation at each pointer's offset.
type PL
    p as long ptr
    n as long
end type
type PP
    a as zstring ptr
    b as zstring ptr
end type
type Mixed
    n as short
    p as any ptr
    d as double
end type

dim shared as long ga = 11, gb = 22
dim shared as PL pl1 = ( @ga, 5 )
dim shared as zstring ptr names(0 to 2) = { @"alpha", @"beta", @"gamma" }
dim shared as PP pp1 = ( @"x1", @"y1" )
dim shared as Mixed mx = ( 7, @gb, 2.5 )
dim shared as PL arr(0 to 1) = { ( @ga, 1 ), ( @gb, 2 ) }
static shared as long ptr pg = @gb

print *pl1.p; pl1.n
print *names(0); " "; *names(1); " "; *names(2)
print *pp1.a; " "; *pp1.b
print mx.n; *cast( long ptr, mx.p ); mx.d
print *arr(0).p; arr(0).n; *arr(1).p; arr(1).n
print *pg
type CB
    tag as long
    fn as function( byval as long ) as long
    k as short
end type
function twice( byval v as long ) as long
    return v * 2
end function
dim shared as CB cb1 = ( 3, @twice, 9 )
print cb1.tag; cb1.fn( 21 ); cb1.k
sub useStatic( )
    static as PL sp = ( @gb, 4 )
    print *sp.p; sp.n
end sub
useStatic( )
