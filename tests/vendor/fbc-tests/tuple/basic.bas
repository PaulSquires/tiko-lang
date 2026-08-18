' TEST_MODE : COMPILE_AND_RUN_OK

'' The tuple TYPE: 'as (T, U)' in every position that accepts it, and the
'' _1.._N fields.
''
'' The load-bearing assertion in this file is that a tuple has exactly the
'' layout of the equivalent hand-written TYPE -- same size, same field offsets.
'' Sizes are never hardcoded, because STRING and pointer sizes differ between
'' 32- and 64-bit targets and a hardcoded number would only be testing win64.
''
'' See docs/tuples/RFC-0001-tuple-type.md.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function sumPair( byval p as (long, long) ) as long
declare function makePair( byval a as long, byval b as long ) as (long, long)
declare function makeNamed( byval n as long, byref s as string ) as (num as long, text as string)
declare sub bumpPair( byref p as (long, long) )

	'' reference types: what each tuple must be laid out like
	type Ref_ll
		as long a
		as long b
	end type

	type Ref_ld
		as long   a
		as double b
	end type

	type Ref_ls
		as long   a
		as string b
	end type

	type Ref_bbb
		as byte a
		as byte b
		as byte c
	end type

	type T_ll  as (long, long)
	type T_ld  as (long, double)
	type T_ls  as (long, string)
	type T_bbb as (byte, byte, byte)

	'' ---- size matches the equivalent TYPE ----
	assert_( sizeof( T_ll  ) = sizeof( Ref_ll  ) )
	assert_( sizeof( T_ld  ) = sizeof( Ref_ld  ) )
	assert_( sizeof( T_ls  ) = sizeof( Ref_ls  ) )
	assert_( sizeof( T_bbb ) = sizeof( Ref_bbb ) )

	'' ---- field offsets match the equivalent TYPE ----
	scope
		dim t as (long, double)
		dim r as Ref_ld
		assert_( (cast( byte ptr, @t._2 ) - cast( byte ptr, @t._1 )) = _
		         (cast( byte ptr, @r.b  ) - cast( byte ptr, @r.a  )) )
	end scope

	scope
		dim t as (byte, byte, byte)
		assert_( (cast( byte ptr, @t._2 ) - cast( byte ptr, @t._1 )) = 1 )
		assert_( (cast( byte ptr, @t._3 ) - cast( byte ptr, @t._1 )) = 2 )
	end scope

	'' ---- read and write through _1.._N ----
	scope
		dim p as (long, string)
		p._1 = 3
		p._2 = "hi"
		assert_( p._1 = 3 )
		assert_( p._2 = "hi" )

		p._1 += 1
		p._2 &= "!"
		assert_( p._1 = 4 )
		assert_( p._2 = "hi!" )
	end scope

	'' ---- element names are documentation; the fields are still _1.._N ----
	scope
		dim q as (count as long, name as string)
		q._1 = 7
		q._2 = "seven"
		assert_( q._1 = 7 )
		assert_( q._2 = "seven" )
	end scope

	'' ---- three elements, and more ----
	scope
		dim r as (single, single, single)
		r._1 = 1 : r._2 = 2 : r._3 = 3
		assert_( r._1 + r._2 + r._3 = 6 )

		dim s as (long, long, long, long, long)
		s._1 = 1 : s._5 = 5
		assert_( s._1 + s._5 = 6 )
	end scope

	'' ---- nesting ----
	scope
		dim n as ((long, long), string)
		n._1._1 = 10
		n._1._2 = 20
		n._2 = "nested"
		assert_( n._1._1 + n._1._2 = 30 )
		assert_( n._2 = "nested" )
	end scope

	'' ---- pointer elements ----
	scope
		dim x as long = 99
		dim z as zstring * 8 = "abc"
		dim p as (any ptr, zstring ptr)
		p._1 = @x
		p._2 = @z
		assert_( *cast( long ptr, p._1 ) = 99 )
		assert_( *p._2 = "abc" )
	end scope

	'' ---- a tuple as a UDT field, and as an array element ----
	scope
		type Holder
			as long          tag
			as (long, long)  pair
		end type

		dim h as Holder
		h.tag = 1
		h.pair._1 = 5
		h.pair._2 = 6
		assert_( h.pair._1 + h.pair._2 = 11 )

		dim arr(0 to 2) as (long, string)
		arr(0)._1 = 0 : arr(0)._2 = "zero"
		arr(2)._1 = 2 : arr(2)._2 = "two"
		assert_( arr(0)._2 = "zero" )
		assert_( arr(2)._1 = 2 )
	end scope

	'' ---- copy assignment copies every element, including STRING ----
	scope
		dim a as (long, string)
		a._1 = 1 : a._2 = "one"

		dim b as (long, string) = a
		assert_( b._1 = 1 )
		assert_( b._2 = "one" )

		'' and the copy is independent
		b._1 = 2 : b._2 = "two"
		assert_( a._1 = 1 )
		assert_( a._2 = "one" )
	end scope

	'' ---- CAST to a tuple type ----
	scope
		dim a as (long, long)
		a._1 = 4 : a._2 = 5
		dim b as (long, long) = cast( (long, long), a )
		assert_( b._1 = 4 )
		assert_( b._2 = 5 )
	end scope

	'' ---- parameters and results ----
	assert_( sumPair( makePair( 20, 22 ) ) = 42 )

	scope
		dim p as (long, string) = makeNamed( 9, "nine" )
		assert_( p._1 = 9 )
		assert_( p._2 = "nine" )
	end scope

	'' byref parameter writes through
	scope
		dim p as (long, long)
		p._1 = 1 : p._2 = 2
		bumpPair( p )
		assert_( p._1 = 2 )
		assert_( p._2 = 3 )
	end scope

end

'' a tuple parameter, byval
private function sumPair( byval p as (long, long) ) as long
	function = p._1 + p._2
end function

'' a tuple result -- multiple return
private function makePair( byval a as long, byval b as long ) as (long, long)
	dim r as (long, long)
	r._1 = a
	r._2 = b
	return r
end function

'' a tuple result whose elements need a ctor/dtor, declared with element names
private function makeNamed( byval n as long, byref s as string ) as (num as long, text as string)
	dim r as (long, string)
	r._1 = n
	r._2 = s
	return r
end function

'' a tuple parameter, byref
private sub bumpPair( byref p as (long, long) )
	p._1 += 1
	p._2 += 1
end sub
