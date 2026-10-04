function Show(of T)( byval x as T ) as integer
    return sizeof( T )
end function
print Show( 1.5f )
print Show( true )
print Show( 1.5 )
print Show( 7 )
type Node(of T)
    as T v
    as Node(of T) ptr nxt
end type
function Val0(of T)( byval n as Node(of T) ptr ) as T
    return n->v
end function
dim as Node(of long) a
a.v = 42
print Val0( @a )
