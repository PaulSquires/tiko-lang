' TEST_MODE : COMPILE_AND_RUN_OK

'' A user-written operator over a tuple type beats the built-in element-wise
'' comparison.
''
'' The guard in astNewBOP sits AFTER hDoGlobOpOverload, which is what makes this
'' true; moving it earlier would silently take the ability away. Separate from
'' equality.bas because a global operator over (long, long) would then apply to
'' every comparison in that file.
''
'' See docs/tuples/RFC-0004-equality.md section 3.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

	dim shared as long ran

	type P as (long, long)

	'' deliberately says everything is equal, so the built-in chain cannot be
	'' mistaken for it
	operator = ( byref a as P, byref b as P ) as integer
		ran += 1
		return 1
	end operator

	scope
		dim x as P = (1, 2)
		dim y as P = (3, 4)

		ran = 0
		assert_( x = y )        '' element-wise would be FALSE
		assert_( ran = 1 )
	end scope

	'' a DIFFERENT tuple type has no user operator, so it still compares
	'' element-wise
	scope
		dim a as (long, string) = (1, "x")
		dim b as (long, string) = (2, "y")

		ran = 0
		assert_( (a = b) = 0 )
		assert_( ran = 0 )
	end scope

	end
