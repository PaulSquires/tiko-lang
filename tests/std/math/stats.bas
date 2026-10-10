'' Statistics -- C:\dev\docs\math\RFC-0006-statistics.md.
''
'' EVERY ARRAY PARAMETER IS containers.Array( of T ) now, not a plain 'v( ) as double'.
'' The test data is still written as a plain array literal -- that is the
'' readable way to write a data set -- and copied into the containers.Array the header
'' takes.  PushAll is that copy.

#import "std/containers"
#import "std/numeric"
#include once "fbcunit.bi"

#include once "fblimits.bi"

using containers, numeric

using FB
private sub PushAll overload ( byref d as Array( of double ), a( ) as double )
	for i as long = lbound( a ) to ubound( a )
		d.Push( a( i ) )
	next
end sub

private sub PushAll overload ( byref d as Array( of long ), a( ) as long )
	for i as long = lbound( a ) to ubound( a )
		d.Push( a( i ) )
	next
end sub

private sub PushAll overload ( byref d as Array( of single ), a( ) as single )
	for i as long = lbound( a ) to ubound( a )
		d.Push( a( i ) )
	next
end sub

SUITE( fbc_tests.math.stats )

	'' RFC-0006 section 1.  THE COMPENSATION IS DEMONSTRATED, not claimed: the
	'' naive sum is asserted to FAIL the same test.
	TEST( compensated_summation_ )
		'' the classic adversarial case: one large value and many small ones
		'' whose contribution the large value would otherwise swallow
		dim as Array( of double ) a
		a.Reserve( 100001 )
		a.Push( 1.0e16 )
		for i as long = 1 to 100000
			a.Push( 1.0 )
		next
		dim as double want = 1.0e16 + 100000.0

		CU_ASSERT( Sum( a ) = want )
		CU_ASSERT( ( NaiveSum( a ) = want ) = 0 )         '' the naive one is wrong

		'' and the error is large, not a last-bit difference
		CU_ASSERT( abs( NaiveSum( a ) - want ) > 1000.0 )

		'' Neumaier's advantage over plain Kahan: the running total smaller
		'' than the addend
		dim as double bb( 0 to 2 ) = { 1.0, 1.0e100, -1.0e100 }
		dim as Array( of double ) b
		PushAll( b, bb( ) )
		CU_ASSERT( Sum( b ) = 1.0 )
		CU_ASSERT( ( NaiveSum( b ) = 1.0 ) = 0 )

		'' exact for small integer data
		dim as Array( of double ) c
		for i as long = 0 to 9
			c.Push( cdbl( i + 1 ) )
		next
		CU_ASSERT( Sum( c ) = 55.0 )
		CU_ASSERT( Mean( c ) = 5.5 )
	END_TEST

	'' RFC-0006 section 2.  Welford, not the textbook formula.
	TEST( variance_is_stable_ )
		'' Large mean, tiny spread: the textbook 'E[x^2] - E[x]^2' form
		'' subtracts two nearly-equal huge numbers and can return a NEGATIVE
		'' variance.  This data set is chosen to provoke exactly that.
		dim as double vv( 0 to 3 ) = { 1e9 + 4.0, 1e9 + 7.0, 1e9 + 13.0, 1e9 + 16.0 }
		dim as Array( of double ) v
		PushAll( v, vv( ) )

		'' the textbook form, computed here so the comparison is visible
		dim as double s = 0.0, s2 = 0.0
		for i as long = 0 to 3
			s += v[ i ]
			s2 += v[ i ] * v[ i ]
		next
		dim as double naive = s2 / 4.0 - ( s / 4.0 ) * ( s / 4.0 )

		dim as double good = VariancePopulation( v )
		CU_ASSERT( good > 0.0 )
		CU_ASSERT( abs( good - 22.5 ) < 1e-6 )
		'' the naive form is materially wrong on this data
		CU_ASSERT( abs( naive - 22.5 ) > 1.0 )

		'' Bessel: sample and population differ by exactly n/(n-1)
		dim as double sv = Variance( v ), pv = VariancePopulation( v )
		CU_ASSERT( abs( sv * 3.0 - pv * 4.0 ) < 1e-6 )

		'' a known data set
		dim as double ww( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 5.0 }
		dim as Array( of double ) w
		PushAll( w, ww( ) )
		CU_ASSERT( abs( Mean( w ) - 3.8 ) < 1e-12 )
		CU_ASSERT( abs( VariancePopulation( w ) - 0.96 ) < 1e-12 )
		CU_ASSERT( abs( StdDevPopulation( w ) - 0.9797958971132712 ) < 1e-12 )
		CU_ASSERT( abs( Variance( w ) - 1.2 ) < 1e-12 )
	END_TEST

	'' RFC-0006 section 2.  Order statistics, and NON-MUTATION.
	TEST( median_percentile_ )
		dim as double oddSrc( 0 to 4 ) = { 5.0, 1.0, 3.0, 2.0, 4.0 }
		dim as Array( of double ) odd
		PushAll( odd, oddSrc( ) )
		CU_ASSERT( Median( odd ) = 3.0 )

		'' THE INPUT IS NOT REORDERED -- asking a question does not modify the
		'' caller's data
		CU_ASSERT( odd[ 0 ] = 5.0 )
		CU_ASSERT( odd[ 1 ] = 1.0 )
		CU_ASSERT( odd[ 4 ] = 4.0 )

		dim as double evenSrc( 0 to 3 ) = { 1.0, 2.0, 3.0, 4.0 }
		dim as Array( of double ) even_
		PushAll( even_, evenSrc( ) )
		CU_ASSERT( Median( even_ ) = 2.5 )

		dim as Array( of double ) one
		one.Push( 7.0 )
		CU_ASSERT( Median( one ) = 7.0 )

		dim as Array( of double ) same
		for i as long = 0 to 3
			same.Push( 5.0 )
		next
		CU_ASSERT( Median( same ) = 5.0 )
		CU_ASSERT( Variance( same ) = 0.0 )

		'' the R type-7 / NumPy definition, named in the reference
		dim as Array( of double ) p
		for i as long = 1 to 5
			p.Push( cdbl( i ) )
		next
		CU_ASSERT( Percentile( p, 0.0 ) = 1.0 )
		CU_ASSERT( Percentile( p, 100.0 ) = 5.0 )
		CU_ASSERT( Percentile( p, 50.0 ) = 3.0 )
		CU_ASSERT( Percentile( p, 25.0 ) = 2.0 )
		CU_ASSERT( Percentile( p, 75.0 ) = 4.0 )

		CU_ASSERT( MinOf( p ) = 1.0 )
		CU_ASSERT( MaxOf( p ) = 5.0 )
		CU_ASSERT( Range( p ) = 4.0 )
	END_TEST

	TEST( correlation_ )
		dim as Array( of double ) x, y, z
		for i as long = 1 to 5
			x.Push( cdbl( i ) )
			y.Push( cdbl( i * 2 ) )
			z.Push( cdbl( 12 - i * 2 ) )
		next
		CU_ASSERT( abs( Correlation( x, y ) - 1.0 ) < 1e-12 )

		CU_ASSERT( abs( Correlation( x, z ) + 1.0 ) < 1e-12 )

		CU_ASSERT( abs( Covariance( x, y ) - 5.0 ) < 1e-12 )
	END_TEST

	'' RFC-0006 section 3.  Streaming matches batch, and Merge is exact.
	TEST( running_stats_ )
		dim acc as RunningStats
		acc.Reset( )
		CU_ASSERT( acc.Count( ) = 0 )

		dim as Array( of double ) v
		v.Reserve( 1000 )
		for i as long = 0 to 999
			v.Push( cdbl( ( i * 7 ) mod 101 ) )
			acc.Add( v[ i ] )
		next

		CU_ASSERT( acc.Count( ) = 1000 )
		CU_ASSERT( abs( acc.Mean( ) - Mean( v ) ) < 1e-9 )
		CU_ASSERT( abs( acc.Variance( ) - Variance( v ) ) < 1e-9 )
		CU_ASSERT( abs( acc.StdDev( ) - StdDev( v ) ) < 1e-9 )
		CU_ASSERT( acc.MinValue( ) = MinOf( v ) )
		CU_ASSERT( acc.MaxValue( ) = MaxOf( v ) )

		'' MERGE of two halves equals the whole
		dim l as RunningStats, r as RunningStats
		l.Reset( )
		r.Reset( )
		for i as long = 0 to 499
			l.Add( v[ i ] )
		next
		for i as long = 500 to 999
			r.Add( v[ i ] )
		next
		l.Merge( r )
		CU_ASSERT( l.Count( ) = 1000 )
		CU_ASSERT( abs( l.Mean( ) - acc.Mean( ) ) < 1e-9 )
		CU_ASSERT( abs( l.Variance( ) - acc.Variance( ) ) < 1e-9 )
		CU_ASSERT( l.MinValue( ) = acc.MinValue( ) )
		CU_ASSERT( l.MaxValue( ) = acc.MaxValue( ) )

		'' merging an empty accumulator changes nothing
		dim e as RunningStats
		e.Reset( )
		dim as double before = l.Mean( )
		l.Merge( e )
		CU_ASSERT( l.Mean( ) = before )
		CU_ASSERT( l.Count( ) = 1000 )

		acc.Reset( )
		CU_ASSERT( acc.Count( ) = 0 )
	END_TEST

	'' Empty and degenerate inputs are NaN, not zero: zero is a legitimate
	'' answer for every one of these.
	TEST( degenerate_ )
		dim as Array( of double ) one
		one.Push( 5.0 )
		CU_ASSERT( ( Variance( one ) = Variance( one ) ) = 0 )   '' NaN
		CU_ASSERT( VariancePopulation( one ) = 0.0 )
		CU_ASSERT( Mean( one ) = 5.0 )
		CU_ASSERT( Sum( one ) = 5.0 )

		'' AN EMPTY containers.Array IS NOW EXPRESSIBLE, which a plain array was not:
		'' Mean of nothing is NaN, and Count of nothing is zero.
		dim as Array( of double ) nothing_
		CU_ASSERT( Count( nothing_ ) = 0 )
		CU_ASSERT( ( Mean( nothing_ ) = Mean( nothing_ ) ) = 0 )

		dim acc as RunningStats
		acc.Reset( )
		CU_ASSERT( ( acc.Mean( ) = acc.Mean( ) ) = 0 )
		acc.Add( 1.0 )
		CU_ASSERT( ( acc.Variance( ) = acc.Variance( ) ) = 0 )
		CU_ASSERT( acc.Mean( ) = 1.0 )
	END_TEST

	'' Element types other than DOUBLE.
	TEST( element_types_ )
		dim as long liSrc( 0 to 4 ) = { 1, 2, 3, 4, 5 }
		dim as Array( of long ) li
		PushAll( li, liSrc( ) )
		CU_ASSERT( Sum( li ) = 15.0 )
		CU_ASSERT( Mean( li ) = 3.0 )
		CU_ASSERT( Median( li ) = 3.0 )

		dim as single sgSrc( 0 to 3 ) = { 1.5f, 2.5f, 3.5f, 4.5f }
		dim as Array( of single ) sg
		PushAll( sg, sgSrc( ) )
		CU_ASSERT( Sum( sg ) = 12.0 )
		CU_ASSERT( Mean( sg ) = 3.0 )

		'' containers.Array IS ZERO-BASED, so the non-zero-lbound case this used to
		'' cover cannot arise any more.  What replaces it is the mistake that
		'' CAN now be made: reading Capacity( ) where Count( ) was meant, which
		'' would average in the reserved slack.
		dim as Array( of double ) spare
		spare.Reserve( 64 )
		for k as long = 1 to 5
			spare.Push( cdbl( k ) )
		next
		CU_ASSERT( spare.Capacity( ) >= 64 )
		CU_ASSERT( Sum( spare ) = 15.0 )
		CU_ASSERT( Mean( spare ) = 3.0 )
		CU_ASSERT( Median( spare ) = 3.0 )
		CU_ASSERT( MinOf( spare ) = 1.0 )
	END_TEST

END_SUITE
