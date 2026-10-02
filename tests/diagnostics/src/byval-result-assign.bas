function P0( ) as long
    return 1
end function
function P2( byval i as long, byval j as long ) as long
    return i + j
end function
type T
    v as long
    declare function Get2( byval i as long, byval j as long ) as long
end type
function T.Get2( byval i as long, byval j as long ) as long
    return v
end function
dim as T a
P0( ) = 42
P2( 0, 1 ) = 42
a.Get2( 1, 2 ) = 5
P2( 0, 1 = 42 )
