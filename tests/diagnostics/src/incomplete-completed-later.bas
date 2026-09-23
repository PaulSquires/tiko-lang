'' TKO0811: a forward type COMPLETED BELOW its use is still incomplete there -- fbc reads a
'' file top to bottom, so these are its error 71. The controls are accepted by fbc.
type X as Foo
dim as X a1
type H
    v as X
end type
type Y as X
dim as Y a2
sub DefBody( )
    dim as X a3
end sub

'' Accepted by fbc: a pointer above, a byref parameter of a declaration above, and any use
'' below the completion.
dim as X ptr p1
declare sub DeclByref( byref v as X )
type Foo
    k as long
end type
dim as X a4
print a4.k; p1 = 0
