'' 'procptr( T.member )' is an N_MEMBER, not a bare name.
''
'' Rejecting anything but an N_IDENT left the whole expression untyped, so
'' 'var fp = procptr( T.proc1 )' gave fp a VOID slot and the store into it was
'' malformed. Both shapes are bound to their procedure symbol by then, so the type
'' comes from the same place.

type T
    __ as integer
    declare sub proc1( )
    declare abstract sub v1( )
end type

sub T.proc1( )
end sub

sub free1( )
end sub

var fp = procptr( T.proc1 )
var fg = procptr( free1 )
fp = 0
fg = 0

'' The two-argument form names which override to point at. It does not change the
'' result type.
var fv = procptr( T.v1, virtual )
fv = 0
