'' fb/finsolve.bi -- C:\dev\docs\finance\RFC-0003-solvers.md.
''
'' THE ORACLE HERE IS BETTER THAN AN EXTERNAL TOOL, and that is unusual enough
'' to say up front: the objectives below are POLYNOMIALS AND FUNCTIONS WHOSE
'' ROOTS ARE KNOWN IN CLOSED FORM.  There is nothing to pin against a
'' spreadsheet -- ( x - 3 )( x + 1 )( x - 7 ) has roots at 3, -1 and 7 by
'' construction, and an assertion that the solver finds one of them is exact
'' rather than approximate.
''
'' THE DEFAULT BOUNDS ARE RATE BOUNDS.  FinSolverOptionsDefault sets
'' LowerBound_ = -0.9999999, because a periodic rate at or below -100% is
'' meaningless.  A general-purpose objective needs them widened, and every test
'' below that uses one does so explicitly -- a root outside the bounds is
'' excluded by construction, not merely hard to find.

#import "std/money"
#import "std/outcome"
#import "std/numeric"
#import "std/chrono"
#import "std/containers"
#include once "fbcunit.bi"

#include once "fberror.bi"

#include once "fblimits.bi"

using money, outcome, numeric, chrono, containers

using FB
private function D( byref s as string ) as Decimal
	function = DecimalParse( s ).Value( )
end function

'' Bounds wide enough for a general polynomial.
private function wideOptions( byval guess as double ) as FinSolverOptions
	dim as FinSolverOptions o = FinSolverOptionsWithGuess( guess )
	o.LowerBound_ = -1.0e6
	o.UpperBound_ =  1.0e6
	function = o
end function

'' ---------------------------------------------------------------- objectives

'' root sqrt( 2 ) = 1.4142135623730951
private function fSqrt2( byval x as double, byval ctx as any ptr ) as double
	function = x * x - 2.0
end function

'' roots -1, 3, 7
private function fCubic( byval x as double, byval ctx as any ptr ) as double
	function = ( x - 3.0 ) * ( x + 1.0 ) * ( x - 7.0 )
end function

'' no real root at all -- the minimum is 1
private function fNoRoot( byval x as double, byval ctx as any ptr ) as double
	function = x * x + 1.0
end function

'' NEWTON-HOSTILE.  atan( x - 2 ) has root 2, but its derivative falls away as
'' 1/(1+u^2), so a Newton step from a distant seed overshoots by thousands and
'' leaves the bounds -- which is exactly the condition RFC-0003 section 4.2
'' says must abandon the fast path rather than fail.
private function fAtan( byval x as double, byval ctx as any ptr ) as double
	function = atn( x - 2.0 )
end function

'' NON-FINITE BELOW -0.5, finite above, root at 2.  Models an objective whose
'' discount factor overflows at absurd trial values: RFC-0003 section 4.3 says
'' such a probe is SKIPPED, not fatal.
private function fBanded( byval x as double, byval ctx as any ptr ) as double
	if( x < -0.5 ) then return NaN( )
	function = x - 2.0
end function

'' Counts its own evaluations, through the context pointer.
type CallCount
	as long n
end type

private function fCounted( byval x as double, byval ctx as any ptr ) as double
	dim as CallCount ptr c = cptr( CallCount ptr, ctx )
	c->n += 1
	function = x * x - 2.0
end function

SUITE( fbc_tests.finance.solve )

	'' RFC-0003 section 4.4.  Known roots, found.
	TEST( known_roots_ )
		dim as FinResultSolve r = FinSolveRoot( @fSqrt2, 0, wideOptions( 1.0 ) )
		CU_ASSERT( r.IsOk( ) )
		CU_ASSERT( r.Value( ).Converged_ )
		CU_ASSERT_DOUBLE_EQUAL( r.Value( ).Root_, 1.4142135623730951, 1.0e-12 )
		CU_ASSERT( abs( r.Value( ).Residual_ ) <= 1.0e-12 )

		'' Every root of the cubic is reachable from a seed beside it.
		dim as FinResultSolve r1 = FinSolveRoot( @fCubic, 0, wideOptions( -1.4 ) )
		CU_ASSERT( r1.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( r1.Value( ).Root_, -1.0, 1.0e-9 )

		dim as FinResultSolve r3 = FinSolveRoot( @fCubic, 0, wideOptions( 3.2 ) )
		CU_ASSERT( r3.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( r3.Value( ).Root_, 3.0, 1.0e-9 )

		dim as FinResultSolve r7 = FinSolveRoot( @fCubic, 0, wideOptions( 6.8 ) )
		CU_ASSERT( r7.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( r7.Value( ).Root_, 7.0, 1.0e-9 )

		'' A seed that IS the root returns immediately, before any iteration.
		dim as FinResultSolve r0 = FinSolveRoot( @fCubic, 0, wideOptions( 3.0 ) )
		CU_ASSERT( r0.IsOk( ) )
		CU_ASSERT_DOUBLE_EXACT( r0.Value( ).Root_, 3.0 )
		CU_ASSERT( r0.Value( ).Bracketed_ = false )
	END_TEST

	'' RFC-0003 section 4.2.  The fast path, and that the answer does not
	'' depend on it.
	TEST( newton_fast_path_ )
		'' Well-conditioned: Newton alone finishes, so no bracket was needed.
		dim as FinResultSolve fast = FinSolveRoot( @fSqrt2, 0, wideOptions( 1.5 ) )
		CU_ASSERT( fast.IsOk( ) )
		CU_ASSERT( fast.Value( ).Bracketed_ = false )

		'' The SAME root from a seed that forces the bracket instead -- a
		'' negative seed, where the derivative points away from the positive
		'' root.  If the two disagreed, the answer would depend on the fast
		'' path, which RFC-0003 section 4.2 says it must not.
		dim as FinResultSolve slow = FinSolveRoot( @fSqrt2, 0, wideOptions( -3.0 ) )
		CU_ASSERT( slow.IsOk( ) )
		'' Both are roots of x^2 = 2; from -3 the negative root is the one
		'' beside the seed, so compare magnitudes.
		CU_ASSERT_DOUBLE_EQUAL( abs( slow.Value( ).Root_ ), 1.4142135623730951, 1.0e-9 )

		'' NEWTON-HOSTILE, and it still converges.  From a distant seed the
		'' atan derivative sends the first Newton step thousands away and out
		'' of bounds; the fast path is abandoned and the bracket finds the root.
		dim as FinSolverOptions o = wideOptions( 60.0 )
		o.LowerBound_ = -100.0
		o.UpperBound_ = 100.0
		dim as FinResultSolve hostile = FinSolveRoot( @fAtan, 0, o )
		CU_ASSERT( hostile.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( hostile.Value( ).Root_, 2.0, 1.0e-9 )
		CU_ASSERT( hostile.Value( ).Bracketed_ )
	END_TEST

	'' RFC-0003 section 4.3.  A probe the objective cannot evaluate is SKIPPED.
	TEST( nonfinite_probe_is_skipped_ )
		dim as FinSolverOptions o = wideOptions( 0.1 )
		dim as FinResultSolve r = FinSolveRoot( @fBanded, 0, o )
		CU_ASSERT( r.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( r.Value( ).Root_, 2.0, 1.0e-9 )
	END_TEST

	'' RFC-0003 section 4.0.  The one pre-check this header can make, and it
	'' happens BEFORE any evaluation -- asserted by counting calls.
	TEST( bad_bounds_ )
		dim as CallCount c
		c.n = 0

		dim as FinSolverOptions o = FinSolverOptionsWithGuess( 1.0 )
		o.LowerBound_ = 1.0
		o.UpperBound_ = 0.0                 '' inverted
		dim as FinResultSolve r = FinSolveRoot( @fCounted, @c, o )
		CU_ASSERT( r.IsOk( ) = false )
		CU_ASSERT( r.Failure( ).Code( ) = FIN_DOMAIN )
		CU_ASSERT( c.n = 0 )                '' not one evaluation

		'' Equal bounds are not a range either.
		dim as FinSolverOptions eq_ = FinSolverOptionsWithGuess( 1.0 )
		eq_.LowerBound_ = 2.0
		eq_.UpperBound_ = 2.0
		CU_ASSERT( FinSolveRoot( @fSqrt2, 0, eq_ ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A non-finite bound.
		dim as FinSolverOptions inf_ = wideOptions( 1.0 )
		inf_.UpperBound_ = Infinity( )
		CU_ASSERT( FinSolveRoot( @fSqrt2, 0, inf_ ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A null objective.
		CU_ASSERT( FinSolveRoot( 0, 0, wideOptions( 1.0 ) ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A cap below one iteration.
		dim as FinSolverOptions cap0 = wideOptions( 1.0 )
		cap0.MaxIterations_ = 0
		CU_ASSERT( FinSolveRoot( @fSqrt2, 0, cap0 ).Failure( ).Code( ) = FIN_DOMAIN )
	END_TEST

	'' RFC-0003 section 4.3.  No sign change anywhere in range -> FIN_NO_BRACKET,
	'' carrying the closest approach rather than nothing.
	TEST( no_bracket_ )
		dim as FinResultSolve r = FinSolveRoot( @fNoRoot, 0, wideOptions( 0.1 ) )
		CU_ASSERT( r.IsOk( ) = false )
		CU_ASSERT( r.Failure( ).Code( ) = FIN_NO_BRACKET )

		'' The payload is the point of returning Fail rather than a sentinel:
		'' x^2 + 1 has its minimum 1 at x = 0, so the best |f| seen is >= 1 and
		'' the best x is near zero.
		CU_ASSERT( r.Failure( ).Residual( ) >= 1.0 )
		CU_ASSERT( abs( r.Failure( ).BestGuess( ) ) < 1.0 )
		CU_ASSERT( IsNaN( r.Failure( ).BestGuess( ) ) = false )
	END_TEST

	'' RFC-0003 section 4.5.  The cap, and the payload it fills.
	TEST( no_convergence_ )
		'' A tolerance no double can reach, and a cap of three Brent steps.
		dim as FinSolverOptions o = wideOptions( -3.0 )
		o.Tolerance_     = 1.0e-300
		o.StepTolerance_ = 1.0e-300
		o.MaxIterations_ = 3

		dim as FinResultSolve r = FinSolveRoot( @fSqrt2, 0, o )
		CU_ASSERT( r.IsOk( ) = false )
		CU_ASSERT( r.Failure( ).Code( ) = FIN_NO_CONVERGENCE )

		'' Every field of RFC-0001 section 4's solver payload is filled.
		CU_ASSERT( r.Failure( ).Iterations( ) > 0 )
		CU_ASSERT( IsNaN( r.Failure( ).Residual( ) ) = false )
		CU_ASSERT( IsNaN( r.Failure( ).BestGuess( ) ) = false )

		'' And it really did get close -- "we stopped at" is worth reporting.
		CU_ASSERT( abs( abs( r.Failure( ).BestGuess( ) ) - 1.4142135623730951 ) < 0.5 )
	END_TEST

	'' RFC-0003 section 5.  Multiple roots are NOT an error, and the header
	'' does not promise which one you get.
	TEST( multiple_roots_ )
		dim as double seeds( 0 to 3 ) = { -1.4, 3.2, 6.8, 1.0 }

		for k as long = 0 to 3
			dim as FinResultSolve r = FinSolveRoot( @fCubic, 0, wideOptions( seeds( k ) ) )

			'' NEVER an error -- ill-posed is not the same as unsolvable.
			CU_ASSERT( r.IsOk( ) )

			'' Whatever came back IS a root, to tolerance.  That is the whole
			'' guarantee: not WHICH root, but that it is one.
			dim as double got = r.Value( ).Root_
			dim as double residual = ( got - 3.0 ) * ( got + 1.0 ) * ( got - 7.0 )
			CU_ASSERT( abs( residual ) < 1.0e-6 )

			dim as boolean isKnown = ( abs( got - 3.0 ) < 1.0e-6 )
			if( abs( got + 1.0 ) < 1.0e-6 ) then isKnown = true
			if( abs( got - 7.0 ) < 1.0e-6 ) then isKnown = true
			CU_ASSERT( isKnown )
		next

		'' NOT NECESSARILY THE NEAREST ROOT, and this pins it rather than
		'' leaving it as folklore: from a seed of 1.0 the nearest roots are -1
		'' and 3, both two away -- and the Newton fast path steps straight to
		'' 7 in one move, because f'(1) = -4 and f(1) = 24.  Measured.
		dim as FinResultSolve far = FinSolveRoot( @fCubic, 0, wideOptions( 1.0 ) )
		CU_ASSERT( far.IsOk( ) )
		CU_ASSERT_DOUBLE_EQUAL( far.Value( ).Root_, 7.0, 1.0e-9 )
	END_TEST

	'' RFC-0003 section 6.  The same problem twice gives the same answer.
	TEST( reproducible_ )
		for k as long = 1 to 5
			dim as FinResultSolve a = FinSolveRoot( @fSqrt2, 0, wideOptions( 1.0 ) )
			dim as FinResultSolve b = FinSolveRoot( @fSqrt2, 0, wideOptions( 1.0 ) )
			CU_ASSERT( a.IsOk( ) )
			CU_ASSERT( b.IsOk( ) )
			CU_ASSERT_DOUBLE_EXACT( a.Value( ).Root_, b.Value( ).Root_ )
			CU_ASSERT( a.Value( ).Iterations_ = b.Value( ).Iterations_ )
			CU_ASSERT( a.Value( ).Bracketed_ = b.Value( ).Bracketed_ )
		next
	END_TEST

	'' RFC-0004 section 4.  SolveRatePerPeriod -- the function phase 2
	'' deliberately did not build, now that the solver exists.
	TEST( solve_rate_per_period_ )
		dim as Decimal i = RatePerPeriod( D( "0.0595" ), COMPOUND_MONTHLY ).Value( )

		dim as AnnuityTerms t = AnnuityTermsMake( i, 360, DecimalZero( ), _
		                                          D( "400000" ), DecimalZero( ), _
		                                          PAY_END_OF_PERIOD )
		dim as Decimal pmt = PaymentAmount( t ).Value( )

		'' RECOVER THE RATE the payment was built from.  This is the round trip
		'' that matters, and it needs no oracle.
		dim as AnnuityTerms rt = AnnuityTermsMake( DecimalZero( ), 360, pmt, _
		                                           D( "400000" ), DecimalZero( ), _
		                                           PAY_END_OF_PERIOD )
		dim as FinResultDec solved = SolveRatePerPeriod( rt )
		CU_ASSERT( solved.IsOk( ) )
		CU_ASSERT( solved.Value( ).Round( 12 ) = i.Round( 12 ) )

		'' Annuity due round-trips too -- the timing reaches the objective.
		dim as AnnuityTerms td = AnnuityTermsMake( i, 360, DecimalZero( ), _
		                                           D( "400000" ), DecimalZero( ), _
		                                           PAY_BEGIN_OF_PERIOD )
		dim as Decimal pmtd = PaymentAmount( td ).Value( )
		dim as AnnuityTerms rtd = AnnuityTermsMake( DecimalZero( ), 360, pmtd, _
		                                            D( "400000" ), DecimalZero( ), _
		                                            PAY_BEGIN_OF_PERIOD )
		CU_ASSERT( SolveRatePerPeriod( rtd ).Value( ).Round( 12 ) = i.Round( 12 ) )

		'' A ZERO-RATE LOAN SOLVES TO EXACTLY ZERO -- 2400 repaid in 24
		'' payments of 100 is 0%, and the solver must say so rather than
		'' returning a tiny non-zero rate.
		dim as AnnuityTerms z = AnnuityTermsMake( DecimalZero( ), 24, D( "-100" ), _
		                                          D( "2400" ), DecimalZero( ), _
		                                          PAY_END_OF_PERIOD )
		dim as FinResultDec zr = SolveRatePerPeriod( z )
		CU_ASSERT( zr.IsOk( ) )
		CU_ASSERT( zr.Value( ).IsZero( ) )

		'' A savings goal: the rate that turns 120 deposits of 500 into 100000.
		dim as AnnuityTerms sv = AnnuityTermsMake( DecimalZero( ), 120, D( "-500" ), _
		                                           DecimalZero( ), D( "100000" ), _
		                                           PAY_END_OF_PERIOD )
		dim as FinResultDec svr = SolveRatePerPeriod( sv )
		CU_ASSERT( svr.IsOk( ) )
		'' Verify by feeding it back: 120 payments of 500 at that rate must
		'' reach 100000.
		dim as AnnuityTerms chk = AnnuityTermsMake( svr.Value( ), 120, D( "-500" ), _
		                                            DecimalZero( ), DecimalZero( ), _
		                                            PAY_END_OF_PERIOD )
		dim as Decimal reached = FutureValue( chk ).Value( )
		CU_ASSERT( reached.Round( 4 ) = D( "100000" ).Round( 4 ) )

		'' Nothing to solve for.
		dim as AnnuityTerms none = AnnuityTermsMake( DecimalZero( ), 12, DecimalZero( ), _
		                                             D( "1000" ), DecimalZero( ), _
		                                             PAY_END_OF_PERIOD )
		CU_ASSERT( SolveRatePerPeriod( none ).Failure( ).Code( ) = FIN_DOMAIN )

		'' A term of zero periods.
		dim as AnnuityTerms n0 = AnnuityTermsMake( DecimalZero( ), 0, D( "-100" ), _
		                                           D( "1000" ), DecimalZero( ), _
		                                           PAY_END_OF_PERIOD )
		CU_ASSERT( SolveRatePerPeriod( n0 ).Failure( ).Code( ) = FIN_INVALID_PERIODS )
	END_TEST

END_SUITE
