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

'' A STRUCTOR HAS NO ORDINARY NAME TO RESOLVE -- the parser leaves the keyword as the
'' member -- so RefOf answered nothing and every one of these declined. Measured
'' against fbc, which takes the FIRST overload when no signature is written and the
'' matching one when it is:
''
''     procptr( C.constructor )                           &_ZN1CC1Ev
''     procptr( C.constructor, sub( byval as integer ) )  &_ZN1CC1Eu7INTEGER
''     procptr( C.destructor )                            &_ZN1CD1Ev
''     procptr( C.M, sub( byval as long ) )               &_ZN1C1MEi
''
'' THE SIGNATURE HAD TO BE PARSED AS A TYPE. Read as an expression it came out as a
'' CALL to something named 'sub', which nothing could match -- so the overload was
'' chosen by taking the first: a silently WRONG function address rather than a decline.
''
'' AND AN UNMATCHED SECOND ARGUMENT DECLINES rather than falling back to the first. The
'' only reason to write one is that the first is not the one wanted. 'procptr( T.v1,
'' virtual )' above lands there too -- it names which OVERRIDE to point at, which is
'' not the direct address this path would give.
type C
    as long n
    declare constructor( )
    declare constructor( byval x as integer )
    declare destructor( )
    declare sub M( )
    declare sub M( byval a as long )
end type
constructor C( ) : end constructor
constructor C( byval x as integer ) : n = x : end constructor
destructor C( ) : end destructor
sub C.M( ) : end sub
sub C.M( byval a as long ) : end sub

var pc  = procptr( C.constructor )
var pci = procptr( C.constructor, sub( byval as integer ) )
var pd  = procptr( C.destructor )
var pm  = procptr( C.M )
var pml = procptr( C.M, sub( byval as long ) )
