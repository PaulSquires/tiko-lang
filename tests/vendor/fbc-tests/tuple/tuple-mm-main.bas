' TEST_MODE : MULTI_MODULE_OK

'' The calling module. Spells the SAME tuples WITH element names, and with
'' different names than any other declaration -- they must not reach the type,
'' or these declarations would not resolve to the definitions in
'' tuple-mm-a.bas.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

extern "c++"
declare function MakePair( byval a as long, byval b as long ) as (min as long, max as long)
declare function SumPair( byval p as (lo as long, hi as long) ) as long
declare function MakeText( byval n as long ) as (id as long, label as string)
end extern

	dim p as (long, long) = MakePair( 20, 22 )
	assert_( p._1 = 20 )
	assert_( p._2 = 22 )
	assert_( SumPair( p ) = 42 )

	'' the value produced by the other module feeds straight back into it
	assert_( SumPair( MakePair( 1, 2 ) ) = 3 )

	'' a tuple whose element needs a ctor/dtor, constructed over there and
	'' destroyed over here
	scope
		dim t as (long, string) = MakeText( 9 )
		assert_( t._1 = 9 )
		assert_( t._2 = "n=9" )
	end scope

end
