' TEST_MODE : COMPILE_AND_RUN_OK

'' Construction and destruction of tuple elements.
''
'' A tuple declares no members of its own. Everything here is supposed to fall
'' out of symbStructEnd( ), which sees a field whose type has a ctor/dtor and
'' declares the implicit ones -- exactly as it does for a hand-written TYPE.
'' This file exists to prove that "falls out" is true rather than assumed, so
'' every count is checked against a hand-written TYPE doing the same thing.
''
'' See docs/tuples/RFC-0001-tuple-type.md section 6.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

	dim shared as long ctors, dtors, copies

	type Counted
		as long v
		declare constructor( )
		declare constructor( byval n as long )
		declare constructor( byref rhs as Counted )
		declare destructor( )
		declare operator let( byref rhs as Counted )
	end type

	constructor Counted( )            : this.v = 0     : ctors += 1 : end constructor
	constructor Counted( byval n as long ) : this.v = n : ctors += 1 : end constructor
	constructor Counted( byref rhs as Counted ) : this.v = rhs.v : ctors += 1 : copies += 1 : end constructor
	destructor Counted( )             : dtors += 1     : end destructor
	operator Counted.let( byref rhs as Counted ) : this.v = rhs.v : copies += 1 : end operator

declare function makeCounted( byval a as long, byval b as long ) as (Counted, Counted)

	'' the hand-written equivalent of (Counted, Counted)
	type RefPair
		as Counted a
		as Counted b
	end type

	type CPair as (Counted, Counted)

	'' ---- a tuple of a ctor'd/dtor'd type behaves like the TYPE ----
	scope
		dim as long tc, td, rc, rd

		'' tuple
		ctors = 0 : dtors = 0
		scope
			dim t as CPair
			t._1.v = 1
			t._2.v = 2
			assert_( t._1.v + t._2.v = 3 )
		end scope
		tc = ctors : td = dtors

		'' reference TYPE
		ctors = 0 : dtors = 0
		scope
			dim r as RefPair
			r.a.v = 1
			r.b.v = 2
			assert_( r.a.v + r.b.v = 3 )
		end scope
		rc = ctors : rd = dtors

		assert_( tc = rc )
		assert_( td = rd )
		assert_( tc = 2 )       '' one per element
		assert_( td = 2 )
	end scope

	'' ---- copy-construction copies every element ----
	scope
		ctors = 0 : dtors = 0 : copies = 0
		scope
			dim a as CPair
			a._1.v = 7
			a._2.v = 8

			dim b as CPair = a
			assert_( b._1.v = 7 )
			assert_( b._2.v = 8 )

			'' independent
			b._1.v = 0
			assert_( a._1.v = 7 )
		end scope
		assert_( copies = 2 )       '' one per element
		assert_( ctors = dtors )    '' balanced
	end scope

	'' ---- assignment between two live tuples ----
	scope
		ctors = 0 : dtors = 0 : copies = 0
		scope
			dim a as CPair
			dim b as CPair
			a._1.v = 3 : a._2.v = 4
			b = a
			assert_( b._1.v = 3 andalso b._2.v = 4 )
		end scope
		assert_( ctors = dtors )
	end scope

	'' ---- returned by value, including the temporary ----
	scope
		ctors = 0 : dtors = 0
		scope
			dim p as CPair = makeCounted( 5, 6 )
			assert_( p._1.v = 5 )
			assert_( p._2.v = 6 )
		end scope
		assert_( ctors = dtors )
	end scope

	'' ---- STRING elements: no user code at all, still balanced ----
	scope
		dim a as (string, string)
		a._1 = "left"
		a._2 = "right"

		dim b as (string, string) = a
		assert_( b._1 = "left" andalso b._2 = "right" )

		b._1 = "changed"
		assert_( a._1 = "left" )        '' deep copy, not a shared descriptor

		'' a tuple of strings inside an array, resized
		dim arr( ) as (string, string)
		redim arr( 0 to 3 )
		arr(2)._1 = "two"
		redim preserve arr( 0 to 7 )
		assert_( arr(2)._1 = "two" )
	end scope

	'' ---- nested: a tuple of a tuple of a ctor'd type ----
	scope
		ctors = 0 : dtors = 0
		scope
			dim n as (CPair, long)
			n._1._1.v = 11
			n._2 = 12
			assert_( n._1._1.v + n._2 = 23 )
		end scope
		assert_( ctors = 2 )
		assert_( ctors = dtors )
	end scope

end

private function makeCounted( byval a as long, byval b as long ) as (Counted, Counted)
	dim r as (Counted, Counted)
	r._1.v = a
	r._2.v = b
	return r
end function
