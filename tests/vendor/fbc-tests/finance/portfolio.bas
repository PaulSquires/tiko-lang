'' fb/finport.bi -- C:\dev\docs\finance\RFC-0008-portfolio.md.
''
'' ORACLE: an independent implementation in Python, computing each statistic
'' from its definition rather than by calling a library -- so the sample and
'' population forms are written out separately and cannot be confused.  Excel
'' and pandas are named in RFC-0008 section 9 and are unavailable here; the
'' substitution is recorded in C:\dev\docs\finance\amendments.md.
''
'' THE ASSERTION THIS SUITE EXISTS FOR is `sample_vs_population_`.  RFC-0008
'' section 5 warns that mixing a sample covariance with a population variance
'' scales Beta by (n-1)/n -- and the RFC's own delegation table specified
'' exactly that mixture.  The test computes BOTH and asserts the header uses
'' the correct one, so the bug cannot come back quietly.
''
'' EVERY SERIES PARAMETER IS FB.Array now, not a plain 'r( ) as double'.  Test
'' data is still written as a plain array literal -- that is the readable way to
'' write a return series -- and copied into the FB.Array the header takes.
'' PushAll is that copy.

#include once "fbcunit.bi"
#include once "fb/array.bi"
#include once "fb/finance.bi"

using FB

private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

private sub PushAll overload ( byref dst as Array( of double ), src( ) as double )
	for i as long = lbound( src ) to ubound( src )
		dst.Push( src( i ) )
	next
end sub

private sub PushAll overload ( byref dst as Array( of long ), src( ) as long )
	for i as long = lbound( src ) to ubound( src )
		dst.Push( src( i ) )
	next
end sub

private sub PushAll overload ( byref dst as Array( of Decimal ), src( ) as Decimal )
	for i as long = lbound( src ) to ubound( src )
		dst.Push( src( i ) )
	next
end sub

'' A 12-month return series and its benchmark, used throughout.
#define SERIES_N 12

private sub fillSeries( byref r as Array( of double ), byref b as Array( of double ) )
	r.Clear( )
	b.Clear( )
	dim as double rr( 0 to SERIES_N - 1 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
	                                          0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
	dim as double bb( 0 to SERIES_N - 1 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
	                                          0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }
	PushAll( r, rr( ) )
	PushAll( b, bb( ) )
end sub

SUITE( fbc_tests.finance.portfolio )

	'' RFC-0008 section 3.  Returns.
	TEST( returns_ )
		'' HOLDING-PERIOD RETURN IS THE ONE EXACT FUNCTION here: a single
		'' Decimal division, so it is asserted with '='.
		CU_ASSERT( HoldingPeriodReturn( D( "10000" ), D( "11000" ), D( "250" ) ).Value( ) _
		           = D( "0.125" ) )
		CU_ASSERT( HoldingPeriodReturn( D( "100" ), D( "100" ), DecimalZero( ) ).Value( ).IsZero( ) )
		CU_ASSERT( HoldingPeriodReturn( D( "100" ), D( "50" ), DecimalZero( ) ).Value( ) = D( "-0.5" ) )

		'' A zero opening value is FIN_DOMAIN, not an infinity.
		CU_ASSERT( HoldingPeriodReturn( DecimalZero( ), D( "100" ), DecimalZero( ) ).Failure( ).Code( ) _
		           = FIN_DOMAIN )

		'' ANNUALIZATION IS GEOMETRIC, not r * f.  1% a month is 12.68% a year,
		'' not 12%.  The wrong form appears in a great deal of published code.
		CU_ASSERT_DOUBLE_EQUAL( AnnualizeReturn( 0.01, RETURN_MONTHLY ), 0.1268250301319698, 1.0e-14 )
		CU_ASSERT( AnnualizeReturn( 0.01, RETURN_MONTHLY ) > 0.12 )
		CU_ASSERT_DOUBLE_EQUAL( AnnualizeReturn( 0.0, RETURN_MONTHLY ), 0.0, 1.0e-15 )
		'' Annual frequency is the identity.
		CU_ASSERT_DOUBLE_EQUAL( AnnualizeReturn( 0.07, RETURN_ANNUAL ), 0.07, 1.0e-15 )

		'' CAGR: doubling over 5 years.
		dim as FinResultDbl c = CompoundAnnualGrowthRate( D( "1000" ), D( "2000" ), 5.0 )
		CU_ASSERT( c.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( c.Value( ), 0.148698354997035, 1.0e-12 )

		'' Its definition, checked by substitution: growing at the CAGR for the
		'' whole term reproduces the ending value.
		CU_ASSERT_DOUBLE_EQUAL( 1000.0 * ( ( 1.0 + c.Value( ) ) ^ 5.0 ), 2000.0, 1.0e-8 )

		CU_ASSERT( CompoundAnnualGrowthRate( DecimalZero( ), D( "10" ), 5.0 ).Failure( ).Code( ) = FIN_DOMAIN )
		CU_ASSERT( CompoundAnnualGrowthRate( D( "10" ), D( "20" ), 0.0 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0008 section 7.  Time-weighted return.
	TEST( time_weighted_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		dim as FinResultDbl twr = TimeWeightedReturn( r )
		CU_ASSERT( twr.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( twr.Value( ), 0.1410864155548182, 1.0e-14 )

		'' GEOMETRIC LINKING, not summation: the sum of these returns is
		'' 0.1350, and the linked figure is higher because gains compound.
		dim as double plain = 0.0
		for each x in r
			plain += x
		next
		CU_ASSERT( twr.Value( ) > plain )

		'' A single period is itself.
		dim as Array( of double ) one_
		one_.Push( 0.05 )
		CU_ASSERT_DOUBLE_EQUAL( TimeWeightedReturn( one_ ).Value( ), 0.05, 1.0e-15 )

		'' Gain then equal loss does NOT return to zero -- the classic result,
		'' and a good check that the linking is multiplicative.
		dim as double glSrc( 0 to 1 ) = { 0.5, -0.5 }
		dim as Array( of double ) gl
		PushAll( gl, glSrc( ) )
		CU_ASSERT_DOUBLE_EQUAL( TimeWeightedReturn( gl ).Value( ), -0.25, 1.0e-15 )

		'' A total loss is -100%, and anything worse is refused.
		dim as double wipeSrc( 0 to 1 ) = { -1.0, 0.1 }
		dim as Array( of double ) wipe
		PushAll( wipe, wipeSrc( ) )
		CU_ASSERT( TimeWeightedReturn( wipe ).Failure( ).Code( ) = FIN_DOMAIN )
	END_TEST

	'' RFC-0008 section 7.  Modified Dietz.
	TEST( modified_dietz_ )
		'' 100,000 grows to 112,000 with a 10,000 contribution on day 45 of 90.
		'' The contribution was invested for half the period, so the
		'' denominator is 100,000 + 5,000.
		dim as Array( of Decimal ) fl
		fl.Push( D( "10000" ) )
		dim as Array( of long ) off
		off.Push( 45 )

		dim as FinResultDbl m = ModifiedDietzReturn( D( "100000" ), D( "112000" ), fl, off, 90 )
		CU_ASSERT( m.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( m.Value( ), 2000.0 / 105000.0, 1.0e-14 )

		'' A flow on the FIRST day is fully weighted; on the LAST day, not at
		'' all.  The two must differ, and in the documented direction.
		dim as Array( of long ) first_, last_
		first_.Push( 0 )
		last_.Push( 90 )
		dim as double mFirst = ModifiedDietzReturn( D( "100000" ), D( "112000" ), fl, first_, 90 ).Value( )
		dim as double mLast = ModifiedDietzReturn( D( "100000" ), D( "112000" ), fl, last_, 90 ).Value( )
		CU_ASSERT( mFirst < mLast )
		CU_ASSERT_DOUBLE_EQUAL( mFirst, 2000.0 / 110000.0, 1.0e-14 )
		CU_ASSERT_DOUBLE_EQUAL( mLast, 2000.0 / 100000.0, 1.0e-14 )

		'' With NO flows it degenerates to the plain holding-period return.
		'' AN EMPTY FB.Array IS JUST A DEFAULT-CONSTRUCTED ONE -- no 'dim ...
		'' ( any )' dance and no lbound/ubound edge case.
		dim as Array( of Decimal ) noFlow
		dim as Array( of long ) noOff
		dim as FinResultDbl plain = ModifiedDietzReturn( D( "100000" ), D( "112000" ), noFlow, noOff, 90 )
		CU_ASSERT( plain.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( plain.Value( ), 0.12, 1.0e-14 )

		'' Mismatched arrays and an out-of-range offset are named errors.
		dim as long twoOffSrc( 0 to 1 ) = { 10, 20 }
		dim as Array( of long ) twoOff
		PushAll( twoOff, twoOffSrc( ) )
		CU_ASSERT( ModifiedDietzReturn( D( "100000" ), D( "112000" ), fl, twoOff, 90 ).Failure( ).Code( ) _
		           = FIN_LENGTH_MISMATCH )
		dim as Array( of long ) badOff
		badOff.Push( 200 )
		CU_ASSERT( ModifiedDietzReturn( D( "100000" ), D( "112000" ), fl, badOff, 90 ).Failure( ).Code( ) _
		           = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0008 section 5.  THE TEST THIS SUITE EXISTS FOR.
	TEST( sample_vs_population_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		'' BETA USES SAMPLE COVARIANCE OVER SAMPLE VARIANCE.  The n-1 factors
		'' cancel, so this is the regression slope.
		dim as FinResultDbl bt = Beta( r, b )
		CU_ASSERT( bt.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( bt.Value( ), 1.1406708992703496, 1.0e-12 )

		'' It equals the delegation it claims: Covariance / Variance, both from
		'' fb/stats.bi, both sample.
		CU_ASSERT_DOUBLE_EQUAL( bt.Value( ), Covariance( r, b ) / Variance( b ), 1.0e-15 )

		'' THE MIXED FORM, computed here so the difference is a NUMBER and not
		'' a warning: sample covariance over POPULATION variance -- which is
		'' what RFC-0008's first delegation table specified.
		dim as double mixed = Covariance( r, b ) / VariancePopulation( b )
		CU_ASSERT_DOUBLE_EQUAL( mixed, 1.2443682537494725, 1.0e-12 )

		'' THEY DIFFER, and by exactly (n-1)/n.  If this ever passes as equal,
		'' the two variance forms have stopped differing and something is very
		'' wrong in fb/stats.bi.
		CU_ASSERT( bt.Value( ) <> mixed )
		CU_ASSERT_DOUBLE_EQUAL( bt.Value( ) / mixed, 11.0 / 12.0, 1.0e-12 )

		'' THE SPREAD MEASURES USE THE SAMPLE FORM (n-1).  Asserted by
		'' comparing against both, so picking the wrong one fails.
		dim as double volSample = StdDev( r ) * sqr( 12.0 )
		dim as double volPop = StdDevPopulation( r ) * sqr( 12.0 )
		CU_ASSERT( volSample <> volPop )
		CU_ASSERT_DOUBLE_EQUAL( Volatility( r, RETURN_MONTHLY ).Value( ), volSample, 1.0e-15 )

		'' Tracking error likewise.
		dim as Array( of double ) act
		for k as long = 0 to SERIES_N - 1
			act.Push( r[ k ] - b[ k ] )
		next
		CU_ASSERT_DOUBLE_EQUAL( TrackingError( r, b, RETURN_MONTHLY ).Value( ), _
		                        StdDev( act ) * sqr( 12.0 ), 1.0e-15 )
		CU_ASSERT( TrackingError( r, b, RETURN_MONTHLY ).Value( ) <> _
		           StdDevPopulation( act ) * sqr( 12.0 ) )
	END_TEST

	'' RFC-0008 section 4.  The delegation table, asserted function by function.
	TEST( delegation_to_stats_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )
		dim as double f = 12.0

		CU_ASSERT_DOUBLE_EQUAL( Volatility( r, RETURN_MONTHLY ).Value( ), _
		                        StdDev( r ) * sqr( f ), 1.0e-15 )

		CU_ASSERT_DOUBLE_EQUAL( SharpeRatio( r, 0.0002, RETURN_MONTHLY ).Value( ), _
		                        ( ( Mean( r ) - 0.0002 ) * f ) / ( StdDev( r ) * sqr( f ) ), 1.0e-14 )

		CU_ASSERT_DOUBLE_EQUAL( Beta( r, b ).Value( ), _
		                        Covariance( r, b ) / Variance( b ), 1.0e-15 )

		CU_ASSERT_DOUBLE_EQUAL( CorrelationToBenchmark( r, b ).Value( ), _
		                        Correlation( r, b ), 1.0e-15 )

		'' DOWNSIDE DEVIATION IS THE ONE THAT DOES NOT DELEGATE, and cannot:
		'' it measures shortfall against a TARGET over the FULL count, where
		'' StdDev measures spread about the MEAN over n-1.  Asserted to DIFFER
		'' from the StdDev of the below-target values, so the two are not
		'' quietly conflated later.
		dim as FinResultDbl dd = DownsideDeviation( r, 0.0, RETURN_MONTHLY )
		CU_ASSERT( dd.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( dd.Value( ), 0.0312249899919920, 1.0e-14 )

		dim as double belowSrc( 0 to 3 ) = { -0.01, -0.025, -0.005, -0.015 }
		dim as Array( of double ) below
		PushAll( below, belowSrc( ) )
		CU_ASSERT( dd.Value( ) <> StdDev( below ) * sqr( f ) )

		'' A portfolio never below target has ZERO downside deviation -- and
		'' therefore no Sortino ratio, which is FIN_DOMAIN rather than an
		'' infinity.
		dim as double upSrc( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
		dim as Array( of double ) up_
		PushAll( up_, upSrc( ) )
		CU_ASSERT_DOUBLE_EQUAL( DownsideDeviation( up_, 0.0, RETURN_MONTHLY ).Value( ), 0.0, 1.0e-15 )
		CU_ASSERT( SortinoRatio( up_, 0.0, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_DOMAIN )
	END_TEST

	'' RFC-0008 section 3.  The risk metrics, against the reference.
	TEST( risk_metrics_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		CU_ASSERT_DOUBLE_EQUAL( Volatility( r, RETURN_MONTHLY ).Value( ), 0.0708872343937891, 1.0e-14 )
		CU_ASSERT_DOUBLE_EQUAL( SharpeRatio( r, 0.0002, RETURN_MONTHLY ).Value( ), 1.8705765732570023, 1.0e-12 )
		CU_ASSERT_DOUBLE_EQUAL( SortinoRatio( r, 0.0, RETURN_MONTHLY ).Value( ), 4.3234601527373524, 1.0e-12 )
		CU_ASSERT_DOUBLE_EQUAL( Alpha( r, b, 0.0002, RETURN_MONTHLY ).Value( ), 0.0007384440443476, 1.0e-14 )
		CU_ASSERT_DOUBLE_EQUAL( TrackingError( r, b, RETURN_MONTHLY ).Value( ), 0.0103879300589237, 1.0e-14 )
		CU_ASSERT_DOUBLE_EQUAL( InformationRatio( r, b, RETURN_MONTHLY ).Value( ), 1.6365146765111500, 1.0e-11 )
		CU_ASSERT_DOUBLE_EQUAL( CorrelationToBenchmark( r, b ).Value( ), 0.9968135918762372, 1.0e-14 )

		'' SORTINO EXCEEDS SHARPE here, and must: the series has more upside
		'' volatility than downside, which is exactly what Sortino ignores.
		CU_ASSERT( SortinoRatio( r, 0.0, RETURN_MONTHLY ).Value( ) > _
		           SharpeRatio( r, 0.0, RETURN_MONTHLY ).Value( ) )

		'' A PORTFOLIO IDENTICAL TO ITS BENCHMARK has beta 1, correlation 1,
		'' zero tracking error -- and therefore no information ratio.
		CU_ASSERT_DOUBLE_EQUAL( Beta( b, b ).Value( ), 1.0, 1.0e-12 )
		CU_ASSERT_DOUBLE_EQUAL( CorrelationToBenchmark( b, b ).Value( ), 1.0, 1.0e-12 )
		CU_ASSERT_DOUBLE_EQUAL( TrackingError( b, b, RETURN_MONTHLY ).Value( ), 0.0, 1.0e-15 )
		CU_ASSERT( InformationRatio( b, b, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_DOMAIN )
		CU_ASSERT_DOUBLE_EQUAL( Alpha( b, b, 0.0002, RETURN_MONTHLY ).Value( ), 0.0, 1.0e-14 )

		'' A DOUBLED benchmark has beta 2 and correlation 1 -- beta measures
		'' the slope, correlation only the tightness.
		dim as Array( of double ) lev
		for each x in b
			lev.Push( 2.0 * x )
		next
		CU_ASSERT_DOUBLE_EQUAL( Beta( lev, b ).Value( ), 2.0, 1.0e-12 )
		CU_ASSERT_DOUBLE_EQUAL( CorrelationToBenchmark( lev, b ).Value( ), 1.0, 1.0e-12 )

		'' VOLATILITY SCALES BY sqrt(f), NOT f.  Quarterly against monthly on
		'' the same series differs by exactly sqrt(12/4).
		dim as double vm = Volatility( r, RETURN_MONTHLY ).Value( )
		dim as double vq = Volatility( r, RETURN_QUARTERLY ).Value( )
		CU_ASSERT_DOUBLE_EQUAL( vm / vq, sqr( 12.0 / 4.0 ), 1.0e-13 )
	END_TEST

	'' RFC-0008 section 3.  Series and drawdown.
	TEST( series_and_drawdown_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		dim as FinResultSeries cum = CumulativeReturnSeries( r )
		CU_ASSERT( cum.IsOk( ) )
		CU_ASSERT( cum.Value( ).Count( ) = SERIES_N )

		'' The first entry is the first return, and the last is the TWR --
		'' which ties the series to the scalar rather than leaving them
		'' independently pinned.
		CU_ASSERT_DOUBLE_EQUAL( cum.Value( ).At( 0 ), 0.02, 1.0e-15 )
		CU_ASSERT_DOUBLE_EQUAL( cum.Value( ).At( SERIES_N - 1 ), _
		                        TimeWeightedReturn( r ).Value( ), 1.0e-14 )

		dim as FinResultSeries dd = DrawdownSeries( r )
		CU_ASSERT( dd.IsOk( ) )
		CU_ASSERT( dd.Value( ).Count( ) = SERIES_N )

		'' EVERY DRAWDOWN IS <= 0, measured from the running peak.
		for each x in dd.Value( )
			CU_ASSERT( x <= 0.0 )
		next
		'' A new high has exactly zero drawdown.
		CU_ASSERT_DOUBLE_EQUAL( dd.Value( ).At( 0 ), 0.0, 1.0e-15 )

		'' MaxDrawdown IS THE MAGNITUDE, POSITIVE -- the asymmetry with
		'' DrawdownSeries is deliberate and documented.
		dim as FinResultDbl md = MaxDrawdown( r )
		CU_ASSERT( md.IsOk( ) )
		CU_ASSERT( md.Value( ) > 0.0 )
		CU_ASSERT_DOUBLE_EQUAL( md.Value( ), 0.0250000000000001, 1.0e-13 )

		'' The peak and trough indices bracket the worst fall.  THEY ARE
		'' ZERO-BASED OFFSETS into the FB.Array, which is what they were before
		'' too -- the header always subtracted lbound before returning.
		CU_ASSERT( MaxDrawdownPeak( r ).HasValue( ) )
		CU_ASSERT( MaxDrawdownTrough( r ).HasValue( ) )
		CU_ASSERT( MaxDrawdownPeak( r ).Value( ) = 3 )
		CU_ASSERT( MaxDrawdownTrough( r ).Value( ) = 4 )
		CU_ASSERT( MaxDrawdownTrough( r ).Value( ) > MaxDrawdownPeak( r ).Value( ) )

		'' A SERIES THAT NEVER DREW DOWN returns ABSENCE for both indices --
		'' RFC-0001 section 6's test for Optional -- and a max drawdown of
		'' exactly zero, POSITIVE zero rather than -0.
		dim as double upSrc( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
		dim as Array( of double ) up_
		PushAll( up_, upSrc( ) )
		CU_ASSERT( MaxDrawdownPeak( up_ ).HasValue( ) = false )
		CU_ASSERT( MaxDrawdownTrough( up_ ).HasValue( ) = false )
		CU_ASSERT_DOUBLE_EQUAL( MaxDrawdown( up_ ).Value( ), 0.0, 1.0e-300 )
		CU_ASSERT( ( 1.0 / MaxDrawdown( up_ ).Value( ) ) > 0.0 )   '' +0, not -0

		'' A monotonic decline draws down every period, ending at the total.
		dim as double downSrc( 0 to 2 ) = { -0.1, -0.1, -0.1 }
		dim as Array( of double ) down_
		PushAll( down_, downSrc( ) )
		CU_ASSERT_DOUBLE_EQUAL( MaxDrawdown( down_ ).Value( ), 1.0 - 0.9 * 0.9 * 0.9, 1.0e-14 )
		CU_ASSERT( MaxDrawdownTrough( down_ ).Value( ) = 2 )
	END_TEST

	'' RFC-0008 section 3.  The summary.
	TEST( summary_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		dim as FinResultReturns s = SummarizeReturns( r, 0.0002, RETURN_MONTHLY )
		CU_ASSERT( s.IsOk( ) )

		CU_ASSERT( s.Value( ).Observations_ = SERIES_N )

		'' EVERY FIELD AGREES WITH ITS OWN FUNCTION -- the summary is a
		'' convenience, not a second implementation.
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).Total_, TimeWeightedReturn( r ).Value( ), 1.0e-15 )
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).Volatility_, Volatility( r, RETURN_MONTHLY ).Value( ), 1.0e-15 )
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).Sharpe_, SharpeRatio( r, 0.0002, RETURN_MONTHLY ).Value( ), 1.0e-15 )
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).Sortino_, SortinoRatio( r, 0.0002, RETURN_MONTHLY ).Value( ), 1.0e-15 )
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).MaxDrawdown_, MaxDrawdown( r ).Value( ), 1.0e-15 )

		'' TWELVE MONTHLY OBSERVATIONS ANNUALIZE TO THEMSELVES -- a full year
		'' of data needs no scaling, which is a good check that the
		'' annualization is not applied twice.
		CU_ASSERT_DOUBLE_EQUAL( s.Value( ).Annualized_, s.Value( ).Total_, 1.0e-13 )
	END_TEST

	'' RFC-0008 section 7.  Money-weighted return -- the investor's number.
	TEST( money_weighted_ )
		'' 10,000 in at the start, 5,000 more after six months, worth 16,500
		'' at the end of the year.
		dim as Array( of CashFlow ) f
		f.Push( CashFlowMake( D( "-10000" ), LocalDate( 2026, 1, 1 ) ) )
		f.Push( CashFlowMake( D( "-5000" ),  LocalDate( 2026, 7, 1 ) ) )

		dim as FinResultDbl mwr = MoneyWeightedReturn( f, D( "16500" ), LocalDate( 2027, 1, 1 ), _
		                                               DAYCOUNT_ACTUAL_365_FIXED )
		CU_ASSERT( mwr.IsOk( ) )

		'' Verified BY SUBSTITUTION rather than against a pinned constant: the
		'' dated NPV of the same flows at the returned rate must be zero.
		dim as Array( of CashFlow ) full_
		full_.Push( f[ 0 ] )
		full_.Push( f[ 1 ] )
		full_.Push( CashFlowMake( D( "16500" ), LocalDate( 2027, 1, 1 ) ) )
		dim as Decimal rate = DecimalFromDouble( mwr.Value( ) )
		dim as FinResultDec chk = NetPresentValueOnDates( full_, rate, DAYCOUNT_ACTUAL_365_FIXED )
		CU_ASSERT( chk.IsOk( ) )
		CU_ASSERT( chk.Value( ).AbsValue( ) < D( "0.01" ) )

		'' It differs from the time-weighted view, because the second
		'' contribution was exposed for only half the year.
		CU_ASSERT( mwr.Value( ) > 0.0 )

		'' An invalid terminal date is refused.
		CU_ASSERT( MoneyWeightedReturn( f, D( "16500" ), LocalDate.Invalid( ), _
		                                DAYCOUNT_ACTUAL_365_FIXED ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )
	END_TEST

	'' RFC-0001 section 6.  Errors, by code.
	TEST( portfolio_errors_ )
		dim as Array( of double ) r, b
		fillSeries( r, b )

		'' EMPTY series -- a default-constructed FB.Array, with no 'dim ...
		'' ( any )' to explain.
		dim as Array( of double ) empty_
		CU_ASSERT( Volatility( empty_, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( TimeWeightedReturn( empty_ ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( SummarizeReturns( empty_, 0.0, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( CumulativeReturnSeries( empty_ ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( MaxDrawdownPeak( empty_ ).HasValue( ) = false )

		'' A SINGLE observation has no sample variance -- n-1 is zero.
		dim as Array( of double ) one_
		one_.Push( 0.02 )
		CU_ASSERT( Volatility( one_, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		CU_ASSERT( SharpeRatio( one_, 0.0, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_EMPTY_SERIES )
		'' But it DOES have a time-weighted return and a drawdown.
		CU_ASSERT( TimeWeightedReturn( one_ ).IsOk( ) )
		CU_ASSERT( MaxDrawdown( one_ ).IsOk( ) )

		'' MISMATCHED LENGTHS.
		dim as double shortSrc( 0 to 4 ) = { 0.01, 0.02, 0.01, 0.02, 0.01 }
		dim as Array( of double ) shortB
		PushAll( shortB, shortSrc( ) )
		CU_ASSERT( Beta( r, shortB ).Failure( ).Code( ) = FIN_LENGTH_MISMATCH )
		CU_ASSERT( TrackingError( r, shortB, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_LENGTH_MISMATCH )
		CU_ASSERT( CorrelationToBenchmark( r, shortB ).Failure( ).Code( ) = FIN_LENGTH_MISMATCH )

		'' A CONSTANT benchmark has zero variance, so beta is undefined.
		dim as Array( of double ) flat_
		for k as long = 0 to SERIES_N - 1
			flat_.Push( 0.01 )
		next
		CU_ASSERT( Beta( r, flat_ ).Failure( ).Code( ) = FIN_DOMAIN )
		CU_ASSERT( SharpeRatio( flat_, 0.0, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A non-finite observation.
		dim as double nanSrc( 0 to 2 ) = { 0.01, NaN( ), 0.02 }
		dim as Array( of double ) nan_
		PushAll( nan_, nanSrc( ) )
		CU_ASSERT( Volatility( nan_, RETURN_MONTHLY ).Failure( ).Code( ) = FIN_DOMAIN )
	END_TEST

END_SUITE
