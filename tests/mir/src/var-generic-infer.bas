'' INFERRING A TYPE ARGUMENT FROM A 'VAR'.
''
'' A var has no type until Check, and type arguments are inferred before it, so
'' 'var c0 = b : print First( c0 )' inferred nothing -- and the whole PRINT was dropped
'' with no diagnostic: fbc prints 4, tiko printed nothing and exited 0. Inside a call
'' statement the same miss called the template instead, which is how every 'select
'' channel' failed to link (tests/driver/src/select-channel-link.bas).
''
'' The var's type is its initialiser's, asked the same question -- including a METHOD
'' call's result, and a method inherited through 'extends'.

type Box( of T )
	as T v
end type

function First( of T )( byref b as Box( of T ) ) as long
	return sizeof( T )
end function

type Holder
	as Box( of short ) bs
	declare function Get( ) as Box( of short )
end type
function Holder.Get( ) as Box( of short )
	return bs
end function

type Parent
	as Box( of double ) bd
	declare function Get2( ) as Box( of double )
end type
function Parent.Get2( ) as Box( of double )
	return bd
end function
type Derived extends Parent
	as long extra
end type

dim as Box( of long ) b
var c0 = b
print First( c0 )

dim as Holder h
var c1 = h.Get( )
print First( c1 )

dim as Derived d
var c2 = d.Get2( )
print First( c2 )
