' TEST_MODE : COMPILE_AND_RUN_OK

'' Tuple '=' and '<>', element by element.
''
'' Two things here are not obvious and are the reason this file exists:
''
''  - '<>' is the ORELSE chain of '<>', NOT 'not (l = r)'. With a NaN element
''    those differ, and the negated form would call two NaN-bearing tuples
''    equal. The NaN case below is the assertion.
''  - each side is read through one address temp, so a call on either side is
''    evaluated once and not once per element.
''
'' See docs/tuples/RFC-0004-equality.md.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function mk( byval n as long ) as (long, long)

	dim shared as long calls, cmps

	'' an element type whose own '=' is observable, for short-circuit
	type Watched
		as long v
		declare constructor( )
		declare constructor( byval n as long )
	end type
	constructor Watched( )                 : this.v = 0 : end constructor
	constructor Watched( byval n as long ) : this.v = n : end constructor

	operator = ( byref a as Watched, byref b as Watched ) as integer
		cmps += 1
		return a.v = b.v
	end operator
	operator <> ( byref a as Watched, byref b as Watched ) as integer
		cmps += 1
		return a.v <> b.v
	end operator

	'' ---- scalars ----
	scope
		dim a as (long, long) = (1, 2)
		dim b as (long, long) = (1, 2)
		dim c as (long, long) = (1, 3)

		assert_( a = b )
		assert_( (a = c) = 0 )
		assert_( a <> c )
		assert_( (a <> b) = 0 )
	end scope

	'' ---- STRING elements go through the runtime comparison ----
	scope
		dim a as (long, string) = (1, "hello")
		dim b as (long, string) = (1, "hello")
		dim c as (long, string) = (1, "world")

		assert_( a = b )
		assert_( a <> c )

		'' and a string that is equal by value, not by identity
		dim d as (long, string) = (1, "hel" & "lo")
		assert_( a = d )
	end scope

	'' ---- nested tuples recurse ----
	scope
		'' all-scalar nesting goes inline
		dim a as ((long, long), long) = ((1, 2), 3)
		dim b as ((long, long), long) = ((1, 2), 3)
		dim c as ((long, long), long) = ((1, 9), 3)

		'' with a STRING element the inner tuple is built first: a nested
		'' literal is not context-typed, and a string LITERAL is not a STRING.
		'' RFC-0002 section 4 documents it and errors/tuple-errors.bas pins it.
		dim inner as (long, string) = (1, "n")
		dim s1 as ((long, string), long) = (inner, 3)
		dim s2 as ((long, string), long) = (inner, 3)
		dim other as (long, string) = (1, "m")
		dim s3 as ((long, string), long) = (other, 3)
		assert_( s1 = s2 )
		assert_( s1 <> s3 )


		assert_( a = b )
		assert_( a <> c )
	end scope

	'' ---- literals compare ----
	scope
		assert_( (1, "x") = (1, "x") )
		assert_( (1, "x") <> (1, "y") )
	end scope

	'' ---- element NAMES are not part of identity, so these compare ----
	scope
		dim d as (min as long, max as long) = (5, 10)
		dim e as (lo  as long, hi  as long) = (5, 10)
		assert_( d = e )
	end scope

	'' ---- NaN: '=' false AND '<>' true, exactly as for the bare element ----
	scope
		dim nan as double = 0.0
		nan = nan / nan

		'' establish what the element alone does, so the tuple is compared
		'' against the language rather than against an expectation
		assert_( (nan = nan) = 0 )
		assert_( nan <> nan )

		dim x as (double, long)
		dim y as (double, long)
		x._1 = nan : x._2 = 1
		y._1 = nan : y._2 = 1

		assert_( (x = y) = 0 )      '' would be TRUE if '<>' were built as NOT '='
		assert_( x <> y )
	end scope

	'' ---- each side is evaluated exactly once ----
	scope
		calls = 0
		assert_( mk( 1 ) = mk( 1 ) )
		assert_( calls = 2 )        '' one per side, not one per element

		calls = 0
		assert_( (mk( 1 ) <> mk( 2 )) )
		assert_( calls = 2 )
	end scope

	'' ---- the comparison short-circuits ----
	scope
		dim a as (Watched, Watched)
		dim b as (Watched, Watched)
		a._1.v = 1 : a._2.v = 2
		b._1.v = 9 : b._2.v = 2

		'' '=' stops at the first mismatch, so the second element is not compared
		cmps = 0
		assert_( (a = b) = 0 )
		assert_( cmps = 1 )

		'' '<>' stops at the first difference too
		cmps = 0
		assert_( a <> b )
		assert_( cmps = 1 )

		'' when the first elements match, both are compared
		b._1.v = 1
		cmps = 0
		assert_( a = b )
		assert_( cmps = 2 )
	end scope

	'' ---- usable where any condition is ----
	scope
		dim a as (long, long) = (1, 2)
		dim b as (long, long) = (1, 2)
		dim n as long = 0

		if( a = b ) then n += 1
		while( a = b )
			n += 1
			exit while
		wend
		n += iif( a = b, 1, 0 )
		assert_( n = 3 )
	end scope

	end

private function mk( byval n as long ) as (long, long)
	calls += 1
	return (n, n)
end function
