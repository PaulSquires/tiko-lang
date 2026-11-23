'' overload-unbound-refused.test: a call Check scores against an overload set and cannot bind.
type DT
    x as longint
end type
type LDay
    y as long
    declare constructor( byref a as const DT, byval b as long = 7 )
end type
constructor LDay( byref a as const DT, byval b as long = 7 ) : y = a.x + b : end constructor
type LE
    y as long
    declare constructor( byref a as const DT )
end type
constructor LE( byref a as const DT ) : y = a.x * 2 : end constructor
sub P4 overload( byval f as LDay ) : print "P4 LDay"; f.y : end sub
sub P4( byval f as LE ) : print "P4 LE"; f.y : end sub
dim as DT t : t.x = 5
P4( t )
