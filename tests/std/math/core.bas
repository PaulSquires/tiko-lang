'' Core scalar math -- C:\dev\docs\math\RFC-0001-core.md.
''
'' The gate for phase 1.  Every claim RFC-0001 makes about behaviour is asserted
'' here, including the ones that are surprising, so that a later "fix" has to
'' argue with the RFC first.

#import "std/numeric"
#include once "fbcunit.bi"

#include once "fblimits.bi"

using numeric

using FB
'' Test-local helpers, written independently of the header under test so that a
'' bug in the header cannot agree with itself.
union TestSingleBits
	as ulong  u
	as single f
end union

private function from_bits_test( byval u as ulong ) as single
	dim as TestSingleBits b
	b.u = u
	function = b.f
end function

private function is_even_test( byval x as double ) as boolean
	function = ( x - 2.0 * int( x / 2.0 ) ) = 0.0
end function

private function pow10_test( byval d as long ) as double
	dim as double r = 1.0
	for i as long = 1 to d
		r *= 10.0
	next
	function = r
end function

'' win64 passes the first four arguments in registers and the fifth onward on
'' the stack -- a different emission path, which had the same negative-zero bug.
private function sign_of_six_( byval a as double, byval b as double, byval c as double, _
                               byval d as double, byval e as double, byval f as double ) as string
	dim as string r = ""
	dim as ulongint u
	u = *cptr( ulongint ptr, @a ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	u = *cptr( ulongint ptr, @b ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	u = *cptr( ulongint ptr, @c ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	u = *cptr( ulongint ptr, @d ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	u = *cptr( ulongint ptr, @e ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	u = *cptr( ulongint ptr, @f ) : r += iif( ( u shr 63 ) <> 0, "-", "+" )
	function = r
end function

SUITE( fbc_tests.math.core )

	'' RFC-0001 section 3.  The constants are compared to within an ulp of the
	'' intrinsic that computes them, NOT bit-for-bit: 'atn' and 'exp' are in
	'' RFC-0008's BOUNDED class, so an exact assertion here would be asserting
	'' the platform libm rather than this header.
	TEST( constants_ )
		CU_ASSERT( abs( PI - 4.0 * atn( 1.0 ) ) <= Ulp( PI ) )
		CU_ASSERT( TAU = 2.0 * PI )
		CU_ASSERT( abs( E - exp( 1.0 ) ) <= Ulp( E ) )
		CU_ASSERT( abs( SQRT2 - sqr( 2.0 ) ) <= Ulp( SQRT2 ) )
		CU_ASSERT( abs( LN2 - log( 2.0 ) ) <= Ulp( LN2 ) )
		CU_ASSERT( abs( LN10 - log( 10.0 ) ) <= Ulp( LN10 ) )
		CU_ASSERT( abs( DEG2RAD * 180.0 - PI ) <= Ulp( PI ) )

		'' 1 + EPSILON is representable; 1 + EPSILON/2 rounds back to 1
		CU_ASSERT( 1.0 + EPSILON_DOUBLE <> 1.0 )
		CU_ASSERT( 1.0 + EPSILON_DOUBLE / 2.0 = 1.0 )
		CU_ASSERT( EPSILON_DOUBLE = Ulp( 1.0 ) )

		'' the non-finite values are FUNCTIONS -- a CONST cannot hold one
		CU_ASSERT( IsNaN( NaN( ) ) )
		CU_ASSERT( IsInfinite( Infinity( ) ) )
		CU_ASSERT( IsInfinite( NegInfinity( ) ) )
		CU_ASSERT( IsNegative( NegInfinity( ) ) )
		CU_ASSERT( IsNaN( NaNF( ) ) )
		CU_ASSERT( IsInfinite( InfinityF( ) ) )

		'' NaN is not equal to itself -- which is exactly why IsNaN exists
		CU_ASSERT( ( NaN( ) = NaN( ) ) = 0 )

		CU_ASSERT( MAX_DOUBLE * 2.0 = Infinity( ) )
		CU_ASSERT( IsNormal( MIN_POSITIVE_DOUBLE ) )
		CU_ASSERT( IsSubnormal( MinSubnormalDouble( ) ) )
		CU_ASSERT( IsSubnormal( MinSubnormalSingle( ) ) )
	END_TEST

	'' RFC-0001 section 7.  Bit-pattern classification, not comparison.
	TEST( classification_ )
		CU_ASSERT( Classify( NaN( ) ) = FP_NAN )
		CU_ASSERT( Classify( Infinity( ) ) = FP_INFINITE )
		CU_ASSERT( Classify( 0.0 ) = FP_ZERO )
		CU_ASSERT( Classify( -0.0 ) = FP_ZERO )
		CU_ASSERT( Classify( MinSubnormalDouble( ) ) = FP_SUBNORMAL )
		CU_ASSERT( Classify( 1.0 ) = FP_NORMAL )

		CU_ASSERT( Classify( NaNF( ) ) = FP_NAN )
		CU_ASSERT( Classify( InfinityF( ) ) = FP_INFINITE )
		CU_ASSERT( Classify( 0.0f ) = FP_ZERO )
		CU_ASSERT( Classify( MinSubnormalSingle( ) ) = FP_SUBNORMAL )
		CU_ASSERT( Classify( 1.0f ) = FP_NORMAL )

		CU_ASSERT( IsFinite( 1.0 ) )
		CU_ASSERT( IsFinite( Infinity( ) ) = false )
		CU_ASSERT( IsFinite( NaN( ) ) = false )
		CU_ASSERT( IsNormal( 0.0 ) = false )
		CU_ASSERT( IsNormal( MinSubnormalDouble( ) ) = false )

		'' THE ONE WHOSE OBVIOUS READING IS WRONG.  A sign-bit query, not a
		'' comparison: -0.0 < 0.0 is false, but its sign bit is set.
		''
		'' BOTH forms are asserted, and the direct one is a REGRESSION TEST.
		'' Passing '-0.0' directly as a byval float argument used to be
		'' miscompiled by -gen gas64: it materialised the immediate with
		'' 'xor eax, eax' -- because -0.0 = 0.0 is true -- and so delivered
		'' POSITIVE zero.  Fixed in ir-gas64.bas (hisposzero_asm64 tests the bit
		'' pattern instead of the value); see docs/gas64-negative-zero-arg-bug.md.
		'' If that shortcut ever comes back, these two lines fail on gas64 and
		'' pass on gcc.
		CU_ASSERT( IsNegative( -0.0 ) )
		CU_ASSERT( IsNegative( -0.0f ) )

		dim as double negzero = -0.0
		dim as single negzerof = -0.0f
		CU_ASSERT( IsNegative( negzero ) )
		CU_ASSERT( IsNegative( negzerof ) )

		'' ...and the same value reaching a callee on the STACK rather than in a
		'' register, which is a separate emission path and was equally wrong.
		CU_ASSERT( sign_of_six_( -0.0, -0.0, -0.0, -0.0, -0.0, -0.0 ) = "------" )
		CU_ASSERT( sign_of_six_( 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) = "++++++" )
		CU_ASSERT( ( negzero < 0.0 ) = 0 )
		CU_ASSERT( negzero = 0.0 )
		CU_ASSERT( IsNegative( 0.0 ) = false )
		CU_ASSERT( IsNegative( -1.0 ) )
		CU_ASSERT( Classify( negzero ) = FP_ZERO )
	END_TEST

	'' RFC-0001 section 4.
	TEST( selection_ )
		CU_ASSERT( Min( 3L, 9L ) = 3 )
		CU_ASSERT( Max( 3L, 9L ) = 9 )
		CU_ASSERT( Min( -4LL, -9LL ) = -9 )
		CU_ASSERT( Max( cubyte( 200 ), cubyte( 7 ) ) = 200 )
		CU_ASSERT( Min( cshort( -5 ), cshort( 5 ) ) = -5 )
		CU_ASSERT( Max( 1.5f, 2.5f ) = 2.5f )

		'' NaN PROPAGATES.  C's fmin returns the non-NaN operand; this does not,
		'' because discarding a NaN turns a detectable error into an
		'' undetectable wrong answer.
		CU_ASSERT( IsNaN( Min( NaN( ), 1.0 ) ) )
		CU_ASSERT( IsNaN( Min( 1.0, NaN( ) ) ) )
		CU_ASSERT( IsNaN( Max( NaN( ), 1.0 ) ) )
		CU_ASSERT( IsNaN( Max( 1.0, NaN( ) ) ) )
		CU_ASSERT( IsNaN( Min( NaNF( ), 1.0f ) ) )

		CU_ASSERT( Clamp( 5.0, 0.0, 1.0 ) = 1.0 )
		CU_ASSERT( Clamp( -5.0, 0.0, 1.0 ) = 0.0 )
		CU_ASSERT( Clamp( 0.5, 0.0, 1.0 ) = 0.5 )
		CU_ASSERT( Clamp( 0.0, 0.0, 1.0 ) = 0.0 )
		CU_ASSERT( Clamp( 1.0, 0.0, 1.0 ) = 1.0 )
		CU_ASSERT( Clamp( 5L, 0L, 10L ) = 5 )

		'' lo > hi is a caller error and returns hi.  Deterministic rather than
		'' right, because there is no right answer -- RFC-0001 section 4.
		CU_ASSERT( Clamp( 5.0, 10.0, 0.0 ) = 0.0 )
		CU_ASSERT( Clamp( 5L, 10L, 0L ) = 0 )

		'' a NaN v falls through every comparison -- propagation again
		CU_ASSERT( IsNaN( Clamp( NaN( ), 0.0, 1.0 ) ) )

		CU_ASSERT( Sign( -4.2 ) = -1 )
		CU_ASSERT( Sign( 4.2 ) = 1 )
		CU_ASSERT( Sign( 0.0 ) = 0 )
		CU_ASSERT( Sign( -0.0 ) = 0 )
		CU_ASSERT( Sign( NaN( ) ) = 0 )
		CU_ASSERT( Sign( -7LL ) = -1 )
		CU_ASSERT( Sign( 0L ) = 0 )
	END_TEST

	'' RFC-0001 section 4.  Monotonic, and NOT exact at t = 1.
	TEST( lerp_ )
		CU_ASSERT( Lerp( 0.0, 10.0, 0.0 ) = 0.0 )
		CU_ASSERT( Lerp( 0.0, 10.0, 0.5 ) = 5.0 )
		CU_ASSERT( Lerp( -10.0, 10.0, 0.5 ) = 0.0 )

		'' monotonic across the range
		dim as double prev = Lerp( 1.0, 2.0, 0.0 )
		for i as long = 1 to 1000
			dim as double cur = Lerp( 1.0, 2.0, i / 1000.0 )
			CU_ASSERT( cur >= prev )
			prev = cur
		next

		'' The documented consequence: the fast form may miss the endpoint by an
		'' ulp.  Pinned, not hidden -- if this ever becomes exact, RFC-0001
		'' section 4 has to change with it.
		CU_ASSERT( abs( Lerp( 1.0, 2.0, 1.0 ) - 2.0 ) <= Ulp( 2.0 ) )
	END_TEST

	'' RFC-0001 section 5.  The part most often got wrong.
	TEST( rounding_ties_ )
		'' half away from zero
		CU_ASSERT( Round( 0.5 ) = 1.0 )
		CU_ASSERT( Round( 1.5 ) = 2.0 )
		CU_ASSERT( Round( 2.5 ) = 3.0 )
		CU_ASSERT( Round( 3.5 ) = 4.0 )
		CU_ASSERT( Round( -0.5 ) = -1.0 )
		CU_ASSERT( Round( -1.5 ) = -2.0 )
		CU_ASSERT( Round( -2.5 ) = -3.0 )
		CU_ASSERT( Round( -3.5 ) = -4.0 )

		'' half to even
		CU_ASSERT( RoundHalfEven( 0.5 ) = 0.0 )
		CU_ASSERT( RoundHalfEven( 1.5 ) = 2.0 )
		CU_ASSERT( RoundHalfEven( 2.5 ) = 2.0 )
		CU_ASSERT( RoundHalfEven( 3.5 ) = 4.0 )
		CU_ASSERT( RoundHalfEven( 4.5 ) = 4.0 )
		CU_ASSERT( RoundHalfEven( -0.5 ) = 0.0 )
		CU_ASSERT( RoundHalfEven( -1.5 ) = -2.0 )
		CU_ASSERT( RoundHalfEven( -2.5 ) = -2.0 )
		CU_ASSERT( RoundHalfEven( -3.5 ) = -4.0 )

		'' Every tie in -5..5, both modes.  Note that 'i + 0.5' for negative i is
		'' CLOSER to zero than i, so half-away-from-zero lands on i itself --
		'' Round( -4.5 ) is -5 and Round( -0.5 ) is -1.  Getting that backwards is
		'' the easiest way to write a test that accuses a correct implementation.
		for i as long = -5 to 5
			dim as double x = i + 0.5
			if( i >= 0 ) then
				CU_ASSERT( Round( x ) = i + 1 )
			else
				CU_ASSERT( Round( x ) = i )
			end if
			CU_ASSERT( abs( Round( x ) - x ) = 0.5 )
			CU_ASSERT( is_even_test( RoundHalfEven( x ) ) )
			CU_ASSERT( abs( RoundHalfEven( x ) - x ) = 0.5 )
		next

		'' non-ties agree between the two modes
		for i as long = -50 to 50
			dim as double x = i / 10.0
			if( abs( x - int( x ) ) <> 0.5 ) then
				CU_ASSERT( Round( x ) = RoundHalfEven( x ) )
			end if
		next
	END_TEST

	'' The two bugs in 'int( x + 0.5 )', pinned so the idiom cannot come back.
	TEST( rounding_beats_the_idiom_ )
		'' 1. wrong for negatives
		CU_ASSERT( int( -2.5 + 0.5 ) = -2.0 )      '' the idiom
		CU_ASSERT( Round( -2.5 ) = -3.0 )          '' the answer

		'' 2. wrong just below a tie.  0.49999999999999994 is the largest double
		'' below 0.5; adding 0.5 rounds it UP to 1.0 before int ever sees it.
		''
		'' THE SUM IS STORED FIRST, AND THAT IS NOT DECORATION.  The bug being
		'' pinned is a DOUBLE-PRECISION one, so the addition has to be rounded to
		'' double before int sees it.  On win32 fbc uses the x87 with the
		'' precision control at 64-bit mantissa, and an unstored sum stays in an
		'' 80-bit register where 0.49999999999999994 + 0.5 is exact and stays
		'' below 1.0 -- so the idiom accidentally gets the right answer and the
		'' assertion fails.  C99 permits that (FLT_EVAL_METHOD = 2); the store is
		'' what makes the test say what it means on every target.
		dim as double justunder = 0.49999999999999994
		CU_ASSERT( justunder < 0.5 )
		dim as double bumped = justunder + 0.5
		CU_ASSERT( bumped = 1.0 )                  '' the store really did round
		CU_ASSERT( int( bumped ) = 1.0 )           '' the idiom
		CU_ASSERT( Round( justunder ) = 0.0 )      '' the answer
	END_TEST

	'' RFC-0001 section 5.  INT is floor, FIX is truncation, and neither name
	'' says so -- which is why Floor/Ceil/Truncate exist.
	TEST( floor_ceil_truncate_ )
		CU_ASSERT( Floor( -2.5 ) = -3.0 )
		CU_ASSERT( Floor( 2.5 ) = 2.0 )
		CU_ASSERT( Ceil( -2.5 ) = -2.0 )
		CU_ASSERT( Ceil( 2.5 ) = 3.0 )
		CU_ASSERT( Truncate( -2.5 ) = -2.0 )
		CU_ASSERT( Truncate( 2.5 ) = 2.0 )

		'' the equivalences that justify the names
		for i as long = -50 to 50
			dim as double x = i / 7.0
			CU_ASSERT( Floor( x ) = int( x ) )
			CU_ASSERT( Truncate( x ) = fix( x ) )
		next

		CU_ASSERT( Floor( -2.5f ) = -3.0f )
		CU_ASSERT( Ceil( -2.5f ) = -2.0f )
		CU_ASSERT( Truncate( -2.5f ) = -2.0f )

		'' non-finite rides through
		CU_ASSERT( IsNaN( Round( NaN( ) ) ) )
		CU_ASSERT( IsInfinite( Round( Infinity( ) ) ) )
		CU_ASSERT( IsNaN( RoundHalfEven( NaN( ) ) ) )
	END_TEST

	'' RFC-0001 section 5, the digits form.
	TEST( rounding_digits_ )
		CU_ASSERT( Round( 3.14159, 2 ) = 3.14 )
		CU_ASSERT( Round( 3.14159, 4 ) = 3.1416 )
		CU_ASSERT( Round( 3.14159, 0 ) = 3.0 )
		CU_ASSERT( Round( -3.14159, 2 ) = -3.14 )
		CU_ASSERT( RoundHalfEven( 1.005, 2 ) = 1.0 )
		CU_ASSERT( Round( 1.25, 1 ) = 1.3 )
		CU_ASSERT( RoundHalfEven( 1.25, 1 ) = 1.2 )
		CU_ASSERT( RoundHalfEven( 1.35, 1 ) = 1.4 )

		'' Out of range is NaN, not the input unchanged -- returning the input
		'' would hide the mistake.  RFC-0001 section 5.
		CU_ASSERT( IsNaN( Round( 1.5, -1 ) ) )
		CU_ASSERT( IsNaN( Round( 1.5, 18 ) ) )
		CU_ASSERT( IsNaN( RoundHalfEven( 1.5, -1 ) ) )
		CU_ASSERT( IsNaN( RoundHalfEven( 1.5, 18 ) ) )

		'' Already integral at this scale -- nothing to do, and no overflow
		CU_ASSERT( Round( 1e300, 17 ) = 1e300 )
		CU_ASSERT( IsNaN( Round( NaN( ), 2 ) ) )

		'' THE CONSEQUENCE OF SCALING, pinned so it is a decision and not a
		'' surprise.  The double nearest 2.675 is 2.67499999999999982..., so an
		'' EXACT decimal round to 2 places would give 2.67.  Multiplying by 100
		'' lands on exactly 267.5 -- the product rounds UP to the tie -- so the
		'' tie rule fires and both modes give 2.68.
		''
		'' This follows directly from RFC-0001 section 5 ("the tie decision is
		'' made on the scaled value").  Anything that changes it has to change
		'' the RFC first, and would mean an exact decimal path rather than a
		'' scale-and-round one.
		CU_ASSERT( 2.675 * 100.0 = 267.5 )
		CU_ASSERT( Round( 2.675, 2 ) = 2.68 )
		CU_ASSERT( RoundHalfEven( 2.675, 2 ) = 2.68 )

		'' every digit position round-trips a value that is exact at it
		for d as long = 0 to 15
			dim as double x = 1.0 + 1.0 / pow10_test( d )
			CU_ASSERT( Round( x, d ) = x )
		next
	END_TEST

	'' RFC-0001 section 6.  BOUNDED, not exact -- accuracy is the platform's.
	'' These assert identities that hold for any conforming libm rather than
	'' bit patterns, which would be a claim RFC-0008 does not make.
	TEST( libm_surface_ )
		'' THESE ARE BOUNDED, NOT EXACT, AND THIS TEST USED TO GET THAT WRONG.
		'' 'Cbrt( 27.0 ) = 3.0' held on the Windows libm and FAILED on glibc --
		'' which is precisely the platform variation RFC-0008 declines to claim
		'' away, asserted here in the one form the section header says not to
		'' use.  A value that is exactly representable does not mean a
		'' correctly-rounded implementation must produce it.
		''
		'' Each is now within one ulp of the exact result.  The special cases
		'' below (Tanh(0), Cosh(0), Acosh(1), LogB) stay exact: C annex F
		'' REQUIRES those, so they are not a platform bet.
		CU_ASSERT( abs( Hypot( 3.0, 4.0 ) - 5.0 ) <= Ulp( 5.0 ) )
		CU_ASSERT( abs( Hypot( 3.0f, 4.0f ) - 5.0f ) <= Ulp( 5.0f ) )
		CU_ASSERT( abs( Cbrt( 27.0 ) - 3.0 ) <= Ulp( 3.0 ) )
		CU_ASSERT( abs( Cbrt( -8.0 ) + 2.0 ) <= Ulp( 2.0 ) )
		CU_ASSERT( abs( Log2( 8.0 ) - 3.0 ) <= Ulp( 3.0 ) )
		CU_ASSERT( abs( Log10( 1000.0 ) - 3.0 ) <= Ulp( 3.0 ) )
		CU_ASSERT( abs( Exp2( 10.0 ) - 1024.0 ) <= Ulp( 1024.0 ) )
		CU_ASSERT( abs( Pow( 2.0, 10.0 ) - 1024.0 ) <= Ulp( 1024.0 ) )
		CU_ASSERT( Tanh( 0.0 ) = 0.0 )
		CU_ASSERT( Cosh( 0.0 ) = 1.0 )
		CU_ASSERT( Sinh( 0.0 ) = 0.0 )
		CU_ASSERT( Acosh( 1.0 ) = 0.0 )
		CU_ASSERT( Atanh( 0.0 ) = 0.0 )
		CU_ASSERT( Asinh( 0.0 ) = 0.0 )
		CU_ASSERT( LogB( 8.0 ) = 3.0 )
		CU_ASSERT( ScaleB( 1.0, 10 ) = 1024.0 )
		CU_ASSERT( Fma( 2.0, 3.0, 4.0 ) = 10.0 )
		CU_ASSERT( CopySign( 3.0, -1.0 ) = -3.0 )
		CU_ASSERT( IsNegative( CopySign( 0.0, -1.0 ) ) )

		'' Inverse pairs, to a stated tolerance rather than to the bit.
		''
		'' The Log2/Exp2 tolerance is measured against the INTERMEDIATE, not
		'' against x, and that is not slack: near y = 1, d(log2 y)/dy is 1/ln2,
		'' so one ulp of error in Exp2( x ) becomes ~1.4 ulp of y in the result
		'' -- which for a small x is many ulps of x.  At x = 0.05 the round-trip
		'' error is 1.04e-16 where 8*Ulp( 0.05 ) is 5.55e-17.  A round trip
		'' cannot be more accurate than the representation it passes through.
		for i as long = 1 to 200
			dim as double x = i / 20.0
			dim as double half_ = x / 10.0
			CU_ASSERT( abs( Cbrt( x * x * x ) - x ) <= 8.0 * Ulp( x ) )
			CU_ASSERT( abs( Atanh( Tanh( half_ ) ) - half_ ) <= 8.0 * Ulp( half_ ) )
			CU_ASSERT( abs( Log2( Exp2( x ) ) - x ) <= 8.0 * Ulp( Exp2( x ) ) )
		next

		'' log1p/expm1 are the accurate-near-zero pair and that is the point
		dim as double tiny = 1e-17
		CU_ASSERT( Log1p( tiny ) <> 0.0 )
		CU_ASSERT( Expm1( tiny ) <> 0.0 )
		'' Stored, for the reason given in rounding_beats_the_idiom_: 1.0 + 1e-17
		'' is not 1.0 in an 80-bit x87 register (extended has a ~1e-19 epsilon),
		'' so on win32 the naive form quietly gets the accurate answer and stops
		'' demonstrating anything.
		dim as double onepluseps = 1.0 + tiny
		CU_ASSERT( onepluseps = 1.0 )            '' the store really did round
		CU_ASSERT( log( onepluseps ) = 0.0 )     '' what it replaces

		'' Hypot does not overflow where the hand-rolled form does.  The square is
		'' stored for the same reason as in rounding_beats_the_idiom_: 1e400 is
		'' not representable as a double but IS representable in an 80-bit x87
		'' register, so an unstored big*big never overflows on win32 and the
		'' hand-rolled form comes back finite.
		dim as double big = 1e200
		CU_ASSERT( IsFinite( Hypot( big, big ) ) )
		dim as double squared = big * big
		CU_ASSERT( IsInfinite( squared ) )         '' the store really did overflow
		CU_ASSERT( IsInfinite( sqr( squared + squared ) ) )
	END_TEST

	'' RFC-0001 section 6.  Ulp and NextAfter.
	TEST( ulp_and_nextafter_ )
		CU_ASSERT( Ulp( 1.0 ) = EPSILON_DOUBLE )
		CU_ASSERT( 1.0 + Ulp( 1.0 ) <> 1.0 )
		CU_ASSERT( NextAfter( 1.0, 2.0 ) = 1.0 + Ulp( 1.0 ) )
		CU_ASSERT( NextAfter( 1.0, 0.0 ) < 1.0 )

		'' away from zero on BOTH sides -- Ulp is always positive
		CU_ASSERT( Ulp( -1.0 ) > 0.0 )
		CU_ASSERT( Ulp( -1.0 ) = Ulp( 1.0 ) )
		CU_ASSERT( Ulp( 1.0f ) = EPSILON_SINGLE )
		CU_ASSERT( IsNaN( Ulp( Infinity( ) ) ) )
		CU_ASSERT( Ulp( 0.0 ) = MinSubnormalDouble( ) )
	END_TEST

	'' RFC-0001 section 7 -- exhaustive over the whole SINGLE domain.  All 2^32
	'' bit patterns, classified against an independent reference.  This is the
	'' one long-running test in phase 1.
	TEST( classification_exhaustive_single_ )
		dim as ulong u = 0
		dim as ulongint nan_ = 0, inf_ = 0, zero_ = 0, sub_ = 0, norm_ = 0

		do
			dim as single x = from_bits_test( u )
			dim as ulong ex = ( u shr 23 ) and &hFFul
			dim as ulong m = u and &h7FFFFFul

			'' the reference, computed independently of the header
			dim as FpClass want
			if( ex = &hFFul ) then
				if( m <> 0ul ) then want = FP_NAN else want = FP_INFINITE
			elseif( ex = 0ul ) then
				if( m = 0ul ) then want = FP_ZERO else want = FP_SUBNORMAL
			else
				want = FP_NORMAL
			end if

			if( Classify( x ) <> want ) then
				CU_ASSERT( Classify( x ) = want )
				exit do
			end if
			dim as boolean wantneg = ( u shr 31 ) <> 0ul
			if( IsNegative( x ) <> wantneg ) then
				CU_ASSERT( IsNegative( x ) = wantneg )
				exit do
			end if

			select case want
			case FP_NAN       : nan_ += 1
			case FP_INFINITE  : inf_ += 1
			case FP_ZERO      : zero_ += 1
			case FP_SUBNORMAL : sub_ += 1
			case FP_NORMAL    : norm_ += 1
			end select

			if( u = &hFFFFFFFFul ) then exit do
			u += 1
		loop

		'' the counts are a known, checkable property of IEEE 754 binary32
		CU_ASSERT( zero_ = 2 )                       '' +0 and -0
		CU_ASSERT( inf_ = 2 )                        '' +inf and -inf
		CU_ASSERT( nan_ = 2ull * ( 8388608ull - 1ull ) )
		CU_ASSERT( sub_ = 2ull * ( 8388608ull - 1ull ) )
		CU_ASSERT( norm_ = 2ull * 254ull * 8388608ull )
		CU_ASSERT( nan_ + inf_ + zero_ + sub_ + norm_ = 4294967296ull )
	END_TEST

	'' Frexp and Modf both split a double in two and both hand ONE half back
	'' through a byref out-parameter, so the pair is easy to get backwards.
	'' Frexp splits on the EXPONENT, Modf on the DECIMAL POINT.
	TEST( frexp_and_modf_ )
		dim as long e

		'' 1024 = 0.5 * 2^11, and the fraction is always in [0.5, 1)
		CU_ASSERT( Frexp( 1024.0, e ) = 0.5 )
		CU_ASSERT( e = 11 )

		CU_ASSERT( Frexp( 1.0, e ) = 0.5 )
		CU_ASSERT( e = 1 )

		'' zero is the documented special case: both halves are zero
		CU_ASSERT( Frexp( 0.0, e ) = 0.0 )
		CU_ASSERT( e = 0 )

		'' the sign rides on the fraction, not the exponent
		CU_ASSERT( Frexp( -1024.0, e ) = -0.5 )
		CU_ASSERT( e = 11 )

		'' it round-trips EXACTLY through ScaleB, which is the whole contract
		for i as long = -60 to 60
			dim as double x = ( 1.0 + i * 0.017 ) * ( 2.0 ^ i )
			dim as double f = Frexp( x, e )
			CU_ASSERT( abs( f ) >= 0.5 andalso abs( f ) < 1.0 )
			CU_ASSERT( ScaleB( f, e ) = x )
		next

		'' Modf splits at the decimal point and BOTH halves keep the sign, so
		'' they always add back to the input
		dim as double ip
		CU_ASSERT( Modf( 2.75, ip ) = 0.75 )
		CU_ASSERT( ip = 2.0 )

		CU_ASSERT( Modf( -2.5, ip ) = -0.5 )
		CU_ASSERT( ip = -2.0 )

		'' an integer has no fractional half
		CU_ASSERT( Modf( 7.0, ip ) = 0.0 )
		CU_ASSERT( ip = 7.0 )

		CU_ASSERT( Modf( -0.25, ip ) = -0.25 )
		CU_ASSERT( ip = 0.0 orelse ip = -0.0 )

		for i as long = -200 to 200
			dim as double x = i * 0.125 + 0.0625
			dim as double fr = Modf( x, ip )
			CU_ASSERT( ip + fr = x )
			CU_ASSERT( abs( fr ) < 1.0 )
			CU_ASSERT( ip = int( abs( x ) ) * sgn( x ) )
		next
	END_TEST

	'' The single-precision negative infinity.  NegInfinity( ) is the double.
	TEST( neg_infinity_single_ )
		dim as single ninf = NegInfinityF( )

		CU_ASSERT( IsInfinite( ninf ) )
		CU_ASSERT( IsNegative( ninf ) )
		CU_ASSERT( IsFinite( ninf ) = false )
		CU_ASSERT( IsNaN( ninf ) = false )
		CU_ASSERT( Classify( ninf ) = FP_INFINITE )

		'' it is the negation of the positive one, and it is a SINGLE -- the
		'' double NegInfinity narrows to the same bits
		CU_ASSERT( ninf = -InfinityF( ) )
		CU_ASSERT( ninf < 0.0f )
		CU_ASSERT( ninf < -3.4e38f )
		CU_ASSERT( csng( NegInfinity( ) ) = ninf )
	END_TEST

	'' Degrees and radians, which exist so that the conversion factor is never
	'' typed out at a call site.
	TEST( angle_conversion_ )
		const as double PI_ = 3.14159265358979323846

		CU_ASSERT( abs( DegToRad( 180.0 ) - PI_ ) < 1e-15 )
		CU_ASSERT( abs( DegToRad( 90.0 ) - PI_ / 2.0 ) < 1e-15 )
		CU_ASSERT( DegToRad( 0.0 ) = 0.0 )

		CU_ASSERT( abs( RadToDeg( PI_ ) - 180.0 ) < 1e-12 )
		CU_ASSERT( abs( RadToDeg( PI_ / 2.0 ) - 90.0 ) < 1e-12 )
		CU_ASSERT( RadToDeg( 0.0 ) = 0.0 )

		'' negatives are not a special case
		CU_ASSERT( abs( DegToRad( -45.0 ) + PI_ / 4.0 ) < 1e-15 )
		CU_ASSERT( abs( RadToDeg( -PI_ / 4.0 ) + 45.0 ) < 1e-12 )

		'' round trip, both directions, over a full turn and past it
		for d as long = -720 to 720
			CU_ASSERT( abs( RadToDeg( DegToRad( cdbl( d ) ) ) - d ) < 1e-9 )
		next

		'' the single overloads exist and agree to single precision
		dim as single s = DegToRad( 180.0f )
		CU_ASSERT( abs( s - csng( PI_ ) ) < 1e-6 )
		CU_ASSERT( abs( RadToDeg( s ) - 180.0f ) < 1e-3 )
	END_TEST

END_SUITE
