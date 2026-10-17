enum E
    e0
    e1
end enum
type UL
    as long v
    declare operator cast( ) as long
end type
operator UL.cast( ) as long : return 7 : end operator
type UE
    as long v
    declare operator cast( ) as E
end type
operator UE.cast( ) as E : return E.e1 : end operator
type UI
    as long v
    declare operator cast( ) as integer
end type
operator UI.cast( ) as integer : return 9 : end operator

function z1 overload( byval p as zstring ptr ) as long : return 1 : end function
function z1 overload( byval x as long ) as long : return 2 : end function
function e1 overload( byval x as long ) as long : return 1 : end function
function e1 overload( byval x as E ) as long : return 2 : end function
function t1 overload( byval x as long ) as long : return 1 : end function
function t1 overload( byval x as double ) as long : return 2 : end function
sub s1( byval x as long ) : end sub

dim as UL l
dim as UE en1
dim as UI i
'' accepted beside the refusals: one procedure takes the exact cast
s1( l )
'' refused: the exact cast in a set (fbc 99), an enum parameter in a set (99)
print z1( l )
print e1( en1 )
'' refused: two converting overloads at the one bottom score (fbc 98)
print t1( i )
'' refused: an enum cast for a number (fbc 58)
s1( en1 )
