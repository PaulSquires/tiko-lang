'' A return's value is judged as an assignment's: each of these is fbc's 181, or 17 in a sub.
type U : a as integer : end type
type C : a as integer : declare operator cast( ) as integer : end type
operator C.cast( ) as integer : return a : end operator
function f1( ) as integer
    dim u as U
    return u
end function
function f2( ) as U
    return 5
end function
function f3( ) as integer ptr
    return 1.5
end function
function f4( ) as double
    dim p as integer ptr
    return p
end function
sub s1( )
    return 5
end sub
'' ...and what fbc takes.
function g1( ) as double
    return 5
end function
function g2( ) as integer
    g2 = 3.7
end function
function g3( ) as zstring ptr
    return @"abc"
end function
sub s2( )
    return
end sub
