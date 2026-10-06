

common shared array1() as integer
common shared array2() as integer
dim shared array3() as integer
extern array4() as integer
dim array4() as integer

namespace ns
	private sub f1( )
		'' This should not redim the COMMON SHARED, separate namespace
		dim array1(1 to 1) as integer

		'' These should REDIM the globals though
		redim array2(1 to 1) as integer
		redim array3(1 to 1) as integer
		redim array4(1 to 1) as integer
	end sub

	private sub f2( )
		'' These REDIM the globals
		redim .array1(2 to 2) as integer
		redim .array2(2 to 2) as integer
		redim .array3(2 to 2) as integer
		redim .array4(2 to 2) as integer
	end sub
end namespace

private sub f3( )
	'' These should all REDIM though (same namespace)
	dim array1(3 to 3) as integer
	redim array2(3 to 3) as integer
	redim array3(3 to 3) as integer
	redim array4(3 to 3) as integer
end sub

sub test_proc
	print (lbound( array1 ) = 0), (ubound( array1 ) = -1)
	print (lbound( array2 ) = 0), (ubound( array2 ) = -1)
	print (lbound( array3 ) = 0), (ubound( array3 ) = -1)
	print (lbound( array4 ) = 0), (ubound( array4 ) = -1)

	ns.f1( )

	print (lbound( array1 ) = 0), (ubound( array1 ) = -1)
	print (lbound( array2 ) = 1), (ubound( array2 ) = 1)
	print (lbound( array3 ) = 1), (ubound( array3 ) = 1)
	print (lbound( array4 ) = 1), (ubound( array4 ) = 1)

	ns.f2( )

	print (lbound( array1 ) = 2), (ubound( array1 ) = 2)
	print (lbound( array2 ) = 2), (ubound( array2 ) = 2)
	print (lbound( array3 ) = 2), (ubound( array3 ) = 2)
	print (lbound( array4 ) = 2), (ubound( array4 ) = 2)

	f3( )

	print (lbound( array1 ) = 3), (ubound( array1 ) = 3)
	print (lbound( array2 ) = 3), (ubound( array2 ) = 3)
	print (lbound( array3 ) = 3), (ubound( array3 ) = 3)
	print (lbound( array4 ) = 3), (ubound( array4 ) = 3)
end sub

		test_proc
test_proc
