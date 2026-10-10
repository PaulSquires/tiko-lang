'' Numeric text -- C:\dev\docs\math\RFC-0004-text.md.

#import "std/numeric"
#include once "fbcunit.bi"

#include once "fb/optional.bi"

#include once "fblimits.bi"

using numeric

using FB
SUITE( fbc_tests.math.text )

	'' RFC-0004 section 1.  The defects, demonstrated rather than described.
	TEST( the_defects_are_real_ )
		'' VAL cannot fail: garbage and a legitimate zero are the same answer
		CU_ASSERT( val( "abc" ) = 0 )
		CU_ASSERT( val( "0" ) = 0 )
		CU_ASSERT( val( "12abc" ) = 12 )

		'' ...and TryParse can
		CU_ASSERT( TryParseDouble( "abc" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "0" ).HasValue( ) )
		CU_ASSERT( TryParseDouble( "0" ).Value( ) = 0.0 )
		CU_ASSERT( TryParseDouble( "12abc" ).HasValue( ) = false )

		'' STR does not round-trip
		dim as double d = 0.1 + 0.2
		CU_ASSERT( str( d ) = "0.3" )
		CU_ASSERT( ( val( str( d ) ) = d ) = 0 )

		'' ...and ToString does
		CU_ASSERT( ToString( d ) = "0.30000000000000004" )
		CU_ASSERT( TryParseDouble( ToString( d ) ).Value( ) = d )

		'' the data-dependence that hides it: this one happens to survive STR
		dim as double third = 1.0 / 3.0
		CU_ASSERT( val( str( third ) ) = third )
	END_TEST

	'' RFC-0004 section 2.  Strict means the WHOLE string, or nothing.
	TEST( parse_strictness_ )
		CU_ASSERT( TryParseDouble( "42" ).Value( ) = 42.0 )
		CU_ASSERT( TryParseDouble( "-42.5" ).Value( ) = -42.5 )
		CU_ASSERT( TryParseDouble( "+1.5e3" ).Value( ) = 1500.0 )
		CU_ASSERT( TryParseDouble( ".5" ).Value( ) = 0.5 )
		CU_ASSERT( TryParseDouble( "5." ).Value( ) = 5.0 )

		'' every reject in the RFC's table
		CU_ASSERT( TryParseDouble( "  42" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "42 " ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "42abc" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "1,234" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "-" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "+" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "." ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "e5" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "1e" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "1e+" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "--1" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "1.2.3" ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "$5" ).HasValue( ) = false )

		'' leniency is opted INTO
		CU_ASSERT( TryParseDouble( "  42  ", PARSE_TRIM ).Value( ) = 42.0 )
		CU_ASSERT( TryParseDouble( "42abc", PARSE_ALLOW_TRAILING ).Value( ) = 42.0 )

		'' every prefix of a valid number is checked
		dim as string good = "-12.75e3"
		for i as long = 1 to len( good ) - 1
			dim as string p = left( good, i )
			dim as Optional( of double ) r = TryParseDouble( p )
			'' whatever it decides, it must not crash and must be consistent
			if( r.HasValue( ) ) then
				CU_ASSERT( r.Value( ) = r.Value( ) )
			end if
		next
	END_TEST

	'' RFC-0004 section 2.  FB's own PRINT spellings must read back.
	TEST( special_values_ )
		CU_ASSERT( TryParseDouble( "nan" ).HasValue( ) )
		CU_ASSERT( TryParseDouble( "inf" ).HasValue( ) )
		CU_ASSERT( TryParseDouble( "-inf" ).HasValue( ) )
		CU_ASSERT( TryParseDouble( "nan", PARSE_NO_SPECIAL ).HasValue( ) = false )
		CU_ASSERT( TryParseDouble( "inf", PARSE_NO_SPECIAL ).HasValue( ) = false )

		dim as double got = TryParseDouble( "inf" ).Value( )
		CU_ASSERT( got > 1.0e308 )
		dim as double nn = TryParseDouble( "nan" ).Value( )
		CU_ASSERT( ( nn = nn ) = 0 )

		'' ToString spells them the way it can read them back
		CU_ASSERT( ToString( 0.0 ) = "0" )
		dim as double negz = 0.0
		negz = -negz
		CU_ASSERT( ToString( negz ) = "-0" )      '' STR loses this
	END_TEST

	'' RFC-0004 section 3.  The gate: round-trip, exhaustively for SINGLE.
	'' All 2^32 bit patterns would take too long inside a unit suite; this walks
	'' a large stratified sample plus every exponent boundary, and the exhaustive
	'' sweep is left to the standalone harness.
	TEST( roundtrip_single_ )
		dim as ulong stride = 9973                        '' prime, so it does not
		dim as ulong u = 0                                '' align with any pattern
		dim as ulongint n = 0
		do
			dim as single v = *cptr( single ptr, @u )
			if( v = v ) then                              '' skip NaN payloads
				dim as string s = ToString( v )
				dim as Optional( of single ) r = TryParseSingle( s )
				CU_ASSERT( r.HasValue( ) )
				if( r.HasValue( ) ) then
					dim as single back = r.Value( )
					CU_ASSERT( *cptr( ulong ptr, @back ) = u )
				end if
				n += 1
			end if
			if( u > &hFFFFFFFFul - stride ) then exit do
			u += stride
		loop
		CU_ASSERT( n > 400000 )
	END_TEST

	TEST( roundtrip_double_ )
		'' the curated set: subnormals, both zeros, powers, and the values that
		'' break naive shortest-representation algorithms
		dim as double v( 0 to 19 ) = { _
			0.0, 1.0, -1.0, 0.1, 0.2, 0.3, 1.0/3.0, 2.0/3.0, _
			1e-308, 5e-324, 1.7976931348623157e308, 2.2250738585072014e-308, _
			123456789.123456789, 9007199254740993.0, 1e22, 1e23, _
			0.1+0.2, 4.35, 1.005, 8.98846567431158e307 }
		for i as long = 0 to 19
			dim as string s = ToString( v( i ) )
			dim as Optional( of double ) r = TryParseDouble( s )
			CU_ASSERT( r.HasValue( ) )
			CU_ASSERT( r.Value( ) = v( i ) )
		next

		'' and a wide sweep of constructed values
		for i as longint = 1 to 20000
			dim as double x = cdbl( i ) / 7.0
			CU_ASSERT( TryParseDouble( ToString( x ) ).Value( ) = x )
			dim as double y = cdbl( i ) * 1.0e-13
			CU_ASSERT( TryParseDouble( ToString( y ) ).Value( ) = y )
		next
	END_TEST

	'' ToString produces the SHORTEST such string, not merely one that works.
	TEST( shortest_ )
		CU_ASSERT( ToString( 1.0 ) = "1" )
		CU_ASSERT( ToString( 0.5 ) = "0.5" )
		CU_ASSERT( ToString( 100.0 ) = "100" )
		CU_ASSERT( ToString( 0.1 ) = "0.1" )
		CU_ASSERT( len( ToString( 1.0 ) ) = 1 )

		'' no shorter representation can round-trip: dropping a digit must fail
		for i as longint = 1 to 3000
			dim as double x = cdbl( i ) / 3.0
			dim as string s = ToString( x )
			dim as long dot = instr( s, "." )
			if( dot > 0 andalso instr( s, "e" ) = 0 andalso len( s ) > dot ) then
				dim as string shorter = left( s, len( s ) - 1 )
				dim as Optional( of double ) r = TryParseDouble( shorter )
				if( r.HasValue( ) ) then
					CU_ASSERT( ( r.Value( ) = x ) = 0 )
				end if
			end if
		next
	END_TEST

	'' RFC-0004 section 2.  Integers: overflow is DETECTED, not clamped.
	TEST( integer_parsing_ )
		CU_ASSERT( TryParseLongInt( "0" ).Value( ) = 0 )
		CU_ASSERT( TryParseLongInt( "-1" ).Value( ) = -1 )
		CU_ASSERT( TryParseLongInt( "9223372036854775807" ).Value( ) = MAX_VALUE_LONGINT )
		CU_ASSERT( TryParseLongInt( "-9223372036854775808" ).Value( ) = MIN_VALUE_LONGINT )

		'' one past each end
		CU_ASSERT( TryParseLongInt( "9223372036854775808" ).HasValue( ) = false )
		CU_ASSERT( TryParseLongInt( "-9223372036854775809" ).HasValue( ) = false )
		CU_ASSERT( TryParseULongInt( "18446744073709551615" ).Value( ) = MAX_VALUE_ULONGINT )
		CU_ASSERT( TryParseULongInt( "18446744073709551616" ).HasValue( ) = false )
		CU_ASSERT( TryParseULongInt( "-1" ).HasValue( ) = false )

		CU_ASSERT( TryParseLong( "2147483647" ).Value( ) = MAX_VALUE_LONG )
		CU_ASSERT( TryParseLong( "2147483648" ).HasValue( ) = false )
		CU_ASSERT( TryParseULong( "4294967295" ).Value( ) = MAX_VALUE_ULONG )
		CU_ASSERT( TryParseULong( "4294967296" ).HasValue( ) = false )

		CU_ASSERT( TryParseLongInt( "" ).HasValue( ) = false )
		CU_ASSERT( TryParseLongInt( "1.5" ).HasValue( ) = false )
		CU_ASSERT( TryParseLongInt( "1 " ).HasValue( ) = false )
		CU_ASSERT( TryParseLongInt( "abc" ).HasValue( ) = false )

		'' other bases
		CU_ASSERT( TryParseLongInt( "ff", 16 ).Value( ) = 255 )
		CU_ASSERT( TryParseLongInt( "FF", 16 ).Value( ) = 255 )
		CU_ASSERT( TryParseLongInt( "1010", 2 ).Value( ) = 10 )
		CU_ASSERT( TryParseLongInt( "777", 8 ).Value( ) = 511 )
		CU_ASSERT( TryParseLongInt( "2", 2 ).HasValue( ) = false )

		'' round-trip over a wide range
		for i as longint = -100000 to 100000 step 37
			CU_ASSERT( TryParseLongInt( str( i ) ).Value( ) = i )
		next
	END_TEST

	'' RFC-0004 section 3.  NumFormat.
	TEST( formatting_ )
		dim as NumFormat f
		f.style = NUM_FIXED
		f.digits = 2
		CU_ASSERT( ToString( 3.14159, f ) = "3.14" )
		CU_ASSERT( ToString( -3.14159, f ) = "-3.14" )

		f.grouping = true
		CU_ASSERT( ToString( 1234567.891, f ) = "1,234,567.89" )
		CU_ASSERT( ToString( 100.0, f ) = "100.00" )
		CU_ASSERT( ToString( 1000.0, f ) = "1,000.00" )

		'' the separators are the caller's, never the OS's by default
		f.groupSep = " "
		f.decimalSep = ","
		CU_ASSERT( ToString( 1234567.891, f ) = "1 234 567,89" )

		dim as NumFormat g
		g.style = NUM_PERCENT
		g.digits = 1
		CU_ASSERT( ToString( 0.256, g ) = "25.6%" )

		dim as NumFormat p
		p.style = NUM_FIXED
		p.digits = 2
		p.plusSign = true
		p.prefix = "$"
		CU_ASSERT( ToString( 5.0, p ) = "$+5.00" )

		dim as NumFormat sci
		sci.style = NUM_SCIENTIFIC
		sci.digits = 2
		CU_ASSERT( left( ToString( 1234.0, sci ), 4 ) = "1.23" )
	END_TEST

	'' VAL and STR are byte-identical to before.
	TEST( existing_behaviour_unchanged_ )
		CU_ASSERT( val( "abc" ) = 0 )
		CU_ASSERT( val( "12abc" ) = 12 )
		CU_ASSERT( val( "  7" ) = 7 )
		CU_ASSERT( str( 0.1 + 0.2 ) = "0.3" )
		CU_ASSERT( str( 1 ) = "1" )
		CU_ASSERT( str( -1.5 ) = "-1.5" )
		CU_ASSERT( valint( "42" ) = 42 )
		CU_ASSERT( vallng( "42" ) = 42 )
	END_TEST

	'' The host's separators, and nothing else -- digit shaping, per-locale
	'' currency placement and non-Gregorian digits are deliberately out of
	'' scope.  The content is machine-dependent, so what is asserted here is
	'' the SHAPE: a usable NumFormat that ToString will accept.
	TEST( current_locale_format_ )
		dim f as NumFormat = CurrentLocaleFormat( )

		'' separators are non-empty and distinct, or grouping cannot work
		CU_ASSERT( len( f.decimalSep ) > 0 )
		CU_ASSERT( len( f.groupSep ) > 0 )
		CU_ASSERT( f.decimalSep <> f.groupSep )

		'' it is a NumFormat like any other, so ToString accepts it
		CU_ASSERT( len( ToString( 1234.5, f ) ) > 0 )
		CU_ASSERT( instr( ToString( 1234.5, f ), f.decimalSep ) > 0 )

		'' the caller may override any field it returns
		f.grouping = true
		f.style    = NUM_FIXED
		f.digits   = 2
		dim as string g = ToString( 1234567.891, f )
		CU_ASSERT( instr( g, f.groupSep ) > 0 )
		CU_ASSERT( right( g, len( f.decimalSep ) + 2 ) = f.decimalSep + "89" )

		'' the SEPARATOR-FREE spelling does not vary by machine, which is why
		'' the one-argument ToString is the one tests and files should use
		CU_ASSERT( ToString( 1.5 ) = "1.5" )
		CU_ASSERT( ToString( -0.25 ) = "-0.25" )
	END_TEST

END_SUITE
