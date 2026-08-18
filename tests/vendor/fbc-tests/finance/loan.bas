'' fb/finloan.bi -- C:\dev\docs\finance\RFC-0005-loans.md.
''
'' THE STRONGEST TESTS HERE NEED NO ORACLE.  RFC-0005 section 6.1 lists five
'' invariants that must hold on EVERY ROW OF EVERY SCENARIO, and the last of
'' them -- a final closing balance of EXACTLY zero, compared with '=' and not
'' with a tolerance -- is the whole reason section 6 is specified as nine
'' numbered steps rather than left to implementation taste.
''
'' Where a pinned value IS used, the oracle is an INDEPENDENT implementation of
'' those nine steps in Python's arbitrary-precision `decimal`, written from the
'' RFC rather than from this header, and copied back.  Excel is not available in
'' the build environment; the substitution is recorded in
'' C:\dev\docs\finance\amendments.md.
''
'' A published Canadian lender's amortization table is what RFC-0005 section 9
'' names as the ideal oracle for the Canadian rows.  It is NOT used here -- no
'' such table is available offline -- and that gap is recorded in amendments.md
'' rather than papered over.  What IS asserted for the Canadian case is
'' stronger than a transcription anyway: that the convention changes the payment
'' by a specific amount, and that the schedule closes exactly.

#include once "fbcunit.bi"
#include once "fb/finance.bi"

using FB

private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

'' ---------------------------------------------------------------------------
'' THE FIVE INVARIANTS, RFC-0005 section 6.1.  Walks a whole schedule and
'' asserts every one of them on every row.  Returns the row count so callers can
'' assert that too.
'' ---------------------------------------------------------------------------
private function assertInvariants( byref t as LoanTerms, byref label as string ) as long
	dim as FinResultSchedule sc = LoanSchedule( t )
	CU_ASSERT( sc.IsOk( ) )
	if( sc.IsOk( ) = false ) then return 0

	dim as Decimal runningInterest = DecimalZero( )
	dim as Decimal runningPrincipal = DecimalZero( )
	dim as Decimal lastClose = t.Principal_
	dim as long n = 0
	dim as boolean sawFinal = false

	dim as AmortizationIterator it = sc.Value( ).GetIterator( )
	while( it.IsValid( ) )
		dim as AmortizationRow r = it.Value( )
		n += 1

		'' 1 -- Payment = Interest + Principal, an IDENTITY because principal
		''      is the residual (step 3), not an independent computation.
		CU_ASSERT( r.Payment_ = ( r.Interest_ + r.Principal_ ) )

		'' 2 -- Closing = Opening - Principal - Extra.  Exact subtraction of
		''      already-rounded quantities, so no drift accumulates (step 4).
		''      The FINAL row is exempt: step 5 assigns the balance rather than
		''      subtracting to it, which is the entire point.
		if( r.IsFinal_ = false ) then
			CU_ASSERT( r.ClosingBalance_ = ( r.OpeningBalance_ - r.Principal_ - r.ExtraPrincipal_ ) )
		end if

		'' 3 -- the opening balance is the previous closing balance
		CU_ASSERT( r.OpeningBalance_ = lastClose )

		'' 4 -- the cumulative columns are the running sums
		runningInterest = runningInterest + r.Interest_
		runningPrincipal = runningPrincipal + r.Principal_ + r.ExtraPrincipal_
		CU_ASSERT( r.CumulativeInterest_ = runningInterest )
		CU_ASSERT( r.CumulativePrincipal_ = runningPrincipal )

		'' periods are 1-based and contiguous
		CU_ASSERT( r.Period_ = n )

		lastClose = r.ClosingBalance_
		if( r.IsFinal_ ) then sawFinal = true
		it.MoveNext( )
	wend

	CU_ASSERT( n > 0 )
	CU_ASSERT( sawFinal )

	'' 5 -- THE FINAL BALANCE IS EXACTLY THE TARGET, compared with '=' and NOT
	''      within a tolerance.  Zero for an ordinary loan, the balloon
	''      otherwise.  A library whose final balance is 0.0000000001 has not
	''      converged, it has drifted.
	CU_ASSERT( lastClose = t.BalloonAmount_ )

	'' and every dollar is accounted for
	CU_ASSERT( runningPrincipal = ( t.Principal_ - t.BalloonAmount_ ) )

	function = n
end function

SUITE( fbc_tests.finance.loan )

	'' RFC-0005 section 3.1.  THE TWO MORTGAGE CONSTRUCTORS ARE NOT TWO CODE
	'' PATHS -- they fill the same record and differ in one field.
	TEST( terms_differ_in_one_field_ )
		dim as Decimal p = D( "400000" )
		dim as Decimal r = D( "0.0595" )

		dim as LoanTerms us = LoanTermsUsMortgage( p, r, 25 )
		dim as LoanTerms ca = LoanTermsCanadianMortgage( p, r, 25 )

		'' The one field that differs.
		CU_ASSERT( us.Compounding_ = COMPOUND_MONTHLY )
		CU_ASSERT( ca.Compounding_ = COMPOUND_SEMIANNUAL )
		CU_ASSERT( us.Compounding_ <> ca.Compounding_ )

		'' EVERYTHING ELSE IS IDENTICAL.  If this ever fails, the two
		'' constructors have started to diverge into two code paths, which is
		'' exactly what RFC-0002 section 2 forbids.
		CU_ASSERT( us.Principal_ = ca.Principal_ )
		CU_ASSERT( us.NominalAnnualRate_ = ca.NominalAnnualRate_ )
		CU_ASSERT( us.PaymentFrequency_ = ca.PaymentFrequency_ )
		CU_ASSERT( us.TermMonths_ = ca.TermMonths_ )
		CU_ASSERT( us.Timing_ = ca.Timing_ )
		CU_ASSERT( us.BalloonAmount_ = ca.BalloonAmount_ )
		CU_ASSERT( us.Rounding_.Digits_ = ca.Rounding_.Digits_ )
		CU_ASSERT( us.Rounding_.Mode_ = ca.Rounding_.Mode_ )
		CU_ASSERT( us.Basis_ = ca.Basis_ )
		CU_ASSERT( us.TermMonths_ = 300 )
	END_TEST

	'' RFC-0005 section 4.  The payment, both conventions, and the difference
	'' between them -- which is the reason this module exists.
	TEST( payment_both_conventions_ )
		dim as Decimal p = D( "400000" )
		dim as Decimal r = D( "0.0595" )

		dim as FinResultDec us = LoanPayment( LoanTermsUsMortgage( p, r, 25 ) )
		dim as FinResultDec ca = LoanPayment( LoanTermsCanadianMortgage( p, r, 25 ) )
		CU_ASSERT( us.IsOk( ) )
		CU_ASSERT( ca.IsOk( ) )

		CU_ASSERT( us.Value( ) = D( "2564.99" ) )
		CU_ASSERT( ca.Value( ) = D( "2547.35" ) )

		'' THE CONVENTION IS WORTH $17.64 A MONTH on identical inputs, which is
		'' about $5,292 over the term.  A library that ignored the compounding
		'' parameter would return the US number for a Canadian mortgage, and
		'' this assertion is what stops that regression silently.
		CU_ASSERT( ( us.Value( ) - ca.Value( ) ) = D( "17.64" ) )

		'' The 30-year US payment, pinned.
		CU_ASSERT( LoanPayment( LoanTermsUsMortgage( p, r, 30 ) ).Value( ) = D( "2385.36" ) )
	END_TEST

	'' RFC-0005 section 6.1.  THE INVARIANTS, on every row of every scenario.
	TEST( invariants_hold_everywhere_ )
		dim as Decimal p = D( "400000" )

		CU_ASSERT( assertInvariants( LoanTermsUsMortgage( p, D( "0.0595" ), 30 ), "us30" ) = 360 )
		CU_ASSERT( assertInvariants( LoanTermsCanadianMortgage( p, D( "0.0595" ), 25 ), "ca25" ) = 300 )
		CU_ASSERT( assertInvariants( LoanTermsUsMortgage( p, D( "0.02" ), 15 ), "us15low" ) = 180 )
		CU_ASSERT( assertInvariants( LoanTermsUsMortgage( p, D( "0.12" ), 30 ), "us30high" ) = 360 )
		CU_ASSERT( assertInvariants( LoanTermsCanadianMortgage( D( "125000" ), D( "0.0325" ), 20 ), "ca20" ) = 240 )

		'' Non-monthly frequencies exercise the same nine steps.
		dim as LoanTerms wk = LoanTermsMake( p, D( "0.0595" ), 300, PAY_WEEKLY, COMPOUND_SEMIANNUAL )
		CU_ASSERT( assertInvariants( wk, "weekly" ) > 0 )

		dim as LoanTerms qt = LoanTermsMake( p, D( "0.0595" ), 120, PAY_QUARTERLY, COMPOUND_QUARTERLY )
		CU_ASSERT( assertInvariants( qt, "quarterly" ) = 40 )

		'' A ZERO-RATE LOAN amortizes linearly and still lands exactly.
		dim as LoanTerms z = LoanTermsMake( D( "2400" ), DecimalZero( ), 24, PAY_MONTHLY, COMPOUND_MONTHLY )
		CU_ASSERT( assertInvariants( z, "zero" ) = 24 )
		CU_ASSERT( LoanPayment( z ).Value( ) = D( "100" ) )
	END_TEST

	'' RFC-0005 section 6 step 5.  THE FINAL PAYMENT ABSORBS THE REMAINDER --
	'' and this test closes the loop on the README's opening example.
	TEST( final_payment_absorbs_the_residue_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		dim as FinResultSchedule sc = LoanSchedule( t )
		CU_ASSERT( sc.IsOk( ) )

		dim as AmortizationRow final_
		dim as AmortizationIterator it = sc.Value( ).GetIterator( )
		while( it.IsValid( ) )
			final_ = it.Value( )
			it.MoveNext( )
		wend

		CU_ASSERT( final_.IsFinal_ )
		CU_ASSERT( final_.Period_ = 360 )
		CU_ASSERT( final_.ClosingBalance_.IsZero( ) )

		'' The final payment DIFFERS from the scheduled one, and by exactly the
		'' amount the naive double implementation in the docset's README
		'' OVERPAYS: 97 cents.  Rounding the payment half-to-even leaves the
		'' schedule a fraction short each period; step 5 absorbs it, and a
		'' library that posts the scheduled payment 360 times instead
		'' overcharges by precisely this.
		CU_ASSERT( final_.Payment_ = D( "2384.39" ) )
		CU_ASSERT( ( sc.Value( ).Payment( ) - final_.Payment_ ) = D( "0.97" ) )
	END_TEST

	'' RFC-0005 section 4.  Pinned rows, against the independent Python
	'' implementation of the nine steps.
	TEST( us_schedule_rows_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		dim as AmortizationRow r1 = LoanRowAt( t, 1 ).Value( )
		CU_ASSERT( r1.OpeningBalance_ = D( "400000" ) )
		CU_ASSERT( r1.Interest_       = D( "1983.33" ) )
		CU_ASSERT( r1.Principal_      = D( "402.03" ) )
		CU_ASSERT( r1.ClosingBalance_ = D( "399597.97" ) )

		dim as AmortizationRow r2 = LoanRowAt( t, 2 ).Value( )
		CU_ASSERT( r2.Interest_       = D( "1981.34" ) )
		CU_ASSERT( r2.ClosingBalance_ = D( "399193.95" ) )

		dim as AmortizationRow r12 = LoanRowAt( t, 12 ).Value( )
		CU_ASSERT( r12.Interest_       = D( "1960.85" ) )
		CU_ASSERT( r12.ClosingBalance_ = D( "395041.91" ) )

		dim as AmortizationRow r180 = LoanRowAt( t, 180 ).Value( )
		CU_ASSERT( r180.Interest_       = D( "1410.92" ) )
		CU_ASSERT( r180.Principal_      = D( "974.44" ) )
		CU_ASSERT( r180.ClosingBalance_ = D( "283580.13" ) )

		dim as AmortizationRow r359 = LoanRowAt( t, 359 ).Value( )
		CU_ASSERT( r359.ClosingBalance_ = D( "2372.63" ) )

		dim as AmortizationRow r360 = LoanRowAt( t, 360 ).Value( )
		CU_ASSERT( r360.Interest_ = D( "11.76" ) )
		CU_ASSERT( r360.ClosingBalance_.IsZero( ) )
	END_TEST

	'' RFC-0005 section 4.  The Canadian schedule, same treatment.
	TEST( canadian_schedule_rows_ )
		dim as LoanTerms t = LoanTermsCanadianMortgage( D( "400000" ), D( "0.0595" ), 25 )

		dim as AmortizationRow r1 = LoanRowAt( t, 1 ).Value( )
		CU_ASSERT( r1.Interest_       = D( "1959.19" ) )
		CU_ASSERT( r1.Principal_      = D( "588.16" ) )
		CU_ASSERT( r1.ClosingBalance_ = D( "399411.84" ) )

		dim as AmortizationRow r12 = LoanRowAt( t, 12 ).Value( )
		CU_ASSERT( r12.Interest_       = D( "1926.71" ) )
		CU_ASSERT( r12.ClosingBalance_ = D( "392748.76" ) )

		dim as AmortizationRow r150 = LoanRowAt( t, 150 ).Value( )
		CU_ASSERT( r150.Interest_       = D( "1329.28" ) )
		CU_ASSERT( r150.ClosingBalance_ = D( "270176.77" ) )

		dim as AmortizationRow r300 = LoanRowAt( t, 300 ).Value( )
		CU_ASSERT( r300.IsFinal_ )
		CU_ASSERT( r300.Payment_ = D( "2547.66" ) )
		CU_ASSERT( r300.ClosingBalance_.IsZero( ) )

		'' THE FIRST PERIOD'S INTEREST IS THE CONVENTION MADE VISIBLE: under
		'' the US convention the same loan would accrue 400000 * 0.0595/12 =
		'' 1983.33, and here it is 1959.19.  A library that ignored the
		'' compounding parameter would produce the former.
		CU_ASSERT( r1.Interest_ < D( "1983.33" ) )
	END_TEST

	'' RFC-0005 section 4.  The O(1) closed form and the walk DISAGREE, by a
	'' bounded amount, and the doc says which one wins.
	TEST( balance_at_vs_walk_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		'' Period zero is the principal, exactly.
		CU_ASSERT( LoanBalanceAt( t, 0 ).Value( ) = D( "400000" ) )

		for k as long = 12 to 348 step 48
			dim as Decimal walked = LoanRowAt( t, k ).Value( ).ClosingBalance_
			dim as Decimal closed = LoanBalanceAt( t, k ).Value( )

			'' They agree to within Rounding_ times the period number -- the
			'' bound RFC-0005 section 4 states.  Not to the cent, and the
			'' header says so rather than pretending otherwise.
			dim as Decimal gap = walked - closed
			dim as Decimal bound = DecimalFromInt( k ) * D( "0.01" )
			CU_ASSERT( gap.AbsValue( ) <= bound )
		next

		'' THE SCHEDULE IS AUTHORITATIVE: the walked balance is what a ledger
		'' posts, and only it lands on exactly zero.
		CU_ASSERT( LoanRowAt( t, 360 ).Value( ).ClosingBalance_.IsZero( ) )
	END_TEST

	'' RFC-0005 section 4.  Interest and principal between periods.
	TEST( between_periods_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		'' The whole term's interest equals the summary's total.
		dim as FinResultDec all_ = LoanInterestBetween( t, 1, 360 )
		CU_ASSERT( all_.IsOk( ) )
		CU_ASSERT( all_.Value( ) = D( "458728.63" ) )
		CU_ASSERT( all_.Value( ) = LoanSummarize( t ).Value( ).TotalInterest_ )

		'' The whole term's principal is the loan.
		CU_ASSERT( LoanPrincipalBetween( t, 1, 360 ).Value( ) = D( "400000" ) )

		'' A single period matches the row.
		CU_ASSERT( LoanInterestBetween( t, 12, 12 ).Value( ) = LoanRowAt( t, 12 ).Value( ).Interest_ )

		'' Adjacent ranges sum to the whole.
		dim as Decimal a = LoanInterestBetween( t, 1, 180 ).Value( )
		dim as Decimal b = LoanInterestBetween( t, 181, 360 ).Value( )
		CU_ASSERT( ( a + b ) = all_.Value( ) )

		'' Backwards is an error, not an empty sum.
		CU_ASSERT( LoanInterestBetween( t, 200, 100 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
		CU_ASSERT( LoanInterestBetween( t, 0, 10 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0005 section 3.2.  The summary.
	TEST( summary_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		dim as FinResultSummary s = LoanSummarize( t )
		CU_ASSERT( s.IsOk( ) )

		CU_ASSERT( s.Value( ).ScheduledPayment_ = D( "2385.36" ) )
		CU_ASSERT( s.Value( ).FinalPayment_     = D( "2384.39" ) )
		CU_ASSERT( s.Value( ).PaymentCount_     = 360 )
		CU_ASSERT( s.Value( ).TotalInterest_    = D( "458728.63" ) )
		CU_ASSERT( s.Value( ).TotalPrincipal_   = D( "400000" ) )
		CU_ASSERT( s.Value( ).TotalPaid_        = D( "858728.63" ) )

		'' Total paid is interest plus principal, exactly.
		CU_ASSERT( s.Value( ).TotalPaid_ = ( s.Value( ).TotalInterest_ + s.Value( ).TotalPrincipal_ ) )

		'' Without extras there is nothing saved and nothing shortened.
		CU_ASSERT( s.Value( ).InterestSavedVsScheduled_.IsZero( ) )
		CU_ASSERT( s.Value( ).PeriodsSaved_ = 0 )

		'' The effective annual rate matches the rate module.
		CU_ASSERT( s.Value( ).EffectiveAnnualRate_ = _
		           RateEffectiveFromNominal( D( "0.0595" ), COMPOUND_MONTHLY ).Value( ) )
	END_TEST

	'' RFC-0005 section 4.1.  ACCELERATED PAYMENTS -- the Canadian prepayment
	'' product, and the step everybody forgets.
	TEST( accelerated_ )
		dim as Decimal p = D( "400000" )
		dim as Decimal r = D( "0.0595" )

		dim as LoanTerms monthly = LoanTermsCanadianMortgage( p, r, 25 )
		dim as LoanTerms accel = LoanTermsCanadianMortgage( p, r, 25 )
		accel.PaymentFrequency_ = PAY_ACCELERATED_BIWEEKLY

		dim as Decimal pm = LoanPayment( monthly ).Value( )
		dim as Decimal pa = LoanPayment( accel ).Value( )

		'' STEP 2: the posted payment is THE MONTHLY PAYMENT DIVIDED BY TWO,
		'' not an annuity over 26 periods -- that would be ordinary biweekly,
		'' a different and cheaper product.
		CU_ASSERT( pa = MoneyRound( pm / DecimalFromInt( 2 ), accel.Rounding_ ) )

		'' STEP 4: it finishes EARLY, which is the entire product.
		dim as FinResultSummary sm = LoanSummarize( monthly )
		dim as FinResultSummary sa = LoanSummarize( accel )
		CU_ASSERT( sm.IsOk( ) )
		CU_ASSERT( sa.IsOk( ) )

		dim as FinResultSchedule sc = LoanSchedule( accel )
		CU_ASSERT( sa.Value( ).PaymentCount_ < sc.Value( ).Count( ) )

		'' And it costs LESS interest than the monthly schedule.
		CU_ASSERT( sa.Value( ).TotalInterest_ < sm.Value( ).TotalInterest_ )

		'' The invariants hold here too, including the exact final zero.
		CU_ASSERT( assertInvariants( accel, "accel" ) > 0 )
	END_TEST

	'' RFC-0005 section 4.  The implied rate, which is the phase 3 solver
	'' reaching this surface.
	TEST( implied_rate_ )
		dim as Decimal p = D( "400000" )
		dim as Decimal r = D( "0.0595" )
		dim as LoanTerms t = LoanTermsUsMortgage( p, r, 30 )
		dim as Decimal pmt = LoanPayment( t ).Value( )

		dim as FinResultDec implied = LoanImpliedRate( p, pmt, 360, PAY_MONTHLY, COMPOUND_MONTHLY )
		CU_ASSERT( implied.IsOk( ) )

		'' It recovers the quoted rate to four places.  NOT to twelve, and the
		'' reason is not the solver: the payment it is given was ROUNDED TO
		'' CENTS, so the rate implied by 2385.36 is genuinely a shade different
		'' from the rate that produced 2385.358865...  Asserting more places
		'' would be asserting a coincidence.
		CU_ASSERT( implied.Value( ).Round( 4 ) = r.Round( 4 ) )
		CU_ASSERT( implied.Value( ) > D( "0.0594" ) )
		CU_ASSERT( implied.Value( ) < D( "0.0596" ) )

		'' Errors are named.
		CU_ASSERT( LoanImpliedRate( DecimalZero( ), pmt, 360, PAY_MONTHLY, COMPOUND_MONTHLY ).Failure( ).Code( ) = FIN_INVALID_TERM )
		CU_ASSERT( LoanImpliedRate( p, DecimalZero( ), 360, PAY_MONTHLY, COMPOUND_MONTHLY ).Failure( ).Code( ) = FIN_INVALID_TERM )
		CU_ASSERT( LoanImpliedRate( p, pmt, 0, PAY_MONTHLY, COMPOUND_MONTHLY ).Failure( ).Code( ) = FIN_INVALID_TERM )
	END_TEST

	'' RFC-0005 section 5.  The schedule is LAZY and the iterator owns nothing.
	TEST( schedule_is_lazy_and_reusable_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )
		dim as FinResultSchedule sc = LoanSchedule( t )
		CU_ASSERT( sc.IsOk( ) )
		CU_ASSERT( sc.Value( ).Count( ) = 360 )
		CU_ASSERT( sc.Value( ).Payment( ) = D( "2385.36" ) )

		'' TWO INDEPENDENT WALKS of the same schedule give the same rows -- the
		'' schedule holds the terms, not consumed state.
		dim as AmortizationIterator a = sc.Value( ).GetIterator( )
		dim as AmortizationIterator b = sc.Value( ).GetIterator( )
		for k as long = 1 to 5
			CU_ASSERT( a.IsValid( ) )
			CU_ASSERT( b.IsValid( ) )
			CU_ASSERT( a.Value( ).Period_ = b.Value( ).Period_ )
			CU_ASSERT( a.Value( ).ClosingBalance_ = b.Value( ).ClosingBalance_ )
			a.MoveNext( )
			b.MoveNext( )
		next

		'' ABANDONING A WALK EARLY leaks nothing and leaves the schedule
		'' usable -- the iterator holds no resource, unlike fb/fsdir.bi's.
		scope
			dim as AmortizationIterator early = sc.Value( ).GetIterator( )
			early.MoveNext( )
			early.MoveNext( )
		end scope
		CU_ASSERT( sc.Value( ).GetIterator( ).Value( ).Period_ = 1 )

		'' Materializing gives the same rows in the same order.
		dim as Array( of AmortizationRow ) rows = ScheduleToArray( sc.Value( ) )
		CU_ASSERT( rows.Count( ) = 360 )
		CU_ASSERT( rows.At( 0 ).Period_ = 1 )
		CU_ASSERT( rows.At( 0 ).ClosingBalance_ = D( "399597.97" ) )
		CU_ASSERT( rows.At( 359 ).IsFinal_ )
		CU_ASSERT( rows.At( 359 ).ClosingBalance_.IsZero( ) )
	END_TEST

	'' RFC-0005 section 3.2.  Due dates, when a first payment date is given.
	TEST( due_dates_ )
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), D( "0.0595" ), 30 )

		'' Without a date the column is Invalid rather than a fabricated one.
		CU_ASSERT( LoanRowAt( t, 1 ).Value( ).DueDate_.IsValid = false )

		t.FirstPaymentDate_ = LocalDate( 2026, 3, 1 )
		CU_ASSERT( LoanRowAt( t, 1 ).Value( ).DueDate_ = LocalDate( 2026, 3, 1 ) )
		CU_ASSERT( LoanRowAt( t, 2 ).Value( ).DueDate_ = LocalDate( 2026, 4, 1 ) )
		CU_ASSERT( LoanRowAt( t, 13 ).Value( ).DueDate_ = LocalDate( 2027, 3, 1 ) )
		CU_ASSERT( LoanRowAt( t, 360 ).Value( ).DueDate_ = LocalDate( 2056, 2, 1 ) )

		'' The summary reports the payoff date.
		CU_ASSERT( LoanSummarize( t ).Value( ).PayoffDate_ = LocalDate( 2056, 2, 1 ) )
	END_TEST

	'' RFC-0001 section 6.  Errors, by code.
	TEST( loan_errors_ )
		dim as Decimal r = D( "0.0595" )

		'' Zero or negative principal is not a loan.
		CU_ASSERT( LoanPayment( LoanTermsUsMortgage( DecimalZero( ), r, 30 ) ).Failure( ).Code( ) = FIN_INVALID_TERM )
		CU_ASSERT( LoanPayment( LoanTermsUsMortgage( D( "-1000" ), r, 30 ) ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' A term of no months.
		dim as LoanTerms t0 = LoanTermsMake( D( "1000" ), r, 0, PAY_MONTHLY, COMPOUND_MONTHLY )
		CU_ASSERT( LoanPayment( t0 ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' A balloon larger than the loan.
		dim as LoanTerms tb = LoanTermsUsMortgage( D( "400000" ), r, 30 )
		tb.BalloonAmount_ = D( "500000" )
		CU_ASSERT( LoanPayment( tb ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' An out-of-range rounding policy.
		dim as LoanTerms tr = LoanTermsUsMortgage( D( "400000" ), r, 30 )
		tr.Rounding_ = MoneyRoundingMake( 99, DEC_HALF_EVEN, TRUE )
		CU_ASSERT( LoanPayment( tr ).Failure( ).Code( ) = FIN_INVALID_BASIS )

		'' A period that does not exist.
		dim as LoanTerms t = LoanTermsUsMortgage( D( "400000" ), r, 30 )
		CU_ASSERT( LoanRowAt( t, 0 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
		CU_ASSERT( LoanRowAt( t, 999 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
		CU_ASSERT( LoanBalanceAt( t, -1 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

END_SUITE
