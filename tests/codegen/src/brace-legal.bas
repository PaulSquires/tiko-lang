'' The brace lists that stay legal (braceinit.bas): an array's initializer, nested once per
'' dimension; paren lists for UDT elements; a brace list inside a paren list for an ARRAY
'' field, through 'type<R>( ... )' too; and an array result's 'return { ... }'.
type Pod
    as long a, b
end type
type O
    p as Pod
    n as long
end type
type R
    k(1) as long
end type

dim a(1) as Pod = { (1, 2), (3, 4) }
print a(0).a; a(0).b; a(1).a; a(1).b
dim g(0 to 1, 0 to 1) as long = { {1, 2}, {3, 4} }
print g(0, 0); g(0, 1); g(1, 0); g(1, 1)
dim o as O = ( (5, 6), 7 )
print o.p.a; o.p.b; o.n
dim r as R = ( {8, 9} )
print r.k(0); r.k(1)
dim r2 as R = type<R>( {10, 11} )
print r2.k(0); r2.k(1)
dim p as Pod = type<Pod>( 12, 13 )
print p.a; p.b

'' 'type( ... )' with no type written takes the destination's -- fbc's own tests write it.
function MakeR( ) as R
    function = type( { 20, 21 } )
end function
dim r3 as R = MakeR( )
print r3.k(0); r3.k(1)

function Three( ) as long( )
    return { 14, 15, 16 }
end function
var t = Three( )
print t(0); t(2)
