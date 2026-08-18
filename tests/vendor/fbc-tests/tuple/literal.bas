' TEST_MODE : COMPILE_AND_RUN_OK

'' The '(a, b)' literal, and context-typing.
''
'' A literal is built AT the type it is stored into whenever that type is known,
'' converting each element as it goes. Without that, '(1, "hi")' would have type
'' (integer, zstring-literal) and would not go into a (double, string) at all.
'' The four places the target type is known -- assignment, DIM initialisation,
'' RETURN and a call argument -- are all exercised below, and all four already
'' set parser.ctxsym before this feature existed.
''
'' The other half of this file is DESTRUCTION BALANCE. The literal's temp is
'' deliberately not registered for destruction, because its contents are always
'' taken over by the consumer; getting that wrong is a double free for a STRING
'' element and is invisible with scalar test data.
''
'' See docs/tuples/RFC-0002-tuple-values.md sections 1, 2 and 4.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function bump( byval n as long ) as long
declare sub takesDD( byval p as (double, double) )
declare sub takesLS( byval p as (long, string) )
declare function givesDS( ) as (double, string)
declare function givesLL( ) as (long, long)

	dim shared as long ctors, dtors
	dim shared as long calls, firstcall

	type Counted
		as long v
		declare constructor( )
		declare constructor( byval n as long )
		declare constructor( byref rhs as Counted )
		declare destructor( )
		declare operator let( byref rhs as Counted )
	end type

	constructor Counted( )                      : this.v = 0     : ctors += 1 : end constructor
	constructor Counted( byval n as long )      : this.v = n     : ctors += 1 : end constructor
	constructor Counted( byref rhs as Counted ) : this.v = rhs.v : ctors += 1 : end constructor
	destructor Counted( )                       : dtors += 1     : end destructor
	operator Counted.let( byref rhs as Counted ): this.v = rhs.v : end operator

	declare sub takesCounted( byval p as (Counted, long) )
	declare function givesCounted( ) as (Counted, long)

	'' ---- construction, left to right, once each ----
	scope
		dim t as (long, string) = (3, "hi")
		assert_( t._1 = 3 )
		assert_( t._2 = "hi" )

		dim u as (long, long, long) = (1, 2, 3)
		assert_( u._1 + u._2 + u._3 = 6 )

		'' nested literal -- inner elements convert too
		dim n as ((double, double), long) = ((4, 5), 6)
		assert_( n._1._1 = 4.0 )
		assert_( n._1._2 = 5.0 )
		assert_( n._2 = 6 )

		'' a nested tuple built separately always works
		dim inner as (long, string) = (7, "seven")
		dim outer as ((long, string), long) = (inner, 8)
		assert_( outer._1._1 = 7 )
		assert_( outer._1._2 = "seven" )
		assert_( outer._2 = 8 )
	end scope

	'' ---- elements are evaluated exactly once, in source order ----
	scope
		dim t as (long, long) = ( bump( 1 ), bump( 2 ) )
		assert_( t._1 = 1 )
		assert_( t._2 = 2 )
		assert_( calls = 2 )        '' once each, not twice
		assert_( firstcall = 1 )    '' left to right
	end scope

	'' ---- context-typing: the literal adapts to its target ----
	scope
		'' DIM initialisation: integer literal -> double, string literal -> STRING
		dim a as (double, string) = (1, "hi")
		assert_( a._1 = 1.0 )
		assert_( a._2 = "hi" )

		'' assignment
		dim b as (double, double)
		b = (2, 3)
		assert_( b._1 = 2.0 andalso b._2 = 3.0 )

		'' RETURN
		dim c as (double, string) = givesDS( )
		assert_( c._1 = 0.0 )
		assert_( c._2 = "" )

		dim d as (long, long) = givesLL( )
		assert_( d._1 = 9 andalso d._2 = 10 )

		'' call argument
		takesDD( (4, 5) )
		takesLS( (6, "six") )
	end scope

	'' ---- without a usable context the literal takes its own type ----
	scope
		dim e as (long, long) = (7, 8)      '' target known
		dim f as (long, long)
		f._1 = 7 : f._2 = 8
		assert_( e._1 = f._1 andalso e._2 = f._2 )
	end scope

	'' ---- DESTRUCTION BALANCE, per context ----
	scope
		dim keepalive as Counted             '' outside the counters

		'' DIM initialisation
		ctors = 0 : dtors = 0
		scope
			dim t as (Counted, long) = ( Counted(1), 2 )
			assert_( t._1.v = 1 andalso t._2 = 2 )
		end scope
		assert_( ctors = dtors )

		'' assignment
		ctors = 0 : dtors = 0
		scope
			dim u as (Counted, long)
			u = ( Counted(3), 4 )
			assert_( u._1.v = 3 andalso u._2 = 4 )
		end scope
		assert_( ctors = dtors )

		'' call argument
		ctors = 0 : dtors = 0
		scope
			takesCounted( ( Counted(5), 6 ) )
		end scope
		assert_( ctors = dtors )

		'' RETURN
		ctors = 0 : dtors = 0
		scope
			dim w as (Counted, long) = givesCounted( )
			assert_( w._1.v = 7 andalso w._2 = 8 )
		end scope
		assert_( ctors = dtors )
	end scope

	'' ---- STRING elements: deep copies, no aliasing, no double free ----
	scope
		'' long enough that the descriptors are heap allocations, so a double
		'' free would be a real one
		dim s as (string, string) = ("aaaaaaaaaaaaaaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbbbbbbbb")
		dim s2 as (string, string) = s
		assert_( s2._1 = "aaaaaaaaaaaaaaaaaaaaaaaa" )

		s2._1 = "changed"
		assert_( s._1 = "aaaaaaaaaaaaaaaaaaaaaaaa" )    '' independent

		'' a literal in a loop: the temp must not accumulate or be reused wrongly
		dim total as long = 0
		for i as long = 1 to 100
			dim q as (long, string) = ( i, "x" & i )
			total += q._1
			assert_( q._2 = "x" & i )
		next
		assert_( total = 5050 )
	end scope

	end


private function bump( byval n as long ) as long
	calls += 1
	if( calls = 1 ) then
		firstcall = n
	end if
	function = n
end function

private sub takesDD( byval p as (double, double) )
	assert_( p._1 = 4.0 andalso p._2 = 5.0 )
end sub

private sub takesLS( byval p as (long, string) )
	assert_( p._1 = 6 andalso p._2 = "six" )
end sub

private function givesDS( ) as (double, string)
	return (0, "")
end function

private function givesLL( ) as (long, long)
	return (9, 10)
end function

private sub takesCounted( byval p as (Counted, long) )
	assert_( p._1.v = 5 andalso p._2 = 6 )
end sub

private function givesCounted( ) as (Counted, long)
	return ( Counted(7), 8 )
end function
