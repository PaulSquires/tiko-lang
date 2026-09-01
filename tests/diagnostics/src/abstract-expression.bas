'' An abstract type cannot be instantiated by an EXPRESSION either. MEASURED with fbc,
'' all three are error 306: 'new A', 'type<A>( )' and 'A( )' -- and a TYPEDEF for A
'' behaves as A does. A POINTER or REFERENCE to one stays legal; that is the only way an
'' abstract type is ever used, so the two accepted lines below matter as much as the
'' refused ones.
type A extends object
    declare abstract sub f1( )
    x as integer
end type

type A2 as A

sub takes( byref r as A )
end sub

dim ok1 as A ptr = 0
sub taking( byval p as A ptr )
end sub

dim bad1 as A ptr = new A
print (type<A>()).x
print (A()).x
print (A2()).x
