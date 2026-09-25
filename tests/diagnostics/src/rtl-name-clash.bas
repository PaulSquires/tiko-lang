'' Declarations named like a runtime procedure fbc predeclares -- its error 4,
'' "Duplicated definition", on lines 11 to 18 (fbc-modern 1.20). Lines 20 to 37 are
'' accepted: a method's parameter and local, a namespace, a new overload of an
'' overloadable runtime procedure, a field, an enum member, a prototype's parameter.
type T
    as long run
    declare sub m( )
    declare sub p( byval kill as long )
end type

sub Run( )
end sub
declare sub Chain( )
dim as long timer
const beep = 1
for settime as long = 1 to 2 : next
sub f( byval shell as long )
    dim as long stop
end sub
sub T.p( byval kill as long )
end sub

namespace N
    dim shared as long run
    sub g( )
        dim as long timer
    end sub
end namespace
sub T.m( )
    dim as long run
end sub
sub Hex( )
end sub
enum E
    system
end enum
declare function h( byval reset as long ) as long
