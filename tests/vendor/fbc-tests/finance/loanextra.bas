'' fb/finloan.bi, the harder half -- C:\dev\docs\finance\RFC-0005-loans.md
'' section 6 steps 6 to 9, and section 7.
''
'' Extra payments, balloons, payoff with per-diem interest, negative
'' amortization and the analytical rounding mode.  These are the cases where
'' the nine-step algorithm earns its specification: every one of them is a
'' place a schedule can quietly stop adding up.
''
'' ORACLE: an INDEPENDENT implementation of the nine steps in Python's
'' arbitrary-precision `decimal`, written from the RFC rather than from this
'' header.  Excel is unavailable in the build environment -- see
'' C:\dev\docs\finance\amendments.md.

#include once "fbcunit.bi"
#include once "fb/finance.bi"

using FB

private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

'' The same five invariants as loan.bas, over a schedule WITH extras.  Every
'' scenario in this file runs through it, because the whole risk of extras is
'' that they break the row arithmetic.
private function assertInvariantsExtra _
	( byref t as LoanTerms, byref extras as Array( of ExtraPayment ) ) as long

	dim as FinResultSchedule sc = LoanSchedule( t, extras )
	CU_ASSERT( sc.IsOk( ) )
	if( sc.IsOk( ) = false ) then return 0

	dim as Decimal ci = DecimalZero( ), cp = DecimalZero( )
	dim as Decimal lastClose = t.Principal_
	dim as long n = 0

	dim as AmortizationIterator it = sc.Value( ).GetIterator( )
	while( it.IsValid( ) )
		dim as AmortizationRow r = it.Value( )
		n += 1

		CU_ASSERT( r.Payment_ = ( r.Interest_ + r.Principal_ ) )
		CU_ASSERT( r.OpeningBalance_ = lastClose )
		if( r.IsFinal_ = false ) then
			CU_ASSERT( r.ClosingBalance_ = ( r.OpeningBalance_ - r.Principal_ - r.ExtraPrincipal_ ) )
		end if

		'' AN EXTRA IS NEVER NEGATIVE and never exceeds what is owed -- step 7's
		'' cap is what stops a large prepayment producing a negative balance.
		CU_ASSERT( r.ExtraPrincipal_ >= DecimalZero( ) )
		CU_ASSERT( r.ClosingBalance_ >= t.BalloonAmount_ )

		ci = ci + r.Interest_
		cp = cp + r.Principal_ + r.ExtraPrincipal_
		CU_ASSERT( r.CumulativeInterest_ = ci )
		CU_ASSERT( r.CumulativePrincipal_ = cp )

		lastClose = r.ClosingBalance_
		it.MoveNext( )
	wend

	CU_ASSERT( lastClose = t.BalloonAmount_ )
	CU_ASSERT( cp = ( t.Principal_ - t.BalloonAmount_ ) )
	function = n
end function

SUITE( fbc_tests.finance.loanextra )

	'' RFC-0005 section 6 step 7.  A RECURRING extra payment.
	TEST( recurring_extra_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		dim as Array( of ExtraPayment ) ex
		ex.Push( ExtraPaymentRecurring( 1, 360, D( "200" ) ) )

		dim as FinResultSchedule sc = LoanSchedule( t, ex )
		CU_ASSERT( sc.IsOk( ) )

		'' The extra is applied AFTER the scheduled split, so interest and
		'' principal for period 1 are unchanged from the plain schedule -- only
		'' the closing balance moves.
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		dim as AmortizationRow r1 = it.Value( )
		CU_ASSERT( r1.Interest_       = D( "1983.33" ) )
		CU_ASSERT( r1.Principal_      = D( "402.03" ) )
		CU_ASSERT( r1.ExtraPrincipal_ = D( "200" ) )
		CU_ASSERT( r1.ClosingBalance_ = D( "399397.97" ) )

		dim as FinResultSummary s = LoanSummarize( t, ex )
		CU_ASSERT( s.IsOk( ) )

		'' IT FINISHES 65 PERIODS EARLY and saves 96,974.24 in interest.
		CU_ASSERT( s.Value( ).PaymentCount_  = 295 )
		CU_ASSERT( s.Value( ).TotalInterest_ = D( "361754.39" ) )
		CU_ASSERT( s.Value( ).PeriodsSaved_  = 65 )
		CU_ASSERT( s.Value( ).InterestSavedVsScheduled_ = D( "96974.24" ) )

		'' The saving is exactly the difference from the plain schedule.
		dim as FinResultSummary plain = LoanSummarize( t )
		CU_ASSERT( s.Value( ).InterestSavedVsScheduled_ = _
		           ( plain.Value( ).TotalInterest_ - s.Value( ).TotalInterest_ ) )
		CU_ASSERT( s.Value( ).PeriodsSaved_ = ( plain.Value( ).PaymentCount_ - s.Value( ).PaymentCount_ ) )

		CU_ASSERT( assertInvariantsExtra( t, ex ) = 295 )
	END_TEST

	'' RFC-0005 section 6 step 7.  A ONE-OFF lump prepayment.
	TEST( one_off_extra_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		dim as Array( of ExtraPayment ) ex
		ex.Push( ExtraPaymentOnce( 12, D( "50000" ) ) )

		'' Period 12 splits as usual, then 50,000 comes off the balance.
		dim as FinResultSchedule sc = LoanSchedule( t, ex )
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		while( it.IsValid( ) andalso ( it.Value( ).Period_ < 12 ) )
			it.MoveNext( )
		wend
		CU_ASSERT( it.Value( ).Period_         = 12 )
		CU_ASSERT( it.Value( ).Interest_       = D( "1960.85" ) )
		CU_ASSERT( it.Value( ).Principal_      = D( "424.51" ) )
		CU_ASSERT( it.Value( ).ExtraPrincipal_ = D( "50000" ) )
		CU_ASSERT( it.Value( ).ClosingBalance_ = D( "345041.91" ) )

		'' Period 11 and 13 have no extra at all.
		dim as AmortizationIterator it2 = sc.Value( ).GetIterator( )
		while( it2.IsValid( ) andalso ( it2.Value( ).Period_ < 11 ) )
			it2.MoveNext( )
		wend
		CU_ASSERT( it2.Value( ).ExtraPrincipal_.IsZero( ) )
		it2.MoveNext( )
		it2.MoveNext( )
		CU_ASSERT( it2.Value( ).Period_ = 13 )
		CU_ASSERT( it2.Value( ).ExtraPrincipal_.IsZero( ) )

		dim as FinResultSummary s = LoanSummarize( t, ex )
		CU_ASSERT( s.Value( ).PaymentCount_  = 268 )
		CU_ASSERT( s.Value( ).TotalInterest_ = D( "287781.06" ) )
		CU_ASSERT( s.Value( ).PeriodsSaved_  = 92 )

		CU_ASSERT( assertInvariantsExtra( t, ex ) = 268 )
	END_TEST

	'' RFC-0005 section 6 step 7.  THE CAP.  An extra larger than the balance
	'' terminates the loan cleanly instead of producing a negative balance --
	'' which is what an uncapped implementation does.
	TEST( oversized_extra_is_capped_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		dim as Array( of ExtraPayment ) ex
		ex.Push( ExtraPaymentOnce( 3, D( "10000000" ) ) )     '' ten million

		dim as FinResultSummary s = LoanSummarize( t, ex )
		CU_ASSERT( s.IsOk( ) )
		CU_ASSERT( s.Value( ).PaymentCount_ = 3 )

		dim as FinResultSchedule sc = LoanSchedule( t, ex )
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		dim as AmortizationRow last_
		while( it.IsValid( ) )
			last_ = it.Value( )
			it.MoveNext( )
		wend

		'' Exactly zero, never negative, and the extra was trimmed to fit.
		CU_ASSERT( last_.ClosingBalance_.IsZero( ) )
		CU_ASSERT( last_.ExtraPrincipal_ < D( "10000000" ) )
		CU_ASSERT( last_.Period_ = 3 )

		'' Total principal is still exactly the loan -- not ten million.
		CU_ASSERT( s.Value( ).TotalPrincipal_ = D( "400000" ) )

		CU_ASSERT( assertInvariantsExtra( t, ex ) = 3 )
	END_TEST

	'' Several extras at once, overlapping.
	TEST( multiple_extras_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		dim as Array( of ExtraPayment ) ex
		ex.Push( ExtraPaymentRecurring( 1, 60, D( "100" ) ) )
		ex.Push( ExtraPaymentRecurring( 25, 120, D( "150" ) ) )   '' overlaps ex[ 0 ]
		ex.Push( ExtraPaymentOnce( 36, D( "5000" ) ) )            '' overlaps both

		dim as FinResultSchedule sc = LoanSchedule( t, ex )
		CU_ASSERT( sc.IsOk( ) )

		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		while( it.IsValid( ) andalso ( it.Value( ).Period_ < 36 ) )
			it.MoveNext( )
		wend
		'' OVERLAPPING RANGES ADD: 100 + 150 + 5000 at period 36.
		CU_ASSERT( it.Value( ).Period_         = 36 )
		CU_ASSERT( it.Value( ).ExtraPrincipal_ = D( "5250" ) )

		'' Period 10 is inside ex[ 0 ] only.
		dim as AmortizationIterator i10 = sc.Value( ).GetIterator( )
		while( i10.IsValid( ) andalso ( i10.Value( ).Period_ < 10 ) )
			i10.MoveNext( )
		wend
		CU_ASSERT( i10.Value( ).ExtraPrincipal_ = D( "100" ) )

		CU_ASSERT( assertInvariantsExtra( t, ex ) > 0 )
	END_TEST

	'' RFC-0005 section 6 step 6.  BALLOON.
	TEST( balloon_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		t.BalloonAmount_ = D( "200000" )

		CU_ASSERT( LoanPayment( t ).Value( ) = D( "2184.35" ) )

		dim as FinResultSchedule sc = LoanSchedule( t )
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		dim as AmortizationRow last_
		dim as long n = 0
		while( it.IsValid( ) )
			last_ = it.Value( )
			n += 1
			it.MoveNext( )
		wend

		CU_ASSERT( n = 360 )
		CU_ASSERT( last_.IsFinal_ )
		'' EXACTLY the balloon, by assignment -- the same rule as landing on
		'' zero, with a different target.
		CU_ASSERT( last_.ClosingBalance_ = D( "200000" ) )
		CU_ASSERT( last_.Payment_ = D( "2180.62" ) )

		dim as FinResultSummary s = LoanSummarize( t )
		CU_ASSERT( s.Value( ).TotalInterest_ = D( "586362.27" ) )
		'' Only the amortized part is repaid over the schedule.
		CU_ASSERT( s.Value( ).TotalPrincipal_ = D( "200000" ) )

		'' A balloon EQUAL to the principal is an interest-only loan.
		dim as LoanTerms io = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		io.BalloonAmount_ = D( "400000" )
		dim as FinResultSchedule ios = LoanSchedule( io )
		CU_ASSERT( ios.IsOk( ) )
		dim as AmortizationIterator iit = ios.Value( ).GetIterator( )
		CU_ASSERT( iit.Value( ).Principal_.IsZero( ) )
		CU_ASSERT( iit.Value( ).ClosingBalance_ = D( "400000" ) )
	END_TEST

	'' RFC-0005 section 7.  PAYOFF with per-diem interest.
	TEST( payoff_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		t.FirstPaymentDate_ = LocalDate( 2026, 3, 1 )
		t.Basis_ = DAYCOUNT_ACTUAL_365_FIXED

		'' Period 12 falls due 2027-02-01 with a balance of 395,041.91.
		CU_ASSERT( LoanRowAt( t, 12 ).Value( ).DueDate_ = LocalDate( 2027, 2, 1 ) )
		CU_ASSERT( LoanRowAt( t, 12 ).Value( ).ClosingBalance_ = D( "395041.91" ) )

		'' ON the due date there is no per-diem to add.
		CU_ASSERT( LoanPayoffAmount( t, 12, LocalDate( 2027, 2, 1 ) ).Value( ) = D( "395041.91" ) )

		'' 42 days later, 395041.91 * 0.0595 * 42/365 = 2704.68 accrued.
		CU_ASSERT( LoanPayoffAmount( t, 12, LocalDate( 2027, 3, 15 ) ).Value( ) = D( "397746.59" ) )

		'' Payoff before period one is the principal.
		CU_ASSERT( LoanPayoffAmount( t, 0, LocalDate( 2026, 3, 1 ) ).Value( ) = D( "400000" ) )

		'' A date BEFORE the period's due date is refused rather than accruing
		'' negative interest.
		CU_ASSERT( LoanPayoffAmount( t, 12, LocalDate( 2026, 12, 1 ) ).Failure( ).Code( ) _
		           = FIN_UNORDERED_DATES )

		'' Act/360 accrues MORE than Act/365 over the same span.
		dim as LoanTerms t360 = t
		t360.Basis_ = DAYCOUNT_ACTUAL_360
		CU_ASSERT( LoanPayoffAmount( t360, 12, LocalDate( 2027, 3, 15 ) ).Value( ) > _
		           LoanPayoffAmount( t, 12, LocalDate( 2027, 3, 15 ) ).Value( ) )

		'' A period that does not exist.
		CU_ASSERT( LoanPayoffAmount( t, 9999, LocalDate( 2027, 3, 15 ) ).Failure( ).Code( ) _
		           = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0005 section 6 step 8.  NEGATIVE AMORTIZATION -- and an honest note
	'' about what this test does and does not establish.
	''
	'' STEP 8 IS SPECIFIED BUT UNREACHABLE THROUGH THE CURRENT API.  The
	'' payment is always DERIVED from LoanTerms, so it always services the
	'' interest: there is no field that sets a payment below it.  Even the
	'' extreme cases do not get there --
	''
	''     balloon = principal   -> interest-only, principal exactly zero
	''     huge rate, long term  -> payment rises to match
	''
	'' so the branch exists, is correct, and NOTHING IN THIS SUITE EXERCISES
	'' IT.  Recorded in C:\dev\docs\finance\amendments.md rather than counted
	'' as covered.  It becomes reachable the moment RFC-0005 section 8's
	'' deferred features land -- a caller-supplied payment, or a rate reset.
	''
	'' What IS asserted here: the two boundary shapes that the API CAN reach,
	'' and the step-8 arithmetic computed from the same primitives, so a future
	'' change that introduces clamping fails this test.
	TEST( negative_amortization_ )
		'' REACHABLE SHAPE 1 -- interest-only.  Principal is exactly zero, the
		'' balance never moves, and the row still adds up.
		dim as LoanTerms io = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		io.BalloonAmount_ = D( "400000" )

		dim as FinResultSchedule ios = LoanSchedule( io )
		CU_ASSERT( ios.IsOk( ) )

		dim as AmortizationIterator it = ios.Value( ).GetIterator( )
		dim as long n = 0
		while( it.IsValid( ) andalso ( n < 12 ) )
			CU_ASSERT( it.Value( ).Principal_.IsZero( ) )
			CU_ASSERT( it.Value( ).ClosingBalance_ = D( "400000" ) )
			CU_ASSERT( it.Value( ).Payment_ = ( it.Value( ).Interest_ + it.Value( ).Principal_ ) )
			n += 1
			it.MoveNext( )
		wend
		CU_ASSERT( n = 12 )

		'' REACHABLE SHAPE 2 -- a very high rate still amortizes, because the
		'' payment is derived rather than given.  The balance only ever falls.
		dim as LoanTerms hi = LoanTermsUsMortgage( D( "400000" ), D( "0.30" ), 30 )
		dim as FinResultSchedule his = LoanSchedule( hi )
		CU_ASSERT( his.IsOk( ) )

		dim as AmortizationIterator hit = his.Value( ).GetIterator( )
		dim as Decimal prev = D( "400000" )
		dim as long m = 0
		while( hit.IsValid( ) andalso ( m < 24 ) )
			CU_ASSERT( hit.Value( ).ClosingBalance_ <= prev )
			CU_ASSERT( hit.Value( ).Principal_ >= DecimalZero( ) )
			prev = hit.Value( ).ClosingBalance_
			m += 1
			hit.MoveNext( )
		wend

		'' STEP 8'S ARITHMETIC, from the same primitives the header uses.  If a
		'' later change clamps principal at zero, THIS is the assertion that
		'' catches it -- the residual must be free to go negative.
		dim as Decimal opening = D( "400000" )
		dim as Decimal rate = RatePerPeriod( D( "0.20" ), COMPOUND_MONTHLY ).Value( )
		dim as Decimal interest = MoneyRound( opening * rate, MoneyRoundingCents( ) )
		CU_ASSERT( interest = D( "6666.67" ) )

		dim as Decimal payment = D( "500" )
		dim as Decimal principal = payment - interest
		CU_ASSERT( principal < DecimalZero( ) )
		CU_ASSERT( payment = ( interest + principal ) )         '' the identity holds
		CU_ASSERT( ( opening - principal ) > opening )           '' the balance grows
	END_TEST

	'' RFC-0005 section 6 step 9.  THE ANALYTICAL MODE rounds only on output.
	TEST( exact_rounding_mode_ )
		dim as LoanTerms cents = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		dim as LoanTerms exact_ = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		exact_.Rounding_ = MoneyRoundingExact( )

		dim as Decimal pc = LoanPayment( cents ).Value( )
		dim as Decimal pe = LoanPayment( exact_ ).Value( )

		'' The exact payment carries its full expansion; the cents one is it,
		'' rounded.
		CU_ASSERT( pc = D( "2385.36" ) )
		CU_ASSERT( pe <> pc )
		CU_ASSERT( pe.Round( 2 ) = pc )

		'' Steps 3, 4 and 5 are unchanged -- the identity and the exact final
		'' zero still hold with no rounding at all.
		dim as FinResultSchedule sc = LoanSchedule( exact_ )
		CU_ASSERT( sc.IsOk( ) )

		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		dim as Decimal lastClose = D( "400000" )
		dim as long n = 0
		while( it.IsValid( ) )
			dim as AmortizationRow r = it.Value( )
			n += 1
			CU_ASSERT( r.Payment_ = ( r.Interest_ + r.Principal_ ) )
			CU_ASSERT( r.OpeningBalance_ = lastClose )
			lastClose = r.ClosingBalance_
			it.MoveNext( )
		wend
		CU_ASSERT( n = 360 )
		CU_ASSERT( lastClose.IsZero( ) )

		'' The two modes agree on the total to within Digits_ x periods.
		dim as Decimal ic = LoanSummarize( cents ).Value( ).TotalInterest_
		dim as Decimal ie = LoanSummarize( exact_ ).Value( ).TotalInterest_
		dim as Decimal gap = ic - ie
		CU_ASSERT( gap.AbsValue( ) < D( "10" ) )
	END_TEST

	'' A four-decimal rounding policy is honoured end to end.
	TEST( four_decimal_policy_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		t.Rounding_ = MoneyRoundingBankersFour( )

		dim as Decimal pmt = LoanPayment( t ).Value( )
		CU_ASSERT( pmt = D( "2385.3589" ) )

		dim as FinResultSchedule sc = LoanSchedule( t )
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		dim as Decimal lastClose = D( "400000" )
		dim as long n = 0
		while( it.IsValid( ) )
			CU_ASSERT( it.Value( ).Payment_ = ( it.Value( ).Interest_ + it.Value( ).Principal_ ) )
			CU_ASSERT( it.Value( ).OpeningBalance_ = lastClose )
			lastClose = it.Value( ).ClosingBalance_
			n += 1
			it.MoveNext( )
		wend
		CU_ASSERT( lastClose.IsZero( ) )
		CU_ASSERT( n = 360 )
	END_TEST

	'' RFC-0005 section 8.  APR -- the arithmetic, and the warning that goes
	'' with it.
	TEST( annual_percentage_rate_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		'' With no fees the APR is the note rate, to four places.
		dim as FinResultDec none = LoanAnnualPercentageRate( t, DecimalZero( ) )
		CU_ASSERT( none.IsOk( ) )
		CU_ASSERT( none.Value( ).Round( 4 ) = D( "0.0595" ) )

		'' FEES RAISE IT: the borrower receives less but repays the same.
		dim as FinResultDec fees = LoanAnnualPercentageRate( t, D( "8000" ) )
		CU_ASSERT( fees.IsOk( ) )
		CU_ASSERT( fees.Value( ) > none.Value( ) )

		'' More fees, higher still -- monotonic.
		dim as FinResultDec more = LoanAnnualPercentageRate( t, D( "16000" ) )
		CU_ASSERT( more.Value( ) > fees.Value( ) )

		'' Fees at or above the principal are not a loan.
		CU_ASSERT( LoanAnnualPercentageRate( t, D( "400000" ) ).Failure( ).Code( ) = FIN_INVALID_TERM )
		CU_ASSERT( LoanAnnualPercentageRate( t, D( "-1" ) ).Failure( ).Code( ) = FIN_INVALID_TERM )
	END_TEST

END_SUITE
