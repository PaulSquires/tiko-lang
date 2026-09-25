'' A PASCAL CALL EVALUATES LEFT TO RIGHT, and a pascal method's receiver FIRST -- the
'' reverse of the order the arguments are passed in, which is fbc's rule for every
'' convention. fbc-modern 1.20 prints G1 G2 G3 for P3's arguments and getT G1 G2 for M's
'' (measured 2026-09-25). tiko went right to left, receiver last, as for cdecl.
type T
    as long v
    declare function M pascal ( byval a as long, byval b as long ) as long
end type
function T.M pascal ( byval a as long, byval b as long ) as long
    return a
end function
declare function G( byval n as long ) as long
declare function getT( ) byref as T
function P3 pascal ( byval a as long, byval b as long, byval c as long ) as long
    return a
end function
dim as long s = P3( G( 1 ), G( 2 ), G( 3 ) )
dim as long r = getT( ).M( G( 1 ), G( 2 ) )
