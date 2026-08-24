type t1
    as long a
end type
sub proc2( byval v as t1, byval n as long )
    print v.a, n
end sub
dim x as t1, y as t1
y.a = 2
x = type<t1>( y )
proc2( x, 2 )
x = type<t1>( (y) )
x = (type<t1>( y ))
x = (type<t1>( (y) ))
print x.a
