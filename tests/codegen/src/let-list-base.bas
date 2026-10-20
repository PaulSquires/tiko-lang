' 'let( c, i1, i2 ) = gc' over a GrandChild takes its Child base, and 'let( p, ... )' that
' base's Parent part.
type Parent
    dim as integer p1, p2
end type
type Child extends Parent
    dim as integer c1, c2
end type
type GrandChild extends Child
    dim as integer gc1, gc2
end type
dim as GrandChild gc = type(1, 2, 3, 4, 5, 6)
dim as integer i1, i2, j1, j2
dim as Parent p
dim as Child c
let(c, i1, i2) = gc
print c.p1; c.p2; c.c1; c.c2; i1; i2
let(p, j1, j2) = gc
print p.p1; p.p2; j1; j2
