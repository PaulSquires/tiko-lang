'' A definition in an OVERLOAD set that certainly differs from the one same-arity
'' declaration is a NEW overload, not that declaration's body.
declare sub g overload( byval a as long )
sub g( byval a as double )
    print "g double"; a
end sub
declare sub h overload( byval a as long ptr )
sub h( byval a as long )
    print "h long"; a
end sub
declare sub k overload( a() as long )
sub k( byval a as long )
    print "k scalar"; a
end sub
g( 1.5 )
h( 3 )
k( 4 )
