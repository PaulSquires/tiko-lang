'' LBOUND and UBOUND over a FIXED array fold to constants, and 'type<T>( )' with no
'' arguments is the default constructor on a temporary.
type C
    as integer i
    declare constructor( )
end type

constructor C( )
    this.i = 123
end constructor

dim b_( 2 to 9, 0 to 3 ) as long
dim shared s_( 0 to 7 ) as long
print lbound( b_ ), ubound( b_ ), lbound( b_, 2 ), ubound( b_, 2 )
print ubound( s_ ) - lbound( s_ ) + 1

dim as integer a
dim x as C
a = (type<C>( )).i
x = type<C>( )
print a, x.i
