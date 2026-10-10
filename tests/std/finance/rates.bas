'' fb/fincore.bi -- C:\dev\docs\finance\RFC-0002-interest-and-rates.md.
''
'' THE ORACLE, NAMED UP FRONT.  Every non-obvious expected value below was
'' produced by an INDEPENDENT implementation -- Python's arbitrary-precision
'' `decimal` module at 60 significant digits, computing the same closed form --
'' and copied back here.  Nothing is an expectation of what this header happens
'' to produce.
''
'' RFC-0002 section 9 names Excel EFFECT/NOMINAL as the oracle for the rate
'' conversions.  Excel is not available in the build environment, so the
'' high-precision reference stands in for it; the two agree by construction
'' because EFFECT is documented as exactly the closed form computed here.  That
'' substitution is recorded in C:\dev\docs\finance\amendments.md rather than
'' being left as a silent difference between the RFC and the suite.
''
'' The 30/360 and Act/Act cases come from the rules in ISDA's 2006 Definitions
'' 4.16(f) and 4.16(g), applied by hand.
''
'' Where an expected value TERMINATES it is asserted with '=', exactly.  Where
'' it does not, the assertion is agreement to a stated number of decimal places
'' -- because the exact kernel reduces to FIN_WORK_SCALE after every step and
'' RFC-0002 section 6.3 bounds, rather than eliminates, the resulting error.

#import "std/money"
#import "std/outcome"
#import "std/numeric"
#import "std/chrono"
#include once "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

#include once "fblimits.bi"

using money, outcome, numeric, chrono

using FB
private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

'' Agreement to 'places' decimal places.  Both sides are reduced the same way,
'' so this is a real assertion and not a tolerance that hides a sign error.
private function sameTo( byref a as Decimal, byref b as Decimal, byval places as long ) as boolean
	if( a.IsValid( ) = false ) then return false
	if( b.IsValid( ) = false ) then return false
	function = ( a.Round( places ) = b.Round( places ) )
end function

'' ( 1 + i )^n by a naive loop, written independently of the header's binary
'' exponentiation.  Deliberately NOT reduced between steps, so it is a
'' different computation and not a re-run of the same one.
private function naivePow( byref i as Decimal, byval n as long ) as Decimal
	dim as Decimal acc = DecimalOne( )
	dim as Decimal f = DecimalOne( ) + i
	for k as long = 1 to n
		acc = ( acc * f ).Round( 26 )
	next
	function = acc
end function

SUITE( fbc_tests.finance.rates )

	'' RFC-0002 section 2.  The values ARE periods per year -- RatePerPeriod
	'' divides by the enum, so a wrong value here is a wrong rate everywhere.
	TEST( convention_enums_ )
		CU_ASSERT( COMPOUND_ANNUAL      = 1 )
		CU_ASSERT( COMPOUND_SEMIANNUAL  = 2 )
		CU_ASSERT( COMPOUND_QUARTERLY   = 4 )
		CU_ASSERT( COMPOUND_MONTHLY     = 12 )
		CU_ASSERT( COMPOUND_SEMIMONTHLY = 24 )
		CU_ASSERT( COMPOUND_BIWEEKLY    = 26 )
		CU_ASSERT( COMPOUND_WEEKLY      = 52 )
		CU_ASSERT( COMPOUND_DAILY_360   = 360 )
		CU_ASSERT( COMPOUND_DAILY_365   = 365 )

		'' The two that are NOT frequencies.
		CU_ASSERT( COMPOUND_SIMPLE     = 0 )
		CU_ASSERT( COMPOUND_CONTINUOUS = -1 )

		CU_ASSERT( PAY_ANNUAL     = 1 )
		CU_ASSERT( PAY_MONTHLY    = 12 )
		CU_ASSERT( PAY_BIWEEKLY   = 26 )
		CU_ASSERT( PAY_WEEKLY     = 52 )

		'' NEGATIVE ON PURPOSE, so no SELECT CASE can fall through to abs( )
		'' and treat an accelerated product as an ordinary one.
		CU_ASSERT( PAY_ACCELERATED_BIWEEKLY < 0 )
		CU_ASSERT( PAY_ACCELERATED_WEEKLY   < 0 )

		CU_ASSERT( PAY_END_OF_PERIOD   = 0 )
		CU_ASSERT( PAY_BEGIN_OF_PERIOD = 1 )
	END_TEST

	'' RFC-0002 section 7.  EXACT: a plain Decimal division, nothing capped.
	TEST( rate_per_period_ )
		dim as Decimal j = D( "0.0595" )

		'' EXACTLY j/12, compared with '=' -- this is the claim RFC-0002
		'' section 7.1 makes for the US convention, and it is why the division
		'' is NOT reduced to FIN_WORK_SCALE.
		CU_ASSERT( RatePerPeriod( j, COMPOUND_MONTHLY ).Value( ) = ( j / DecimalFromInt( 12 ) ) )
		CU_ASSERT( RatePerPeriod( j, COMPOUND_SEMIANNUAL ).Value( ) = D( "0.02975" ) )
		CU_ASSERT( RatePerPeriod( j, COMPOUND_QUARTERLY ).Value( ) = D( "0.014875" ) )
		CU_ASSERT( RatePerPeriod( j, COMPOUND_ANNUAL ).Value( ) = j )

		'' Simple interest has no per-period compounding to divide into.
		CU_ASSERT( RatePerPeriod( j, COMPOUND_SIMPLE ).Value( ) = j )

		'' Continuous has no "per period" at all -- and this must be a named
		'' refusal, not a division by zero.
		dim as FinResultDec k = RatePerPeriod( j, COMPOUND_CONTINUOUS )
		CU_ASSERT( k.IsOk( ) = false )
		CU_ASSERT( k.Failure( ).Code( ) = FIN_INVALID_BASIS )
	END_TEST

	'' RFC-0002 section 7.  Effective annual from nominal.
	TEST( effective_from_nominal_ )
		'' TERMINATING cases -- asserted EXACTLY.  ( 1 + j/2 )^2 and
		'' ( 1 + j/4 )^4 have finite expansions, so the kernel's reduce never
		'' fires and there is nothing to approximate.
		CU_ASSERT( RateEffectiveFromNominal( D( "0.0595" ), COMPOUND_SEMIANNUAL ).Value( ) _
		           = D( "0.0603850625" ) )
		CU_ASSERT( RateEffectiveFromNominal( D( "0.10" ), COMPOUND_QUARTERLY ).Value( ) _
		           = D( "0.103812890625" ) )
		CU_ASSERT( RateEffectiveFromNominal( D( "0.0725" ), COMPOUND_SEMIANNUAL ).Value( ) _
		           = D( "0.07381406250" ) )
		CU_ASSERT( RateEffectiveFromNominal( D( "0.0595" ), COMPOUND_QUARTERLY ).Value( ) _
		           = D( "0.060840808013164306640625" ) )

		'' NON-TERMINATING -- agreement to 20 places against the reference.
		CU_ASSERT( sameTo( RateEffectiveFromNominal( D( "0.0595" ), COMPOUND_MONTHLY ).Value( ), _
		                   D( "0.061149734374645764804842" ), 20 ) )
		CU_ASSERT( sameTo( RateEffectiveFromNominal( D( "0.05" ), COMPOUND_MONTHLY ).Value( ), _
		                   D( "0.051161897881733189804874" ), 20 ) )
		CU_ASSERT( sameTo( RateEffectiveFromNominal( D( "0.03" ), COMPOUND_DAILY_365 ).Value( ), _
		                   D( "0.030453263600509832406567" ), 20 ) )

		'' Annual compounding is the identity, exactly.
		CU_ASSERT( RateEffectiveFromNominal( D( "0.0595" ), COMPOUND_ANNUAL ).Value( ) = D( "0.0595" ) )
	END_TEST

	'' RFC-0002 section 7.  The DOUBLE KERNEL direction, so the claim is 15
	'' significant digits, not 20 places -- and the test says which.
	TEST( nominal_from_effective_ )
		'' Round trip: nominal -> effective -> nominal recovers the input.
		dim as Decimal j = D( "0.0595" )
		dim as FinResultDec eff = RateEffectiveFromNominal( j, COMPOUND_MONTHLY )
		dim as FinResultDec back = RateNominalFromEffective( eff.Value( ), COMPOUND_MONTHLY )
		CU_ASSERT( sameTo( back.Value( ), j, 15 ) )

		'' m = 1 is the identity and takes the EXACT path -- taking the double
		'' path for it would round a rate the caller handed us verbatim.
		CU_ASSERT( RateNominalFromEffective( j, COMPOUND_ANNUAL ).Value( ) = j )

		'' Simple is likewise pass-through.
		CU_ASSERT( RateNominalFromEffective( j, COMPOUND_SIMPLE ).Value( ) = j )
	END_TEST

	'' RFC-0002 section 7.  Continuous compounding, both directions.
	TEST( continuous_conversions_ )
		dim as Decimal eff = D( "0.0603850625" )

		dim as FinResultDec c = RateContinuousFromEffective( eff )
		CU_ASSERT( c.IsOk( ) )

		'' exp( ln( 1 + e ) ) - 1 = e, to the double's precision.
		dim as FinResultDec backx = RateEffectiveFromContinuous( c.Value( ) )
		CU_ASSERT( sameTo( backx.Value( ), eff, 15 ) )

		'' A continuous rate is always BELOW the effective rate it produces.
		CU_ASSERT( c.Value( ) < eff )
	END_TEST

	'' RFC-0002 section 7.1 -- THE FUNNEL.  This is the test the module exists
	'' for.
	TEST( rate_per_payment_funnel_ )
		dim as Decimal j = D( "0.0595" )

		'' CASE 1 -- m = p, the US mortgage.  EXACT, and asserted with '=':
		'' the value never touches a double.
		dim as FinResultDec us = RatePerPaymentFromNominal( j, COMPOUND_MONTHLY, PAY_MONTHLY )
		CU_ASSERT( us.Value( ) = ( j / DecimalFromInt( 12 ) ) )

		'' CASE 2 -- m/p a whole number.  Monthly compounding, annual payments:
		'' ( 1 + j/12 )^12 - 1, which is the effective annual rate, EXACTLY the
		'' same value the other entry point produces.
		dim as FinResultDec whole = RatePerPaymentFromNominal( j, COMPOUND_MONTHLY, PAY_ANNUAL )
		CU_ASSERT( whole.Value( ) = RateEffectiveFromNominal( j, COMPOUND_MONTHLY ).Value( ) )

		'' CASE 3 -- THE CANADIAN MORTGAGE.  m = 2, p = 12, so the exponent is
		'' 1/6 and this is the one crossing of the double boundary.  15
		'' significant digits is the honest claim.
		dim as FinResultDec ca = RatePerPaymentFromNominal( j, COMPOUND_SEMIANNUAL, PAY_MONTHLY )
		CU_ASSERT( sameTo( ca.Value( ), D( "0.004897965062376150288713" ), 15 ) )

		'' AND IT COMPOUNDS BACK.  Six of the Canadian monthly rate must give
		'' the semi-annual rate it was derived from.  This needs no oracle at
		'' all, and it is what makes the conversion right rather than merely
		'' reproducible.
		dim as FinResultDec six = GrowthFactor( ca.Value( ), 6 )
		CU_ASSERT( sameTo( six.Value( ) - DecimalOne( ), D( "0.02975" ), 15 ) )

		'' THE TWO CONVENTIONS DIFFER, and by enough to matter.  If this ever
		'' passes as equal, the compounding parameter has stopped being read.
		CU_ASSERT( ca.Value( ) <> us.Value( ) )
		CU_ASSERT( ca.Value( ) < us.Value( ) )

		'' The accelerated frequencies return the UNDERLYING MONTHLY rate --
		'' RFC-0002 section 7.1, and RFC-0005 section 4.1 splits the payment.
		dim as FinResultDec acc = RatePerPaymentFromNominal( j, COMPOUND_SEMIANNUAL, PAY_ACCELERATED_BIWEEKLY )
		CU_ASSERT( acc.Value( ) = ca.Value( ) )
	END_TEST

	'' RFC-0002 section 6.3.  The exact growth kernel.
	TEST( growth_kernel_ )
		dim as Decimal i = D( "0.0049583333333333333333333333" )   '' 0.0595/12

		'' n = 0 short-circuits before the loop, so it is exactly one.
		CU_ASSERT( GrowthFactor( i, 0 ).Value( ) = DecimalOne( ) )

		'' n = 1 is NOT exactly 1 + i when i carries more than FIN_WORK_SCALE
		'' places, and that is the specified behaviour rather than a defect:
		'' RFC-0002 section 6.3 reduces after EVERY multiply, including the
		'' first.  This rate has 28 places because 0.0595/12 does not
		'' terminate, so four of them are dropped.  The contract is "exact to
		'' FIN_WORK_SCALE", and the assertion says exactly that.
		CU_ASSERT( sameTo( GrowthFactor( i, 1 ).Value( ), DecimalOne( ) + i, 24 ) )

		'' A rate that FITS in FIN_WORK_SCALE is untouched, and there n = 1 is
		'' exact -- which is the common case, and worth pinning separately.
		CU_ASSERT( GrowthFactor( D( "0.0125" ), 1 ).Value( ) = D( "1.0125" ) )

		'' Against the 60-digit reference, to 20 places.
		CU_ASSERT( sameTo( GrowthFactor( i, 360 ).Value( ), _
		                   D( "5.933351683992691323795766" ), 20 ) )
		CU_ASSERT( sameTo( GrowthFactor( i, 300 ).Value( ), _
		                   D( "4.409778160832663188249847" ), 20 ) )

		'' Against a NAIVE 360-step loop written separately above -- a
		'' different algorithm, not a re-run of this one.
		CU_ASSERT( sameTo( GrowthFactor( i, 360 ).Value( ), naivePow( i, 360 ), 20 ) )
		CU_ASSERT( sameTo( GrowthFactor( i, 120 ).Value( ), naivePow( i, 120 ), 20 ) )

		'' THE EXPONENT LAW, which needs no oracle: g(a) * g(b) = g(a+b).
		'' It exercises the binary decomposition at every bit width.
		for n as long = 1 to 64
			dim as Decimal ga = GrowthFactor( i, n ).Value( )
			dim as Decimal gb = GrowthFactor( i, n + 7 ).Value( )
			dim as Decimal gs = GrowthFactor( i, n + n + 7 ).Value( )
			CU_ASSERT( sameTo( ga * gb, gs, 20 ) )
		next

		'' A terminating rate stays EXACT through the kernel: 1.5^8 has a
		'' finite expansion and the reduce never fires.
		CU_ASSERT( GrowthFactor( D( "0.5" ), 8 ).Value( ) = D( "25.62890625" ) )

		'' Zero rate: the growth factor is 1 for every n, exactly.
		for n as long = 0 to 40
			CU_ASSERT( GrowthFactor( DecimalZero( ), n ).Value( ) = DecimalOne( ) )
		next
	END_TEST

	'' RFC-0002 section 6.3.  Discount is the reciprocal, and the round trip
	'' is the assertion.
	TEST( discount_factor_ )
		dim as Decimal i = D( "0.0049583333333333333333333333" )

		CU_ASSERT( DiscountFactor( i, 0 ).Value( ) = DecimalOne( ) )
		CU_ASSERT( sameTo( DiscountFactor( i, 360 ).Value( ), _
		                   D( "0.168538804584574460486431" ), 20 ) )

		'' g * v = 1, to 20 places, across a spread of terms.
		for n as long = 1 to 480 step 17
			dim as Decimal g = GrowthFactor( i, n ).Value( )
			dim as Decimal v = DiscountFactor( i, n ).Value( )
			CU_ASSERT( sameTo( g * v, DecimalOne( ), 20 ) )
		next
	END_TEST

	'' RFC-0002 section 6.3.  Overflow is a NAMED refusal, not a silent loss
	'' of digits.
	TEST( growth_overflow_ )
		'' 2.0 per period for 200 periods is 3^200, far past a 96-bit mantissa.
		dim as FinResultDec big = GrowthFactor( D( "2" ), 200 )
		CU_ASSERT( big.IsOk( ) = false )
		CU_ASSERT( big.Failure( ).Code( ) = FIN_OVERFLOW )

		'' And a rate at or below -1 is refused before any arithmetic.
		CU_ASSERT( GrowthFactor( D( "-1" ), 5 ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( GrowthFactor( D( "-2" ), 5 ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( GrowthFactor( D( "0.05" ), -1 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0002 section 3.  Day count -- the actual/N family.
	TEST( day_count_actual_ )
		dim as LocalDate a = LocalDate( 2026, 1, 1 )
		dim as LocalDate b = LocalDate( 2027, 1, 1 )

		CU_ASSERT( DayCountDays( a, b, DAYCOUNT_ACTUAL_365_FIXED ) = 365 )
		CU_ASSERT( DayCountFraction( a, b, DAYCOUNT_ACTUAL_365_FIXED ) = DecimalOne( ) )

		'' Act/360 over a 365-day year is MORE than one year, and that is the
		'' point of the basis rather than a bug.
		CU_ASSERT( DayCountFraction( a, b, DAYCOUNT_ACTUAL_360 ) > DecimalOne( ) )
		CU_ASSERT( DayCountFraction( a, b, DAYCOUNT_ACTUAL_360 ) _
		           = ( DecimalFromInt( 365 ) / DecimalFromInt( 360 ) ) )

		'' A leap year really is 366 days.
		CU_ASSERT( DayCountDays( LocalDate( 2024, 1, 1 ), LocalDate( 2025, 1, 1 ), _
		                         DAYCOUNT_ACTUAL_365_FIXED ) = 366 )

		'' Act/365.25 -- an integer over an integer, exactly.
		CU_ASSERT( DayCountFraction( a, b, DAYCOUNT_ACTUAL_365_25 ) _
		           = ( DecimalFromInt( 36500 ) / DecimalFromInt( 36525 ) ) )

		'' An Invalid date yields a zero span rather than a wild number.
		CU_ASSERT( DayCountDays( LocalDate.Invalid( ), b, DAYCOUNT_ACTUAL_365_FIXED ) = 0 )
		CU_ASSERT( DayCountFraction( a, LocalDate.Invalid( ), DAYCOUNT_ACTUAL_360 ).IsZero( ) )
	END_TEST

	'' RFC-0002 section 3.  Act/Act (ISDA) -- leap-aware, split per year.
	TEST( day_count_act_act_ )
		'' A whole leap year is exactly 1: 366/366.
		CU_ASSERT( DayCountFraction( LocalDate( 2024, 1, 1 ), LocalDate( 2025, 1, 1 ), _
		                             DAYCOUNT_ACTUAL_ACTUAL_ISDA ) = DecimalOne( ) )

		'' A whole common year is exactly 1: 365/365.
		CU_ASSERT( DayCountFraction( LocalDate( 2026, 1, 1 ), LocalDate( 2027, 1, 1 ), _
		                             DAYCOUNT_ACTUAL_ACTUAL_ISDA ) = DecimalOne( ) )

		'' Four consecutive years spanning one leap year is exactly 4 -- the
		'' per-year split is what makes this land on a whole number, and a
		'' single 365 or 366 denominator could not.
		CU_ASSERT( DayCountFraction( LocalDate( 2023, 1, 1 ), LocalDate( 2027, 1, 1 ), _
		                             DAYCOUNT_ACTUAL_ACTUAL_ISDA ) = DecimalFromInt( 4 ) )

		'' A span CROSSING a year boundary: 2023-07-01 to 2024-07-01 is
		'' 184 days in 2023 (of 365) plus 182 days in 2024 (of 366).
		'' Two statements, not one continued across a line: a '_' continuation
		'' at a binary operator OUTSIDE parentheses does not survive an fbcunit
		'' TEST body, giving "error 3: Expected End-of-Line, found '+'".
		'' Continuations INSIDE an open paren are fine, and are used freely
		'' elsewhere in this file.  Measured.
		dim as Decimal expect_ = DecimalFromInt( 184 ) / DecimalFromInt( 365 )
		expect_ = expect_ + ( DecimalFromInt( 182 ) / DecimalFromInt( 366 ) )
		CU_ASSERT( DayCountFraction( LocalDate( 2023, 7, 1 ), LocalDate( 2024, 7, 1 ), _
		                             DAYCOUNT_ACTUAL_ACTUAL_ISDA ) = expect_ )

		'' Reversing the dates negates the fraction.
		dim as Decimal fwd = DayCountFraction( LocalDate( 2023, 7, 1 ), LocalDate( 2024, 7, 1 ), _
		                                       DAYCOUNT_ACTUAL_ACTUAL_ISDA )
		dim as Decimal rev = DayCountFraction( LocalDate( 2024, 7, 1 ), LocalDate( 2023, 7, 1 ), _
		                                       DAYCOUNT_ACTUAL_ACTUAL_ISDA )
		CU_ASSERT( rev = -fwd )

		'' A zero-length span is zero.
		CU_ASSERT( DayCountFraction( LocalDate( 2024, 3, 4 ), LocalDate( 2024, 3, 4 ), _
		                             DAYCOUNT_ACTUAL_ACTUAL_ISDA ).IsZero( ) )
	END_TEST

	'' RFC-0002 section 3.  The two 30/360 bases, ISDA 2006 Definitions
	'' 4.16(f) and 4.16(g).  They differ ONLY in end-of-month handling, so
	'' every case below is chosen to sit on that difference.
	TEST( day_count_thirty_360_ )
		'' A plain month is 30 days on both.
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 15 ), LocalDate( 2026, 2, 15 ), _
		                         DAYCOUNT_THIRTY_360_US ) = 30 )
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 15 ), LocalDate( 2026, 2, 15 ), _
		                         DAYCOUNT_THIRTY_E_360 ) = 30 )

		'' A whole year is 360 on both.
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 1 ), LocalDate( 2027, 1, 1 ), _
		                         DAYCOUNT_THIRTY_360_US ) = 360 )
		CU_ASSERT( DayCountFraction( LocalDate( 2026, 1, 1 ), LocalDate( 2027, 1, 1 ), _
		                             DAYCOUNT_THIRTY_E_360 ) = DecimalOne( ) )

		'' D1 = 31 becomes 30 under BOTH rules.
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 31 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_360_US ) = 60 )
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 31 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_E_360 ) = 60 )

		'' THE DIVERGENCE.  D1 = 15, D2 = 31.
		''   US   : rule 2 needs D1 to be 30 or 31; it is 15, so D2 STAYS 31
		''          -> 30*1 + (31-15) = 46
		''   30E  : D2 = 31 becomes 30 unconditionally
		''          -> 30*1 + (30-15) = 45
		'' If these two ever agree, one of the rules has been dropped.
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 15 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_360_US ) = 76 )
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 15 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_E_360 ) = 75 )

		'' D1 = 30, D2 = 31: US rule 2 fires because D1 is 30.
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 30 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_360_US ) = 60 )
		CU_ASSERT( DayCountDays( LocalDate( 2026, 1, 30 ), LocalDate( 2026, 3, 31 ), _
		                         DAYCOUNT_THIRTY_E_360 ) = 60 )

		'' The 30/360 fraction is days/360, exactly.
		CU_ASSERT( DayCountFraction( LocalDate( 2026, 1, 15 ), LocalDate( 2026, 3, 31 ), _
		                             DAYCOUNT_THIRTY_360_US ) _
		           = ( DecimalFromInt( 76 ) / DecimalFromInt( 360 ) ) )
	END_TEST

	'' RFC-0002 section 5.  Simple interest -- EXACT, two multiplies.
	TEST( simple_interest_ )
		dim as Decimal p = D( "10000" )
		dim as Decimal r = D( "0.05" )

		'' A full year at 5% is 500, exactly.
		CU_ASSERT( SimpleInterest( p, r, DecimalOne( ) ) = D( "500" ) )

		'' Half a year is half of it, exactly.
		CU_ASSERT( SimpleInterest( p, r, D( "0.5" ) ) = D( "250" ) )

		'' Between two dates, Act/365F over a full common year.
		CU_ASSERT( SimpleInterestBetween( p, r, LocalDate( 2026, 1, 1 ), _
		                                  LocalDate( 2027, 1, 1 ), _
		                                  DAYCOUNT_ACTUAL_365_FIXED ) = D( "500" ) )

		'' Act/360 over the same span is MORE, because the basis divides 365
		'' actual days by a 360-day year.
		dim as Decimal i360 = SimpleInterestBetween( p, r, LocalDate( 2026, 1, 1 ), _
		                                             LocalDate( 2027, 1, 1 ), _
		                                             DAYCOUNT_ACTUAL_360 )
		CU_ASSERT( i360 > D( "500" ) )

		'' Asserted against the SAME association order the implementation uses
		'' -- principal * rate * fraction -- and not against
		'' ( 500 * 365 ) / 360, which is a DIFFERENT number in the last digit.
		''
		'' Decimal multiplication and division are exact only up to 28
		'' significant digits, so they are NOT associative across a
		'' non-terminating quotient: ( 500 * 365 ) / 360 keeps all its digits
		'' until the single division, while 500 * ( 365 / 360 ) rounds 365/360
		'' to 28 digits first and then scales it up.  Neither is wrong; they
		'' are different computations.  Worth pinning explicitly, because an
		'' assertion written the other way looks equally reasonable and fails.
		dim as Decimal yf = DayCountFraction( LocalDate( 2026, 1, 1 ), _
		                                      LocalDate( 2027, 1, 1 ), _
		                                      DAYCOUNT_ACTUAL_360 )
		CU_ASSERT( i360 = ( p * r * yf ) )
		CU_ASSERT( sameTo( i360, D( "506.944444444444444444444444" ), 20 ) )

		'' Zero principal, zero rate and zero time each give exactly zero.
		CU_ASSERT( SimpleInterest( DecimalZero( ), r, DecimalOne( ) ).IsZero( ) )
		CU_ASSERT( SimpleInterest( p, DecimalZero( ), DecimalOne( ) ).IsZero( ) )
		CU_ASSERT( SimpleInterest( p, r, DecimalZero( ) ).IsZero( ) )
	END_TEST

	'' RFC-0002 section 4.  Rounding policy.
	TEST( money_rounding_ )
		dim as MoneyRounding cents = MoneyRoundingCents( )
		CU_ASSERT( cents.Digits_ = 2 )
		CU_ASSERT( cents.Mode_ = DEC_HALF_EVEN )
		CU_ASSERT( cents.RoundEach_ )

		'' HALF TO EVEN, which is the default for the reason currency.bi and
		'' decimal.bi both give: half-up biases every tie the same way.
		CU_ASSERT( MoneyRound( D( "2.675" ), cents ) = D( "2.68" ) )
		CU_ASSERT( MoneyRound( D( "2.665" ), cents ) = D( "2.66" ) )
		CU_ASSERT( MoneyRound( D( "-2.675" ), cents ) = D( "-2.68" ) )
		CU_ASSERT( MoneyRound( D( "-2.665" ), cents ) = D( "-2.66" ) )

		'' Not a tie -- ordinary rounding either way.
		CU_ASSERT( MoneyRound( D( "2.674" ), cents ) = D( "2.67" ) )
		CU_ASSERT( MoneyRound( D( "2.676" ), cents ) = D( "2.68" ) )

		dim as MoneyRounding four = MoneyRoundingBankersFour( )
		CU_ASSERT( four.Digits_ = 4 )
		CU_ASSERT( MoneyRound( D( "1.00005" ), four ) = D( "1.0000" ) )
		CU_ASSERT( MoneyRound( D( "1.00015" ), four ) = D( "1.0002" ) )

		'' EXACT mode does not round at all -- RoundEach_ is false, so
		'' MoneyRound is the identity and the value passes through whole.
		dim as MoneyRounding exact_ = MoneyRoundingExact( )
		CU_ASSERT( exact_.RoundEach_ = false )
		CU_ASSERT( MoneyRound( D( "2.675" ), exact_ ) = D( "2.675" ) )
		CU_ASSERT( MoneyRound( D( "1.23456789012345678901234567" ), exact_ ) _
		           = D( "1.23456789012345678901234567" ) )

		'' An explicitly-built policy honours all three fields.
		dim as MoneyRounding up = MoneyRoundingMake( 2, DEC_HALF_UP, TRUE )
		CU_ASSERT( MoneyRound( D( "2.665" ), up ) = D( "2.67" ) )
		CU_ASSERT( MoneyRound( D( "2.675" ), up ) = D( "2.68" ) )
	END_TEST

	'' RFC-0001 sections 3 and 6.  The error surface, asserted by CODE rather
	'' than merely "it failed".
	TEST( error_codes_ )
		dim as Decimal j = D( "0.0595" )

		CU_ASSERT( RatePerPeriod( j, COMPOUND_CONTINUOUS ).Failure( ).Code( ) = FIN_INVALID_BASIS )
		CU_ASSERT( GrowthFactor( D( "-1.5" ), 3 ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( GrowthFactor( j, -5 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
		CU_ASSERT( GrowthFactor( D( "2" ), 400 ).Failure( ).Code( ) = FIN_OVERFLOW )

		'' An Invalid Decimal in gives a named refusal, not an Invalid out.
		CU_ASSERT( RatePerPeriod( DecimalInvalid( ), COMPOUND_MONTHLY ).Failure( ).Code( ) _
		           = FIN_INVALID_RATE )

		'' Every code has a message, and none of them is the fallback.
		CU_ASSERT( FinanceErrorMessage( FIN_NO_SIGN_CHANGE ) <> FinanceErrorMessage( FIN_UNKNOWN ) )
		CU_ASSERT( FinanceErrorMessage( FIN_NO_BRACKET ) <> FinanceErrorMessage( FIN_NO_CONVERGENCE ) )
		CU_ASSERT( len( FinanceErrorMessage( FIN_OVERFLOW ) ) > 0 )

		'' The solver payload survives construction and copy.
		dim as FinanceError s = FinanceErrorSolver( FIN_NO_CONVERGENCE, 128, 1.0e-9, 0.0731 )
		dim as FinanceError t = s
		CU_ASSERT( t.Code( ) = FIN_NO_CONVERGENCE )
		CU_ASSERT( t.Iterations( ) = 128 )
		CU_ASSERT_DOUBLE_EQUAL( t.Residual( ), 1.0e-9, 1.0e-18 )
		CU_ASSERT_DOUBLE_EQUAL( t.BestGuess( ), 0.0731, 1.0e-15 )

		'' A non-solver error carries NaN as its best guess -- absence of an
		'' iterate, said in the type rather than as a zero that reads as one.
		CU_ASSERT( IsNaN( FinanceErrorMake( FIN_EMPTY_SERIES ).BestGuess( ) ) )
		CU_ASSERT( FinanceErrorMake( FIN_EMPTY_SERIES ).Iterations( ) = 0 )

		'' A DEFAULT-CONSTRUCTED Result is a FAILURE (result.bi:24-28), and its
		'' default FinanceError is FIN_UNKNOWN.
		dim as FinResultDec blank
		CU_ASSERT( blank.IsOk( ) = false )
		CU_ASSERT( blank.Failure( ).Code( ) = FIN_UNKNOWN )
	END_TEST

END_SUITE
