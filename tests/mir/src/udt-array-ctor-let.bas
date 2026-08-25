type T
    myarray(any) as integer
    declare constructor( array( ) as integer )
    declare operator let( array( ) as integer )
    declare constructor( )
end type
constructor T( )
end constructor
constructor T( array( ) as integer )
    redim myarray( lbound( array ) to ubound( array ) )
end constructor
operator T.let( array( ) as integer )
    redim myarray( lbound( array ) to ubound( array ) )
end operator
dim a( 0 to 9 ) as integer
dim x as T = a( )
dim z as T
z = a( )
