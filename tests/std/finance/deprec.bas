'' fb/findeprec.bi -- C:\dev\docs\finance\RFC-0007-depreciation.md.
''
'' ORACLE: an independent implementation in Python's 40-digit `decimal`, written
'' from the RFC, plus IRS Publication 946's MACRS 200%-declining-balance
'' schedule for the five-year class -- which this header reproduces EXACTLY when
'' PlacedInService_ is 0.5.
''
'' WHAT IS NOT REPRODUCED, and it is a real distinction: the published MACRS
'' PERCENTAGE TABLES carry display rounding that forces each column to sum to
'' exactly 100.00.  The three-year column shows 44.45 where the arithmetic gives
'' 44.4444, and the seven-year column alternates 8.93 / 8.92 / 8.93 where the
'' arithmetic gives 8.9249 three times.  This header returns the ARITHMETIC.
'' The five-year column happens to need no adjustment, which is why it is the
'' one asserted with '='.  Recorded in C:\dev\docs\finance\amendments.md.
''
'' THE ANTI-CASE IS ASSERTED, not merely described: the naive switch rule --
'' straight line on the ORIGINAL base over the ORIGINAL life -- is computed here
'' and asserted to DIFFER from the header's.  A regression to it fails loudly
'' rather than producing plausible numbers.

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

private function sameTo( byref a as Decimal, byref b as Decimal, byval places as long ) as boolean
	if( a.IsValid( ) = false ) then return false
	if( b.IsValid( ) = false ) then return false
	function = ( a.Round( places ) = b.Round( places ) )
end function

'' Walks a schedule and asserts the invariants that hold for EVERY method:
'' the book value never falls below salvage, the expense is never negative,
'' the accumulated column is the running sum, and the final book value is
'' EXACTLY salvage.  Returns the row count.
private function assertDepInvariants _
	( byref t as DepreciationTerms, byval m as DepreciationMethod ) as long

	dim as FinResultDepSchedule s = DepreciationScheduleOf( t, m )
	CU_ASSERT( s.IsOk( ) )
	if( s.IsOk( ) = false ) then return 0

	dim as Decimal accum = DecimalZero( )
	dim as Decimal lastBv = t.Cost_
	dim as long n = 0

	dim as DepreciationScheduleIterator it = s.Value( ).GetIterator( )
	while( it.IsValid( ) )
		dim as DepreciationRow r = it.Value( )
		n += 1

		CU_ASSERT( r.Period_ = n )
		CU_ASSERT( r.OpeningBookValue_ = lastBv )

		'' NEVER a negative expense.
		CU_ASSERT( r.Expense_ >= DecimalZero( ) )

		'' NEVER a book value below salvage -- the floor is absolute.
		CU_ASSERT( r.ClosingBookValue_ >= t.Salvage_ )

		'' The row adds up.
		CU_ASSERT( r.ClosingBookValue_ = ( r.OpeningBookValue_ - r.Expense_ ) )

		accum = accum + r.Expense_
		CU_ASSERT( r.AccumulatedDepreciation_ = accum )

		lastBv = r.ClosingBookValue_
		it.MoveNext( )
	wend

	CU_ASSERT( n > 0 )
	'' THE FINAL BOOK VALUE IS EXACTLY SALVAGE, with '=' and not a tolerance.
	CU_ASSERT( lastBv = t.Salvage_ )
	CU_ASSERT( accum = ( t.Cost_ - t.Salvage_ ) )

	function = n
end function

SUITE( fbc_tests.finance.deprec )

	'' RFC-0007 section 3.  Straight line.
	TEST( straight_line_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )

		CU_ASSERT( DepreciationStraightLine( t, 1 ).Value( ) = D( "6428.57" ) )
		CU_ASSERT( DepreciationStraightLine( t, 4 ).Value( ) = D( "6428.57" ) )

		'' The base is cost MINUS salvage, and the total is exactly that.
		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_STRAIGHT_LINE ) = 7 )

		'' A clean division is exact everywhere.
		dim as DepreciationTerms clean = DepreciationTermsMake( D( "10000" ), DecimalZero( ), 4 )
		for k as long = 1 to 4
			CU_ASSERT( DepreciationStraightLine( clean, k ).Value( ) = D( "2500" ) )
		next

		'' Zero salvage and zero cost are both legitimate.
		dim as DepreciationTerms free_ = DepreciationTermsMake( DecimalZero( ), DecimalZero( ), 3 )
		CU_ASSERT( DepreciationStraightLine( free_, 1 ).Value( ).IsZero( ) )

		'' Out of range.
		CU_ASSERT( DepreciationStraightLine( t, 0 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
		CU_ASSERT( DepreciationStraightLine( t, 8 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

	'' RFC-0007 section 3.  Declining balance and double declining.
	TEST( declining_balance_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )

		CU_ASSERT( DepreciationDoubleDeclining( t, 1 ).Value( ) = D( "14285.71" ) )
		CU_ASSERT( DepreciationDoubleDeclining( t, 2 ).Value( ) = D( "10204.08" ) )
		CU_ASSERT( DepreciationDoubleDeclining( t, 3 ).Value( ) = D( "7288.63" ) )
		CU_ASSERT( DepreciationDoubleDeclining( t, 7 ).Value( ) = D( "1640.51" ) )
		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_DOUBLE_DECLINING ) = 7 )

		'' 150% declining balance is the SAME method with a different factor --
		'' which is why RateFactor_ is a field rather than three functions.
		dim as DepreciationTerms t150 = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )
		t150.RateFactor_ = D( "1.5" )
		CU_ASSERT( DepreciationDecliningBalance( t150, 1 ).Value( ) = D( "10714.29" ) )
		CU_ASSERT( DepreciationDecliningBalance( t150, 2 ).Value( ) = D( "8418.37" ) )
		CU_ASSERT( assertDepInvariants( t150, DEPRECIATION_DECLINING_BALANCE ) = 7 )

		'' A slower factor writes off less early, always.
		for k as long = 1 to 3
			CU_ASSERT( DepreciationDecliningBalance( t150, k ).Value( ) < _
			           DepreciationDoubleDeclining( t, k ).Value( ) )
		next

		'' DEPRECIATION_DOUBLE_DECLINING ignores RateFactor_ and forces 2 --
		'' otherwise "double" would be a lie whenever the field was set.
		CU_ASSERT( DepreciationDoubleDeclining( t150, 1 ).Value( ) = D( "14285.71" ) )
	END_TEST

	'' RFC-0007 section 4.1.  THE SALVAGE FLOOR IS ABSOLUTE.
	TEST( salvage_floor_ )
		'' Declining balance would run past salvage here in period 4.
		dim as DepreciationTerms t = DepreciationTermsMake( D( "10000" ), D( "2000" ), 5 )

		CU_ASSERT( DepreciationDoubleDeclining( t, 1 ).Value( ) = D( "4000" ) )
		CU_ASSERT( DepreciationDoubleDeclining( t, 2 ).Value( ) = D( "2400" ) )
		CU_ASSERT( DepreciationDoubleDeclining( t, 3 ).Value( ) = D( "1440" ) )

		'' THE FLOOR BITES: the unconstrained expense would be 864, and only
		'' 160 is left above salvage.
		CU_ASSERT( DepreciationDoubleDeclining( t, 4 ).Value( ) = D( "160" ) )

		'' AND EVERY LATER PERIOD IS EXACTLY ZERO -- not a small number.
		CU_ASSERT( DepreciationDoubleDeclining( t, 5 ).Value( ).IsZero( ) )

		dim as FinResultDepSchedule s = DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING )
		dim as DepreciationScheduleIterator it = s.Value( ).GetIterator( )
		while( it.IsValid( ) )
			'' Never below salvage, on any row.
			CU_ASSERT( it.Value( ).ClosingBookValue_ >= D( "2000" ) )
			CU_ASSERT( it.Value( ).Expense_ >= DecimalZero( ) )
			it.MoveNext( )
		wend

		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_DOUBLE_DECLINING ) = 5 )

		'' A salvage equal to cost depreciates nothing at all.
		dim as DepreciationTerms none_ = DepreciationTermsMake( D( "5000" ), D( "5000" ), 4 )
		CU_ASSERT( DepreciationDoubleDeclining( none_, 1 ).Value( ).IsZero( ) )
		CU_ASSERT( assertDepInvariants( none_, DEPRECIATION_STRAIGHT_LINE ) = 4 )
	END_TEST

	'' RFC-0007 section 3.  Sum of years' digits.
	TEST( sum_of_years_digits_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )

		'' 7+6+5+4+3+2+1 = 28, so period 1 takes 7/28 of 45000.
		CU_ASSERT( DepreciationSumOfYearsDigits( t, 1 ).Value( ) = D( "11250.00" ) )
		CU_ASSERT( DepreciationSumOfYearsDigits( t, 2 ).Value( ) = D( "9642.86" ) )
		CU_ASSERT( DepreciationSumOfYearsDigits( t, 4 ).Value( ) = D( "6428.57" ) )
		CU_ASSERT( DepreciationSumOfYearsDigits( t, 7 ).Value( ) = D( "1607.14" ) )

		'' STRICTLY DECREASING, which is the whole character of the method.
		for k as long = 1 to 6
			CU_ASSERT( DepreciationSumOfYearsDigits( t, k ).Value( ) > _
			           DepreciationSumOfYearsDigits( t, k + 1 ).Value( ) )
		next

		'' The middle period equals the straight-line amount, which is a
		'' property of SYD over an odd life rather than a coincidence.
		CU_ASSERT( DepreciationSumOfYearsDigits( t, 4 ).Value( ) = _
		           DepreciationStraightLine( t, 4 ).Value( ) )

		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_SUM_OF_YEARS_DIGITS ) = 7 )
	END_TEST

	'' RFC-0007 section 4.2.  THE SWITCH RULE, and its ANTI-CASE.
	TEST( switch_rule_and_anti_case_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "100" ), DecimalZero( ), 5 )

		dim as FinResultDepSchedule s = DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH )
		CU_ASSERT( s.IsOk( ) )

		'' THE CORRECT RULE: straight line on the REMAINING base over the
		'' REMAINING life, recomputed each period.
		dim as Decimal got( 0 to 4 )
		dim as long switchAt = 0
		dim as long k = 0
		dim as DepreciationScheduleIterator it = s.Value( ).GetIterator( )
		while( it.IsValid( ) )
			got( k ) = it.Value( ).Expense_
			if( it.Value( ).SwitchedToStraightLine_ andalso ( switchAt = 0 ) ) then
				switchAt = it.Value( ).Period_
			end if
			k += 1
			it.MoveNext( )
		wend

		CU_ASSERT( got( 0 ) = D( "40.00" ) )
		CU_ASSERT( got( 1 ) = D( "24.00" ) )
		CU_ASSERT( got( 2 ) = D( "14.40" ) )
		CU_ASSERT( got( 3 ) = D( "10.80" ) )
		CU_ASSERT( got( 4 ) = D( "10.80" ) )
		CU_ASSERT( switchAt = 4 )

		'' THE ANTI-CASE, computed here rather than merely described: straight
		'' line on the ORIGINAL base over the ORIGINAL life, held constant.
		'' It switches at period 3 and produces 40, 24, 20, 16, 0 -- visibly
		'' different, and wrong.
		dim as Decimal naive( 0 to 4 )
		dim as Decimal bv = D( "100" )
		dim as Decimal slFixed = ( ( D( "100" ) - DecimalZero( ) ) / DecimalFromInt( 5 ) )
		dim as boolean latched = false
		dim as long naiveSwitchAt = 0
		for j as long = 1 to 5
			dim as Decimal db = ( ( bv * DecimalFromInt( 2 ) ) / DecimalFromInt( 5 ) )
			if( slFixed >= db ) then
				latched = true
				if( naiveSwitchAt = 0 ) then naiveSwitchAt = j
			end if
			dim as Decimal amt = db
			if( latched ) then amt = slFixed
			if( amt > bv ) then amt = bv
			naive( j - 1 ) = amt
			bv = bv - amt
		next

		CU_ASSERT( naiveSwitchAt = 3 )

		'' THE TWO DIFFER.  This is the assertion that stops a regression to
		'' the naive rule -- which produces plausible numbers and the wrong
		'' schedule.
		dim as boolean identical = true
		for j as long = 0 to 4
			if( got( j ) <> naive( j ) ) then identical = false
		next
		CU_ASSERT( identical = false )
		CU_ASSERT( switchAt <> naiveSwitchAt )
		CU_ASSERT( got( 2 ) <> naive( 2 ) )

		'' The naive rule also fails to write the asset down: its last period
		'' is zero because it has already over-depreciated.
		CU_ASSERT( naive( 4 ).IsZero( ) )
		CU_ASSERT( got( 4 ) > DecimalZero( ) )

		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH ) = 5 )
	END_TEST

	'' RFC-0007 section 4.3.  A PARTIAL FIRST PERIOD, and the MACRS schedule
	'' that follows from it.
	TEST( partial_period_and_macrs_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "100" ), DecimalZero( ), 5 )
		t.PlacedInService_ = D( "0.5" )
		t.Rounding_ = MoneyRoundingExact( )

		'' THE SCHEDULE RUNS ONE PERIOD LONGER -- the remainder does not vanish.
		dim as FinResultDepSchedule s = DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH )
		CU_ASSERT( s.IsOk( ) )
		CU_ASSERT( s.Value( ).Count( ) = 6 )

		'' IRS PUBLICATION 946, MACRS 200% declining balance, five-year class,
		'' half-year convention: 20.00, 32.00, 19.20, 11.52, 11.52, 5.76.
		'' REPRODUCED EXACTLY -- this column needs no display adjustment, which
		'' is why it is the one asserted with '='.
		dim as Decimal want( 0 to 5 ) = { D( "20" ), D( "32" ), D( "19.2" ), _
		                                  D( "11.52" ), D( "11.52" ), D( "5.76" ) }
		dim as long k = 0
		dim as DepreciationScheduleIterator it = s.Value( ).GetIterator( )
		while( it.IsValid( ) )
			CU_ASSERT( it.Value( ).Expense_ = want( k ) )
			k += 1
			it.MoveNext( )
		wend
		CU_ASSERT( k = 6 )

		'' The switch happens where MACRS switches -- period 4, where declining
		'' balance and straight line are EXACTLY equal at 11.52.  A strict '>'
		'' comparison gets the same numbers and the wrong period.
		CU_ASSERT( DepreciationScheduleOf( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH ) _
		           .Value( ).GetIterator( ).IsValid( ) )

		dim as Array( of DepreciationRow ) rows = DepreciationScheduleToArray( s.Value( ) )
		CU_ASSERT( rows.Count( ) = 6 )
		CU_ASSERT( rows.At( 3 ).SwitchedToStraightLine_ )
		CU_ASSERT( rows.At( 2 ).SwitchedToStraightLine_ = false )

		'' The total is still exactly the depreciable base.
		CU_ASSERT( assertDepInvariants( t, DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH ) = 6 )

		'' A PARTIAL PERIOD ON STRAIGHT LINE splits the first and last periods.
		dim as DepreciationTerms sl = DepreciationTermsMake( D( "100" ), DecimalZero( ), 5 )
		sl.PlacedInService_ = D( "0.5" )
		CU_ASSERT( DepreciationStraightLine( sl, 1 ).Value( ) = D( "10" ) )
		CU_ASSERT( DepreciationStraightLine( sl, 2 ).Value( ) = D( "20" ) )
		CU_ASSERT( DepreciationStraightLine( sl, 6 ).Value( ) = D( "10" ) )
		CU_ASSERT( assertDepInvariants( sl, DEPRECIATION_STRAIGHT_LINE ) = 6 )

		'' A WHOLE first period leaves the schedule at its nominal length.
		dim as DepreciationTerms whole = DepreciationTermsMake( D( "100" ), DecimalZero( ), 5 )
		CU_ASSERT( DepreciationScheduleOf( whole, DEPRECIATION_STRAIGHT_LINE ).Value( ).Count( ) = 5 )
	END_TEST

	'' RFC-0007 section 3.  Units of production -- the one method with no
	'' schedule form.
	TEST( units_of_production_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )

		'' A tenth of the total units is a tenth of the depreciable base.
		CU_ASSERT( DepreciationUnitsOfProduction( t, D( "1000" ), D( "10000" ) ).Value( ) = D( "4500" ) )
		CU_ASSERT( DepreciationUnitsOfProduction( t, DecimalZero( ), D( "10000" ) ).Value( ).IsZero( ) )
		CU_ASSERT( DepreciationUnitsOfProduction( t, D( "10000" ), D( "10000" ) ).Value( ) = D( "45000" ) )

		'' The periods sum to the base when the units do.
		dim as Decimal total = DecimalZero( )
		dim as Decimal units( 0 to 4 ) = { D( "2000" ), D( "3000" ), D( "1500" ), D( "2500" ), D( "1000" ) }
		for k as long = 0 to 4
			total = total + DepreciationUnitsOfProduction( t, units( k ), D( "10000" ) ).Value( )
		next
		CU_ASSERT( total = D( "45000" ) )

		'' Zero total units is FIN_DOMAIN, not an infinity.
		CU_ASSERT( DepreciationUnitsOfProduction( t, D( "100" ), DecimalZero( ) ).Failure( ).Code( ) = FIN_DOMAIN )
		CU_ASSERT( DepreciationUnitsOfProduction( t, D( "-1" ), D( "100" ) ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' IT HAS NO SCHEDULE FORM, and asking for one is refused by name
		'' rather than silently producing a units-free schedule.
		CU_ASSERT( DepreciationScheduleOf( t, DEPRECIATION_UNITS_OF_PRODUCTION ).IsOk( ) = false )
		CU_ASSERT( DepreciationScheduleOf( t, DEPRECIATION_UNITS_OF_PRODUCTION ).Failure( ).Code( ) _
		           = FIN_INVALID_BASIS )
	END_TEST

	'' RFC-0007 section 3.  The single-period accessors AGREE WITH THE SCHEDULE,
	'' on every period of every method -- they read the same series.
	TEST( accessors_agree_with_schedule_ )
		dim as DepreciationTerms t = DepreciationTermsMake( D( "50000" ), D( "5000" ), 7 )

		dim as DepreciationMethod methods( 0 to 3 ) = { DEPRECIATION_STRAIGHT_LINE, _
		                                                DEPRECIATION_DECLINING_BALANCE, _
		                                                DEPRECIATION_DOUBLE_DECLINING, _
		                                                DEPRECIATION_SUM_OF_YEARS_DIGITS }

		for mi as long = 0 to 3
			dim as FinResultDepSchedule s = DepreciationScheduleOf( t, methods( mi ) )
			CU_ASSERT( s.IsOk( ) )

			dim as DepreciationScheduleIterator it = s.Value( ).GetIterator( )
			while( it.IsValid( ) )
				dim as long p = it.Value( ).Period_
				dim as Decimal fromSchedule = it.Value( ).Expense_
				dim as Decimal fromAccessor = DecimalZero( )

				select case as const methods( mi )
				case DEPRECIATION_STRAIGHT_LINE
					fromAccessor = DepreciationStraightLine( t, p ).Value( )
				case DEPRECIATION_DECLINING_BALANCE
					fromAccessor = DepreciationDecliningBalance( t, p ).Value( )
				case DEPRECIATION_DOUBLE_DECLINING
					fromAccessor = DepreciationDoubleDeclining( t, p ).Value( )
				case DEPRECIATION_SUM_OF_YEARS_DIGITS
					fromAccessor = DepreciationSumOfYearsDigits( t, p ).Value( )
				end select

				CU_ASSERT( fromAccessor = fromSchedule )
				it.MoveNext( )
			wend
		next
	END_TEST

	'' Every method, over a spread of shapes, holds the invariants.
	TEST( invariants_across_shapes_ )
		dim as string costs( 0 to 3 ) = { "100", "50000", "1234.56", "999999" }
		dim as string salvs( 0 to 3 ) = { "0", "5000", "234.56", "1" }
		dim as long lives( 0 to 3 ) = { 3, 7, 5, 12 }

		dim as DepreciationMethod methods( 0 to 4 ) = { DEPRECIATION_STRAIGHT_LINE, _
		                                                DEPRECIATION_DECLINING_BALANCE, _
		                                                DEPRECIATION_DOUBLE_DECLINING, _
		                                                DEPRECIATION_DOUBLE_DECLINING_WITH_SWITCH, _
		                                                DEPRECIATION_SUM_OF_YEARS_DIGITS }

		for ci as long = 0 to 3
			for mi as long = 0 to 4
				dim as DepreciationTerms t = DepreciationTermsMake( D( costs( ci ) ), D( salvs( ci ) ), lives( ci ) )
				CU_ASSERT( assertDepInvariants( t, methods( mi ) ) = lives( ci ) )

				'' And again with a partial first period, which adds a row.
				dim as DepreciationTerms p = DepreciationTermsMake( D( costs( ci ) ), D( salvs( ci ) ), lives( ci ) )
				p.PlacedInService_ = D( "0.25" )
				CU_ASSERT( assertDepInvariants( p, methods( mi ) ) = lives( ci ) + 1 )
			next
		next
	END_TEST

	'' RFC-0001 section 6.  Errors, by code.
	TEST( deprec_errors_ )
		dim as DepreciationTerms ok_ = DepreciationTermsMake( D( "1000" ), D( "100" ), 5 )

		'' Salvage above cost is a mistake, not a write-down.
		dim as DepreciationTerms bad = DepreciationTermsMake( D( "1000" ), D( "2000" ), 5 )
		CU_ASSERT( DepreciationStraightLine( bad, 1 ).Failure( ).Code( ) = FIN_INVALID_TERM )
		CU_ASSERT( DepreciationScheduleOf( bad, DEPRECIATION_STRAIGHT_LINE ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' A life of no periods.
		dim as DepreciationTerms noLife = DepreciationTermsMake( D( "1000" ), DecimalZero( ), 0 )
		CU_ASSERT( DepreciationStraightLine( noLife, 1 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )

		'' Negative cost or salvage.
		dim as DepreciationTerms negC = DepreciationTermsMake( D( "-1000" ), DecimalZero( ), 5 )
		CU_ASSERT( DepreciationStraightLine( negC, 1 ).Failure( ).Code( ) = FIN_INVALID_TERM )

		'' An out-of-range PlacedInService_.
		dim as DepreciationTerms hi = DepreciationTermsMake( D( "1000" ), DecimalZero( ), 5 )
		hi.PlacedInService_ = D( "1.5" )
		CU_ASSERT( DepreciationStraightLine( hi, 1 ).Failure( ).Code( ) = FIN_INVALID_BASIS )

		dim as DepreciationTerms zeroF = DepreciationTermsMake( D( "1000" ), DecimalZero( ), 5 )
		zeroF.PlacedInService_ = DecimalZero( )
		CU_ASSERT( DepreciationStraightLine( zeroF, 1 ).Failure( ).Code( ) = FIN_INVALID_BASIS )

		'' A non-positive rate factor.
		dim as DepreciationTerms zeroR = DepreciationTermsMake( D( "1000" ), DecimalZero( ), 5 )
		zeroR.RateFactor_ = DecimalZero( )
		CU_ASSERT( DepreciationDecliningBalance( zeroR, 1 ).Failure( ).Code( ) = FIN_INVALID_BASIS )

		'' An Invalid Decimal anywhere.
		dim as DepreciationTerms inv = DepreciationTermsMake( DecimalInvalid( ), DecimalZero( ), 5 )
		CU_ASSERT( DepreciationStraightLine( inv, 1 ).IsOk( ) = false )

		'' A period past the end.
		CU_ASSERT( DepreciationStraightLine( ok_, 6 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

END_SUITE
