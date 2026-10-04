namespace A
    type T
        v as long
    end type
end namespace
namespace B
    type T
        d as double
        s as string
    end type
end namespace
declare sub f( byref q as A.T )
sub f( byref q as B.T )
    print q.d
end sub
dim x as A.T
f( x )
