type RS
    nm as string
    v as double
end type
type RU
    nm as ustring
    v as double
end type
type RN
    a as long
    b as double
end type
type RZ
    z as zstring * 8
    v as double
end type
type RW
    inner as RS
    k as long
end type
type TC
    nm as string
    declare constructor( )
    declare constructor( byref s as string, byval w as double )
end type
constructor TC( )
end constructor
constructor TC( byref s as string, byval w as double )
    nm = s
end constructor
sub TakeRU( byval r as RU )
end sub
function MakeRS( ) as RS
    return type( "b", 2.0 )
end function
dim as RS rs
dim as RU ru
dim as RN rn
dim as RZ rz
dim as RW rw
dim as TC vtc
dim as RS ars(0 to 1)
rs = type( "south", 1.0 )
ru = type( "south", 1.0 )
dim as RU ru2 = type( "south", 1.0 )
ars(1) = type( "x", 2.0 )
rw = type( rs, 3 )
rw.inner = type( "a", 1.0 )
rs = type<RS>( "south", 1.0 )
TakeRU( type( "a", 1.0 ) )
rn = type( 1, 2.0 )
rz = type( "ab", 2.0 )
rs = type( )
vtc = type( "c", 1.5 )
