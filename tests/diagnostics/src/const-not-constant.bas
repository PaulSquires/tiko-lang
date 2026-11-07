'' A NUMERIC CONSTANT THAT READS A VARIABLE OR CALLS A PROCEDURE -- fbc's error 11, "Expected
'' constant", on each refused line. The folded forms below them are fine.
function f( byval n as integer ) as integer
    return n * 2
end function
declare function ext( byval n as integer ) as integer
type U
    as integer a, b
end type
dim shared g as integer = 3
dim shared uu as U
dim shared arr( 0 to 3 ) as integer
const KA = f( 4 )                                   '' 11: the program's own function
const KB = ext( 4 ) + 1                             '' 11: a declared one
const KC = 1 + g * 2                                '' 11: a variable
const KD = ( -g )                                   '' 11
const KE = @g                                       '' 11
const KF = uu.a                                     '' 11: a variable's field
const KG = cast( integer, g )                       '' 11
const KH = abs( g )                                 '' 11: a builtin over a variable
const KI = iif( g, 2, 3 )                           '' 11
const KJ = arr( 1 )                                 '' 11: an array element
sub P( byval n as integer )
    const KK = n + 1                                '' 11: a parameter
end sub
namespace NS
    const NK = 5
end namespace
enum E1
    EA = 2
end enum
const L = sizeof( g ) + len( g ) + offsetof( U, b ) + abs( -3 ) + sqr( 16 ) + cint( 2.5 )
const M = cast( integer, 2.5 ) + asc( "A" ) + iif( 1, 2, 3 ) + 2 ^ 3 + EA + NS.NK + L
type T
    as long z( 0 to M )
end type
print L, M, sizeof( T )
