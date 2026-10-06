type T1
	as integer i
end type
type T2
	as integer a, b, c, d, e, f
end type
var b1 = new T1( type<T1>( 123 ) )
var c1 = new T1( type( 123 ) )
var c2 = new T2( type( 1 ) )
var c3 = new T2( 4, 5 )
print b1->i, c1->i, c2->a, c2->b, c3->a, c3->b, c3->c
