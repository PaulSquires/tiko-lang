' TEST_MODE : COMPILE_AND_RUN_OK

'' Tuples in -lang qb.
''
'' The point of this file is the DESTRUCTURING form. 'LET(a, b) = ...' is
'' `-lang fb` only -- it is reachable just when FB_LANG_OPT_LET is unset
'' (parser-assignment.bas), so in this dialect it has always been error 7.
'' '(a, b) = expr' has no such gate, which means this dialect gains a
'' destructuring syntax it never had.
''
'' See docs/tuples/RFC-0003-destructuring.md section 3.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

declare function makePair( ) as (long, string)

	dim p as (long, string)
	p._1 = 1
	p._2 = "one"
	assert_( p._1 = 1 )
	assert_( p._2 = "one" )

	dim x as long
	dim y as string
	(x, y) = p
	assert_( x = 1 )
	assert_( y = "one" )

	(x, y) = makePair( )
	assert_( x = 2 )
	assert_( y = "two" )

	(x, y) = (3, "three")
	assert_( x = 3 )
	assert_( y = "three" )

	'' the right-hand side is bound before any target is written
	dim a as long
	dim b as long
	a = 1
	b = 2
	(a, b) = (b, a)
	assert_( a = 2 )
	assert_( b = 1 )

	'' a parenthesised lvalue still means what it always did
	(a) = 9
	assert_( a = 9 )

	end

function makePair( ) as (long, string)
	'' -lang qb has OPTION GOSUB semantics, so RETURN is the GOSUB return and
	'' the result is set by assigning to the function name -- the QB idiom.
	makePair = (2, "two")
end function
