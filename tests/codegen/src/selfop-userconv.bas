'' A COMPOUND-ASSIGNMENT OPERATOR WHOSE ONLY OVERLOAD TAKES THE UDT ITSELF, given an
'' integer: the integer reaches it through the converting constructor, as a temporary --
'' byref and byval alike. tiko found no candidate ('n += 123' over tkl's CInt96, whose
'' '+=' takes 'byref as CInt96') and the statement was not compiled (TKO0994).
'' Measured with fbc: 14, then 28.
type T
    as longint v
    declare constructor( )
    declare constructor( byval n as longint )
    declare operator += ( byref o as T )
    declare operator -= ( byref o as T )
    declare operator *= ( byval o as T )
end type
constructor T( ) : v = 0 : end constructor
constructor T( byval n as longint ) : v = n : end constructor
operator T.+= ( byref o as T ) : v += o.v : end operator
operator T.-= ( byref o as T ) : v -= o.v : end operator
operator T.*= ( byval o as T ) : v *= o.v : end operator
dim as T a = 5
a += 3
a -= 1
a += a
print a.v
a *= 2
print a.v
