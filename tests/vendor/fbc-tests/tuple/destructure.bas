' TEST_MODE : COMPILE_AND_RUN_OK

'' Destructuring: 'var (a, b) = expr' to declare, '(a, b) = expr' to assign.
''
'' Both forms bind the right-hand side once before writing any target, which is
'' what makes '(a, b) = (b, a)' a swap. Both are checked against all three shapes
'' of right-hand side -- a tuple variable, a literal, and a call -- because they
'' reach the value by different routes and a STRING element is the only thing
'' that notices when one of them gets the lifetime wrong.
''
'' See docs/tuples/RFC-0003-destructuring.md.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function givesLS( ) as (long, string)
declare function counted( ) as (long, long)
declare function sideEffect( ) as (long, string)

	dim shared as long calls

	type Holder
		as long   tag
		as string label
	end type

	'' ---- 'var (a, b) =' declares locals of the ELEMENT types ----
	scope
		var (lo, hi) = (3, 4)
		assert_( lo = 3 andalso hi = 4 )

		'' really longs, not tuples
		lo += 1
		assert_( lo = 4 )

		var (n, s) = givesLS( )
		assert_( n = 5 )
		assert_( s = "five" )

		'' really a STRING, and it owns its data
		s &= "!"
		assert_( s = "five!" )

		'' three elements
		var (a, b, c) = (1, 2, 3)
		assert_( a + b + c = 6 )
	end scope

	'' ---- 'var' from each shape of right-hand side ----
	scope
		dim v as (long, string)
		v._1 = 1 : v._2 = "from-var"

		var (a1, b1) = v
		assert_( a1 = 1 andalso b1 = "from-var" )

		var (a2, b2) = (2, "from-literal")
		assert_( a2 = 2 andalso b2 = "from-literal" )

		var (a3, b3) = givesLS( )
		assert_( a3 = 5 andalso b3 = "five" )
	end scope

	'' ---- '(a, b) =' assigns to existing lvalues ----
	scope
		dim x as long, y as string

		dim v as (long, string)
		v._1 = 1 : v._2 = "from-var"
		(x, y) = v
		assert_( x = 1 andalso y = "from-var" )

		(x, y) = (2, "from-literal")
		assert_( x = 2 andalso y = "from-literal" )

		(x, y) = givesLS( )
		assert_( x = 5 andalso y = "five" )
	end scope

	'' ---- any lvalue, not just plain variables ----
	scope
		dim h as Holder
		dim arr(1 to 3) as long
		dim p as long ptr = @arr(1)

		(h.tag, h.label) = (7, "seven")
		assert_( h.tag = 7 andalso h.label = "seven" )

		(arr(2), arr(3)) = (8, 9)
		assert_( arr(2) = 8 andalso arr(3) = 9 )

		(*p, arr(2)) = (10, 11)
		assert_( arr(1) = 10 andalso arr(2) = 11 )
	end scope

	'' ---- the right-hand side is bound before any target is written ----
	scope
		dim a as long = 1, b as long = 2
		(a, b) = (b, a)
		assert_( a = 2 andalso b = 1 )

		dim s1 as string = "one", s2 as string = "two"
		(s1, s2) = (s2, s1)
		assert_( s1 = "two" andalso s2 = "one" )
	end scope

	'' ---- a call on the right is evaluated exactly once ----
	scope
		dim x as long, y as long
		calls = 0
		(x, y) = counted( )
		assert_( calls = 1 )
		assert_( x = 20 andalso y = 22 )

		calls = 0
		var (p, q) = counted( )
		assert_( calls = 1 )
		assert_( p = 20 andalso q = 22 )
	end scope

	'' ---- elements convert per element ----
	scope
		dim d1 as double, d2 as double
		(d1, d2) = (1, 2)
		assert_( d1 = 1.0 andalso d2 = 2.0 )

		'' narrowing follows FB's ordinary rules
		dim i1 as long, i2 as long
		dim src as (double, double)
		src._1 = 3.0 : src._2 = 4.0
		(i1, i2) = src
		assert_( i1 = 3 andalso i2 = 4 )
	end scope

	'' ---- a STRING element survives, and is independent ----
	scope
		dim s as string
		dim n as long
		(n, s) = sideEffect( )
		assert_( n = 1 )
		assert_( s = "aaaaaaaaaaaaaaaaaaaaaaaa" )

		'' and it is a copy, not a view
		s = "changed"
		var (n2, s2) = sideEffect( )
		assert_( s2 = "aaaaaaaaaaaaaaaaaaaaaaaa" )
		assert_( s = "changed" )
	end scope

	'' ---- in a loop: no accumulation, no reuse ----
	scope
		dim total as long = 0
		dim x as long, y as string
		for i as long = 1 to 50
			(x, y) = ( i, "x" & i )
			assert_( y = "x" & i )
			total += x

			var (a, b) = ( i, "y" & i )
			assert_( b = "y" & i )
			total += a
		next
		assert_( total = 2 * 1275 )
	end scope

	'' ---- LET is unchanged, and still destructures a plain UDT ----
	scope
		dim h as Holder
		h.tag = 4 : h.label = "four"

		dim t as long, l as string
		let (t, l) = h
		assert_( t = 4 andalso l = "four" )

		'' ...and a tuple, since a tuple is a UDT
		dim u as long, v as string
		let (u, v) = givesLS( )
		assert_( u = 5 andalso v = "five" )
	end scope

	end

private function givesLS( ) as (long, string)
	return (5, "five")
end function

private function counted( ) as (long, long)
	calls += 1
	return (20, 22)
end function

private function sideEffect( ) as (long, string)
	return (1, "aaaaaaaaaaaaaaaaaaaaaaaa")
end function
