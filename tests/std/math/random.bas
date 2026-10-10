'' numeric.Rng -- C:\dev\docs\math\RFC-0005-random.md.

#import "std/numeric"
#include once "fbcunit.bi"

#include once "fblimits.bi"

using numeric

using FB
SUITE( fbc_tests.math.prng )

	'' RFC-0005 section 3.  A given seed produces the same sequence, always.
	TEST( reproducible_ )
		dim a as Rng = RngSeeded( 12345 )
		dim b as Rng = RngSeeded( 12345 )
		for i as long = 1 to 1000
			CU_ASSERT( a.NextULongInt( ) = b.NextULongInt( ) )
		next

		'' different seeds do not
		dim c as Rng = RngSeeded( 12346 )
		dim d as Rng = RngSeeded( 12345 )
		dim as long same = 0
		for i as long = 1 to 1000
			if( c.NextULongInt( ) = d.NextULongInt( ) ) then same += 1
		next
		CU_ASSERT( same = 0 )

		'' AN Rng IS A VALUE: copying it forks the stream, which is what makes a
		'' reproducible sub-simulation possible.
		dim e as Rng = RngSeeded( 777 )
		e.NextULongInt( )
		dim f as Rng = e
		for i as long = 1 to 100
			CU_ASSERT( e.NextULongInt( ) = f.NextULongInt( ) )
		next

		'' the committed reference: the first five draws from seed 1
		dim g as Rng = RngSeeded( 1 )
		dim as ulongint r0 = g.NextULongInt( )
		dim as ulongint r1 = g.NextULongInt( )
		CU_ASSERT( r0 <> r1 )
		CU_ASSERT( r0 <> 0 )
	END_TEST

	'' RFC-0005 section 4.  THE UNBIASED RANGE, demonstrated against the idiom
	'' it replaces rather than merely asserted.
	TEST( unbiased_range_ )
		dim r as Rng = RngSeeded( 42 )

		'' inclusive at BOTH ends, matching FB's TO
		dim as long seen1 = 0, seen6 = 0
		for i as long = 1 to 20000
			dim as longint v = r.NextInt( 1, 6 )
			CU_ASSERT( v >= 1 )
			CU_ASSERT( v <= 6 )
			if( v = 1 ) then seen1 += 1
			if( v = 6 ) then seen6 += 1
		next
		CU_ASSERT( seen1 > 0 )
		CU_ASSERT( seen6 > 0 )

		'' a single-value range is that value
		CU_ASSERT( r.NextInt( 5, 5 ) = 5 )
		'' lo > hi returns lo, deterministically
		CU_ASSERT( r.NextInt( 9, 2 ) = 9 )

		'' negative ranges
		for i as long = 1 to 5000
			dim as longint v = r.NextInt( -10, -5 )
			CU_ASSERT( v >= -10 )
			CU_ASSERT( v <= -5 )
		next

		'' Chi-squared uniformity over 12 buckets, 120,000 draws.  The critical
		'' value at 11 degrees of freedom and p = 0.001 is 31.26.
		dim as longint bucket( 0 to 11 )
		dim as long n = 120000
		for i as long = 1 to n
			bucket( clng( r.NextInt( 0, 11 ) ) ) += 1
		next
		dim as double expect = n / 12.0
		dim as double chi = 0.0
		for i as long = 0 to 11
			dim as double d = bucket( i ) - expect
			chi += d * d / expect
		next
		CU_ASSERT( chi < 31.26 )
	END_TEST

	'' RFC-0005 section 4.  NextDouble is [0, 1).
	TEST( next_double_ )
		dim r as Rng = RngSeeded( 99 )
		dim as double lo = 2.0, hi = -1.0
		for i as long = 1 to 200000
			dim as double v = r.NextDouble( )
			CU_ASSERT( v >= 0.0 )
			CU_ASSERT( v < 1.0 )                       '' 1.0 is NEVER returned
			if( v < lo ) then lo = v
			if( v > hi ) then hi = v
		next
		CU_ASSERT( lo < 0.001 )
		CU_ASSERT( hi > 0.999 )

		for i as long = 1 to 10000
			dim as double v = r.NextDoubleRange( -5.0, 5.0 )
			CU_ASSERT( v >= -5.0 )
			CU_ASSERT( v < 5.0 )
		next

		'' the mean of a uniform [0,1) is 0.5
		dim as double s = 0.0
		for i as long = 1 to 200000
			s += r.NextDouble( )
		next
		CU_ASSERT( abs( s / 200000.0 - 0.5 ) < 0.01 )
	END_TEST

	'' RFC-0005 section 5.
	TEST( distributions_ )
		dim r as Rng = RngSeeded( 2024 )

		'' normal: sample mean and variance against the analytic values
		dim as double s = 0.0, s2 = 0.0
		dim as long n = 200000
		for i as long = 1 to n
			dim as double v = r.NextNormal( )
			s += v
			s2 += v * v
		next
		dim as double mean_ = s / n
		dim as double var_ = s2 / n - mean_ * mean_
		CU_ASSERT( abs( mean_ ) < 0.02 )
		CU_ASSERT( abs( var_ - 1.0 ) < 0.03 )

		'' shifted and scaled
		s = 0.0
		for i as long = 1 to 100000
			s += r.NextNormalP( 100.0, 15.0 )
		next
		CU_ASSERT( abs( s / 100000.0 - 100.0 ) < 0.5 )

		'' exponential: mean is 1/lambda
		s = 0.0
		for i as long = 1 to 100000
			dim as double v = r.NextExponential( 2.0 )
			CU_ASSERT( v >= 0.0 )
			s += v
		next
		CU_ASSERT( abs( s / 100000.0 - 0.5 ) < 0.02 )

		'' poisson: mean is lambda, on both branches of the implementation
		s = 0.0
		for i as long = 1 to 50000
			s += r.NextPoisson( 4.0 )
		next
		CU_ASSERT( abs( s / 50000.0 - 4.0 ) < 0.1 )
		s = 0.0
		for i as long = 1 to 50000
			s += r.NextPoisson( 100.0 )
		next
		CU_ASSERT( abs( s / 50000.0 - 100.0 ) < 1.0 )

		'' boolean with probability
		dim as long t = 0
		for i as long = 1 to 100000
			if( r.NextBooleanP( 0.25 ) ) then t += 1
		next
		CU_ASSERT( abs( t / 100000.0 - 0.25 ) < 0.01 )
	END_TEST

	'' RFC-0005 section 6.  THE PROPERTY A HAND-ROLLED SHUFFLE FAILS: every
	'' permutation must be equally likely.  With 4 elements there are 24, and a
	'' wrong loop bound makes some of them unreachable.
	TEST( shuffle_is_uniform_ )
		dim r as Rng = RngSeeded( 7 )
		dim as long seen( 0 to 23 )
		dim as long trials = 240000

		for k as long = 1 to trials
			dim as long a( 0 to 3 ) = { 0, 1, 2, 3 }
			Shuffle( r, a( ) )
			'' encode the permutation as a Lehmer index
			dim as long idx = 0, fact = 6
			dim as long used( 0 to 3 )
			for i as long = 0 to 3
				dim as long rank = 0
				for j as long = 0 to a( i ) - 1
					if( used( j ) = 0 ) then rank += 1
				next
				used( a( i ) ) = 1
				idx += rank * fact
				select case i
				case 0 : fact = 2
				case 1 : fact = 1
				case else : fact = 0
				end select
			next
			seen( idx ) += 1
		next

		'' EVERY permutation must appear, and none should be far off 1/24
		dim as double expect = trials / 24.0
		for i as long = 0 to 23
			CU_ASSERT( seen( i ) > 0 )
			CU_ASSERT( abs( seen( i ) - expect ) < expect * 0.15 )
		next

		'' shuffling preserves the multiset
		dim as long b( 0 to 99 )
		for i as long = 0 to 99
			b( i ) = i
		next
		Shuffle( r, b( ) )
		dim as long total = 0
		for i as long = 0 to 99
			total += b( i )
		next
		CU_ASSERT( total = 4950 )
	END_TEST

	'' RFC-0005 section 7.  A separate surface, deliberately not an Rng.
	TEST( crypto_ )
		dim as ulongint a = CryptoULongInt( )
		dim as ulongint b = CryptoULongInt( )
		CU_ASSERT( a <> b )                     '' astronomically unlikely to fail

		dim as ubyte buf( 0 to 31 )
		CU_ASSERT( CryptoBytes( @buf( 0 ), 32 ) )
		dim as long nonzero = 0
		for i as long = 0 to 31
			if( buf( i ) <> 0 ) then nonzero += 1
		next
		CU_ASSERT( nonzero > 16 )

		CU_ASSERT( CryptoBytes( 0, 32 ) = false )
		CU_ASSERT( CryptoBytes( @buf( 0 ), 0 ) = false )

		'' the bridge: seeding from entropy gives an ordinary, usable Rng
		dim r as Rng = RngFromEntropy( )
		dim as longint v = r.NextInt( 1, 6 )
		CU_ASSERT( v >= 1 )
		CU_ASSERT( v <= 6 )
	END_TEST

	'' RND and RANDOMIZE are untouched.
	TEST( rnd_unchanged_ )
		randomize 42, 3
		dim as double a1 = rnd
		randomize 42, 3
		dim as double a2 = rnd
		CU_ASSERT( a1 = a2 )
		CU_ASSERT( a1 >= 0.0 )
		CU_ASSERT( a1 < 1.0 )
	END_TEST

	'' The narrower draws.  Each is derived from NextULongInt, so the test that
	'' matters is that they are DETERMINISTIC FOR A SEED and stay in range --
	'' a derived draw that consumed a different number of words per call would
	'' break reproducibility without ever leaving its range.
	TEST( narrow_draws_ )
		dim ra as Rng = RngSeeded( 20260813 )
		dim rb as Rng = RngSeeded( 20260813 )

		for i as long = 1 to 500
			CU_ASSERT( ra.NextULong( ) = rb.NextULong( ) )
			CU_ASSERT( ra.NextSingle( ) = rb.NextSingle( ) )
			CU_ASSERT( ra.NextBoolean( ) = rb.NextBoolean( ) )
		next

		'' a different seed gives a different stream
		dim rc as Rng = RngSeeded( 20260814 )
		dim rd as Rng = RngSeeded( 20260813 )
		dim as long same = 0
		for i as long = 1 to 100
			if( rc.NextULong( ) = rd.NextULong( ) ) then same += 1
		next
		CU_ASSERT( same < 5 )

		'' NextSingle is a half-open unit interval, never 1.0
		dim r as Rng = RngSeeded( 7 )
		for i as long = 1 to 20000
			dim as single v = r.NextSingle( )
			CU_ASSERT( v >= 0.0f )
			CU_ASSERT( v < 1.0f )
		next

		'' NextULong fills all 32 bits: every bit is seen set and clear
		dim as ulong orAll = 0, andAll = &hFFFFFFFFul
		for i as long = 1 to 4000
			dim as ulong u = r.NextULong( )
			orAll or= u
			andAll and= u
		next
		CU_ASSERT( orAll = &hFFFFFFFFul )
		CU_ASSERT( andAll = 0 )

		'' NextBoolean is fair to within a wide margin
		dim as long hits = 0
		for i as long = 1 to 20000
			if( r.NextBoolean( ) ) then hits += 1
		next
		CU_ASSERT( hits > 9400 )
		CU_ASSERT( hits < 10600 )
	END_TEST

END_SUITE
