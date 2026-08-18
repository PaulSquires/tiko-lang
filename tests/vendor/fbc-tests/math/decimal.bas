'' FB.Decimal -- 128-bit decimal, the .NET 'System.Decimal' shape.
''
'' Every expectation in dotnet_pinned_ was produced by running the same
'' expression through .NET's own System.Decimal and copying the answer back;
'' the 24,000-pair differential run behind them is recorded in
'' C:\dev\fbc-modern\docs\decimal\decimal.txt.

#include once "fbcunit.bi"
#include once "fb/decimal.bi"

using FB

private function d_( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

'' a decimal string built independently of the header, from a digit string and
'' a scale, so that ToString is checked against something that is not itself
private function place_( byref digits as string, byval scale as long ) as string
	dim as string d = digits
	if( scale = 0 ) then return d
	while( len( d ) <= scale )
		d = "0" + d
	wend
	function = left( d, len( d ) - scale ) + "." + right( d, scale )
end function

private function apply_( byref a as Decimal, byref op as string, byref b as Decimal ) as Decimal
	select case op
	case "+" : return a + b
	case "-" : return a - b
	case "*" : return a * b
	case "/" : return a / b
	end select
	function = a mod b
end function

#macro CASE_( a, op, b, want )
	scope
		dim as Decimal r_ = apply_( d_( a ), op, d_( b ) )
		CU_ASSERT( r_.ToString( ) = want )
	end scope
#endmacro

SUITE( fbc_tests.math.dec )

	'' ---------------------------------------------------------------------
	'' Construction, and the accessors that read the representation back
	'' ---------------------------------------------------------------------
	TEST( construction_ )
		CU_ASSERT( DecimalZero( ).IsValid( ) )
		CU_ASSERT( DecimalZero( ).IsZero( ) )
		CU_ASSERT( DecimalZero( ).Sign( ) = 0 )
		CU_ASSERT( DecimalZero( ).Scale( ) = 0 )
		CU_ASSERT( DecimalZero( ).ToString( ) = "0" )

		'' a default-constructed Decimal is ZERO and VALID -- zero is the
		'' meaningful default for a number
		dim as Decimal fresh
		CU_ASSERT( fresh.IsValid( ) )
		CU_ASSERT( fresh.IsZero( ) )
		CU_ASSERT( fresh.ToString( ) = "0" )

		CU_ASSERT( DecimalOne( ).ToString( ) = "1" )
		CU_ASSERT( DecimalOne( ).Sign( ) = 1 )
		CU_ASSERT( DecimalOne( ).IsNegative( ) = false )
		CU_ASSERT( DecimalMinusOne( ).ToString( ) = "-1" )
		CU_ASSERT( DecimalMinusOne( ).Sign( ) = -1 )
		CU_ASSERT( DecimalMinusOne( ).IsNegative( ) )

		'' the range endpoints, which are 2^96-1 with each sign
		CU_ASSERT( DecimalMaxValue( ).ToString( ) = "79228162514264337593543950335" )
		CU_ASSERT( DecimalMinValue( ).ToString( ) = "-79228162514264337593543950335" )
		CU_ASSERT( DecimalMaxValue( ).Lo( ) = &hFFFFFFFFul )
		CU_ASSERT( DecimalMaxValue( ).Mid( ) = &hFFFFFFFFul )
		CU_ASSERT( DecimalMaxValue( ).Hi( ) = &hFFFFFFFFul )
		CU_ASSERT( DecimalMaxValue( ).Scale( ) = 0 )
		CU_ASSERT( DecimalMinValue( ).IsNegative( ) )

		CU_ASSERT( DecimalFromInt( 0 ).ToString( ) = "0" )
		CU_ASSERT( DecimalFromInt( 1 ).ToString( ) = "1" )
		CU_ASSERT( DecimalFromInt( -1 ).ToString( ) = "-1" )
		CU_ASSERT( DecimalFromInt( 1234567890123456789ll ).ToString( ) = "1234567890123456789" )
		'' MIN_VALUE_LONGINT has no positive counterpart in a LONGINT, and is
		'' exactly where a naive negation wraps
		CU_ASSERT( DecimalFromInt( MIN_VALUE_LONGINT ).ToString( ) = "-9223372036854775808" )
		CU_ASSERT( DecimalFromInt( MAX_VALUE_LONGINT ).ToString( ) = "9223372036854775807" )
		CU_ASSERT( DecimalFromUInt( 18446744073709551615ull ).ToString( ) = "18446744073709551615" )
		CU_ASSERT( DecimalFromUInt( 0ull ).IsZero( ) )

		CU_ASSERT( DecimalFromScaled( 1999, 2 ).ToString( ) = "19.99" )
		CU_ASSERT( DecimalFromScaled( -1999, 2 ).ToString( ) = "-19.99" )
		CU_ASSERT( DecimalFromScaled( 1, 28 ).ToString( ) = "0.0000000000000000000000000001" )
		CU_ASSERT( DecimalFromScaled( 0, 4 ).ToString( ) = "0.0000" )
		CU_ASSERT( DecimalFromScaled( 1, 29 ).IsValid( ) = false )
		CU_ASSERT( DecimalFromScaled( 1, -1 ).IsValid( ) = false )

		'' the .NET constructor, limb for limb
		CU_ASSERT( DecimalFromParts( 1, 0, 0, false, 0 ).ToString( ) = "1" )
		CU_ASSERT( DecimalFromParts( 0, 1, 0, false, 0 ).ToString( ) = "4294967296" )
		CU_ASSERT( DecimalFromParts( 0, 0, 1, false, 0 ).ToString( ) = "18446744073709551616" )
		CU_ASSERT( DecimalFromParts( 1, 0, 0, true, 4 ).ToString( ) = "-0.0001" )
		CU_ASSERT( DecimalFromParts( 1, 0, 0, false, 29 ).IsValid( ) = false )
		CU_ASSERT( DecimalFromParts( 1, 0, 0, false, -1 ).IsValid( ) = false )

		'' the limbs come back out unchanged
		dim as Decimal p = DecimalFromParts( 305419896, 2271560481, 16, true, 7 )
		CU_ASSERT( p.Lo( ) = 305419896 )
		CU_ASSERT( p.Mid( ) = 2271560481 )
		CU_ASSERT( p.Hi( ) = 16 )
		CU_ASSERT( p.Scale( ) = 7 )
		CU_ASSERT( p.IsNegative( ) )

		'' a zero mantissa never carries a sign, so there is no negative zero
		CU_ASSERT( DecimalFromParts( 0, 0, 0, true, 2 ).IsNegative( ) = false )
		CU_ASSERT( DecimalFromParts( 0, 0, 0, true, 2 ).ToString( ) = "0.00" )
		CU_ASSERT( DecimalFromParts( 0, 0, 0, true, 2 ).Sign( ) = 0 )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Parsing.  STRICT: the whole string must be consumed, and more than 28
	'' decimal places is an ERROR rather than a truncation.
	'' ---------------------------------------------------------------------
	TEST( parse_is_strict_ )
		CU_ASSERT( DecimalParse( "0" ).HasValue( ) )
		CU_ASSERT( DecimalParse( "19.99" ).Value( ).ToString( ) = "19.99" )
		CU_ASSERT( DecimalParse( "+19.99" ).Value( ).ToString( ) = "19.99" )
		CU_ASSERT( DecimalParse( "-19.99" ).Value( ).ToString( ) = "-19.99" )
		CU_ASSERT( DecimalParse( "0.0000000000000000000000000001" ).Value( ).Scale( ) = 28 )
		CU_ASSERT( DecimalParse( "79228162514264337593543950335" ).Value( ).ToString( ) = "79228162514264337593543950335" )
		CU_ASSERT( DecimalParse( "-0" ).Value( ).IsNegative( ) = false )
		CU_ASSERT( DecimalParse( "000123" ).Value( ).ToString( ) = "123" )

		'' 29 decimal places: an ERROR, not a silent 28
		CU_ASSERT( DecimalParse( "0.00000000000000000000000000001" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "1.12345678901234567890123456789" ).HasValue( ) = false )
		'' one past 2^96-1
		CU_ASSERT( DecimalParse( "79228162514264337593543950336" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "-79228162514264337593543950336" ).HasValue( ) = false )

		CU_ASSERT( DecimalParse( "" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "abc" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( " 1" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "1 " ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "1.2.3" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "1." ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( ".1" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "-" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "+" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "1e3" ).HasValue( ) = false )     '' no exponent grammar
		CU_ASSERT( DecimalParse( "1,234" ).HasValue( ) = false )
		CU_ASSERT( DecimalParse( "12abc" ).HasValue( ) = false )   '' not a prefix parse
		CU_ASSERT( DecimalParse( "--1" ).HasValue( ) = false )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Text.  ToString is exact and prints EXACTLY 'scale' decimals; parsing
	'' that string returns the identical representation, scale included.
	'' ---------------------------------------------------------------------
	TEST( text_round_trip_ )
		CU_ASSERT( DecimalFromScaled( 1, 0 ).ToString( ) = "1" )
		CU_ASSERT( DecimalFromScaled( 10, 1 ).ToString( ) = "1.0" )
		CU_ASSERT( DecimalFromScaled( 100, 2 ).ToString( ) = "1.00" )
		CU_ASSERT( DecimalFromScaled( -5, 3 ).ToString( ) = "-0.005" )
		CU_ASSERT( DecimalInvalid( ).ToString( ) = "Invalid" )

		'' every scale, both signs, against an independently built string
		for sc as long = 0 to 28
			dim as Decimal d = DecimalFromScaled( 123456789ll, sc )
			CU_ASSERT( d.ToString( ) = place_( "123456789", sc ) )
			CU_ASSERT( d.Scale( ) = sc )
			CU_ASSERT( DecimalParse( d.ToString( ) ).Value( ).Scale( ) = sc )
			CU_ASSERT( DecimalParse( d.ToString( ) ).Value( ).ToString( ) = d.ToString( ) )

			dim as Decimal n = DecimalFromScaled( -123456789ll, sc )
			CU_ASSERT( n.ToString( ) = "-" + place_( "123456789", sc ) )
			CU_ASSERT( DecimalParse( n.ToString( ) ).Value( ).ToString( ) = n.ToString( ) )
		next

		'' a broad sweep of mantissas at a spread of scales
		for m as longint = -100000 to 100000 step 37
			for sc as long = 0 to 6
				dim as Decimal d = DecimalFromScaled( m, sc )
				dim as Decimal back = DecimalParse( d.ToString( ) ).Value( )
				CU_ASSERT( back.ToString( ) = d.ToString( ) )
				CU_ASSERT( back.Scale( ) = d.Scale( ) )
				CU_ASSERT( back = d )
			next
		next

		'' ToStringFixed forces the scale, growing as well as shrinking
		CU_ASSERT( d_( "1.5" ).ToStringFixed( 4 ) = "1.5000" )
		CU_ASSERT( d_( "1.5" ).ToStringFixed( 0 ) = "2" )         '' half-to-even
		CU_ASSERT( d_( "2.5" ).ToStringFixed( 0 ) = "2" )
		CU_ASSERT( d_( "-1.005" ).ToStringFixed( 2 ) = "-1.00" )
		CU_ASSERT( d_( "1" ).ToStringFixed( 28 ) = "1.0000000000000000000000000000" )
		CU_ASSERT( DecimalInvalid( ).ToStringFixed( 2 ) = "Invalid" )
	END_TEST

	'' ---------------------------------------------------------------------
	'' THE SCALE IS PART OF THE VALUE, NOT PART OF THE FORMATTING.  1.10 and
	'' 1.1 are equal, print differently, and report different scales.
	'' ---------------------------------------------------------------------
	TEST( scale_is_observable_but_not_compared_ )
		dim as Decimal a = d_( "1.10" )
		dim as Decimal b = d_( "1.1" )
		CU_ASSERT( a = b )
		CU_ASSERT( ( a <> b ) = false )
		CU_ASSERT( DecimalCompare( a, b ) = 0 )
		CU_ASSERT( a.ToString( ) = "1.10" )
		CU_ASSERT( b.ToString( ) = "1.1" )
		CU_ASSERT( a.Scale( ) = 2 )
		CU_ASSERT( b.Scale( ) = 1 )

		'' equal values, every scale a 7 can reach
		for sc as long = 0 to 27
			dim as Decimal x = DecimalFromScaled( 7, 0 )
			dim as Decimal y = DecimalFromScaled( 7, 0 ).Rescale( sc )
			CU_ASSERT( x = y )
			CU_ASSERT( y.Scale( ) = sc )
			CU_ASSERT( DecimalCompare( x, y ) = 0 )
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Addition and subtraction.  EXACT, and the result carries the wider of
	'' the two scales.
	'' ---------------------------------------------------------------------
	TEST( addition_ )
		'' the reason the type exists
		CU_ASSERT( ( d_( "0.1" ) + d_( "0.2" ) ).ToString( ) = "0.3" )
		CU_ASSERT( ( d_( "0.1" ) + d_( "0.2" ) ) = d_( "0.3" ) )
		CU_ASSERT( 0.1 + 0.2 <> 0.3 )                              '' the DOUBLE does not

		CU_ASSERT( ( d_( "1.0" ) + d_( "2.00" ) ).ToString( ) = "3.00" )
		CU_ASSERT( ( d_( "1" ) - d_( "1.00" ) ).ToString( ) = "0.00" )
		CU_ASSERT( ( d_( "1" ) - d_( "1.00" ) ).IsZero( ) )
		CU_ASSERT( ( d_( "-5" ) + d_( "3" ) ).ToString( ) = "-2" )
		CU_ASSERT( ( d_( "5" ) - d_( "8" ) ).ToString( ) = "-3" )
		CU_ASSERT( ( d_( "-5" ) - d_( "-8" ) ).ToString( ) = "3" )

		'' 28 places plus 28 places, no loss
		CU_ASSERT( ( d_( "0.0000000000000000000000000001" ) + d_( "0.0000000000000000000000000002" ) ).ToString( ) = "0.0000000000000000000000000003" )

		'' a + b - b = a, bit for bit, over a spread of scales and signs
		for m as longint = -5000 to 5000 step 7
			for sc as long = 0 to 8
				dim as Decimal x = DecimalFromScaled( m, sc )
				dim as Decimal y = DecimalFromScaled( 98765, 4 )
				dim as Decimal r = x + y
				r = r - y
				CU_ASSERT( r = x )
				CU_ASSERT( ( x + y ) = ( y + x ) )                 '' commutative
				CU_ASSERT( ( x - y ) = -( y - x ) )
			next
		next

		'' associativity holds because every intermediate is exact
		dim as Decimal p = d_( "0.1" ), q = d_( "0.02" ), s = d_( "0.003" )
		CU_ASSERT( ( ( p + q ) + s ) = ( p + ( q + s ) ) )
		CU_ASSERT( ( ( p + q ) + s ).ToString( ) = "0.123" )

		'' the identity, and self-subtraction, at every scale
		for sc as long = 0 to 28
			dim as Decimal z = DecimalFromScaled( 12345, 4 ).Rescale( sc )
			if( z.IsValid( ) ) then
				CU_ASSERT( ( z + DecimalZero( ) ) = z )
				CU_ASSERT( ( z - z ).IsZero( ) )
			end if
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Multiplication.  Scale is the SUM of the operand scales, reduced only
	'' when the mantissa will not fit 96 bits or the scale would pass 28.
	'' ---------------------------------------------------------------------
	TEST( multiplication_ )
		CU_ASSERT( ( d_( "1.5" ) * d_( "2" ) ).ToString( ) = "3.0" )
		CU_ASSERT( ( d_( "1.10" ) * d_( "1.00" ) ).ToString( ) = "1.1000" )
		CU_ASSERT( ( d_( "1.0000" ) * d_( "1.0000" ) ).ToString( ) = "1.00000000" )
		CU_ASSERT( ( d_( "1.000" ) * d_( "1000" ) ).ToString( ) = "1000.000" )
		CU_ASSERT( ( d_( "-3" ) * d_( "4" ) ).ToString( ) = "-12" )
		CU_ASSERT( ( d_( "-3" ) * d_( "-4" ) ).ToString( ) = "12" )
		CU_ASSERT( ( d_( "0" ) * d_( "-4" ) ).IsNegative( ) = false )

		'' the worked example from the header
		dim as Decimal price = d_( "19.99" )
		dim as Decimal line_ = price * 3
		CU_ASSERT( line_.ToString( ) = "59.97" )
		CU_ASSERT( ( line_ * d_( "0.0825" ) ).ToString( ) = "4.947525" )

		'' 28 significant digits kept
		CU_ASSERT( ( d_( "123456789012345678901234567.8" ) * d_( "10" ) ).ToString( ) = "1234567890123456789012345678.0" )

		'' commutativity and the identities, over a sweep
		for m as longint = -300 to 300 step 3
			for sc as long = 0 to 8
				dim as Decimal x = DecimalFromScaled( m, sc )
				dim as Decimal y = d_( "12.345" )
				CU_ASSERT( ( x * y ) = ( y * x ) )
				CU_ASSERT( ( x * DecimalOne( ) ) = x )
				CU_ASSERT( ( x * DecimalMinusOne( ) ) = -x )
				CU_ASSERT( ( x * DecimalZero( ) ).IsZero( ) )
			next
		next

		'' distributive, which only holds because nothing rounds here
		for m as longint = -50 to 50
			dim as Decimal x = DecimalFromScaled( m, 3 )
			dim as Decimal y = d_( "7.25" )
			dim as Decimal z = d_( "0.031" )
			CU_ASSERT( ( x * ( y + z ) ) = ( ( x * y ) + ( x * z ) ) )
		next

		'' UNDERFLOW: both operands nonzero, the product below 1e-28
		dim as Decimal tiny = d_( "0.0000000000000000000000000001" ) * d_( "0.1" )
		CU_ASSERT( tiny.IsZero( ) )
		CU_ASSERT( tiny.IsValid( ) )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Division.  The terminating quotient when there is one, 28 digits when
	'' there is not, rounded half-to-even -- NOT truncated.
	'' ---------------------------------------------------------------------
	TEST( division_ )
		CU_ASSERT( ( d_( "1" ) / d_( "3" ) ).ToString( ) = "0.3333333333333333333333333333" )
		CU_ASSERT( ( d_( "2" ) / d_( "3" ) ).ToString( ) = "0.6666666666666666666666666667" )
		'' truncation would have given ...6666; it rounds
		CU_ASSERT( ( d_( "2" ) / d_( "3" ) ) <> d_( "0.6666666666666666666666666666" ) )

		CU_ASSERT( ( d_( "1" ) / d_( "4" ) ).ToString( ) = "0.25" )
		CU_ASSERT( ( d_( "1" ) / d_( "8" ) ).ToString( ) = "0.125" )
		CU_ASSERT( ( d_( "100.00" ) / d_( "4" ) ).ToString( ) = "25.00" )
		CU_ASSERT( ( d_( "10.0" ) / d_( "2" ) ).ToString( ) = "5.0" )
		CU_ASSERT( ( d_( "1.0" ) / d_( "1" ) ).ToString( ) = "1.0" )
		CU_ASSERT( ( d_( "5" ) / d_( "2.5" ) ).ToString( ) = "2" )
		CU_ASSERT( ( d_( "1.5" ) / d_( "0.5" ) ).ToString( ) = "3" )
		CU_ASSERT( ( d_( "0.001" ) / d_( "10" ) ).ToString( ) = "0.0001" )
		CU_ASSERT( ( d_( "12.34" ) / d_( "2" ) ).ToString( ) = "6.17" )
		CU_ASSERT( ( d_( "7" ) / d_( "11" ) ).ToString( ) = "0.6363636363636363636363636364" )
		CU_ASSERT( ( d_( "9.5" ) / d_( "0.091" ) ).ToString( ) = "104.3956043956043956043956044" )
		CU_ASSERT( ( d_( "-6" ) / d_( "3" ) ).ToString( ) = "-2" )
		CU_ASSERT( ( d_( "6" ) / d_( "-3" ) ).ToString( ) = "-2" )
		CU_ASSERT( ( d_( "-6" ) / d_( "-3" ) ).ToString( ) = "2" )
		CU_ASSERT( ( d_( "0" ) / d_( "3" ) ).IsZero( ) )

		'' DIVISION BY ZERO IS Invalid, not a trap and not a wrong number
		CU_ASSERT( ( d_( "1" ) / d_( "0" ) ).IsValid( ) = false )
		CU_ASSERT( ( d_( "0" ) / d_( "0" ) ).IsValid( ) = false )
		CU_ASSERT( ( d_( "1" ) / d_( "0.000" ) ).IsValid( ) = false )

		'' ( a / b ) * b recovers a exactly whenever the quotient terminated
		for m as longint = -400 to 400 step 3
			dim as Decimal a = DecimalFromScaled( m, 2 )
			dim as Decimal b = d_( "0.25" )
			CU_ASSERT( ( ( a / b ) * b ) = a )
		next

		'' x / x is one, for everything that is not zero
		for m as longint = 1 to 500 step 7
			for sc as long = 0 to 6
				dim as Decimal x = DecimalFromScaled( m, sc )
				CU_ASSERT( ( x / x ) = DecimalOne( ) )
				CU_ASSERT( ( -x / x ) = DecimalMinusOne( ) )
			next
		next

		'' the .NET example that shows division rounds rather than truncates
		CU_ASSERT( ( ( d_( "2" ) / d_( "3" ) ) * d_( "3" ) ).ToString( ) = "2.0000000000000000000000000001" )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Remainder.  Sign follows the DIVIDEND.
	'' ---------------------------------------------------------------------
	TEST( remainder_ )
		CU_ASSERT( ( d_( "1" ) mod d_( "0.3" ) ).ToString( ) = "0.1" )
		CU_ASSERT( ( d_( "-7.5" ) mod d_( "2" ) ).ToString( ) = "-1.5" )
		CU_ASSERT( ( d_( "7.5" ) mod d_( "-2" ) ).ToString( ) = "1.5" )
		CU_ASSERT( ( d_( "-7.5" ) mod d_( "-2" ) ).ToString( ) = "-1.5" )
		CU_ASSERT( ( d_( "10" ) mod d_( "5" ) ).IsZero( ) )
		CU_ASSERT( ( d_( "1" ) mod d_( "0" ) ).IsValid( ) = false )

		'' |a| < |b| gives back a, scale and all
		CU_ASSERT( ( d_( "0.25" ) mod d_( "1000" ) ).ToString( ) = "0.25" )
		CU_ASSERT( ( d_( "-0.25" ) mod d_( "1000" ) ).ToString( ) = "-0.25" )

		'' the defining identity: a = trunc( a / b ) * b + ( a mod b )
		for m as longint = -300 to 300 step 7
			dim as Decimal a = DecimalFromScaled( m, 2 )
			dim as Decimal b = d_( "1.25" )
			dim as Decimal q = a / b
			q = q.Truncate( )
			CU_ASSERT( ( q * b + ( a mod b ) ) = a )
			if( ( a mod b ).IsZero( ) = false ) then
				CU_ASSERT( ( a mod b ).Sign( ) = a.Sign( ) )
			end if
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Comparison.  Total order over values, blind to scale.
	'' ---------------------------------------------------------------------
	TEST( comparison_ )
		CU_ASSERT( d_( "1" ) < d_( "2" ) )
		CU_ASSERT( d_( "-2" ) < d_( "-1" ) )
		CU_ASSERT( d_( "-1" ) < d_( "0" ) )
		CU_ASSERT( d_( "0" ) < d_( "0.0000000000000000000000000001" ) )
		CU_ASSERT( d_( "1.10" ) <= d_( "1.1" ) )
		CU_ASSERT( d_( "1.10" ) >= d_( "1.1" ) )
		CU_ASSERT( ( d_( "1.10" ) < d_( "1.1" ) ) = false )
		CU_ASSERT( ( d_( "1.10" ) > d_( "1.1" ) ) = false )
		CU_ASSERT( DecimalMinValue( ) < DecimalMaxValue( ) )

		CU_ASSERT( DecimalCompare( d_( "1" ), d_( "2" ) ) = -1 )
		CU_ASSERT( DecimalCompare( d_( "2" ), d_( "1" ) ) = 1 )
		CU_ASSERT( DecimalCompare( d_( "2" ), d_( "2.000" ) ) = 0 )
		'' -2 is the 'either was Invalid' answer, and is no ordering
		CU_ASSERT( DecimalCompare( DecimalInvalid( ), d_( "1" ) ) = -2 )
		CU_ASSERT( DecimalCompare( d_( "1" ), DecimalInvalid( ) ) = -2 )

		'' antisymmetry and transitivity over a ladder that crosses zero
		dim as Decimal ladder( 0 to 8 )
		ladder( 0 ) = d_( "-1000" )
		ladder( 1 ) = d_( "-1.0001" )
		ladder( 2 ) = d_( "-1" )
		ladder( 3 ) = d_( "-0.0001" )
		ladder( 4 ) = d_( "0" )
		ladder( 5 ) = d_( "0.0001" )
		ladder( 6 ) = d_( "1" )
		ladder( 7 ) = d_( "1.0001" )
		ladder( 8 ) = d_( "1000" )
		for i as long = 0 to 8
			for j as long = 0 to 8
				dim as long c = DecimalCompare( ladder( i ), ladder( j ) )
				if( i < j ) then CU_ASSERT( c = -1 )
				if( i = j ) then CU_ASSERT( c = 0 )
				if( i > j ) then CU_ASSERT( c = 1 )
				CU_ASSERT( ( ladder( i ) < ladder( j ) ) = ( i < j ) )
				CU_ASSERT( ( ladder( i ) = ladder( j ) ) = ( i = j ) )
				CU_ASSERT( ( ladder( i ) <> ladder( j ) ) = ( i <> j ) )
				CU_ASSERT( ( ladder( i ) > ladder( j ) ) = ( i > j ) )
				CU_ASSERT( ( ladder( i ) <= ladder( j ) ) = ( i <= j ) )
				CU_ASSERT( ( ladder( i ) >= ladder( j ) ) = ( i >= j ) )
			next
		next

		'' comparison agrees with subtraction, at mixed scales
		for m as longint = -200 to 200 step 3
			dim as Decimal a = DecimalFromScaled( m, 3 )
			dim as Decimal b = d_( "0.05" )
			CU_ASSERT( ( a < b ) = ( ( a - b ).Sign( ) < 0 ) )
			CU_ASSERT( ( a > b ) = ( ( a - b ).Sign( ) > 0 ) )
			CU_ASSERT( ( a = b ) = ( ( a - b ).Sign( ) = 0 ) )
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Rounding.  Half-to-even by default; every mode reachable by name.
	'' ---------------------------------------------------------------------
	TEST( rounding_modes_ )
		'' the banker's ties, both parities, both signs
		CU_ASSERT( d_( "2.5" ).Round( 0 ).ToString( ) = "2" )
		CU_ASSERT( d_( "3.5" ).Round( 0 ).ToString( ) = "4" )
		CU_ASSERT( d_( "-2.5" ).Round( 0 ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-3.5" ).Round( 0 ).ToString( ) = "-4" )
		CU_ASSERT( d_( "0.125" ).Round( 2 ).ToString( ) = "0.12" )
		CU_ASSERT( d_( "0.135" ).Round( 2 ).ToString( ) = "0.14" )
		CU_ASSERT( d_( "2.345" ).Round( 2 ).ToString( ) = "2.34" )
		'' NOT a tie -- there is a nonzero digit past the half
		CU_ASSERT( d_( "2.3451" ).Round( 2 ).ToString( ) = "2.35" )

		'' and the exact-decimal round that a DOUBLE cannot do
		CU_ASSERT( d_( "2.675" ).Round( 2 ).ToString( ) = "2.68" )
		CU_ASSERT( d_( "2.674" ).Round( 2 ).ToString( ) = "2.67" )

		'' Round NEVER INCREASES the scale
		CU_ASSERT( d_( "1.5" ).Round( 8 ).ToString( ) = "1.5" )
		CU_ASSERT( d_( "1.5" ).Round( 8 ).Scale( ) = 1 )
		CU_ASSERT( d_( "1" ).Round( 0 ).ToString( ) = "1" )

		CU_ASSERT( d_( "1" ).Round( -1 ).IsValid( ) = false )
		CU_ASSERT( d_( "1" ).Round( 29 ).IsValid( ) = false )
		CU_ASSERT( DecimalInvalid( ).Round( 2 ).IsValid( ) = false )

		'' every mode on the same tie
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_HALF_EVEN ).ToString( ) = "2" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_HALF_UP ).ToString( ) = "3" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_HALF_DOWN ).ToString( ) = "2" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_UP ).ToString( ) = "3" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_DOWN ).ToString( ) = "2" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_CEILING ).ToString( ) = "3" )
		CU_ASSERT( d_( "2.5" ).RoundMode( 0, DEC_FLOOR ).ToString( ) = "2" )

		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_HALF_EVEN ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_HALF_UP ).ToString( ) = "-3" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_HALF_DOWN ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_UP ).ToString( ) = "-3" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_DOWN ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_CEILING ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-2.5" ).RoundMode( 0, DEC_FLOOR ).ToString( ) = "-3" )

		'' a non-tie: only UP / DOWN / CEILING / FLOOR can disagree
		CU_ASSERT( d_( "1.2" ).RoundMode( 0, DEC_UP ).ToString( ) = "2" )
		CU_ASSERT( d_( "1.2" ).RoundMode( 0, DEC_DOWN ).ToString( ) = "1" )
		CU_ASSERT( d_( "-1.2" ).RoundMode( 0, DEC_UP ).ToString( ) = "-2" )
		CU_ASSERT( d_( "-1.2" ).RoundMode( 0, DEC_DOWN ).ToString( ) = "-1" )
		CU_ASSERT( d_( "-1.2" ).RoundMode( 0, DEC_CEILING ).ToString( ) = "-1" )
		CU_ASSERT( d_( "-1.2" ).RoundMode( 0, DEC_FLOOR ).ToString( ) = "-2" )

		'' an EXACT value is never moved, whatever the mode
		for mode as long = DEC_HALF_EVEN to DEC_FLOOR
			CU_ASSERT( d_( "1.50" ).RoundMode( 1, mode ).ToString( ) = "1.5" )
			CU_ASSERT( d_( "-1.50" ).RoundMode( 1, mode ).ToString( ) = "-1.5" )
			CU_ASSERT( d_( "7" ).RoundMode( 0, mode ).ToString( ) = "7" )
		next

		'' half-to-even does not drift: rounding every tie from a run of
		'' quarters lands on the even integer exactly half the time
		dim as long ups = 0
		for k as longint = 1 to 200 step 2                         '' k/2 is always a tie
			dim as Decimal t = DecimalFromScaled( k * 5, 1 )       '' 0.5, 1.5, 2.5 ...
			if( t.Round( 0 ) > t ) then ups += 1
		next
		CU_ASSERT( ups = 50 )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Rescale and Normalize -- the two ways to move the scale on purpose
	'' ---------------------------------------------------------------------
	TEST( rescale_and_normalize_ )
		CU_ASSERT( d_( "1.5" ).Rescale( 4 ).ToString( ) = "1.5000" )
		CU_ASSERT( d_( "1.5" ).Rescale( 4 ).Scale( ) = 4 )
		CU_ASSERT( d_( "1.5" ).Rescale( 4 ) = d_( "1.5" ) )
		CU_ASSERT( d_( "1.55" ).Rescale( 1 ).ToString( ) = "1.6" )   '' half-to-even
		CU_ASSERT( d_( "1.45" ).Rescale( 1 ).ToString( ) = "1.4" )
		CU_ASSERT( d_( "1.5" ).Rescale( 1 ).ToString( ) = "1.5" )
		CU_ASSERT( d_( "1" ).Rescale( -1 ).IsValid( ) = false )
		CU_ASSERT( d_( "1" ).Rescale( 29 ).IsValid( ) = false )
		CU_ASSERT( DecimalInvalid( ).Rescale( 2 ).IsValid( ) = false )
		'' growing the scale past what 96 bits can hold is Invalid, not a wrap
		CU_ASSERT( DecimalMaxValue( ).Rescale( 1 ).IsValid( ) = false )

		CU_ASSERT( d_( "1.2300" ).Normalize( ).ToString( ) = "1.23" )
		CU_ASSERT( d_( "1.2300" ).Normalize( ) = d_( "1.23" ) )
		CU_ASSERT( d_( "100.00" ).Normalize( ).ToString( ) = "100" )
		CU_ASSERT( d_( "0.000" ).Normalize( ).ToString( ) = "0" )
		CU_ASSERT( d_( "-1.500" ).Normalize( ).ToString( ) = "-1.5" )
		CU_ASSERT( d_( "1.23" ).Normalize( ).ToString( ) = "1.23" )
		CU_ASSERT( DecimalInvalid( ).Normalize( ).IsValid( ) = false )

		'' Rescale then Normalize is the identity on an already-normal value
		for m as longint = 1 to 999 step 7
			dim as Decimal x = DecimalFromScaled( m, 3 ).Normalize( )
			for sc as long = x.Scale( ) to 12
				CU_ASSERT( x.Rescale( sc ).Normalize( ) = x )
				CU_ASSERT( x.Rescale( sc ).Normalize( ).Scale( ) = x.Scale( ) )
				CU_ASSERT( x.Rescale( sc ) = x )
			next
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Floor, Ceiling, Truncate, AbsValue, negation, Sign
	'' ---------------------------------------------------------------------
	TEST( floor_ceiling_truncate_abs_ )
		CU_ASSERT( d_( "1.5" ).Floor( ).ToString( ) = "1" )
		CU_ASSERT( d_( "-1.5" ).Floor( ).ToString( ) = "-2" )
		CU_ASSERT( d_( "1.5" ).Ceiling( ).ToString( ) = "2" )
		CU_ASSERT( d_( "-1.5" ).Ceiling( ).ToString( ) = "-1" )
		CU_ASSERT( d_( "1.9" ).Truncate( ).ToString( ) = "1" )
		CU_ASSERT( d_( "-1.9" ).Truncate( ).ToString( ) = "-1" )
		CU_ASSERT( d_( "2.000" ).Floor( ).ToString( ) = "2" )
		CU_ASSERT( d_( "-2.000" ).Ceiling( ).ToString( ) = "-2" )

		CU_ASSERT( d_( "-1.25" ).AbsValue( ).ToString( ) = "1.25" )
		CU_ASSERT( d_( "1.25" ).AbsValue( ).ToString( ) = "1.25" )
		CU_ASSERT( DecimalMinValue( ).AbsValue( ) = DecimalMaxValue( ) )
		CU_ASSERT( DecimalInvalid( ).AbsValue( ).IsValid( ) = false )
		CU_ASSERT( DecimalInvalid( ).Floor( ).IsValid( ) = false )
		CU_ASSERT( DecimalInvalid( ).Ceiling( ).IsValid( ) = false )
		CU_ASSERT( DecimalInvalid( ).Truncate( ).IsValid( ) = false )

		CU_ASSERT( ( -d_( "1.25" ) ).ToString( ) = "-1.25" )
		CU_ASSERT( ( -d_( "-1.25" ) ).ToString( ) = "1.25" )
		CU_ASSERT( ( -d_( "0.00" ) ).IsNegative( ) = false )
		CU_ASSERT( ( -DecimalInvalid( ) ).IsValid( ) = false )

		'' the relations that define them, over a sweep across zero
		for m as longint = -500 to 500 step 3
			dim as Decimal x = DecimalFromScaled( m, 2 )
			CU_ASSERT( x.Floor( ) <= x )
			CU_ASSERT( x.Ceiling( ) >= x )
			CU_ASSERT( ( x.Ceiling( ) - x.Floor( ) ) <= DecimalOne( ) )
			CU_ASSERT( x.Floor( ).Scale( ) = 0 )
			CU_ASSERT( x.AbsValue( ) = x.AbsValue( ).AbsValue( ) )
			CU_ASSERT( x.AbsValue( ).Sign( ) >= 0 )
			CU_ASSERT( ( -( -x ) ) = x )
			CU_ASSERT( ( x + ( -x ) ).IsZero( ) )
			'' Truncate is Floor for positives and Ceiling for negatives
			if( x.Sign( ) >= 0 ) then
				CU_ASSERT( x.Truncate( ) = x.Floor( ) )
			else
				CU_ASSERT( x.Truncate( ) = x.Ceiling( ) )
			end if
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' INVALID IS INFECTIOUS, and 'Invalid = Invalid' IS FALSE -- the same
	'' rule fb/currency.bi and fb/chrono.bi use.
	'' ---------------------------------------------------------------------
	TEST( invalid_is_infectious_ )
		dim as Decimal inv = DecimalInvalid( )
		dim as Decimal one = DecimalOne( )

		CU_ASSERT( inv.IsValid( ) = false )
		CU_ASSERT( inv.IsZero( ) = false )
		CU_ASSERT( inv.IsNegative( ) = false )
		CU_ASSERT( inv.Sign( ) = 0 )
		CU_ASSERT( inv.Scale( ) = -1 )

		'' Invalid = Invalid is FALSE.  Test with IsValid.
		CU_ASSERT( ( inv = inv ) = false )
		CU_ASSERT( ( inv = one ) = false )
		CU_ASSERT( ( one = inv ) = false )
		CU_ASSERT( inv <> inv )
		CU_ASSERT( inv <> one )
		CU_ASSERT( ( inv < one ) = false )
		CU_ASSERT( ( inv > one ) = false )
		CU_ASSERT( ( inv <= one ) = false )
		CU_ASSERT( ( inv >= one ) = false )

		'' every operator propagates it, from either side
		CU_ASSERT( ( inv + one ).IsValid( ) = false )
		CU_ASSERT( ( one + inv ).IsValid( ) = false )
		CU_ASSERT( ( inv - one ).IsValid( ) = false )
		CU_ASSERT( ( one - inv ).IsValid( ) = false )
		CU_ASSERT( ( inv * one ).IsValid( ) = false )
		CU_ASSERT( ( one * inv ).IsValid( ) = false )
		CU_ASSERT( ( inv / one ).IsValid( ) = false )
		CU_ASSERT( ( one / inv ).IsValid( ) = false )
		CU_ASSERT( ( inv mod one ).IsValid( ) = false )
		CU_ASSERT( ( one mod inv ).IsValid( ) = false )
		CU_ASSERT( ( inv + 1 ).IsValid( ) = false )
		CU_ASSERT( ( 1 + inv ).IsValid( ) = false )
		CU_ASSERT( ( inv - 1 ).IsValid( ) = false )
		CU_ASSERT( ( 1 - inv ).IsValid( ) = false )
		CU_ASSERT( ( inv * 2 ).IsValid( ) = false )
		CU_ASSERT( ( 2 * inv ).IsValid( ) = false )
		CU_ASSERT( ( inv / 2 ).IsValid( ) = false )
		CU_ASSERT( ( 2 / inv ).IsValid( ) = false )

		'' and it survives a chain rather than being laundered by one
		CU_ASSERT( ( ( ( inv + one ) * one ) - one ).IsValid( ) = false )

		'' the conversions out report it rather than inventing a number
		CU_ASSERT( inv.ToString( ) = "Invalid" )
		CU_ASSERT( inv.ToDouble( ) <> inv.ToDouble( ) )            '' NaN
		CU_ASSERT( inv.ToLongInt( ).HasValue( ) = false )
		CU_ASSERT( inv.ToCurrency( ).IsValid( ) = false )
		CU_ASSERT( DecimalFromCurrency( CurrencyInvalid( ) ).IsValid( ) = false )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Overflow becomes Invalid, at both ends, rather than wrapping
	'' ---------------------------------------------------------------------
	TEST( overflow_is_invalid_ )
		CU_ASSERT( ( DecimalMaxValue( ) + DecimalOne( ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalMinValue( ) - DecimalOne( ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalMaxValue( ) * d_( "2" ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalMaxValue( ) * DecimalMaxValue( ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalMinValue( ) * d_( "2" ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalMaxValue( ) / d_( "0.5" ) ).IsValid( ) = false )
		CU_ASSERT( ( DecimalOne( ) / d_( "0.0000000000000000000000000001" ) ).ToString( ) = "10000000000000000000000000000" )
		CU_ASSERT( ( d_( "100" ) / d_( "0.0000000000000000000000000001" ) ).IsValid( ) = false )

		'' the endpoints themselves are fine, and survive a round trip
		CU_ASSERT( ( DecimalMaxValue( ) - DecimalOne( ) + DecimalOne( ) ) = DecimalMaxValue( ) )
		CU_ASSERT( ( DecimalMinValue( ) + DecimalOne( ) - DecimalOne( ) ) = DecimalMinValue( ) )
		CU_ASSERT( ( DecimalMaxValue( ) + DecimalMinValue( ) ).IsZero( ) )

		'' 79228162514264337593543950336 is one past the mantissa, at any scale
		CU_ASSERT( ( DecimalMaxValue( ) * d_( "1.0" ) ) = DecimalMaxValue( ) )
	END_TEST

	'' ---------------------------------------------------------------------
	'' Conversions in and out
	'' ---------------------------------------------------------------------
	TEST( conversions_ )
		'' ---- DOUBLE in.  Fifteen significant digits, trailing zeros gone.
		CU_ASSERT( DecimalFromDouble( 0.0 ).IsZero( ) )
		CU_ASSERT( DecimalFromDouble( 0.1 ).ToString( ) = "0.1" )
		CU_ASSERT( DecimalFromDouble( 0.2 ).ToString( ) = "0.2" )
		CU_ASSERT( DecimalFromDouble( 1.0 ).ToString( ) = "1" )
		CU_ASSERT( DecimalFromDouble( -1.5 ).ToString( ) = "-1.5" )
		CU_ASSERT( DecimalFromDouble( 1.0 / 3.0 ).ToString( ) = "0.333333333333333" )
		CU_ASSERT( DecimalFromDouble( 1.0e20 ).ToString( ) = "100000000000000000000" )
		'' the DOUBLE that is not three tenths comes back as three tenths
		CU_ASSERT( DecimalFromDouble( 0.1 + 0.2 ).ToString( ) = "0.3" )
		'' NaN and the infinities have no decimal value
		CU_ASSERT( DecimalFromDouble( 0.0 / 0.0 ).IsValid( ) = false )
		CU_ASSERT( DecimalFromDouble( 1.0e300 ).IsValid( ) = false )
		CU_ASSERT( DecimalFromDouble( -1.0e300 ).IsValid( ) = false )

		'' ---- DOUBLE out.  BOUNDED, so this asserts closeness, not equality.
		for m as longint = -1000 to 1000 step 7
			dim as Decimal x = DecimalFromScaled( m, 3 )
			dim as double d = x.ToDouble( )
			dim as double want = cdbl( m ) / 1000.0
			dim as double e_ = d - want
			if( e_ < 0.0 ) then e_ = -e_
			CU_ASSERT( e_ < 1.0e-12 )
		next
		CU_ASSERT( DecimalOne( ).ToDouble( ) = 1.0 )
		CU_ASSERT( d_( "0.5" ).ToDouble( ) = 0.5 )
		CU_ASSERT( d_( "-0.25" ).ToDouble( ) = -0.25 )
		CU_ASSERT( DecimalZero( ).ToDouble( ) = 0.0 )

		'' ---- LONGINT out.  Truncates toward zero; None when it will not fit.
		CU_ASSERT( d_( "1.9" ).ToLongInt( ).Value( ) = 1 )
		CU_ASSERT( d_( "-1.9" ).ToLongInt( ).Value( ) = -1 )
		CU_ASSERT( d_( "0" ).ToLongInt( ).Value( ) = 0 )
		CU_ASSERT( d_( "9223372036854775807" ).ToLongInt( ).Value( ) = MAX_VALUE_LONGINT )
		CU_ASSERT( d_( "-9223372036854775808" ).ToLongInt( ).Value( ) = MIN_VALUE_LONGINT )
		CU_ASSERT( d_( "9223372036854775808" ).ToLongInt( ).HasValue( ) = false )
		CU_ASSERT( d_( "-9223372036854775809" ).ToLongInt( ).HasValue( ) = false )
		CU_ASSERT( DecimalMaxValue( ).ToLongInt( ).HasValue( ) = false )
		for v as longint = -1000 to 1000 step 3
			CU_ASSERT( DecimalFromInt( v ).ToLongInt( ).Value( ) = v )
		next

		'' ---- Currency both ways.  Four places is exactly Currency's scale.
		dim as Currency c = CurrencyParse( "19.99" ).Value( )
		CU_ASSERT( DecimalFromCurrency( c ).ToString( ) = "19.9900" )
		CU_ASSERT( DecimalFromCurrency( c ) = d_( "19.99" ) )
		CU_ASSERT( DecimalFromCurrency( c ).Scale( ) = 4 )
		CU_ASSERT( d_( "19.99" ).ToCurrency( ).ToString( ) = "19.9900" )
		CU_ASSERT( d_( "-0.0001" ).ToCurrency( ).Raw( ) = -1 )
		'' more than four places rounds half-to-even, and says so by rounding
		CU_ASSERT( d_( "0.00005" ).ToCurrency( ).Raw( ) = 0 )
		CU_ASSERT( d_( "0.00015" ).ToCurrency( ).Raw( ) = 2 )
		'' past Currency's range it is Invalid rather than a wrapped amount
		CU_ASSERT( DecimalMaxValue( ).ToCurrency( ).IsValid( ) = false )
		CU_ASSERT( d_( "1000000000000000" ).ToCurrency( ).IsValid( ) = false )

		'' Currency -> Decimal -> Currency is the identity over its whole range
		dim as longint probe( 0 to 7 ) = { 0, 1, -1, 10000, -10000, _
			9223372036854775807ll, -9223372036854775807ll, 123456789 }
		for i as long = 0 to 7
			dim as Currency k = CurrencyFromRaw( probe( i ) )
			CU_ASSERT( DecimalFromCurrency( k ).ToCurrency( ).Raw( ) = probe( i ) )
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Mixed Decimal / LONGINT operators
	'' ---------------------------------------------------------------------
	TEST( mixed_integer_operators_ )
		dim as Decimal p = d_( "19.99" )
		CU_ASSERT( ( p * 3 ).ToString( ) = "59.97" )
		CU_ASSERT( ( 3 * p ).ToString( ) = "59.97" )
		CU_ASSERT( ( p + 1 ).ToString( ) = "20.99" )
		CU_ASSERT( ( 1 + p ).ToString( ) = "20.99" )
		CU_ASSERT( ( p - 1 ).ToString( ) = "18.99" )
		CU_ASSERT( ( 1 - p ).ToString( ) = "-18.99" )
		CU_ASSERT( ( p / 2 ).ToString( ) = "9.995" )
		CU_ASSERT( ( 100 / d_( "4" ) ).ToString( ) = "25" )
		CU_ASSERT( ( p / 0 ).IsValid( ) = false )

		'' the mixed form and the spelled-out form agree, everywhere
		for n as longint = -50 to 50
			dim as Decimal d = DecimalFromInt( n )
			CU_ASSERT( ( p + n ) = ( p + d ) )
			CU_ASSERT( ( n + p ) = ( d + p ) )
			CU_ASSERT( ( p - n ) = ( p - d ) )
			CU_ASSERT( ( n - p ) = ( d - p ) )
			CU_ASSERT( ( p * n ) = ( p * d ) )
			CU_ASSERT( ( n * p ) = ( d * p ) )
			if( n <> 0 ) then
				CU_ASSERT( ( p / n ) = ( p / d ) )
				CU_ASSERT( ( n / p ) = ( d / p ) )
			end if
		next
	END_TEST

	'' ---------------------------------------------------------------------
	'' Apportion -- the parts always sum to the total, EXACTLY
	'' ---------------------------------------------------------------------
	TEST( apportion_ )
		dim as longint w( 0 to 2 ) = { 1, 1, 1 }
		redim as Decimal r( 0 )
		DecimalApportion( d_( "100.00" ), 2, w( ), r( ) )
		CU_ASSERT( ubound( r ) = 2 )
		CU_ASSERT( ( r( 0 ) + r( 1 ) + r( 2 ) ) = d_( "100.00" ) )
		CU_ASSERT( r( 0 ).ToString( ) = "33.34" )
		CU_ASSERT( r( 1 ).ToString( ) = "33.33" )
		CU_ASSERT( r( 2 ).ToString( ) = "33.33" )
		for i as long = 0 to 2
			CU_ASSERT( r( i ).Scale( ) = 2 )
		next

		'' unequal weights
		dim as longint w2( 0 to 2 ) = { 1, 2, 3 }
		DecimalApportion( d_( "100.00" ), 2, w2( ), r( ) )
		CU_ASSERT( ( r( 0 ) + r( 1 ) + r( 2 ) ) = d_( "100.00" ) )
		CU_ASSERT( r( 0 ).ToString( ) = "16.67" )
		CU_ASSERT( r( 1 ).ToString( ) = "33.33" )
		CU_ASSERT( r( 2 ).ToString( ) = "50.00" )

		'' a negative total keeps the sign on every part and still sums exactly
		DecimalApportion( d_( "-100.00" ), 2, w( ), r( ) )
		CU_ASSERT( ( r( 0 ) + r( 1 ) + r( 2 ) ) = d_( "-100.00" ) )
		for i as long = 0 to 2
			CU_ASSERT( r( i ).Sign( ) = -1 )
		next

		'' the sum is exact for every total, every part count, every scale
		for cents as longint = 1 to 400 step 7
			for parts as long = 2 to 7
				redim as longint ww( 0 to parts - 1 )
				for i as long = 0 to parts - 1
					ww( i ) = i + 1
				next
				redim as Decimal rr( 0 )
				DecimalApportion( DecimalFromScaled( cents, 2 ), 2, ww( ), rr( ) )
				dim as Decimal total = DecimalZero( )
				for i as long = 0 to parts - 1
					total = total + rr( i )
				next
				CU_ASSERT( total = DecimalFromScaled( cents, 2 ) )
			next
		next

		'' a zero weight set yields zeros rather than a division by zero
		dim as longint wz( 0 to 2 ) = { 0, 0, 0 }
		DecimalApportion( d_( "100.00" ), 2, wz( ), r( ) )
		for i as long = 0 to 2
			CU_ASSERT( r( i ).IsZero( ) )
			CU_ASSERT( r( i ).IsValid( ) )
		next

		'' an Invalid total makes every part Invalid rather than zero
		DecimalApportion( DecimalInvalid( ), 2, w( ), r( ) )
		for i as long = 0 to 2
			CU_ASSERT( r( i ).IsValid( ) = false )
		next

		'' one part gets the lot
		dim as longint w1( 0 to 0 ) = { 5 }
		DecimalApportion( d_( "12.34" ), 2, w1( ), r( ) )
		CU_ASSERT( ubound( r ) = 0 )
		CU_ASSERT( r( 0 ).ToString( ) = "12.34" )
	END_TEST

	'' ---------------------------------------------------------------------
	'' PINNED AGAINST .NET.  Each row was evaluated by System.Decimal and the
	'' answer copied here verbatim, scale included -- so a change that alters
	'' the result OR the scale fails, not just one that alters the value.
	'' ---------------------------------------------------------------------
	TEST( dotnet_pinned_ )
		'' spelled-out cases from the .NET documentation and probes
		CASE_( "1.0", "+", "2.00", "3.00" )
		CASE_( "1", "-", "1.00", "0.00" )
		CASE_( "1.10", "*", "1.00", "1.1000" )
		CASE_( "1.0000", "*", "1.0000", "1.00000000" )
		CASE_( "1", "/", "3", "0.3333333333333333333333333333" )
		CASE_( "100.00", "/", "4", "25.00" )
		CASE_( "7", "/", "11", "0.6363636363636363636363636364" )
		CASE_( "-7.5", "%", "2", "-1.5" )
		CASE_( "1", "%", "0.3", "0.1" )

		CASE_( "2917060547995114274525540", "%", "235709801155076", "9802493858928" )
		CASE_( "52.25", "+", "-0.00203276070468454244", "52.24796723929531545756" )
		CASE_( "-0.0000000000009", "-", "46556501.1779153", "-46556501.1779153000009" )
		CASE_( "0.00527", "+", "1850.87687792730433", "1850.88214792730433" )
		CASE_( "0.0000000000000000000000005", "+", "0.000000000000000000003220", "0.0000000000000000000032205" )
		CASE_( "-0.0828", "+", "-0.0000703649", "-0.0828703649" )
		CASE_( "744245.008886381438", "%", "0.000000030", "0.000000011438" )
		CASE_( "-863803658384", "*", "0.0000000000312618", "-27.0040572076689312" )
		CASE_( "-3020", "/", "-2429383.471892910822278", "0.0012431137508509089047566942" )
		CASE_( "0.0000932708068093720", "/", "-3328298953871.779624917", "-0.000000000000000028023566423" )
		CASE_( "-555730462829.2759261124", "-", "-0.000000000000474", "-555730462829.275926112399526" )
		CASE_( "0.0000000000000000000000846", "+", "88.87536568788096567295100", "88.8753656878809656729510846" )
		CASE_( "3469182.429928648981736086923", "+", "0.0000000000651818659037", "3469182.4299286490469179528267" )
		CASE_( "-0.0000000000000000457", "%", "0.0000000000642668356603661", "-0.0000000000000000457" )
		CASE_( "-82785770412.9", "%", "130227444528840.9316625365979", "-82785770412.9" )
		CASE_( "-0.0000000000598453076", "-", "0.0000000483960370", "-0.0000000484558823076" )
		CASE_( "0.00000000049", "*", "0.000434839208923979", "0.0000000000002130712123727497" )
		CASE_( "0.00000000000000000028", "+", "-73077386.3", "-73077386.29999999999999999972" )
		CASE_( "0.000000000000835325049", "*", "-990.365257927301", "-0.0000000008272769076060203463" )
		CASE_( "68872576360836880530.53957", "/", "-0.000000000021", "Invalid" )
		CASE_( "0.0002077707170651307349881486", "*", "-8531832394726.38324", "-1772664934.5318121792558083859" )
		CASE_( "-532801127482583053.2099909927", "-", "13307536658569462.8", "-546108664141152516.0099909927" )
		CASE_( "-21453873887861443.7", "%", "976225493951065.541", "-953138514889067.339" )
		CASE_( "-0.0000000000000000000000023", "/", "-148952392924890.7741763", "0" )
		CASE_( "0.00000000000967115501", "%", "2.179664369648457929154846922", "0.00000000000967115501" )
		CASE_( "36.596439378566557364322929008", "-", "0.000000000094", "36.596439378472557364322929008" )
		CASE_( "0.0000000000000000000868262580", "%", "0.000000000000000000472", "0.0000000000000000000868262580" )
		CASE_( "0.000000000021", "*", "0.00000981", "0.00000000000000020601" )
		CASE_( "0.5042", "*", "-0.0000000000000004705", "-0.00000000000000023722610" )
		CASE_( "4398814472781.675294150512017", "/", "18.5432685093", "237218938536.94342859550020165" )
		CASE_( "46969974768181618.06440888454", "-", "0.00000000000000006", "46969974768181618.064408884540" )
		CASE_( "-0.0000000007730", "/", "92094462298812.70663139656", "-0.0000000000000000000000083936" )
		CASE_( "-0.0000000000000000000685107440", "-", "920116.430562439736", "-920116.4305624397360000000685" )
		CASE_( "28397939163426164163885457714", "+", "-10050.6794438", "28397939163426164163885447663" )
		CASE_( "-0.00000000000000000000007", "*", "610698920256278227.7264", "-0.000042748924417939475940848" )
		CASE_( "-8635755723.27843", "+", "-0.08781072707277368408528528", "-8635755723.366240727072773684" )
		CASE_( "-0.0000000000000280347", "-", "-6.250", "6.2499999999999719653" )
		CASE_( "7.656", "%", "1361067756735.1016140256530633", "7.656" )
		CASE_( "0.000000000000228996380135682", "*", "373244", "0.000000085471524907362492408" )
		CASE_( "73493761811167.1758", "+", "0.00766973977232", "73493761811167.18346973977232" )
		CASE_( "-0.000000000000000000107", "%", "0.445626128902", "-0.000000000000000000107" )
		CASE_( "-63354.9", "/", "-242303852253515001230.1", "0.0000000000000002614688103832" )
		CASE_( "0.0000000000000032", "/", "-0.00000000073", "-0.0000043835616438356164383562" )
		CASE_( "93084514129841.07885711675", "+", "-7975.54092817006613", "93084514121865.53792894668387" )
		CASE_( "-748500620.1443079665060", "-", "0.000000000201543103700379094", "-748500620.14430796670754310370" )
		CASE_( "-0.009573", "*", "-0.000931730248400964", "0.000008919453667942428372" )
		CASE_( "0.000000000000000000003499", "%", "-0.000000000000000000000000104", "0.000000000000000000000000024" )
		CASE_( "5.387", "%", "-0.572", "0.239" )
		CASE_( "0.000543308323645861", "/", "86040263.30445173355002252412", "0.0000000000063145822987939434" )
		CASE_( "8685.83", "*", "0.00000000000247219585373", "0.0000000214730729122036459" )
		CASE_( "29332.1", "-", "924219.257", "-894887.157" )
		CASE_( "-0.0000000000000000000113", "%", "-25.3837575335", "-0.0000000000000000000113" )
		CASE_( "0.00000000000000006794", "-", "-0.00131357275745973", "0.00131357275745979794" )
		CASE_( "8163.68251", "+", "-0.0000000885651", "8163.6825099114349" )
		CASE_( "-0.0000000000510133300735374295", "/", "-0.612561957650520489", "0.0000000000832786454274746356" )
		CASE_( "-0.0000000000666", "%", "0.0000000000000000000000000045", "0.0000000000000000000000000000" )
		CASE_( "29849758712419173803.46", "+", "0.00000239761", "29849758712419173803.460002398" )
		CASE_( "12886198378167577832398938276", "-", "0.0000000000127590859176975", "12886198378167577832398938276" )
		CASE_( "-3617.17217", "/", "-0.000000000000000000000003932", "919931884537131230925737538.1" )
		CASE_( "-0.000774842355", "*", "-474569963", "367716.907743182865" )
		CASE_( "-0.0000000000000000401", "-", "-15419902592.8902992", "15419902592.890299199999999960" )
		CASE_( "23670.1903134486", "-", "-0.000000000005", "23670.190313448605" )
		CASE_( "-548860082330.38881692500052089", "*", "3622007194842715.2881910552944", "-1987975167162633362177120792.7" )
		CASE_( "-0.000000722251757157244231", "*", "6025190739800995.786084648", "-4351704599.0288255213575618441" )
		CASE_( "-0.007344", "-", "2491730.275262746808059987", "-2491730.282606746808059987" )
		CASE_( "237720", "-", "0.0958271", "237719.9041729" )
		CASE_( "782952397148", "+", "-0.000000000000000000907804", "782952397148.00000000000000000" )
		CASE_( "0.0000000000000000000000000069", "+", "-655406432602.359924", "-655406432602.35992400000000000" )
		CASE_( "-0.000000000000000000007232", "+", "-0.00000000000186780097094", "-0.000000000001867800978172" )
		CASE_( "-0.00000000000000000211105", "-", "-52.7158564609091320", "52.71585646090913199788895" )
		CASE_( "-0.000000000000000085", "/", "6674.006447719133889167", "-0.0000000000000000000127359781" )
		CASE_( "-0.00000000000000000000000060", "%", "187891005814.70106082720183877", "-0.00000000000000000000000060" )
		CASE_( "0.0000000000000000000046", "*", "4.11552608470562", "0.0000000000000000000189314200" )
		CASE_( "-602.427995909174", "*", "62331008149439647.04141", "-37549944322465318943.922949932" )
		CASE_( "0.0000000000000000006", "*", "-53378811237707.32541524", "-0.000032027286742624395249144" )
		CASE_( "-0.0000000000000000989", "/", "0.0000000000000000000887898585", "-1113.8659490036241019575450726" )
		CASE_( "-6.168334914942764873430743628", "/", "-6107807277.005958734667077", "0.0000000010099098801241935598" )
		CASE_( "-0.000434340200713240", "*", "-6620713396155.252120490", "2875641985.3509090597378227204" )
		CASE_( "9758380213443394.49", "/", "-0.000000000286449417459532990", "-34066678508159197460600398.411" )
		CASE_( "-0.0000000000000000002616", "/", "0.0000000000000000000021", "-124.57142857142857142857142857" )
		CASE_( "-0.000000728789677", "*", "348264271329.111748", "-253811.405812583711521825396" )
		CASE_( "0.00000000007", "-", "589654093910851125895785.7", "-589654093910851125895785.70000" )
		CASE_( "0.0300697", "+", "0.795739071", "0.825808771" )
		CASE_( "-0.0000807", "-", "0.000000008159", "-0.000080708159" )
		CASE_( "0.00000000000000004", "%", "0.000000000000000000000007928", "0.000000000000000000000005376" )
		CASE_( "-0.000000000000000000000002", "%", "-4009344017015805834487774863", "-0.000000000000000000000002" )
		CASE_( "-0.00000000532063", "%", "637.137", "-0.00000000532063" )
		CASE_( "83.2", "*", "0.0000000714", "0.00000594048" )
		CASE_( "-0.000000000000000000018", "%", "-0.0000604630840097", "-0.000000000000000000018" )
		CASE_( "-74708714742.8277563", "*", "-64103088416808712652.55055", "Invalid" )
		CASE_( "247279758902.7670360914300", "+", "-8.97", "247279758893.7970360914300" )
		CASE_( "0.000000000000000000000210706", "*", "0.272378", "0.0000000000000000000000573917" )
		CASE_( "-0.000665", "+", "-8139142.752703311439925", "-8139142.753368311439925" )
		CASE_( "0.00010", "*", "-0.000000000000000003548", "-0.00000000000000000000035480" )
		CASE_( "258663", "-", "0.0000000000000284134534292", "258662.99999999999997158654657" )
		CASE_( "29.54202699478367960668224", "-", "0.00000437", "29.54202262478367960668224" )
		CASE_( "59760647.5", "+", "0.000000000329521875676102409", "59760647.500000000329521875676" )
		CASE_( "7043558566353306639767.323962", "/", "0.00000000000000000005", "Invalid" )
		CASE_( "71937771784672033112287373893", "/", "0.0000036", "Invalid" )
		CASE_( "208881620.111391707", "-", "0.00000000000000007774", "208881620.11139170699999992226" )
		CASE_( "-0.000000245584856958183", "-", "-62136194483.58893148000", "62136194483.588931234415143042" )
		CASE_( "0.06420770102220913356079691", "%", "-0.0000000005795", "0.00000000040620913356079691" )
		CASE_( "-0.000000000000560442730563964", "/", "4388", "-0.0000000000000001277216797092" )
		CASE_( "-0.000000000000000427581", "+", "6634840.07633", "6634840.076329999999999572419" )
		CASE_( "-1871606390.8142486346758561471", "/", "0.000789202420002", "-2371516284516.0885367113090834" )
		CASE_( "81886441.76483157820603511879", "+", "-0.0672148316019", "81886441.69761674660413511879" )
		CASE_( "0.0000005944", "*", "0.00000001", "0.000000000000005944" )
		CASE_( "-913763.109", "%", "-48570808970840991317.62", "-913763.109" )
		CASE_( "-0.004", "%", "609121.36452218254505243880897", "-0.004" )
		CASE_( "0.5", "+", "0.381", "0.881" )
		CASE_( "639.18498895343785641546158217", "/", "-0.0000000696720", "-9174201816.41746837202120769" )
		CASE_( "-49725127028782680891.87056699", "/", "0.0000000000000000000386313933", "Invalid" )
		CASE_( "411262939025.8096023155062", "*", "-0.00000000067", "-275.546169147292433551389154" )
		CASE_( "564532781653666404.2289069", "%", "-133149.826358", "129620.4674089" )
		CASE_( "-712.0078511274591770985266270", "/", "-8358.74666388685598", "0.0851811736565266619634859833" )
		CASE_( "439.8231889015300666131715", "-", "5.059324438597748958034382", "434.763864462932317655137118" )
		CASE_( "58507.074369024908275903264150", "/", "0.0000162557611", "3599159338.5944204283306835845" )
		CASE_( "-0.000234", "+", "-0.0000000008582", "-0.0002340008582" )
		CASE_( "-9255773371519.251773105", "%", "-0.0081", "-0.002573105" )
		CASE_( "9136.21479", "%", "-0.00000000000000000000014", "0.00000000000000000000008" )
	END_TEST

END_SUITE
