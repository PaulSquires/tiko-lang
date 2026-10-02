'' 'C( c1 )' spelt out binds to the IMPLICIT copy constructor a string field gives C.
type C
    declare constructor ( byval a as long )
    declare destructor ( )
    v as long
    s as string
end type
constructor C ( byval a as long )
    v = a : s = "s" & a
    print "ctor"; a
end constructor
destructor C ( )
    print "dtor"; v
end destructor
'' A plain field type holding a string: H's copy is non-trivial through its FIELD.
type N
    i as long
    t as string
end type
type H
    declare constructor ( byval a as long )
    n as N
end type
constructor H ( byval a as long )
    n.i = a : n.t = "n" & a
end constructor
function f( ) as C
    return C( 7 )
end function
sub go( )
    dim c1 as C = C( 1 )
    dim c2 as C = C( c1 )
    c1.s = "changed"
    print c2.v; " "; c2.s
    dim c4 as C = C( f( ) )
    print c4.v; " "; c4.s
    dim pc as C ptr = @c2
    dim c5 as C = C( *pc )
    print c5.v; " "; c5.s
    dim h1 as H = H( 5 )
    dim h2 as H = H( h1 )
    h1.n.t = "y"
    print h2.n.i; " "; h2.n.t
end sub
go( )
print "end"
