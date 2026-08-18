'' The cleanup model, in the shapes where an exit path could skip an action.
sub Ordering( )
    dim as long x
    defer x = 1
    defer x = 2
    x = 3
end sub

sub PerIteration( )
    dim as long x
    for i as integer = 1 to 2
        defer x = 8
        x = 9
    next
end sub

sub ThroughScopes( byval f as long )
    dim as long x
    defer x = 4
    scope
        defer x = 5
        if f then return
    end scope
    x = 6
end sub

'' Member access through the measured field offsets.
type Rec
    as long   n
    as double d
end type

sub Members( )
    dim as Rec r
    r.n = 1
    r.d = 2.5
end sub

'' Constructors and destructors, registered into the same cleanup list the defers use.
type Res
    as long h
    declare constructor( )
    declare destructor( )
end type
constructor Res( )
    h = 1
end constructor
destructor Res( )
    h = 0
end destructor

sub Structors( byval f as long )
    dim as Res a
    scope
        dim as Res inner
        if f then return
    end scope
    dim as Res b
end sub

'' Constructor selection by argument type, using the same cost model as ordinary
'' overload resolution -- constructors chain like any other overload set.
type Val
    as long n
    declare constructor( )
    declare constructor( byval a as long )
    declare constructor( byval d as double )
end type
constructor Val( )
    n = 0
end constructor
constructor Val( byval a as long )
    n = a
end constructor
constructor Val( byval d as double )
    n = 1
end constructor

sub Selected( )
    dim as Val p
    dim as Val q = Val( 5 )
    dim as Val r = Val( 2.5 )
end sub
