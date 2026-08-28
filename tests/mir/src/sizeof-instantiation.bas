'' 'sizeof( Box( of long ) )' NAMES A TYPE. It was read as an EXPRESSION, so the
'' '( of long )' was dropped and only the bare name survived -- the TEMPLATE, which has
'' no size.
type Box( of T )
	as T v
end type
type Pair( of A, B )
	as A x
	as B y
end type

dim as long n1 = sizeof( Box( of long ) )
dim as long n2 = sizeof( Box( of double ) )
dim as long n3 = sizeof( Pair( of long, long ) )
dim as long n4 = sizeof( Pair( of double, double ) )
dim b as Box( of long )
dim as long n5 = sizeof( b )
print n1, n2, n3, n4, n5
