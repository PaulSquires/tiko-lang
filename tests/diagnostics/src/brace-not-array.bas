'' A brace list initializes an ARRAY and nothing else (fbc's error 63 and neighbours).
type Pod
    as long a, b
end type
type O
    p as Pod
    n as long
end type
dim p1 as Pod = { 7, 8 }
dim shared p2 as Pod = { 7, 8 }
sub Locals( )
    dim p3 as Pod = { 7, 8 }
    static p4 as Pod = { 7, 8 }
end sub
dim x as long = { 5 }
dim s as string = { "a" }
dim pe as Pod = { }
dim pp as Pod ptr = { 1, 2 }
type Q
    f as Pod = { 1, 2 }
end type
dim o as O = ( { 1, 2 }, 3 )
dim ua(1) as Pod = { { 1, 2 }, ( 3, 4 ) }
sub WithDefault( byval d as Pod = { 1, 2 } )
end sub
var v = { 1, 2 }
p1 = { 1, 2 }
WithDefault( { 1, 2 } )
print { 1 }
