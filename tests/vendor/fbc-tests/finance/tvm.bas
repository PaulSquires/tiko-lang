'' fb/fintvm.bi -- C:\dev\docs\finance\RFC-0004-time-value-of-money.md.
''
'' THE ORACLE, NAMED UP FRONT.  Expected values were produced by an INDEPENDENT
'' implementation -- Python's arbitrary-precision `decimal` at 60 significant
'' digits, computing the same closed form -- and copied back.  Excel is not
'' available in the build environment; the substitution is recorded in
'' C:\dev\docs\finance\amendments.md.
''
'' THE STRONGEST TEST HERE NEEDS NO ORACLE AT ALL.  RFC-0004 section 2 says
'' every function is a rearrangement of
''
''     PV + PMT * a( i, n, timing ) + FV * v( i, n ) = 0
''
'' so `identity_` computes one unknown from the other four and asserts the
'' equation balances.  A sign error, a transposed argument or a drifting
'' factor cannot survive it, and it holds across the whole grid rather than at
'' a pinned point.
''
'' Values that TERMINATE are asserted with '='.  Values that do not are
'' asserted to a stated number of decimal places, because RFC-0002 section 6.3
'' bounds rather than eliminates the exact kernel's error.

#include once "fbcunit.bi"
#include once "fb/finance.bi"

using FB

private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

private function sameTo( byref a as Decimal, byref b as Decimal, byval places as long ) as boolean
	if( a.IsValid( ) = false ) then return false
	if( b.IsValid( ) = false ) then return false
	function = ( a.Round( places ) = b.Round( places ) )
end function

'' The residual of RFC-0004 section 2's identity, for a fully-populated record.
'' Written here rather than in the header so that the test computes it
'' independently of whatever the header did to produce the unknown.
private function identityResidual( byref t as AnnuityTerms ) as Decimal
	dim as FinResultDec a = AnnuityPresentValueFactor( t.RatePerPeriod_, t.Periods_, t.Timing_ )
	dim as FinResultDec v = DiscountFactor( t.RatePerPeriod_, t.Periods_ )
	if( a.IsOk( ) = false ) then return DecimalInvalid( )
	if( v.IsOk( ) = false ) then return DecimalInvalid( )

	dim as Decimal r = t.PresentValue_
	r = r + ( t.Payment_ * a.Value( ) )
	r = r + ( t.FutureValue_ * v.Value( ) )
	function = r
end function

'' The residual measured AGAINST THE SIZE OF THE TERMS THAT PRODUCED IT, which
'' is the only form of the assertion that means the same thing across the whole
'' grid.
''
'' At 10% PER PERIOD for 360 periods the terms of the identity span twenty
'' orders of magnitude -- FV lands near -3e20 while PV is 4e5 -- so an absolute
'' tolerance would be asserting the same number of decimal places about
'' quantities that cannot possibly carry the same number of them.
''
'' The precision that actually binds is the DISCOUNT FACTOR's.  Decimal's
'' ceiling is 28 DECIMAL PLACES, not 28 significant digits, so v = 1.26e-15
'' retains only about thirteen significant digits -- and the identity can be no
'' better than its worst operand.  Measured at 1.3e-14 relative, which is
'' exactly that.  fb/fincore.bi's DiscountFactor carries the same note.
''
'' Dividing by the largest term asks the question that means the same thing in
'' every cell: does the identity balance to the precision the operands carry?
private function relativeResidual( byref t as AnnuityTerms ) as Decimal
	dim as Decimal r = identityResidual( t )
	if( r.IsValid( ) = false ) then return DecimalInvalid( )

	dim as FinResultDec a = AnnuityPresentValueFactor( t.RatePerPeriod_, t.Periods_, t.Timing_ )
	dim as FinResultDec v = DiscountFactor( t.RatePerPeriod_, t.Periods_ )
	if( a.IsOk( ) = false ) then return DecimalInvalid( )
	if( v.IsOk( ) = false ) then return DecimalInvalid( )

	'' Split rather than written as ( x * y ).AbsValue( ): an initialiser that
	'' OPENS with '(' is read as complete, and the member access after it gives
	'' "error 3: Expected End-of-Line, found '.'".  Same fbc quirk as the '/'
	'' case in fb/fintvm.bi.
	dim as Decimal prod2 = t.Payment_ * a.Value( )
	dim as Decimal prod3 = t.FutureValue_ * v.Value( )

	dim as Decimal scale_ = DecimalOne( )
	dim as Decimal term1 = t.PresentValue_.AbsValue( )
	dim as Decimal term2 = prod2.AbsValue( )
	dim as Decimal term3 = prod3.AbsValue( )
	if( term1 > scale_ ) then scale_ = term1
	if( term2 > scale_ ) then scale_ = term2
	if( term3 > scale_ ) then scale_ = term3

	function = ( r / scale_ )
end function

SUITE( fbc_tests.finance.tvm )

	'' RFC-0004 section 2.  THE IDENTITY, across a grid, in all three
	'' directions -- solve for PMT, for PV, for FV, and check the equation
	'' balances each time.  No oracle.
	''
	'' TWELVE PLACES RELATIVE, AND THE BINDING CONSTRAINT IS NAMED.  That is
	'' not slack: the worst cell of this grid is 10% PER PERIOD for 360
	'' periods, where the discount factor is 1.26e-15 and Decimal's ceiling of
	'' 28 DECIMAL PLACES -- not 28 significant digits -- leaves it about
	'' thirteen significant digits.  Measured at 1.3e-14 relative; see
	'' fb/fincore.bi's note on DiscountFactor.  Every realistic cell does far
	'' better, which round_trip_ pins separately at 16 and 18 places.
	TEST( identity_ )
		dim as string rates( 0 to 4 ) = { "0.0049583333333333333333333333", _
		                                  "0.05", "0.0125", "0.0025", "0.10" }
		dim as long terms( 0 to 4 ) = { 360, 10, 96, 24, 5 }

		for ri as long = 0 to 4
			for ti as long = 0 to 4
				dim as Decimal i = D( rates( ri ) )
				dim as long n = terms( ti )

				for due as long = 0 to 1
					dim as PaymentTiming tm = PAY_END_OF_PERIOD
					if( due = 1 ) then tm = PAY_BEGIN_OF_PERIOD

					'' --- solve for PMT, then the identity must balance
					dim as AnnuityTerms t1 = AnnuityTermsMake( i, n, DecimalZero( ), _
					                                           D( "400000" ), D( "-1000" ), tm )
					dim as FinResultDec pmt = PaymentAmount( t1 )
					CU_ASSERT( pmt.IsOk( ) )
					t1.Payment_ = pmt.Value( )
					CU_ASSERT( sameTo( relativeResidual( t1 ), DecimalZero( ), 12 ) )

					'' --- solve for PV
					dim as AnnuityTerms t2 = AnnuityTermsMake( i, n, D( "-2500" ), _
					                                           DecimalZero( ), D( "-1000" ), tm )
					dim as FinResultDec pv = PresentValue( t2 )
					CU_ASSERT( pv.IsOk( ) )
					t2.PresentValue_ = pv.Value( )
					CU_ASSERT( sameTo( relativeResidual( t2 ), DecimalZero( ), 12 ) )

					'' --- solve for FV
					dim as AnnuityTerms t3 = AnnuityTermsMake( i, n, D( "-2500" ), _
					                                           D( "400000" ), DecimalZero( ), tm )
					dim as FinResultDec fv = FutureValue( t3 )
					CU_ASSERT( fv.IsOk( ) )
					t3.FutureValue_ = fv.Value( )
					CU_ASSERT( sameTo( relativeResidual( t3 ), DecimalZero( ), 12 ) )
				next
			next
		next
	END_TEST

	'' RFC-0004 section 4.  Each function recovers what the others were given.
	TEST( round_trip_ )
		dim as Decimal i = RatePerPeriod( D( "0.0595" ), COMPOUND_MONTHLY ).Value( )

		dim as AnnuityTerms t = AnnuityTermsMake( i, 360, DecimalZero( ), _
		                                          D( "400000" ), DecimalZero( ), _
		                                          PAY_END_OF_PERIOD )
		dim as FinResultDec pmt = PaymentAmount( t )
		CU_ASSERT( pmt.IsOk( ) )

		'' The reference, to 24 places.
		CU_ASSERT( sameTo( pmt.Value( ), D( "-2385.358864934633948773025568" ), 18 ) )

		'' Feed the payment back and the principal comes out again.
		dim as AnnuityTerms back = AnnuityTermsMake( i, 360, pmt.Value( ), _
		                                             DecimalZero( ), DecimalZero( ), _
		                                             PAY_END_OF_PERIOD )
		CU_ASSERT( sameTo( PresentValue( back ).Value( ), D( "400000" ), 16 ) )

		'' And the balance at maturity is zero.
		dim as AnnuityTerms atEnd = AnnuityTermsMake( i, 360, pmt.Value( ), _
		                                              D( "400000" ), DecimalZero( ), _
		                                              PAY_END_OF_PERIOD )
		CU_ASSERT( sameTo( FutureValue( atEnd ).Value( ), DecimalZero( ), 16 ) )
	END_TEST

	'' RFC-0004 section 4.  The annuity factors.
	TEST( annuity_factors_ )
		'' TERMINATING -- the future-value factor at these rates has a finite
		'' expansion, so it is asserted EXACTLY.
		CU_ASSERT( AnnuityFutureValueFactor( D( "0.10" ), 10, PAY_END_OF_PERIOD ).Value( ) _
		           = D( "15.937424601" ) )
		CU_ASSERT( AnnuityFutureValueFactor( D( "0.05" ), 4, PAY_END_OF_PERIOD ).Value( ) _
		           = D( "4.310125" ) )
		'' NOT exact, and the reason is worth pinning: TERMINATING IS NOT
		'' ENOUGH -- the value must also FIT.  1.0125^8 terminates, at 32
		'' significant digits, which a 96-bit mantissa cannot hold; the kernel
		'' reduces it to FIN_WORK_SCALE and the factor inherits that.  The
		'' exact expansion 8.3588880945129871368408203125 will not even PARSE
		'' as a Decimal -- it is 29 significant digits.
		CU_ASSERT( sameTo( AnnuityFutureValueFactor( D( "0.0125" ), 8, PAY_END_OF_PERIOD ).Value( ), _
		                   D( "8.358888094512987136840820" ), 18 ) )

		'' NON-TERMINATING -- the present-value factor divides by (1+i)^n.
		CU_ASSERT( sameTo( AnnuityPresentValueFactor( D( "0.10" ), 10, PAY_END_OF_PERIOD ).Value( ), _
		                   D( "6.144567105704682526355963" ), 20 ) )
		CU_ASSERT( sameTo( AnnuityPresentValueFactor( D( "0.05" ), 4, PAY_END_OF_PERIOD ).Value( ), _
		                   D( "3.545950504162360333400178" ), 20 ) )

		'' THE FACTORS ARE RELATED: a * (1+i)^n = s, exactly the relationship
		'' that makes PresentValue and FutureValue consistent.
		for n as long = 1 to 60 step 7
			dim as Decimal i = D( "0.0125" )
			dim as Decimal a = AnnuityPresentValueFactor( i, n, PAY_END_OF_PERIOD ).Value( )
			dim as Decimal s = AnnuityFutureValueFactor( i, n, PAY_END_OF_PERIOD ).Value( )
			dim as Decimal g = GrowthFactor( i, n ).Value( )
			CU_ASSERT( sameTo( a * g, s, 18 ) )
		next

		'' n = 0 is a zero factor -- no payments, nothing to discount.
		CU_ASSERT( AnnuityPresentValueFactor( D( "0.05" ), 0, PAY_END_OF_PERIOD ).Value( ).IsZero( ) )
		CU_ASSERT( AnnuityFutureValueFactor( D( "0.05" ), 0, PAY_END_OF_PERIOD ).Value( ).IsZero( ) )
	END_TEST

	'' RFC-0004 section 6.  THE ZERO-RATE LIMITS, every row of the table,
	'' compared with '='.  This is the case that returns Invalid in most
	'' time-value-of-money libraries.
	TEST( zero_rate_ )
		dim as Decimal z = DecimalZero( )

		'' The factors are both exactly n.
		for n as long = 0 to 40
			CU_ASSERT( AnnuityPresentValueFactor( z, n, PAY_END_OF_PERIOD ).Value( ) = DecimalFromInt( n ) )
			CU_ASSERT( AnnuityFutureValueFactor( z, n, PAY_END_OF_PERIOD ).Value( ) = DecimalFromInt( n ) )
			'' An annuity due at zero rate is STILL n payments -- (1+i) is 1.
			CU_ASSERT( AnnuityPresentValueFactor( z, n, PAY_BEGIN_OF_PERIOD ).Value( ) = DecimalFromInt( n ) )
		next

		'' PV = -( PMT*n + FV )
		dim as AnnuityTerms t1 = AnnuityTermsMake( z, 12, D( "-100" ), DecimalZero( ), D( "-50" ), PAY_END_OF_PERIOD )
		CU_ASSERT( PresentValue( t1 ).Value( ) = D( "1250" ) )

		'' PMT = -( PV + FV ) / n
		dim as AnnuityTerms t2 = AnnuityTermsMake( z, 12, DecimalZero( ), D( "1200" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PaymentAmount( t2 ).Value( ) = D( "-100" ) )

		dim as AnnuityTerms t3 = AnnuityTermsMake( z, 10, DecimalZero( ), D( "1000" ), D( "500" ), PAY_END_OF_PERIOD )
		CU_ASSERT( PaymentAmount( t3 ).Value( ) = D( "-150" ) )

		'' FV = -( PV + PMT*n )
		dim as AnnuityTerms t4 = AnnuityTermsMake( z, 12, D( "-100" ), DecimalZero( ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( FutureValue( t4 ).Value( ) = D( "1200" ) )

		'' n = -( PV + FV ) / PMT
		dim as AnnuityTerms t5 = AnnuityTermsMake( z, 0, D( "-100" ), D( "1200" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT_DOUBLE_EQUAL( PeriodsRequired( t5 ).Value( ), 12.0, 1.0e-12 )
		CU_ASSERT( PeriodsRequiredWhole( t5 ).Value( ) = 12 )

		'' A zero-rate loan amortizes LINEARLY and the identity still balances.
		dim as AnnuityTerms t6 = AnnuityTermsMake( z, 24, DecimalZero( ), D( "2400" ), DecimalZero( ), PAY_END_OF_PERIOD )
		t6.Payment_ = PaymentAmount( t6 ).Value( )
		CU_ASSERT( t6.Payment_ = D( "-100" ) )
		CU_ASSERT( identityResidual( t6 ).IsZero( ) )
	END_TEST

	'' RFC-0004 section 7.  Annuity due is the ordinary factor times (1+i),
	'' and that is the ONLY difference -- no separate code path.
	TEST( annuity_due_ )
		dim as Decimal i = D( "0.0125" )

		for n as long = 1 to 48 step 5
			dim as Decimal ord = AnnuityPresentValueFactor( i, n, PAY_END_OF_PERIOD ).Value( )
			dim as Decimal due = AnnuityPresentValueFactor( i, n, PAY_BEGIN_OF_PERIOD ).Value( )
			CU_ASSERT( due = ( ord * ( DecimalOne( ) + i ) ) )

			dim as Decimal ordS = AnnuityFutureValueFactor( i, n, PAY_END_OF_PERIOD ).Value( )
			dim as Decimal dueS = AnnuityFutureValueFactor( i, n, PAY_BEGIN_OF_PERIOD ).Value( )
			CU_ASSERT( dueS = ( ordS * ( DecimalOne( ) + i ) ) )
		next

		'' Paying at the START of each period costs LESS per payment, because
		'' every payment works for one extra period.
		dim as Decimal r = RatePerPeriod( D( "0.0595" ), COMPOUND_MONTHLY ).Value( )
		dim as AnnuityTerms o = AnnuityTermsMake( r, 360, DecimalZero( ), D( "400000" ), DecimalZero( ), PAY_END_OF_PERIOD )
		dim as AnnuityTerms b = AnnuityTermsMake( r, 360, DecimalZero( ), D( "400000" ), DecimalZero( ), PAY_BEGIN_OF_PERIOD )

		dim as Decimal po = PaymentAmount( o ).Value( )
		dim as Decimal pb = PaymentAmount( b ).Value( )
		CU_ASSERT( pb > po )       '' both negative, so "smaller payment" is greater
		CU_ASSERT( sameTo( pb, D( "-2373.589815433111437893470444" ), 18 ) )
	END_TEST

	'' RFC-0004 section "Lump sums".  A MULTIPLY, NOT A REARRANGEMENT -- the
	'' sign is unchanged, and this test pins the exact relationship to the
	'' record form so the difference is asserted rather than lurking.
	TEST( lump_sums_ )
		'' 1.1^10 terminates, so this is EXACT.
		CU_ASSERT( FutureValueOfLump( D( "1000" ), D( "0.10" ), 10 ).Value( ) _
		           = D( "2593.7424601" ) )

		'' Round trip returns the original, exactly.
		dim as Decimal fv = FutureValueOfLump( D( "1000" ), D( "0.10" ), 10 ).Value( )
		CU_ASSERT( sameTo( PresentValueOfLump( fv, D( "0.10" ), 10 ).Value( ), D( "1000" ), 20 ) )

		'' SIGN UNCHANGED: a positive amount in gives a positive value out.
		CU_ASSERT( PresentValueOfLump( D( "1000" ), D( "0.05" ), 5 ).Value( ) > DecimalZero( ) )
		CU_ASSERT( FutureValueOfLump( D( "-1000" ), D( "0.05" ), 5 ).Value( ) < DecimalZero( ) )

		'' THE RELATIONSHIP TO THE RECORD FORM, pinned: the record form is the
		'' identity and therefore NEGATES.  These two differ by exactly a sign,
		'' and that is the documented difference rather than an inconsistency.
		dim as AnnuityTerms t = AnnuityTermsMake( D( "0.05" ), 5, DecimalZero( ), _
		                                          DecimalZero( ), D( "1000" ), PAY_END_OF_PERIOD )
		CU_ASSERT( PresentValue( t ).Value( ) = -PresentValueOfLump( D( "1000" ), D( "0.05" ), 5 ).Value( ) )

		'' n = 0 is the identity in both directions.
		CU_ASSERT( PresentValueOfLump( D( "1234.56" ), D( "0.07" ), 0 ).Value( ) = D( "1234.56" ) )
		CU_ASSERT( FutureValueOfLump( D( "1234.56" ), D( "0.07" ), 0 ).Value( ) = D( "1234.56" ) )
	END_TEST

	'' RFC-0004 section 5.  The term, and why it returns a double.
	TEST( term_ )
		'' Against the reference.
		dim as AnnuityTerms t = AnnuityTermsMake( D( "0.05" ), 0, D( "-100" ), _
		                                          D( "1000" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT_DOUBLE_EQUAL( PeriodsRequired( t ).Value( ), 14.206699082890463, 1.0e-12 )

		'' FRACTIONAL, and the whole form CEILS -- 14.2 periods means 15
		'' payments, the last one smaller.
		CU_ASSERT( PeriodsRequiredWhole( t ).Value( ) = 15 )

		'' A term that IS whole comes back whole, not rounded up by a double's
		'' noise: the 360-month mortgage must be 360 payments, not 361.
		dim as Decimal i = RatePerPeriod( D( "0.0595" ), COMPOUND_MONTHLY ).Value( )
		dim as AnnuityTerms m = AnnuityTermsMake( i, 360, DecimalZero( ), D( "400000" ), DecimalZero( ), PAY_END_OF_PERIOD )
		dim as Decimal pmt = PaymentAmount( m ).Value( )

		dim as AnnuityTerms nt = AnnuityTermsMake( i, 0, pmt, D( "400000" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT_DOUBLE_EQUAL( PeriodsRequired( nt ).Value( ), 360.0, 1.0e-6 )
		CU_ASSERT( PeriodsRequiredWhole( nt ).Value( ) = 360 )

		'' NEVER AMORTIZES: the payment does not cover the interest, so the
		'' balance grows forever.  A named code, not an infinity.
		dim as AnnuityTerms bad = AnnuityTermsMake( i, 0, D( "-100" ), D( "400000" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PeriodsRequired( bad ).IsOk( ) = false )
		CU_ASSERT( PeriodsRequired( bad ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A pure lump sum with no payment stream still has a term.
		dim as AnnuityTerms lump = AnnuityTermsMake( D( "0.10" ), 0, DecimalZero( ), _
		                                             D( "1000" ), D( "-2000" ), PAY_END_OF_PERIOD )
		CU_ASSERT_DOUBLE_EQUAL( PeriodsRequired( lump ).Value( ), 7.272540897341713, 1.0e-9 )
	END_TEST

	'' RFC-0001 section 6 and RFC-0004 section 8.  Errors, by CODE.
	TEST( tvm_errors_ )
		dim as Decimal i = D( "0.05" )

		'' Rate at or below -1.
		dim as AnnuityTerms r1 = AnnuityTermsMake( D( "-1" ), 10, DecimalZero( ), D( "100" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PresentValue( r1 ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( FutureValue( r1 ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( PaymentAmount( r1 ).Failure( ).Code( ) = FIN_INVALID_RATE )

		'' Negative term.
		dim as AnnuityTerms r2 = AnnuityTermsMake( i, -3, DecimalZero( ), D( "100" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PresentValue( r2 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )

		'' PaymentAmount over ZERO periods has no answer -- dividing 100 into
		'' no payments is a different failure from a negative term.
		dim as AnnuityTerms r3 = AnnuityTermsMake( i, 0, DecimalZero( ), D( "100" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PaymentAmount( r3 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )

		'' An Invalid Decimal anywhere in the record is refused by name.
		dim as AnnuityTerms r4 = AnnuityTermsMake( i, 10, DecimalInvalid( ), D( "100" ), DecimalZero( ), PAY_END_OF_PERIOD )
		CU_ASSERT( PresentValue( r4 ).IsOk( ) = false )

		'' The factors validate on their own account too.
		CU_ASSERT( AnnuityPresentValueFactor( D( "-2" ), 5, PAY_END_OF_PERIOD ).Failure( ).Code( ) = FIN_INVALID_RATE )
		CU_ASSERT( AnnuityFutureValueFactor( i, -1, PAY_END_OF_PERIOD ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

END_SUITE
