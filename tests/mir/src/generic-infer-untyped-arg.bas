'' A GENERIC OVERLOAD MUST NOT BE BOUND ON AN ARGUMENT IT COULD NOT TYPE. fb/string.bi includes
'' fb/array.bi, whose 'Contains( of T )( byref a as Array( of T ), byref v as T )' heads the
'' FB.Contains chain. Inference skipped the first parameter when its argument was a METHOD
'' call (which it does not type), took T from the literal, and bound 'contains<15>' -- so the
'' concrete ustring overloads were never scored and fbsqlite's tests stopped at TKO0632.
''
'' fbc prints: true false true false false
#include once "fb/string.bi"
type Cell
	as ustring t
	declare function AsText( ) as ustring
end type
function Cell.AsText( ) as ustring
	return t
end function
type Holder
	as Cell c
	declare function Value( ) as Cell
end type
function Holder.Value( ) as Cell
	return c
end function
dim as string s = "a second line"
print FB.Contains( s, "second line" )
print FB.Contains( s, chr( 10 ) )
dim as Holder h
h.c.t = "x second line"
print FB.Contains( h.Value( ).AsText( ), "second line" )
print FB.Contains( h.Value( ).AsText( ), chr( 10 ) )
print FB.Contains( h.c.AsText( ), "Инженеринг" )
