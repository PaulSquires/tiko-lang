'' Integer arithmetic -- C:\dev\docs\math\RFC-0002-integer.md, sections 2-4.

#import "std/numeric"
#import "std/outcome"
#include once "fbcunit.bi"

#include once "fblimits.bi"

#include once "fberror.bi"

using numeric, outcome

using FB
'' A reference IPow written independently of the header: repeated multiplication
'' in the widest signed type, so the header's exponentiation-by-squaring has
'' something to disagree with.
private function ipow_ref( byval b as longint, byval e as longint ) as longint
	dim as longint r = 1
	for i as longint = 1 to e
		r *= b
	next
	function = r
end function

SUITE( fbc_tests.math.intmath )

	'' RFC-0002 section 2.  Three conventions, named so a reader knows which.
	TEST( floor_and_euclid_mod_ )
		'' THE DEFECT: 'MOD' truncates.  This is what the language does today.
		CU_ASSERT( -7 mod 3 = -1 )
		CU_ASSERT( -7 \ 3 = -2 )

		'' ...and this is the answer a wrapping index wants.
		CU_ASSERT( FloorMod( -7L, 3L ) = 2 )
		CU_ASSERT( FloorDiv( -7L, 3L ) = -3 )

		'' sign follows the DIVISOR
		CU_ASSERT( FloorMod( 7L, -3L ) = -2 )
		CU_ASSERT( FloorMod( -7L, -3L ) = -1 )
		CU_ASSERT( FloorMod( 7L, 3L ) = 1 )

		'' Euclidean: always non-negative, whatever the divisor's sign
		CU_ASSERT( EuclidMod( -7L, 3L ) = 2 )
		CU_ASSERT( EuclidMod( -7L, -3L ) = 2 )
		CU_ASSERT( EuclidMod( 7L, -3L ) = 1 )
		CU_ASSERT( EuclidMod( 7L, 3L ) = 1 )

		'' the defining identities, over every sign combination
		for a as long = -20 to 20
			for b as long = -20 to 20
				if( b <> 0 ) then
					dim as long fq = FloorDiv( a, b ), fr = FloorMod( a, b )
					CU_ASSERT( fq * b + fr = a )
					'' remainder has the divisor's sign, or is zero
					if( fr <> 0 ) then CU_ASSERT( ( fr < 0 ) = ( b < 0 ) )
					CU_ASSERT( abs( fr ) < abs( b ) )

					dim as long eq_ = EuclidDiv( a, b ), er = EuclidMod( a, b )
					CU_ASSERT( eq_ * b + er = a )
					CU_ASSERT( er >= 0 )
					CU_ASSERT( er < abs( b ) )

					'' truncating MOD agrees with both when the signs agree
					if( a >= 0 andalso b > 0 ) then
						CU_ASSERT( fr = a mod b )
						CU_ASSERT( er = a mod b )
					end if
				end if
			next
		next

		'' unsigned: all three coincide with the operators
		for a as ulong = 0 to 40
			for b as ulong = 1 to 20
				CU_ASSERT( FloorMod( a, b ) = a mod b )
				CU_ASSERT( EuclidMod( a, b ) = a mod b )
				CU_ASSERT( FloorDiv( a, b ) = a \ b )
			next
		next
	END_TEST

	'' RFC-0002 section 2.  The tuple return.
	TEST( divmod_ )
		var (q, r) = DivMod( 17LL, 5LL )
		CU_ASSERT( q = 3 )
		CU_ASSERT( r = 2 )

		var (q2, r2) = DivMod( -17LL, 5LL )
		CU_ASSERT( q2 = -3 )
		CU_ASSERT( r2 = -2 )

		'' agrees with the operators for every operand pair
		for a as longint = -50 to 50
			for b as longint = -20 to 20
				if( b <> 0 ) then
					var (qq, rr) = DivMod( a, b )
					CU_ASSERT( qq = a \ b )
					CU_ASSERT( rr = a mod b )
					CU_ASSERT( qq * b + rr = a )
				end if
			next
		next

		'' every width has one
		var (a8, b8) = DivMod( cbyte( 100 ), cbyte( 7 ) )
		CU_ASSERT( a8 = 14 )
		CU_ASSERT( b8 = 2 )
		var (au, bu) = DivMod( 100ul, 7ul )
		CU_ASSERT( au = 14 )
		CU_ASSERT( bu = 2 )
	END_TEST

	'' RFC-0002 section 3.  The '^' defect, closed.
	TEST( ipow_exact_ )
		'' THE NAMED REGRESSION CASES.  '^' returns DOUBLE, so these are wrong
		'' today by 89 and by 239 respectively -- while both true results fit in
		'' a LONGINT with room to spare.
		CU_ASSERT( IPow( 3LL, 38LL ) = 1350851717672992089LL )
		CU_ASSERT( IPow( 7LL, 22LL ) = 3909821048582988049LL )

		'' and the operator really is wrong, so the fix is demonstrated rather
		'' than merely asserted.
		''
		'' THE DOUBLE IS PINNED IN A VARIABLE FIRST.  The defect being shown is
		'' that '^' goes through DOUBLE, whose 53-bit mantissa cannot hold 3^38
		'' (61 bits).  On win32 fbc runs the x87 at 64-bit mantissa, which CAN
		'' hold it, so an unstored result converts straight back to the exact
		'' answer and the operator stops looking broken.  Storing to a double is
		'' what makes 'goes through DOUBLE' actually happen on every target.
		dim as longint b = 3, e = 38
		dim as double asdouble = b ^ e
		CU_ASSERT( asdouble = 1350851717672992000.0 )  '' the store really did round
		dim as longint viaop = asdouble
		CU_ASSERT( viaop <> 1350851717672992089LL )
		CU_ASSERT( viaop = 1350851717672992000LL )

		CU_ASSERT( IPow( 2LL, 62LL ) = 4611686018427387904LL )
		CU_ASSERT( IPow( 10LL, 18LL ) = 1000000000000000000LL )
		CU_ASSERT( IPow( 5LL, 0LL ) = 1 )
		CU_ASSERT( IPow( 0LL, 0LL ) = 1 )
		CU_ASSERT( IPow( 0LL, 5LL ) = 0 )
		CU_ASSERT( IPow( -2LL, 3LL ) = -8 )
		CU_ASSERT( IPow( -2LL, 4LL ) = 16 )

		'' negative exponent: no integer answer except for the units
		CU_ASSERT( IPow( 3LL, -1LL ) = 0 )
		CU_ASSERT( IPow( 1LL, -5LL ) = 1 )
		CU_ASSERT( IPow( -1LL, -5LL ) = -1 )
		CU_ASSERT( IPow( -1LL, -4LL ) = 1 )

		'' exhaustive against the independent reference, over every base and
		'' exponent whose true result stays in range
		for base_ as longint = -12 to 12
			for expo as longint = 0 to 20
				dim as longint want = ipow_ref( base_, expo )
				dim as boolean small = abs( base_ ) <= 1
				dim as boolean inrange = ( expo * 4 ) < 63
				if( small orelse inrange ) then
					CU_ASSERT( IPow( base_, expo ) = want )
				end if
			next
		next

		'' unsigned
		CU_ASSERT( IPow( 3ull, 40ull ) = 12157665459056928801ull )
	END_TEST

	'' RFC-0002 section 3.  ISqrt is exact where int( sqr( n ) ) is not.
	TEST( isqrt_gcd_lcm_ )
		CU_ASSERT( ISqrt( 0ull ) = 0 )
		CU_ASSERT( ISqrt( 1ull ) = 1 )
		CU_ASSERT( ISqrt( 3ull ) = 1 )
		CU_ASSERT( ISqrt( 4ull ) = 2 )
		CU_ASSERT( ISqrt( 1000000000000000000ull ) = 1000000000ull )
		CU_ASSERT( ISqrt( MAX_VALUE_ULONGINT ) = 4294967295ull )

		'' the PROPERTY, not a reference implementation:
		'' r*r <= n < (r+1)*(r+1), which is what "floor of the true root" means
		for n as ulongint = 0 to 5000
			dim as ulongint r = ISqrt( n )
			CU_ASSERT( r * r <= n )
			CU_ASSERT( ( r + 1 ) * ( r + 1 ) > n )
		next

		'' and at the top of the range, where the DOUBLE route loses bits
		dim as ulongint big = 18446744065119617025ull      '' 4294967295^2
		CU_ASSERT( ISqrt( big ) = 4294967295ull )
		CU_ASSERT( ISqrt( big - 1 ) = 4294967294ull )

		CU_ASSERT( ISqrt( -1LL ) = -1 )                     '' negative is an error

		CU_ASSERT( GCD( 12L, 18L ) = 6 )
		CU_ASSERT( GCD( 0L, 0L ) = 0 )
		CU_ASSERT( GCD( 0L, 5L ) = 5 )
		CU_ASSERT( GCD( -12L, 18L ) = 6 )                   '' non-negative always
		CU_ASSERT( GCD( -12L, -18L ) = 6 )
		CU_ASSERT( LCM( 4L, 6L ) = 12 )
		CU_ASSERT( LCM( 0L, 5L ) = 0 )

		'' GCD(a,b) * LCM(a,b) = a*b, over random-ish pairs
		for a as long = 1 to 60
			for b as long = 1 to 60
				CU_ASSERT( clngint( GCD( a, b ) ) * clngint( LCM( a, b ) ) = clngint( a ) * clngint( b ) )
			next
		next
	END_TEST

	'' RFC-0002 section 4.  Every operation at both boundaries of every type.
	TEST( checked_boundaries_ )
		'' LONGINT
		CU_ASSERT( AddChecked( MAX_VALUE_LONGINT, 1LL ).HasValue( ) = false )
		CU_ASSERT( AddChecked( MIN_VALUE_LONGINT, -1LL ).HasValue( ) = false )
		CU_ASSERT( AddChecked( MAX_VALUE_LONGINT, 0LL ).Value( ) = MAX_VALUE_LONGINT )
		CU_ASSERT( SubChecked( MIN_VALUE_LONGINT, 1LL ).HasValue( ) = false )
		CU_ASSERT( SubChecked( MAX_VALUE_LONGINT, -1LL ).HasValue( ) = false )
		CU_ASSERT( MulChecked( MAX_VALUE_LONGINT, 2LL ).HasValue( ) = false )
		CU_ASSERT( MulChecked( MIN_VALUE_LONGINT, -1LL ).HasValue( ) = false )
		CU_ASSERT( MulChecked( -1LL, MIN_VALUE_LONGINT ).HasValue( ) = false )
		CU_ASSERT( DivChecked( MIN_VALUE_LONGINT, -1LL ).HasValue( ) = false )
		CU_ASSERT( DivChecked( 1LL, 0LL ).HasValue( ) = false )
		CU_ASSERT( NegChecked( MIN_VALUE_LONGINT ).HasValue( ) = false )

		'' THE CLASSIC SILENT BUG: abs( MIN ) has no representable result and
		'' the intrinsic returns MIN itself, negative.
		CU_ASSERT( abs( MIN_VALUE_LONGINT ) = MIN_VALUE_LONGINT )
		CU_ASSERT( abs( MIN_VALUE_LONGINT ) < 0 )
		CU_ASSERT( AbsChecked( MIN_VALUE_LONGINT ).HasValue( ) = false )
		CU_ASSERT( AbsChecked( -5LL ).Value( ) = 5 )

		'' LONG
		CU_ASSERT( AddChecked( MAX_VALUE_LONG, 1L ).HasValue( ) = false )
		CU_ASSERT( AddChecked( MIN_VALUE_LONG, -1L ).HasValue( ) = false )
		CU_ASSERT( MulChecked( 100000L, 100000L ).HasValue( ) = false )
		CU_ASSERT( MulChecked( 46340L, 46340L ).Value( ) = 2147395600 )

		'' BYTE and SHORT -- the narrow types are not an afterthought
		CU_ASSERT( AddChecked( cbyte( 127 ), cbyte( 1 ) ).HasValue( ) = false )
		CU_ASSERT( AddChecked( cbyte( -128 ), cbyte( -1 ) ).HasValue( ) = false )
		CU_ASSERT( AddChecked( cbyte( 126 ), cbyte( 1 ) ).Value( ) = 127 )
		CU_ASSERT( AbsChecked( cbyte( -128 ) ).HasValue( ) = false )
		CU_ASSERT( MulChecked( cshort( 200 ), cshort( 200 ) ).HasValue( ) = false )

		'' UNSIGNED
		CU_ASSERT( AddChecked( MAX_VALUE_ULONGINT, 1ull ).HasValue( ) = false )
		CU_ASSERT( SubChecked( 0ull, 1ull ).HasValue( ) = false )
		CU_ASSERT( SubChecked( 5ull, 5ull ).Value( ) = 0 )
		CU_ASSERT( MulChecked( MAX_VALUE_ULONGINT, 2ull ).HasValue( ) = false )
		CU_ASSERT( NegChecked( 1ul ).HasValue( ) = false )
		CU_ASSERT( NegChecked( 0ul ).Value( ) = 0 )
		CU_ASSERT( AddChecked( cubyte( 255 ), cubyte( 1 ) ).HasValue( ) = false )
		CU_ASSERT( MulChecked( cushort( 300 ), cushort( 300 ) ).HasValue( ) = false )

		'' A DEFAULT-CONSTRUCTED Optional IS EMPTY, so a forgotten assignment
		'' reads as overflow rather than as success.
		dim as Optional( of longint ) forgotten
		CU_ASSERT( forgotten.HasValue( ) = false )
	END_TEST

	'' Checked results agree with the operators wherever there is no overflow.
	TEST( checked_agrees_when_safe_ )
		for a as long = -300 to 300 step 7
			for b as long = -300 to 300 step 11
				dim as Optional( of long ) s = AddChecked( a, b )
				CU_ASSERT( s.HasValue( ) )
				CU_ASSERT( s.Value( ) = a + b )

				dim as Optional( of long ) d = SubChecked( a, b )
				CU_ASSERT( d.HasValue( ) )
				CU_ASSERT( d.Value( ) = a - b )

				dim as Optional( of long ) m = MulChecked( a, b )
				CU_ASSERT( m.HasValue( ) )
				CU_ASSERT( m.Value( ) = a * b )
			next
		next

		CU_ASSERT( IPowChecked( 3LL, 38LL ).Value( ) = 1350851717672992089LL )
		CU_ASSERT( IPowChecked( 10LL, 19LL ).HasValue( ) = false )
		CU_ASSERT( IPowChecked( 2LL, 63LL ).HasValue( ) = false )
		CU_ASSERT( IPowChecked( 2LL, 62LL ).Value( ) = 4611686018427387904LL )
	END_TEST

	'' RFC-0002 section 4.  Saturating clamps; wrapping is explicit.
	TEST( saturating_and_wrapping_ )
		CU_ASSERT( AddSaturating( MAX_VALUE_LONG, 5L ) = MAX_VALUE_LONG )
		CU_ASSERT( AddSaturating( MIN_VALUE_LONG, -5L ) = MIN_VALUE_LONG )
		CU_ASSERT( SubSaturating( MIN_VALUE_LONG, 5L ) = MIN_VALUE_LONG )
		CU_ASSERT( MulSaturating( MAX_VALUE_LONG, 2L ) = MAX_VALUE_LONG )
		CU_ASSERT( MulSaturating( MAX_VALUE_LONG, -2L ) = MIN_VALUE_LONG )
		CU_ASSERT( MulSaturating( MIN_VALUE_LONG, 2L ) = MIN_VALUE_LONG )
		CU_ASSERT( NegSaturating( MIN_VALUE_LONGINT ) = MAX_VALUE_LONGINT )
		CU_ASSERT( AbsSaturating( MIN_VALUE_LONGINT ) = MAX_VALUE_LONGINT )
		CU_ASSERT( AddSaturating( 3L, 4L ) = 7 )

		'' unsigned saturates at 0 and MAX
		CU_ASSERT( SubSaturating( 0ul, 1ul ) = 0 )
		CU_ASSERT( AddSaturating( MAX_VALUE_ULONG, 1ul ) = MAX_VALUE_ULONG )

		'' Wrapping is exactly what the operator already does.  These exist so
		'' that DELIBERATE wrapping can be spelled as deliberate.
		CU_ASSERT( AddWrapping( MAX_VALUE_LONG, 1L ) = MIN_VALUE_LONG )

		'' The expected value is written out rather than computed, because
		'' 'MAX_VALUE_LONG * 2' is CONSTANT-FOLDED at 64 bits and so does not
		'' wrap -- it is 4294967294, where the 32-bit product is -2.  Comparing
		'' against it would be comparing against a different computation.
		CU_ASSERT( MulWrapping( MAX_VALUE_LONG, 2L ) = -2L )
		CU_ASSERT( MulWrapping( MAX_VALUE_LONG, 2L ) = clng( MAX_VALUE_LONG * 2 ) )
		CU_ASSERT( NegWrapping( MIN_VALUE_LONGINT ) = MIN_VALUE_LONGINT )
		for a as long = -1000 to 1000 step 13
			CU_ASSERT( AddWrapping( a, 7L ) = a + 7 )
			CU_ASSERT( MulWrapping( a, 3L ) = a * 3 )
		next
	END_TEST

	'' SubWrapping is the deliberate-overflow subtraction.  It exists so the
	'' INTENT is on the page: a reader does not have to work out whether the
	'' wrap was known about.  Unlike the bare operator it stays IN THE TYPE
	'' rather than promoting to an integer first.
	TEST( sub_wrapping_ )
		'' the ordinary case is just subtraction
		dim as byte a = 100, b = 100
		CU_ASSERT( SubWrapping( a, b ) = 0 )
		CU_ASSERT( SubWrapping( cbyte( 100 ), cbyte( 40 ) ) = 60 )

		'' the case it is named for: below the floor, wrapped back to the top
		CU_ASSERT( SubWrapping( cbyte( -128 ), cbyte( 1 ) ) = 127 )
		CU_ASSERT( SubWrapping( cbyte( -100 ), cbyte( 100 ) ) = 56 )

		'' unsigned wraps the same way, at zero
		CU_ASSERT( SubWrapping( cubyte( 0 ), cubyte( 1 ) ) = 255 )
		CU_ASSERT( SubWrapping( cushort( 0 ), cushort( 1 ) ) = 65535u )
		CU_ASSERT( SubWrapping( culng( 0 ), culng( 1 ) ) = 4294967295ul )

		'' the wider signed types wrap at their own edges
		CU_ASSERT( SubWrapping( cshort( -32768 ), cshort( 1 ) ) = 32767 )
		CU_ASSERT( SubWrapping( clng( -2147483648 ), clng( 1 ) ) = 2147483647 )

		'' it is the inverse of AddWrapping across the whole BYTE range, which
		'' is the property that makes it usable for checksums and ring indices
		for x as long = -128 to 127
			for y as long = -128 to 127 step 17
				dim as byte p = AddWrapping( cbyte( x ), cbyte( y ) )
				CU_ASSERT( SubWrapping( p, cbyte( y ) ) = cbyte( x ) )
			next
		next

		'' and it agrees with SubChecked wherever SubChecked has an answer
		for x as long = -128 to 127
			for y as long = -128 to 127 step 13
				var r = SubChecked( cbyte( x ), cbyte( y ) )
				if( r.HasValue( ) ) then
					CU_ASSERT( SubWrapping( cbyte( x ), cbyte( y ) ) = r.Value( ) )
				end if
			next
		next
	END_TEST

END_SUITE
