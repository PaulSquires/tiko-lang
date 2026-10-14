'' fbc's 58 for both: no constructor of Holder takes an Other, nor a type derived from one.

type Shape extends object
    as long s
end type
type Holder
    as long kind
    declare constructor( byref v as const Shape )
end type
constructor Holder( byref v as const Shape ) : kind = 2 : end constructor
type Other
    as long q
end type
type OtherKid extends Other
    as long z
end type

sub Take( byref h as const Holder ) : end sub

dim as Other ot
dim as OtherKid ok
Take( ot )
Take( ok )
