' TEST_MODE : COMPILE_AND_RUN_OK

'' Structural identity.
''
'' Two tuples with the same element types in the same order are THE SAME TYPE,
'' however they are spelled and whatever their elements are called. Element
'' names are documentation and never participate.
''
'' Every assignment below is the assertion: if the two sides were distinct
'' types, the file would not compile. The runtime checks only confirm that the
'' right bytes moved.
''
'' See docs/tuples/RFC-0001-tuple-type.md section 3.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function takesUnnamed( byval p as (long, long) ) as long
declare function givesNamed( ) as (first as long, second as long)

	type Pair    as (long, long)
	type MyLong  as long
	type AlsoStr as string

	'' ---- named, differently named, and unnamed are one type ----
	scope
		dim a as (long, long)
		dim b as (min as long, max as long)
		dim c as (lo  as long, hi  as long)
		dim d as Pair

		a._1 = 1 : a._2 = 2
		b = a : assert_( b._1 = 1 andalso b._2 = 2 )
		c = b : assert_( c._1 = 1 andalso c._2 = 2 )
		d = c : assert_( d._1 = 1 andalso d._2 = 2 )
		a = d : assert_( a._1 = 1 andalso a._2 = 2 )
	end scope

	'' ---- an alias of an ELEMENT canonicalises too ----
	scope
		dim a as (long, long)
		dim b as (MyLong, MyLong)
		a._1 = 3 : a._2 = 4
		b = a
		assert_( b._1 = 3 andalso b._2 = 4 )

		dim s as (long, string)
		dim t as (MyLong, AlsoStr)
		s._1 = 5 : s._2 = "five"
		t = s
		assert_( t._1 = 5 andalso t._2 = "five" )
	end scope

	'' ---- a typedef is an alias, not a new type ----
	scope
		'' two typedefs of the same shape are interchangeable
		type P1 as (long, string)
		type P2 as (id as long, label as string)

		dim x as P1
		dim y as P2
		x._1 = 6 : x._2 = "six"
		y = x
		assert_( y._1 = 6 andalso y._2 = "six" )

		'' and both are the bare spelling
		dim z as (long, string) = y
		assert_( z._1 = 6 andalso z._2 = "six" )
	end scope

	'' ---- nested tuples intern by structure too ----
	scope
		dim a as ((long, long), string)
		dim b as ((x as long, y as long), name as string)
		a._1._1 = 7 : a._1._2 = 8 : a._2 = "n"
		b = a
		assert_( b._1._1 = 7 andalso b._1._2 = 8 andalso b._2 = "n" )
	end scope

	'' ---- a signature declared one way accepts a value spelled another ----
	scope
		dim v as (lo as long, hi as long)
		v._1 = 20 : v._2 = 22
		assert_( takesUnnamed( v ) = 42 )

		dim w as (long, long) = givesNamed( )
		assert_( w._1 = 1 andalso w._2 = 2 )

		'' ...and the result of the named-signature function feeds the
		'' unnamed-signature one
		assert_( takesUnnamed( givesNamed( ) ) = 3 )
	end scope

	'' ---- element ORDER is part of identity ----
	'' (long, string) and (string, long) are different types; there is nothing
	'' to assert at runtime, but declaring both and assigning only within each
	'' proves they were interned separately rather than collapsing.
	scope
		dim a as (long, string)
		dim b as (string, long)
		a._1 = 1 : a._2 = "x"
		b._1 = "y" : b._2 = 2
		assert_( a._1 = 1 andalso a._2 = "x" )
		assert_( b._1 = "y" andalso b._2 = 2 )
	end scope

end

private function takesUnnamed( byval p as (long, long) ) as long
	function = p._1 + p._2
end function

private function givesNamed( ) as (first as long, second as long)
	dim r as (long, long)
	r._1 = 1
	r._2 = 2
	return r
end function
