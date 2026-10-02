type F2
    v as double
    declare operator cast( ) as double
    declare operator cast( ) as longint
end type
operator F2.cast( ) as double
    return v
end operator
operator F2.cast( ) as longint
    return clngint( v )
end operator
type F1
    v as double
    declare operator cast( ) as double
end type
operator F1.cast( ) as double
    return v
end operator
sub Take overload( byval x as double )
end sub
sub Take overload( byval x as longint )
end sub
sub Take2 overload( byval x as double, byval n as long )
end sub
sub Take2 overload( byval x as longint, byval n as long )
end sub
sub TakeD( byval x as double )
end sub
dim as F2 a = ( 2.5 )
dim as F1 b = ( 3.5 )
Take( a )
Take2( a, 1 )
Take( b )
TakeD( a )
Take( 2.5 )
