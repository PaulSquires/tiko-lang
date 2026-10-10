'' money.Currency -- C:\dev\docs\math\RFC-0003-currency.md.

#import "std/money"
#import "std/outcome"
#include once "fbcunit.bi"

#include once "fblimits.bi"

#include once "fberror.bi"

using money, outcome

using FB
private function cur( byref s as string ) as Currency
	function = CurrencyParse( s ).Value( )
end function

'' a power of ten, written independently of the header
private function hPow10i_test( byval d as long ) as longint
	dim as longint r = 1
	for i as long = 1 to d
		r *= 10
	next
	function = r
end function

SUITE( fbc_tests.math.money )

	'' RFC-0003 sections 1 and 3.
	TEST( construction_and_text_ )
		CU_ASSERT( CurrencyFromInt( 0 ).Raw( ) = 0 )
		CU_ASSERT( CurrencyFromInt( 1 ).Raw( ) = 10000 )
		CU_ASSERT( CurrencyFromInt( -1 ).Raw( ) = -10000 )
		CU_ASSERT( CurrencyFromParts( 19, 9900 ).ToString( ) = "19.9900" )
		CU_ASSERT( CurrencyFromParts( -19, 9900 ).ToString( ) = "-19.9900" )
		CU_ASSERT( CurrencyFromRaw( 1 ).ToString( ) = "0.0001" )

		'' ALWAYS four decimals, invariant separator, no grouping
		CU_ASSERT( cur( "19.99" ).ToString( ) = "19.9900" )
		CU_ASSERT( cur( "0" ).ToString( ) = "0.0000" )
		CU_ASSERT( cur( "-0.0001" ).ToString( ) = "-0.0001" )
		CU_ASSERT( cur( "1234567.8901" ).ToString( ) = "1234567.8901" )

		'' the range endpoints
		CU_ASSERT( CurrencyFromRaw( MAX_VALUE_LONGINT ).ToString( ) = "922337203685477.5807" )
		CU_ASSERT( CurrencyFromRaw( MIN_VALUE_LONGINT + 1 ).ToString( ) = "-922337203685477.5807" )

		'' ROUND TRIP, exactly, over a spread of values
		for r as longint = -100000 to 100000 step 37
			dim as Currency c = CurrencyFromRaw( r )
			CU_ASSERT( CurrencyParse( c.ToString( ) ).Value( ).Raw( ) = r )
		next
	END_TEST

	'' RFC-0003 section 3.  Strict: MORE THAN FOUR PLACES IS AN ERROR, not a
	'' truncation.  Silently dropping a digit the caller wrote is how a
	'' fixed-scale type loses money.
	TEST( parse_is_strict_ )
		CU_ASSERT( CurrencyParse( "1.23456" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1.00001" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "abc" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( " 1" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1 " ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1.2.3" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1." ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "." ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "-" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1,234" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "$1" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "1e3" ).HasValue( ) = false )
		CU_ASSERT( CurrencyParse( "99999999999999999" ).HasValue( ) = false )

		'' ...and a legitimate zero is NOT a failure, which is the whole point
		CU_ASSERT( CurrencyParse( "0" ).HasValue( ) )
		CU_ASSERT( CurrencyParse( "0" ).Value( ).Raw( ) = 0 )
		CU_ASSERT( CurrencyParse( "0.0000" ).HasValue( ) )
		CU_ASSERT( CurrencyParse( "+1.5" ).Value( ).Raw( ) = 15000 )
		CU_ASSERT( CurrencyParse( "1.5" ).Value( ).Raw( ) = 15000 )
		CU_ASSERT( CurrencyParse( "1.05" ).Value( ).Raw( ) = 10500 )
	END_TEST

	'' RFC-0003 section 4.  Addition and subtraction are EXACT.
	TEST( exact_addition_ )
		CU_ASSERT( ( cur( "0.1" ) + cur( "0.2" ) ) = cur( "0.3" ) )
		CU_ASSERT( ( cur( "19.99" ) + cur( "19.99" ) ).ToString( ) = "39.9800" )
		CU_ASSERT( ( cur( "0" ) - cur( "0.0001" ) ).ToString( ) = "-0.0001" )

		'' THE PROPERTY a DOUBLE cannot give: a + b - b = a, bitwise, always
		for i as longint = -50000 to 50000 step 91
			for j as longint = -3000 to 3000 step 617
				dim as Currency a = CurrencyFromRaw( i ), b = CurrencyFromRaw( j )
				CU_ASSERT( ( ( a + b ) - b ).Raw( ) = a.Raw( ) )
			next
		next

		'' and the DOUBLE really does fail the equivalent, so the point is
		'' demonstrated rather than asserted
		CU_ASSERT( ( 0.1 + 0.2 ) <> 0.3 )
		CU_ASSERT( ( cur( "0.1" ) + cur( "0.2" ) ).Raw( ) = 3000 )
	END_TEST

	'' RFC-0003 section 4.  Multiplication by an integer is exact.
	TEST( multiplication_ )
		CU_ASSERT( ( cur( "19.99" ) * 3LL ).ToString( ) = "59.9700" )
		CU_ASSERT( ( 3LL * cur( "19.99" ) ).ToString( ) = "59.9700" )
		CU_ASSERT( ( cur( "1.5" ) * 0LL ).Raw( ) = 0 )
		CU_ASSERT( ( cur( "-2.5" ) * 4LL ).ToString( ) = "-10.0000" )

		for i as longint = -2000 to 2000 step 37
			for n as longint = -20 to 20
				dim as Currency p = CurrencyFromRaw( i ) * n
				CU_ASSERT( p.Raw( ) = i * n )
			next
		next

		'' by a DOUBLE: rounded, not exact -- and the name does not pretend
		CU_ASSERT( ( cur( "100" ) * 0.5 ).ToString( ) = "50.0000" )
		CU_ASSERT( ( cur( "10" ) * 0.075 ).ToString( ) = "0.7500" )

		'' Currency * Currency does not exist; this is the deliberate gap.
		'' ( no assertion is possible for a call that must not compile )
	END_TEST

	'' RFC-0003 section 4.  Division ROUNDS HALF-TO-EVEN.  Truncation would
	'' bias every result downward across a ledger.
	TEST( division_rounds_not_truncates_ )
		CU_ASSERT( ( CurrencyFromInt( 1 ) / 3LL ).ToString( ) = "0.3333" )
		CU_ASSERT( ( CurrencyFromInt( 2 ) / 3LL ).ToString( ) = "0.6667" )
		CU_ASSERT( ( CurrencyFromInt( 1 ) / 3LL ).Raw( ) = 3333 )
		CU_ASSERT( ( CurrencyFromInt( 2 ) / 3LL ).Raw( ) = 6667 )

		'' truncation would have given 6666 -- pinned, so the rounding cannot
		'' be silently removed
		CU_ASSERT( ( 20000LL \ 3LL ) = 6666 )

		CU_ASSERT( ( CurrencyFromInt( 10 ) / 4LL ).ToString( ) = "2.5000" )
		CU_ASSERT( ( CurrencyFromInt( -1 ) / 3LL ).ToString( ) = "-0.3333" )
		CU_ASSERT( ( CurrencyFromInt( -2 ) / 3LL ).ToString( ) = "-0.6667" )

		'' exact ties go to even
		CU_ASSERT( ( CurrencyFromRaw( 5 ) / 2LL ).Raw( ) = 2 )      '' 2.5 -> 2
		CU_ASSERT( ( CurrencyFromRaw( 15 ) / 2LL ).Raw( ) = 8 )     '' 7.5 -> 8
		CU_ASSERT( ( CurrencyFromRaw( -5 ) / 2LL ).Raw( ) = -2 )
		CU_ASSERT( ( CurrencyFromRaw( -15 ) / 2LL ).Raw( ) = -8 )

		'' the quotient is always within half a unit of the true value
		for i as longint = -5000 to 5000 step 13
			for n as longint = 1 to 17
				dim as Currency q = CurrencyFromRaw( i ) / n
				dim as longint err2 = ( q.Raw( ) * n - i ) * 2
				if( err2 < 0 ) then err2 = -err2
				CU_ASSERT( err2 <= n )
			next
		next

		CU_ASSERT( ( CurrencyFromInt( 1 ) / 0LL ).IsValid( ) = false )

		'' Currency / Currency is a dimensionless DOUBLE
		CU_ASSERT( ( CurrencyFromInt( 10 ) / CurrencyFromInt( 4 ) ) = 2.5 )
	END_TEST

	'' RFC-0003 section 4.  Invalid is infectious and Invalid = Invalid is false.
	TEST( invalid_ )
		dim as Currency ovf = CurrencyFromRaw( MAX_VALUE_LONGINT ) + CurrencyFromRaw( 1 )
		CU_ASSERT( ovf.IsValid( ) = false )
		CU_ASSERT( ovf.ToString( ) = "Invalid" )

		dim as Currency u = CurrencyFromRaw( MIN_VALUE_LONGINT + 1 ) - CurrencyFromRaw( 1 )
		CU_ASSERT( u.IsValid( ) = false )

		'' infectious through every operator
		CU_ASSERT( ( ovf + CurrencyFromInt( 1 ) ).IsValid( ) = false )
		CU_ASSERT( ( ovf - CurrencyFromInt( 1 ) ).IsValid( ) = false )
		CU_ASSERT( ( ovf * 2LL ).IsValid( ) = false )
		CU_ASSERT( ( ovf / 2LL ).IsValid( ) = false )
		CU_ASSERT( ( -ovf ).IsValid( ) = false )
		CU_ASSERT( ovf.Round( 2 ).IsValid( ) = false )
		CU_ASSERT( ovf.AbsValue( ).IsValid( ) = false )

		'' INVALID = INVALID IS FALSE.  Test with IsValid, as with DateTime.
		CU_ASSERT( ( ovf = ovf ) = false )
		CU_ASSERT( ( ovf <> ovf ) = true )

		'' a default-constructed Currency is ZERO and VALID -- zero is the
		'' meaningful default for money, unlike Result's failure default
		dim as Currency fresh
		CU_ASSERT( fresh.IsValid( ) )
		CU_ASSERT( fresh.Raw( ) = 0 )

		'' overflow in multiplication
		CU_ASSERT( ( CurrencyFromRaw( 4000000000000LL ) * 4000000LL ).IsValid( ) = false )
		CU_ASSERT( CurrencyFromInt( MAX_VALUE_LONGINT ).IsValid( ) = false )
		CU_ASSERT( CurrencyFromDouble( 1e30 ).IsValid( ) = false )
	END_TEST

	'' RFC-0003 section 5.
	TEST( rounding_ )
		CU_ASSERT( cur( "1.2345" ).Round( 2 ).ToString( ) = "1.2300" )
		CU_ASSERT( cur( "1.2350" ).Round( 2 ).ToString( ) = "1.2400" )   '' tie -> even (4)
		CU_ASSERT( cur( "1.2250" ).Round( 2 ).ToString( ) = "1.2200" )   '' tie -> even (2)
		CU_ASSERT( cur( "1.2351" ).Round( 2 ).ToString( ) = "1.2400" )
		CU_ASSERT( cur( "-1.2350" ).Round( 2 ).ToString( ) = "-1.2400" )
		CU_ASSERT( cur( "1.5" ).Round( 0 ).ToString( ) = "2.0000" )
		CU_ASSERT( cur( "2.5" ).Round( 0 ).ToString( ) = "2.0000" )      '' banker's
		CU_ASSERT( cur( "1.9999" ).Round( 4 ).ToString( ) = "1.9999" )

		'' the explicit modes
		CU_ASSERT( cur( "2.5" ).RoundMode( 0, CUR_HALF_UP ).ToString( ) = "3.0000" )
		CU_ASSERT( cur( "2.5" ).RoundMode( 0, CUR_HALF_DOWN ).ToString( ) = "2.0000" )
		CU_ASSERT( cur( "2.1" ).RoundMode( 0, CUR_UP ).ToString( ) = "3.0000" )
		CU_ASSERT( cur( "2.9" ).RoundMode( 0, CUR_DOWN ).ToString( ) = "2.0000" )
		CU_ASSERT( cur( "-2.1" ).RoundMode( 0, CUR_FLOOR ).ToString( ) = "-3.0000" )
		CU_ASSERT( cur( "-2.9" ).RoundMode( 0, CUR_CEILING ).ToString( ) = "-2.0000" )

		CU_ASSERT( cur( "2.7" ).Floor( ).ToString( ) = "2.0000" )
		CU_ASSERT( cur( "-2.1" ).Floor( ).ToString( ) = "-3.0000" )
		CU_ASSERT( cur( "2.1" ).Ceiling( ).ToString( ) = "3.0000" )
		CU_ASSERT( cur( "-2.9" ).Ceiling( ).ToString( ) = "-2.0000" )
		CU_ASSERT( cur( "-2.9" ).Truncate( ).ToString( ) = "-2.0000" )
		CU_ASSERT( cur( "2.9" ).Truncate( ).ToString( ) = "2.0000" )

		CU_ASSERT( cur( "1.5" ).Round( 5 ).IsValid( ) = false )
		CU_ASSERT( cur( "1.5" ).Round( -1 ).IsValid( ) = false )

		'' rounding never moves a value by more than half a unit
		for r as longint = -20000 to 20000 step 7
			dim as Currency c = CurrencyFromRaw( r )
			for d as long = 0 to 4
				dim as longint moved = c.Round( d ).Raw( ) - r
				if( moved < 0 ) then moved = -moved
				CU_ASSERT( moved * 2 <= hPow10i_test( 4 - d ) )
			next
		next
	END_TEST

	'' RFC-0003 section 5.  The parts must sum EXACTLY to the total.
	TEST( apportion_ )
		dim as longint w3( 0 to 2 ) = { 1, 1, 1 }
		dim as Currency p3( )
		Apportion( CurrencyFromInt( 100 ), w3( ), p3( ) )
		CU_ASSERT( ( p3( 0 ) + p3( 1 ) + p3( 2 ) ) = CurrencyFromInt( 100 ) )
		CU_ASSERT( p3( 0 ).Raw( ) + p3( 1 ).Raw( ) + p3( 2 ).Raw( ) = 1000000 )

		'' uneven weights
		dim as longint w2( 0 to 1 ) = { 1, 2 }
		dim as Currency p2( )
		Apportion( cur( "10" ), w2( ), p2( ) )
		CU_ASSERT( ( p2( 0 ) + p2( 1 ) ) = cur( "10" ) )

		'' a zero weight gets nothing, and the total still reconciles
		dim as longint wz( 0 to 2 ) = { 0, 1, 1 }
		dim as Currency pz( )
		Apportion( cur( "7.77" ), wz( ), pz( ) )
		CU_ASSERT( pz( 0 ).Raw( ) = 0 )
		CU_ASSERT( ( pz( 0 ) + pz( 1 ) + pz( 2 ) ) = cur( "7.77" ) )

		'' THE PROPERTY, over many totals and shapes: the parts sum to the
		'' total, exactly, every time.
		for t as longint = -5000 to 5000 step 111
			dim as longint w( 0 to 3 ) = { 1, 2, 3, 5 }
			dim as Currency p( )
			Apportion( CurrencyFromRaw( t ), w( ), p( ) )
			dim as longint sum_ = 0
			for i as long = 0 to 3
				sum_ += p( i ).Raw( )
			next
			CU_ASSERT( sum_ = t )
		next
	END_TEST

	'' RFC-0003 section 7.  Accumulate below 0.0001, quantise once.
	TEST( accumulator_ )
		dim acc as CurrencyAccum
		acc.Reset( )
		for i as long = 1 to 3
			acc.Add( CurrencyFromRaw( 3333 ) )
		next
		CU_ASSERT( acc.Count( ) = 3 )
		CU_ASSERT( acc.Total( ).ToString( ) = "0.9999" )

		'' Add is exact: accumulating then totalling equals summing
		acc.Reset( )
		dim as Currency direct
		for i as longint = 1 to 200
			dim as Currency c = CurrencyFromRaw( i * 7 )
			acc.Add( c )
			direct = direct + c
		next
		CU_ASSERT( acc.Total( ) = direct )

		'' THE CASE THAT LOSES MONEY: rounding at every line versus once.
		'' A third of a penny, a hundred times.
		acc.Reset( )
		dim as Currency perline
		for i as long = 1 to 100
			acc.AddScaled( CurrencyFromRaw( 1 ), 1, 3 )
			perline = perline + ( CurrencyFromRaw( 1 ) / 3LL )
		next
		'' rounding each line gives zero -- every line rounds 0.0000333 to 0
		CU_ASSERT( perline.Raw( ) = 0 )
		'' accumulating gives the honest answer, 100/3 of a unit = 33 units
		CU_ASSERT( acc.Total( ).Raw( ) = 33 )

		acc.Reset( )
		CU_ASSERT( acc.Count( ) = 0 )
		CU_ASSERT( acc.Total( ).Raw( ) = 0 )
	END_TEST

	'' RFC-0003 section 6.  The layout IS the COM CY layout.
	TEST( interop_layout_ )
		CU_ASSERT( sizeof( Currency ) = 8 )

		'' the raw field is the scaled int64 that CY.int64 holds
		dim as Currency c = cur( "19.99" )
		CU_ASSERT( c.Raw( ) = 199900 )

		'' round-trips through the raw representation, which is what a
		'' reinterpret to CY would do
		for r as longint = -1000000 to 1000000 step 7919
			CU_ASSERT( CurrencyFromRaw( r ).Raw( ) = r )
		next
	END_TEST

	'' RFC-0003 section 4.  Invalid is an ABSORBING value, not an error return:
	'' it survives arithmetic instead of being papered over, and it never
	'' compares equal to anything -- IsValid is the only test for it.
	TEST( invalid_absorbs_ )
		dim as Currency bad = CurrencyInvalid( )
		CU_ASSERT( bad.IsValid( ) = false )

		dim as Currency ten = CurrencyFromInt( 10 )
		CU_ASSERT( ten.IsValid( ) )

		'' it wins from either side of every operator
		CU_ASSERT( ( bad + ten ).IsValid( ) = false )
		CU_ASSERT( ( ten + bad ).IsValid( ) = false )
		CU_ASSERT( ( bad - ten ).IsValid( ) = false )
		CU_ASSERT( ( ten - bad ).IsValid( ) = false )
		CU_ASSERT( ( -bad ).IsValid( ) = false )

		'' and through the rounding family too
		CU_ASSERT( bad.Round( 2 ).IsValid( ) = false )
		CU_ASSERT( bad.Floor( ).IsValid( ) = false )
		CU_ASSERT( bad.Ceiling( ).IsValid( ) = false )
		CU_ASSERT( bad.Truncate( ).IsValid( ) = false )
		CU_ASSERT( bad.AbsValue( ).IsValid( ) = false )

		'' NOT equal to itself -- the NaN rule, and the reason IsValid exists
		CU_ASSERT( ( bad = CurrencyInvalid( ) ) = false )
		CU_ASSERT( ( bad = ten ) = false )
	END_TEST

	'' ToDouble is NAMED so that leaving exact arithmetic is always visible in
	'' the source.  There is no implicit conversion to double.
	TEST( to_double_ )
		CU_ASSERT( CurrencyFromParts( 12, 3400 ).ToDouble( ) = 12.34 )
		CU_ASSERT( CurrencyFromInt( 0 ).ToDouble( ) = 0.0 )
		CU_ASSERT( CurrencyFromInt( -7 ).ToDouble( ) = -7.0 )

		'' every value with an exact binary expansion round-trips.  Note the
		'' magnitude is always positive: CurrencyFromParts takes the SIGN FROM
		'' `whole` and adds the ten-thousandths away from zero.
		for i as longint = -500 to 500
			dim as Currency c = CurrencyFromParts( i, 2500 )
			CU_ASSERT( abs( c.ToDouble( ) - ( i + 0.25 * iif( i < 0, -1, 1 ) ) ) < 1e-9 )
		next

		'' a value that does NOT survive as a double still converts, which is
		'' exactly the loss the named call is there to make visible
		dim as Currency third = CurrencyFromParts( 0, 3333 )
		CU_ASSERT( abs( third.ToDouble( ) - 0.3333 ) < 1e-12 )
	END_TEST

	'' AddProduct applies a rate per line and rounds ONCE, at the end -- the
	'' difference between it and rounding each line is the whole reason the
	'' accumulator exists.
	TEST( accum_add_product_ )
		dim acc as CurrencyAccum
		dim as Currency line_ = CurrencyFromDouble( 19.99 )

		for i as long = 1 to 3
			acc.AddProduct( line_, 0.075 )
		next

		CU_ASSERT( acc.Count( ) = 3 )

		'' 19.99 * 0.075 = 1.49925, three of them = 4.49775, and the
		'' accumulator keeps the extra digits until Total is asked for
		CU_ASSERT( abs( acc.Total( ).ToDouble( ) - 4.4978 ) < 5e-5 )

		'' a rate of one is the plain Add
		dim b1 as CurrencyAccum, b2 as CurrencyAccum
		for i as long = 1 to 10
			b1.AddProduct( line_, 1.0 )
			b2.Add( line_ )
		next
		CU_ASSERT( b1.Count( ) = b2.Count( ) )
		CU_ASSERT( b1.Total( ).Raw( ) = b2.Total( ).Raw( ) )

		'' a rate of zero contributes nothing but still counts as a line
		dim z as CurrencyAccum
		z.AddProduct( line_, 0.0 )
		CU_ASSERT( z.Count( ) = 1 )
		CU_ASSERT( z.Total( ).Raw( ) = 0 )

		'' Reset clears the running product as well as the count
		acc.Reset( )
		CU_ASSERT( acc.Count( ) = 0 )
		CU_ASSERT( acc.Total( ).Raw( ) = 0 )
	END_TEST

END_SUITE
