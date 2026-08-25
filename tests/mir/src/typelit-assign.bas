type FVec3
    as single x, y, z
end type
type C
    as integer i
    declare constructor( )
end type
constructor C( )
    this.i = 123
end constructor
dim as FVec3 a3
a3 = type( 1.5f, 0.75f, 2.25f )
print a3.x, a3.y, a3.z
dim x as C
x = type<C>( )
print x.i
