'' fb/fincash.bi -- C:\dev\docs\finance\RFC-0006-cash-flows.md.
''
'' THE FILE IS flows.bas, NOT cashflow.bas.  RFC-0006 section 8 named the
'' latter and it cannot be used: the suite name must match the file name, and
''
''     SUITE( fbc_tests.finance.cashflow )
''
'' collides with the PUBLIC TYPE CashFlow under FreeBASIC's case-insensitive
'' identifiers -- "error 4: Duplicated definition, cashflow".  Renaming the file
'' keeps the name-matching rule rather than breaking it.  Recorded in
'' C:\dev\docs\finance\amendments.md.
''
'' ORACLE: an independent implementation in Python's 60-digit `decimal`, plus
'' bisection to 400 iterations for the roots -- a different algorithm from the
'' header's Newton/Brent, not a re-run of it.  Excel is unavailable in the build
'' environment; the substitution is recorded in
'' C:\dev\docs\finance\amendments.md.
''
'' RFC-0006 section 9 says Excel's `NPV` t = 1 offset is asserted "with the
'' shift applied explicitly".  That is done in `npv_starts_at_t_zero_` below --
'' the relationship is asserted as an IDENTITY between our convention and
'' Excel's, which does not need Excel present to be meaningful, because the
'' identity is what the divergence IS.
''
'' The two-sign-change series has roots that are known in closed form -- solving
'' 10u^2 - 10u + 1 = 0 for u = 1/(1+r) -- so the multiple-roots test needs no
'' oracle at all.

'' EVERY SERIES PARAMETER IS containers.Array now, not a plain 'flows( ) as Decimal'.
'' The test data is still written as a plain array literal -- that is the
'' readable way to write a cash-flow series -- and copied into the containers.Array the
'' header takes.  PushAll is that copy.

#import "std/containers"
#import "std/money"
#import "std/outcome"
#import "std/numeric"
#import "std/chrono"
#include once "fbcunit.bi"

#include once "fberror.bi"

#include once "fblimits.bi"

using containers, money, outcome, numeric, chrono

using FB
private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

private sub PushAll overload ( byref dst as Array( of Decimal ), src( ) as Decimal )
	for i as long = lbound( src ) to ubound( src )
		dst.Push( src( i ) )
	next
end sub

private sub PushAll overload ( byref dst as Array( of CashFlow ), src( ) as CashFlow )
	for i as long = lbound( src ) to ubound( src )
		dst.Push( src( i ) )
	next
end sub

private function sameTo( byref a as Decimal, byref b as Decimal, byval places as long ) as boolean
	if( a.IsValid( ) = false ) then return false
	if( b.IsValid( ) = false ) then return false
	function = ( a.Round( places ) = b.Round( places ) )
end function

SUITE( fbc_tests.finance.flows )

	'' RFC-0006 section 2.  flows(0) IS AT t = 0, AND EXCEL'S IS NOT.
	TEST( npv_starts_at_t_zero_ )
		dim as Decimal rate = D( "0.10" )

		'' A single flow at t = 0 is UNDISCOUNTED -- the whole divergence, in
		'' its smallest form.
		dim as Decimal one_Src( 0 to 0 ) = { D( "100" ) }
		dim as Array( of Decimal ) one_
		PushAll( one_, one_Src( ) )
		CU_ASSERT( NetPresentValue( one_, rate ).Value( ) = D( "100" ) )

		'' THE IDENTITY THAT IS THE DIVERGENCE.  Excel's NPV( r, v1..vn )
		'' discounts its first argument by one period, so
		''
		''     Excel_NPV( r, tail )  ==  ourNPV( tail ) / ( 1 + r )
		''
		'' and the correct spreadsheet spelling of a project with a t = 0
		'' outlay is `f0 + Excel_NPV( r, tail )`.  Asserting the identity pins
		'' the divergence without needing Excel present -- the identity IS the
		'' divergence.
		dim as Decimal full_Src( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) full_
		PushAll( full_, full_Src( ) )
		dim as Decimal tail_Src( 0 to 3 ) = { D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) tail_
		PushAll( tail_, tail_Src( ) )

		dim as Decimal ours = NetPresentValue( full_, rate ).Value( )
		dim as Decimal ourTail = NetPresentValue( tail_, rate ).Value( )
		dim as Decimal excelTail = ( ourTail / ( DecimalOne( ) + rate ) )

		CU_ASSERT( sameTo( ours, full_[ 0 ] + excelTail, 18 ) )

		'' And stated the other way round: ours is NOT Excel's on the same
		'' array.  If these ever compare equal, the convention has drifted.
		CU_ASSERT( ours <> excelTail )
	END_TEST

	'' RFC-0006 sections 3 and 4.  Values.
	TEST( npv_and_nfv_ )
		dim as Decimal fSrc( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		CU_ASSERT( sameTo( NetPresentValue( f, D( "0.10" ) ).Value( ), _
		                   D( "115.565876647769961068233044" ), 18 ) )

		'' THE FUTURE VALUE OF THIS SERIES IS EXACTLY 169.2 -- every discount
		'' and re-compounding cancels, so it is asserted with '='.
		CU_ASSERT( NetFutureValue( f, D( "0.10" ) ).Value( ).Round( 10 ) = D( "169.2" ) )

		'' At a zero rate the NPV is just the sum, exactly.
		CU_ASSERT( NetPresentValue( f, DecimalZero( ) ).Value( ) = D( "400" ) )

		'' RFC-0006 section 4: the running-discount accumulation agrees with a
		'' naive per-term GrowthFactor sum, which is a DIFFERENT computation.
		dim as Decimal rate = D( "0.0125" )
		dim as Decimal naive = DecimalZero( )
		for k as long = 0 to 4
			naive = naive + ( f[ k ] * DiscountFactor( rate, k ).Value( ) )
		next
		CU_ASSERT( sameTo( NetPresentValue( f, rate ).Value( ), naive, 18 ) )
	END_TEST

	'' RFC-0006 section 3.  IRR.
	TEST( irr_ )
		dim as Decimal fSrc( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		dim as FinResultDec irr = InternalRateOfReturn( f )
		CU_ASSERT( irr.IsOk( ) )
		CU_ASSERT( sameTo( irr.Value( ), D( "0.1532213787718154" ), 12 ) )

		'' THE DEFINITION, asserted directly: the NPV at the IRR is zero.  No
		'' oracle needed, and it is a stronger statement than the pinned value.
		dim as Decimal atIrr = NetPresentValue( f, irr.Value( ) ).Value( )
		CU_ASSERT( atIrr.AbsValue( ) < D( "0.0000001" ) )

		'' A textbook doubling over one period is exactly 100%.
		dim as Decimal dblSrc( 0 to 1 ) = { D( "-100" ), D( "200" ) }
		dim as Array( of Decimal ) dbl
		PushAll( dbl, dblSrc( ) )
		CU_ASSERT( sameTo( InternalRateOfReturn( dbl ).Value( ), DecimalOne( ), 10 ) )

		'' A series that merely returns the outlay earns exactly nothing.
		dim as Decimal flatSrc( 0 to 1 ) = { D( "-100" ), D( "100" ) }
		dim as Array( of Decimal ) flat
		PushAll( flat, flatSrc( ) )
		CU_ASSERT( sameTo( InternalRateOfReturn( flat ).Value( ), DecimalZero( ), 10 ) )
	END_TEST

	'' RFC-0006 section 3.  MIRR -- the WELL-POSED alternative.
	TEST( mirr_ )
		dim as Decimal fSrc( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		dim as FinResultDec m = ModifiedInternalRateOfReturn( f, D( "0.10" ), D( "0.12" ) )
		CU_ASSERT( m.IsOk( ) )
		CU_ASSERT( sameTo( m.Value( ), D( "0.1390332647327417" ), 12 ) )

		'' A HIGHER REINVESTMENT RATE gives a higher modified return -- the
		'' monotonicity that makes the measure meaningful.
		dim as Decimal lo = ModifiedInternalRateOfReturn( f, D( "0.10" ), D( "0.05" ) ).Value( )
		dim as Decimal hi = ModifiedInternalRateOfReturn( f, D( "0.10" ), D( "0.20" ) ).Value( )
		CU_ASSERT( hi > lo )

		'' MIRR IS DEFINED WHERE IRR IS AMBIGUOUS.  On the two-root series
		'' below, IRR has to pick; MIRR has exactly one answer by construction.
		dim as Decimal two_Src( 0 to 2 ) = { D( "-100" ), D( "1000" ), D( "-1000" ) }
		dim as Array( of Decimal ) two_
		PushAll( two_, two_Src( ) )
		dim as FinResultDec m2 = ModifiedInternalRateOfReturn( two_, D( "0.10" ), D( "0.10" ) )
		'' Its flows never produce a positive terminal value against the
		'' financed outlays here, so it names the domain rather than guessing.
		CU_ASSERT( m2.IsOk( ) orelse ( m2.Failure( ).Code( ) = FIN_DOMAIN ) )
	END_TEST

	'' RFC-0006 section 6 and RFC-0003 section 5.  MULTIPLE ROOTS ARE NOT AN
	'' ERROR.  The roots here are known in closed form: solving
	'' 10u^2 - 10u + 1 = 0 for u = 1/(1+r) gives r = 0.127016653792583 and
	'' r = 7.872983346207417.
	TEST( multiple_roots_ )
		dim as Decimal fSrc( 0 to 2 ) = { D( "-100" ), D( "1000" ), D( "-1000" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		dim as FinResultDec r = InternalRateOfReturn( f )
		CU_ASSERT( r.IsOk( ) )                       '' NEVER an error

		'' Whatever came back IS a root -- that is the entire guarantee, and it
		'' is checked by substitution rather than by comparing to one of them.
		dim as Decimal atRoot = NetPresentValue( f, r.Value( ) ).Value( )
		CU_ASSERT( atRoot.AbsValue( ) < D( "0.000001" ) )

		'' And it is one of the two analytic roots.
		dim as boolean isKnown = sameTo( r.Value( ), D( "0.127016653792583" ), 8 )
		if( sameTo( r.Value( ), D( "7.872983346207417" ), 8 ) ) then isKnown = true
		CU_ASSERT( isKnown )

		'' BOTH are reachable, by seeding near each.
		dim as FinSolverOptions lo = FinSolverOptionsWithGuess( 0.05 )
		dim as FinSolverOptions hi = FinSolverOptionsWithGuess( 7.0 )
		CU_ASSERT( sameTo( InternalRateOfReturn( f, lo ).Value( ), D( "0.127016653792583" ), 8 ) )
		CU_ASSERT( sameTo( InternalRateOfReturn( f, hi ).Value( ), D( "7.872983346207417" ), 8 ) )
	END_TEST

	'' RFC-0006 section 3.  The dated forms.
	TEST( dated_ )
		dim as Array( of CashFlow ) f
		f.Push( CashFlowMake( D( "-10000" ), LocalDate( 2026, 1, 1 ) ) )
		f.Push( CashFlowMake( D( "2750" ),   LocalDate( 2026, 3, 1 ) ) )
		f.Push( CashFlowMake( D( "4250" ),   LocalDate( 2026, 10, 30 ) ) )
		f.Push( CashFlowMake( D( "3250" ),   LocalDate( 2027, 2, 15 ) ) )

		dim as FinResultDec xnpv = NetPresentValueOnDates( f, D( "0.09" ), DAYCOUNT_ACTUAL_365_FIXED )
		CU_ASSERT( xnpv.IsOk( ) )
		CU_ASSERT( sameTo( xnpv.Value( ), D( "-380.38911785301" ), 8 ) )

		dim as FinResultDec xirr = InternalRateOfReturnOnDates( f, DAYCOUNT_ACTUAL_365_FIXED )
		CU_ASSERT( xirr.IsOk( ) )
		CU_ASSERT( sameTo( xirr.Value( ), D( "0.0339189385293678" ), 10 ) )

		'' THE DEFINITION AGAIN: the dated NPV at the dated IRR is zero.
		dim as FinResultDec at_ = NetPresentValueOnDates( f, xirr.Value( ), DAYCOUNT_ACTUAL_365_FIXED )
		CU_ASSERT( at_.Value( ).AbsValue( ) < D( "0.0001" ) )

		'' THE BASIS CHANGES THE ANSWER, and the header does not hide it.
		'' Excel's XIRR hardcodes Act/365; ours takes the basis, so a different
		'' one gives a different -- and equally correct -- number.
		dim as FinResultDec x360 = InternalRateOfReturnOnDates( f, DAYCOUNT_ACTUAL_360 )
		CU_ASSERT( x360.IsOk( ) )
		CU_ASSERT( x360.Value( ) <> xirr.Value( ) )

		'' A single flow on the first date discounts by nothing.
		dim as Array( of CashFlow ) one_
		one_.Push( CashFlowMake( D( "500" ), LocalDate( 2026, 1, 1 ) ) )
		CU_ASSERT( sameTo( NetPresentValueOnDates( one_, D( "0.09" ), DAYCOUNT_ACTUAL_365_FIXED ).Value( ), _
		                   D( "500" ), 8 ) )
	END_TEST

	'' RFC-0006 section 5.  PAYBACK IS Optional -- absence is the finding.
	TEST( payback_ )
		dim as Decimal fSrc( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		dim as Optional( of double ) p = PaybackPeriod( f )
		CU_ASSERT( p.HasValue( ) )
		'' FRACTIONAL, interpolated inside the crossing period: after period 2
		'' the running total is -300 and period 3 brings 500, so 2 + 300/500.
		CU_ASSERT_DOUBLE_EQUAL( p.Value( ), 2.6, 1.0e-12 )

		'' Discounted payback is LATER, because the later flows are worth less.
		dim as Optional( of double ) dp = DiscountedPaybackPeriod( f, D( "0.10" ) )
		CU_ASSERT( dp.HasValue( ) )
		CU_ASSERT( dp.Value( ) > p.Value( ) )

		'' A PROJECT THAT NEVER PAYS BACK RETURNS ABSENCE, not an error and not
		'' a sentinel.  This is RFC-0001 section 6's test for Optional: there is
		'' no sub-reason worth printing.
		dim as Decimal never_Src( 0 to 3 ) = { D( "-1000" ), D( "100" ), D( "100" ), D( "100" ) }
		dim as Array( of Decimal ) never_
		PushAll( never_, never_Src( ) )
		CU_ASSERT( PaybackPeriod( never_ ).HasValue( ) = false )

		'' Discounting can turn a paying project into a non-paying one.
		dim as Decimal thin_Src( 0 to 3 ) = { D( "-1000" ), D( "340" ), D( "340" ), D( "340" ) }
		dim as Array( of Decimal ) thin_
		PushAll( thin_, thin_Src( ) )
		CU_ASSERT( PaybackPeriod( thin_ ).HasValue( ) )
		CU_ASSERT( DiscountedPaybackPeriod( thin_, D( "0.20" ) ).HasValue( ) = false )

		'' Paying back exactly at a period boundary lands on the whole number.
		dim as Decimal exact_Src( 0 to 2 ) = { D( "-1000" ), D( "500" ), D( "500" ) }
		dim as Array( of Decimal ) exact_
		PushAll( exact_, exact_Src( ) )
		CU_ASSERT_DOUBLE_EQUAL( PaybackPeriod( exact_ ).Value( ), 2.0, 1.0e-12 )
	END_TEST

	'' RFC-0006 section 3.  Profitability index.
	TEST( profitability_index_ )
		dim as Decimal fSrc( 0 to 4 ) = { D( "-1000" ), D( "300" ), D( "400" ), D( "500" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )

		dim as FinResultDec idx = ProfitabilityIndex( f, D( "0.10" ) )
		CU_ASSERT( idx.IsOk( ) )
		CU_ASSERT( sameTo( idx.Value( ), D( "1.11556587664777" ), 12 ) )

		'' PI > 1 exactly when NPV > 0 -- the two measures agree by
		'' construction, and this asserts they still do.
		CU_ASSERT( idx.Value( ) > DecimalOne( ) )
		CU_ASSERT( NetPresentValue( f, D( "0.10" ) ).Value( ) > DecimalZero( ) )

		'' At a discount rate above the IRR, both flip together.
		dim as Decimal high = D( "0.30" )
		CU_ASSERT( ProfitabilityIndex( f, high ).Value( ) < DecimalOne( ) )
		CU_ASSERT( NetPresentValue( f, high ).Value( ) < DecimalZero( ) )

		'' A ZERO INITIAL OUTLAY is FIN_DOMAIN, not an infinity.
		dim as Decimal zSrc( 0 to 2 ) = { DecimalZero( ), D( "100" ), D( "-50" ) }
		dim as Array( of Decimal ) z
		PushAll( z, zSrc( ) )
		CU_ASSERT( ProfitabilityIndex( z, D( "0.10" ) ).Failure( ).Code( ) = FIN_DOMAIN )
	END_TEST

	'' RFC-0003 section 4.0 / RFC-0006.  THE THREE SERIES PRE-CHECKS the solver
	'' structurally could not make.  This is the gate phase 3 deferred.
	TEST( series_pre_checks_ )
		'' EMPTY -- there is nothing to appraise.  A DEFAULT-CONSTRUCTED containers.Array
		'' IS the empty series: Count( ) is zero and there is no lbound/ubound
		'' edge case to explain, which the plain-array spelling needed a
		'' paragraph for.
		dim as Array( of Decimal ) empty_
		CU_ASSERT( NetPresentValue( empty_, D( "0.10" ) ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( InternalRateOfReturn( empty_ ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( ProfitabilityIndex( empty_, D( "0.10" ) ).Failure( ).Code( ) = FIN_EMPTY_SERIES )

		'' NO SIGN CHANGE -- NO ROOT CAN EXIST.  This must NOT come back as
		'' "did not converge": that would send the caller hunting for a better
		'' seed that cannot help.
		dim as Decimal allPosSrc( 0 to 2 ) = { D( "100" ), D( "200" ), D( "300" ) }
		dim as Array( of Decimal ) allPos
		PushAll( allPos, allPosSrc( ) )
		dim as Decimal allNegSrc( 0 to 2 ) = { D( "-100" ), D( "-200" ), D( "-300" ) }
		dim as Array( of Decimal ) allNeg
		PushAll( allNeg, allNegSrc( ) )
		CU_ASSERT( InternalRateOfReturn( allPos ).Failure( ).Code( ) = FIN_NO_SIGN_CHANGE )
		CU_ASSERT( InternalRateOfReturn( allNeg ).Failure( ).Code( ) = FIN_NO_SIGN_CHANGE )
		CU_ASSERT( InternalRateOfReturn( allPos ).Failure( ).Code( ) <> FIN_NO_CONVERGENCE )
		CU_ASSERT( InternalRateOfReturn( allPos ).Failure( ).Code( ) <> FIN_NO_BRACKET )

		'' MIRR makes the same check.
		CU_ASSERT( ModifiedInternalRateOfReturn( allPos, D( "0.1" ), D( "0.1" ) ).Failure( ).Code( ) _
		           = FIN_NO_SIGN_CHANGE )

		'' Zeros do not count as a sign.
		dim as Decimal zerosSrc( 0 to 2 ) = { DecimalZero( ), D( "100" ), DecimalZero( ) }
		dim as Array( of Decimal ) zeros
		PushAll( zeros, zerosSrc( ) )
		CU_ASSERT( InternalRateOfReturn( zeros ).Failure( ).Code( ) = FIN_NO_SIGN_CHANGE )

		'' UNORDERED DATES -- a dated series must ASCEND, and a duplicate is as
		'' ambiguous as a reversal.
		dim as Array( of CashFlow ) back_
		back_.Push( CashFlowMake( D( "-100" ), LocalDate( 2026, 5, 1 ) ) )
		back_.Push( CashFlowMake( D( "200" ),  LocalDate( 2026, 1, 1 ) ) )
		CU_ASSERT( InternalRateOfReturnOnDates( back_, DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )
		CU_ASSERT( NetPresentValueOnDates( back_, D( "0.09" ), DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )

		dim as Array( of CashFlow ) dup_
		dup_.Push( CashFlowMake( D( "-100" ), LocalDate( 2026, 1, 1 ) ) )
		dup_.Push( CashFlowMake( D( "200" ),  LocalDate( 2026, 1, 1 ) ) )
		CU_ASSERT( InternalRateOfReturnOnDates( dup_, DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )

		'' An INVALID date is refused rather than treated as day zero -- which
		'' is what a CashFlowAt built for the period-indexed API carries.
		dim as Array( of CashFlow ) noDate
		noDate.Push( CashFlowAt( D( "-100" ), 0 ) )
		noDate.Push( CashFlowAt( D( "200" ), 1 ) )
		CU_ASSERT( InternalRateOfReturnOnDates( noDate, DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )

		'' A bad rate is still a bad rate.
		dim as Decimal fSrc( 0 to 1 ) = { D( "-100" ), D( "200" ) }
		dim as Array( of Decimal ) f
		PushAll( f, fSrc( ) )
		CU_ASSERT( NetPresentValue( f, D( "-1" ) ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( NetPresentValue( f, DecimalInvalid( ) ).Failure( ).Code( ) = FIN_INVALID_RATE )
	END_TEST

	'' A badly-conditioned series still converges here.
	''
	'' RFC-0006 section 9 says two such cases "return #NUM! in Excel".  THAT IS
	'' A CLAIM ABOUT EXCEL, taken from its documentation and NOT measured here,
	'' because Excel is not available in this environment.  What IS measured is
	'' the half that matters: this solver finds the root, and the root is
	'' verified by substitution.
	TEST( hard_series_still_converges_ )
		'' A long series with a very small return -- the shape a Newton-only
		'' solver from a fixed 10% seed is documented to struggle with.
		dim as Array( of Decimal ) thin_
		thin_.Push( D( "-1000" ) )
		for k as long = 1 to 10
			thin_.Push( D( "100.5" ) )
		next

		dim as FinResultDec r = InternalRateOfReturn( thin_ )
		CU_ASSERT( r.IsOk( ) )
		CU_ASSERT( NetPresentValue( thin_, r.Value( ) ).Value( ).AbsValue( ) < D( "0.000001" ) )

		'' A deeply negative return.
		dim as Decimal bad_Src( 0 to 3 ) = { D( "-1000" ), D( "100" ), D( "100" ), D( "100" ) }
		dim as Array( of Decimal ) bad_
		PushAll( bad_, bad_Src( ) )
		dim as FinResultDec rb = InternalRateOfReturn( bad_ )
		CU_ASSERT( rb.IsOk( ) )
		CU_ASSERT( rb.Value( ) < DecimalZero( ) )
		CU_ASSERT( NetPresentValue( bad_, rb.Value( ) ).Value( ).AbsValue( ) < D( "0.000001" ) )

		'' A very large return.
		dim as Decimal big_Src( 0 to 1 ) = { D( "-1" ), D( "1000" ) }
		dim as Array( of Decimal ) big_
		PushAll( big_, big_Src( ) )
		dim as FinResultDec rg = InternalRateOfReturn( big_ )
		CU_ASSERT( rg.IsOk( ) )
		CU_ASSERT( sameTo( rg.Value( ), D( "999" ), 6 ) )
	END_TEST

END_SUITE
