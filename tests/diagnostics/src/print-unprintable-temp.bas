type Box
    v as long
    declare constructor( )
    declare constructor( byval n as long )
end type
constructor Box( )
end constructor
constructor Box( byval n as long )
    v = n
end constructor
type Plain
    a as long
end type
type Outer
    inner as Plain
end type
dim as Box b = Box( 1 )
dim as Box bs(0 to 2)
dim as Box ptr pb = @b
dim as Outer o
dim as Plain pl
function MakeBox( ) as Box
    return Box( 3 )
end function
dim as zstring * 8 zs(0 to 1)
dim as long nums(0 to 1)
print "X["; Box( 7 ); "]Y"
print "T"; type<Plain>( 5 ); "U"
print "P"; *pb; "Q"
print "E"; bs(1); "F"
print "M"; o.inner; "N"
print "I"; iif( 1, pl, pl ); "J"
print "A"; MakeBox( ); "B"
print "S"; zs(0); nums(1); iif( 1, 2, 3 ); "Z"
