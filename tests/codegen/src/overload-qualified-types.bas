namespace A
    type T
        v as long
    end type
end namespace
namespace B
    type T
        d as double
    end type
end namespace
sub f overload( byval q as A.T )
    print "A"; q.v
end sub
sub f overload( byval q as B.T )
    print "B"; q.d
end sub
dim x as A.T : x.v = 3
dim y as B.T : y.d = 2.5
f( x ) : f( y )
