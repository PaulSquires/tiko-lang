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
