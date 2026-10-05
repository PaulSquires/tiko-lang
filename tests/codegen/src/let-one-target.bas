

	type triplet
		dim as short a = any, b = any
		dim as string c
		declare constructor( a as short, b as short, c as zstring ptr )
		declare destructor( )
	end type

	constructor triplet ( a as short, b as short, c as zstring ptr )
		this.a = a
		this.b = b
		this.c = *c
	end constructor

		dim shared as integer dtorcnt = 0

	destructor triplet( )
		dtorcnt += 1
	end destructor

	function func1( ) as triplet
		return triplet( 1, 2, "3" )
	end function

	function func2( ) as triplet
		return triplet( -1, -2, "-3" )
	end function

	function func3( ) as triplet
		return triplet( 10, 11, "12" )
	end function

	function func4( ) as triplet
		return triplet( -10, -11, "-12" )
	end function
		
dim as integer foo, bar
dim as string baz
let( foo, bar, baz ) = func1( ) : print foo; bar; baz
let( foo, , baz ) = func2( ) : print foo; bar; baz
let( foo ) = func3( ) : print foo; bar; baz
let( , , baz ) = func4( ) : print foo; bar; baz

print dtorcnt
