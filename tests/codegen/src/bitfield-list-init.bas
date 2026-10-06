type T
	as long f1 : 1
	as long f2 : 1
	as long f3 : 1
	as long f4 : 1
	as long f5 : 28
	as long f6 : 1
	as long f7 : 1
	as long f8 : 1
	as long f9 : 1
end type
dim as ulong i(0 to 1) = { &hFFFFFFFFu, &hFFFFFFFFu }
dim as T ptr x = cptr( T ptr, @i(0) )
*x = type<T>( 0, 1, 0, 1, &b111, 0, 1, 0, 1 )
print x->f1; x->f2; x->f5; x->f9, hex( i(0) ), hex( i(1) )
dim as T y
y = type<T>( 1, 0, 1, 0, 5, 1, 0, 1, 0 )
print y.f1; y.f5; y.f8
type T3
	as long f1 : 1
	as long f2 : 31
end type
sub s( byval k as long )
	dim as T3 z = ( 1, k )
	print z.f1; z.f2
	dim as T3 w = type<T3>( 0, k + 1 )
	print w.f1; w.f2
end sub
s( 5 )
dim as long km = 9
dim as T3 zm = ( 1, km )
print zm.f1; zm.f2
