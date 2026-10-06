type T
	redim a2(2 to 6, 3 to 12) as integer
	k as integer
	redim s(1 to 3) as string
end type
dim x as T
print lbound( x.a2, 1 ); ubound( x.a2, 1 ); lbound( x.a2, 2 ); ubound( x.a2, 2 ); ubound( x.s )
x.a2(6, 12) = 5 : x.s(3) = "z"
print x.a2(6, 12); x.s(3)
sub tt
	dim y as T
	print ubound( y.a2, 2 )
end sub
tt
type T2
	redim f(1 to 3) as integer
	redim g(any) as integer
	redim h(4) as long
end type
dim x2 as T2
print ubound(x2.f), ubound(x2.g), lbound(x2.h), ubound(x2.h)
