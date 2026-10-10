'' Layout -- C:\dev\docs\tui\RFC-0006-layout.md.
''
'' THE GATE IS rfc0006_s3_post_conditions_hold_everywhere: every constraint mix
'' in the suite, at every total from 1 to 200, asserting that the parts sum to
'' the parent EXACTLY, that none is negative, that they are contiguous, and that
'' the count is preserved.
''
'' Exhaustive rather than sampled, because the failure this guards against is an
'' integer-remainder bug that appears at one width in fifty and is invisible at
'' every other.

#import "std/tui"
#import "std/outcome"
#import "std/chrono"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

using tui, outcome, chrono

using FB
SUITE( fbc_tests.tui.tuilayout_ )

	'' RFC-0006 section 3. THE GATE.
	TEST( rfc0006_s3_post_conditions_hold_everywhere )
		'' 14 mixes, chosen to hit every kind, every combination of kinds that
		'' interacts, and the over-subscribed cases
		dim as long badSum = 0, badNeg = 0, badGap = 0, badCount = 0

		for mix as long = 0 to 13
			dim as TuiConstraintArray cs
			select case mix
			case 0  : cs.Push( TuiFill( ) )
			case 1  : cs.Push( TuiPercent( 45 ) ) : cs.Push( TuiFill( ) )
			case 2  : cs.Push( TuiLength( 12 ) ) : cs.Push( TuiFill( ) ) : cs.Push( TuiLength( 9 ) )
			case 3  : cs.Push( TuiFill( 1 ) ) : cs.Push( TuiFill( 2 ) ) : cs.Push( TuiFill( 1 ) )
			case 4  : cs.Push( TuiRatio( 1, 3 ) ) : cs.Push( TuiRatio( 2, 3 ) )
			case 5  : cs.Push( TuiMin_( 10 ) ) : cs.Push( TuiFill( ) )
			case 6  : cs.Push( TuiMax_( 20 ) ) : cs.Push( TuiFill( ) )
			case 7  : cs.Push( TuiLength( 50 ) ) : cs.Push( TuiLength( 50 ) ) : cs.Push( TuiLength( 50 ) )
			case 8  : cs.Push( TuiMin_( 40 ) ) : cs.Push( TuiMin_( 40 ) ) : cs.Push( TuiMin_( 40 ) )
			case 9  : cs.Push( TuiPercent( 33 ) ) : cs.Push( TuiPercent( 33 ) ) : cs.Push( TuiPercent( 34 ) )
			case 10 : cs.Push( TuiPercent( 80 ) ) : cs.Push( TuiPercent( 80 ) )
			case 11 : cs.Push( TuiLength( 1 ) ) : cs.Push( TuiFill( ) ) : cs.Push( TuiLength( 1 ) )
			case 12 : cs.Push( TuiFill( 3 ) ) : cs.Push( TuiLength( 7 ) ) : cs.Push( TuiFill( 5 ) ) : cs.Push( TuiMin_( 4 ) )
			case 13 : cs.Push( TuiRatio( 1, 7 ) ) : cs.Push( TuiFill( 2 ) ) : cs.Push( TuiMax_( 6 ) ) : cs.Push( TuiPercent( 25 ) )
			end select

			for total as long = 1 to 200
				dim as TuiRectArray p = TuiSplitH( TuiRectOf( 5, 2, total, 9 ), cs )

				if( p.Count( ) <> cs.Count( ) ) then badCount += 1 : continue for

				dim as long sum = 0
				dim as long expectX = 5
				for i as long = 0 to p.Count( ) - 1
					if( p[i].w < 0 ) then badNeg += 1
					if( p[i].x <> expectX ) then badGap += 1
					sum += p[i].w
					expectX += p[i].w
				next
				if( sum <> total ) then badSum += 1
			next
		next

		'' Four exact counts rather than 11,200 assertions -- but any single
		'' violation at any width fails one of them.
		CU_ASSERT_EQUAL( badSum, 0 )
		CU_ASSERT_EQUAL( badNeg, 0 )
		CU_ASSERT_EQUAL( badGap, 0 )
		CU_ASSERT_EQUAL( badCount, 0 )
	END_TEST

	'' The same gate for the vertical direction, since SplitV is a separate
	'' code path and "it is obviously symmetric" is how the asymmetry ships.
	TEST( rfc0006_s3_vertical_holds_too )
		dim as TuiConstraintArray cs
		cs.Push( TuiLength( 12 ) )
		cs.Push( TuiFill( ) )
		cs.Push( TuiLength( 9 ) )

		dim as long bad = 0
		for total as long = 1 to 200
			dim as TuiRectArray p = TuiSplitV( TuiRectOf( 3, 7, 40, total ), cs )
			dim as long sum = 0, expectY = 7
			for i as long = 0 to p.Count( ) - 1
				if( p[i].h < 0 ) then bad += 1
				if( p[i].y <> expectY ) then bad += 1
				if( p[i].x <> 3 ) then bad += 1
				if( p[i].w <> 40 ) then bad += 1
				sum += p[i].h
				expectY += p[i].h
			next
			if( sum <> total ) then bad += 1
		next
		CU_ASSERT_EQUAL( bad, 0 )
	END_TEST

	'' RFC-0006 section 3, step 1. Each kind computes the size it claims to.
	TEST( rfc0006_s3_each_kind_computes_its_size )
		dim as TuiConstraintArray cs

		'' LENGTH is exact
		cs.Clear( ) : cs.Push( TuiLength( 30 ) ) : cs.Push( TuiFill( ) )
		dim as TuiRectArray a = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( a[0].w, 30 )
		CU_ASSERT_EQUAL( a[1].w, 70 )

		'' PERCENT floors
		cs.Clear( ) : cs.Push( TuiPercent( 45 ) ) : cs.Push( TuiFill( ) )
		dim as TuiRectArray b = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( b[0].w, 45 )
		dim as TuiRectArray b7 = TuiSplitH( TuiRectOf( 0, 0, 7, 1 ), cs )
		CU_ASSERT_EQUAL( b7[0].w, 3 )      '' floor( 7 * 45 / 100 ) = 3
		CU_ASSERT_EQUAL( b7[1].w, 4 )

		'' RATIO floors
		cs.Clear( ) : cs.Push( TuiRatio( 1, 3 ) ) : cs.Push( TuiRatio( 2, 3 ) )
		dim as TuiRectArray c = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( c[0].w, 33 )
		CU_ASSERT_EQUAL( c[0].w + c[1].w, 100 )

		'' a zero denominator does not divide by zero
		cs.Clear( ) : cs.Push( TuiRatio( 1, 0 ) ) : cs.Push( TuiFill( ) )
		dim as TuiRectArray z = TuiSplitH( TuiRectOf( 0, 0, 50, 1 ), cs )
		CU_ASSERT_EQUAL( z[0].w, 0 )
		CU_ASSERT_EQUAL( z[1].w, 50 )

		'' MIN takes at least n, and grows into slack when nothing else can
		cs.Clear( ) : cs.Push( TuiMin_( 10 ) ) : cs.Push( TuiLength( 20 ) )
		dim as TuiRectArray d = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( d[0].w, 80 )
		CU_ASSERT_EQUAL( d[1].w, 20 )

		'' MAX takes n when there is room
		cs.Clear( ) : cs.Push( TuiMax_( 20 ) ) : cs.Push( TuiFill( ) )
		dim as TuiRectArray e = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( e[0].w, 20 )
		CU_ASSERT_EQUAL( e[1].w, 80 )
	END_TEST

	'' RFC-0006 section 3, steps 4 and 5. FILL shares by weight, and the
	'' integer leftovers go ONE CELL EACH, LEFT TO RIGHT -- never fractionally,
	'' never all to one. This is the rule that keeps two runs identical.
	TEST( rfc0006_s3_fill_weights_and_the_integer_remainder )
		dim as TuiConstraintArray cs
		cs.Push( TuiFill( 1 ) )
		cs.Push( TuiFill( 2 ) )
		cs.Push( TuiFill( 1 ) )

		dim as TuiRectArray a = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), cs )
		CU_ASSERT_EQUAL( a[0].w, 25 )
		CU_ASSERT_EQUAL( a[1].w, 50 )
		CU_ASSERT_EQUAL( a[2].w, 25 )

		'' 10 / (1:2:1) is 2.5 : 5 : 2.5 -- floors to 2,5,2 with 1 left over,
		'' which goes to the FIRST fill
		dim as TuiRectArray b = TuiSplitH( TuiRectOf( 0, 0, 10, 1 ), cs )
		CU_ASSERT_EQUAL( b[0].w, 3 )
		CU_ASSERT_EQUAL( b[1].w, 5 )
		CU_ASSERT_EQUAL( b[2].w, 2 )
		CU_ASSERT_EQUAL( b[0].w + b[1].w + b[2].w, 10 )

		'' 7 / (1:2:1) -> 1,3,1 = 5, two left over, one each to the first two
		dim as TuiRectArray c = TuiSplitH( TuiRectOf( 0, 0, 7, 1 ), cs )
		CU_ASSERT_EQUAL( c[0].w, 2 )
		CU_ASSERT_EQUAL( c[1].w, 4 )
		CU_ASSERT_EQUAL( c[2].w, 1 )

		'' DETERMINISM: the same inputs give the same answer, every time
		for k as long = 1 to 5
			dim as TuiRectArray again = TuiSplitH( TuiRectOf( 0, 0, 7, 1 ), cs )
			CU_ASSERT_EQUAL( again[0].w, 2 )
			CU_ASSERT_EQUAL( again[1].w, 4 )
			CU_ASSERT_EQUAL( again[2].w, 1 )
		next

		'' a zero or negative weight is treated as 1 rather than dividing by zero
		dim as TuiConstraintArray zw
		zw.Push( TuiFill( 0 ) )
		zw.Push( TuiFill( 0 ) )
		dim as TuiRectArray d = TuiSplitH( TuiRectOf( 0, 0, 9, 1 ), zw )
		CU_ASSERT_EQUAL( d[0].w + d[1].w, 9 )
	END_TEST

	'' RFC-0006 section 3, step 4. Over-subscription shrinks in the specified
	'' ORDER, and -- phase 4 amendment -- RIGHT TO LEFT within each pass, so the
	'' leading panel is the last to give up cells.
	TEST( rfc0006_s3_shrink_order_and_direction )
		dim as TuiConstraintArray cs
		cs.Push( TuiLength( 12 ) )
		cs.Push( TuiFill( ) )
		cs.Push( TuiLength( 9 ) )

		'' 15 columns for 21 of Length plus a Fill: Fill goes first (it is
		'' already 0), then LENGTH shrinks from the RIGHT
		dim as TuiRectArray a = TuiSplitH( TuiRectOf( 0, 0, 15, 1 ), cs )
		CU_ASSERT_EQUAL( a[0].w, 12 )
		CU_ASSERT_EQUAL( a[1].w, 0 )
		CU_ASSERT_EQUAL( a[2].w, 3 )

		'' three Length(50) in 100 columns: the LAST one is sacrificed
		dim as TuiConstraintArray three
		three.Push( TuiLength( 50 ) )
		three.Push( TuiLength( 50 ) )
		three.Push( TuiLength( 50 ) )
		dim as TuiRectArray b = TuiSplitH( TuiRectOf( 0, 0, 100, 1 ), three )
		CU_ASSERT_EQUAL( b[0].w, 50 )
		CU_ASSERT_EQUAL( b[1].w, 50 )
		CU_ASSERT_EQUAL( b[2].w, 0 )

		'' FILL is sacrificed before a MAX, and MAX before a LENGTH
		dim as TuiConstraintArray ord
		ord.Push( TuiLength( 30 ) )
		ord.Push( TuiMax_( 30 ) )
		ord.Push( TuiFill( ) )
		dim as TuiRectArray c = TuiSplitH( TuiRectOf( 0, 0, 40, 1 ), ord )
		CU_ASSERT_EQUAL( c[0].w, 30 )      '' LENGTH survives
		CU_ASSERT_EQUAL( c[2].w, 0 )       '' FILL went first
		CU_ASSERT_EQUAL( c[0].w + c[1].w + c[2].w, 40 )
	END_TEST

	'' A MIN that cannot be honoured. RFC-0006's shrink order reaches every
	'' floor with the deficit unpaid, but its post-condition is unconditional,
	'' so the solver takes the rest from the right anyway. A short rectangle
	'' beats a layout that overflows its parent.
	TEST( rfc0006_s3_impossible_minimums_still_sum )
		dim as TuiConstraintArray cs
		cs.Push( TuiMin_( 40 ) )
		cs.Push( TuiMin_( 40 ) )
		cs.Push( TuiMin_( 40 ) )

		for total as long = 1 to 130
			dim as TuiRectArray p = TuiSplitH( TuiRectOf( 0, 0, total, 1 ), cs )
			dim as long sum = 0
			for i as long = 0 to p.Count( ) - 1
				CU_ASSERT_TRUE( p[i].w >= 0 )
				sum += p[i].w
			next
			CU_ASSERT_EQUAL( sum, total )
		next

		'' and when there IS room, every minimum is honoured
		dim as TuiRectArray ok_ = TuiSplitH( TuiRectOf( 0, 0, 200, 1 ), cs )
		CU_ASSERT_TRUE( ok_[0].w >= 40 )
		CU_ASSERT_TRUE( ok_[1].w >= 40 )
		CU_ASSERT_TRUE( ok_[2].w >= 40 )
	END_TEST

	'' RFC-0006 section 3, post-conditions. A zero-size part is LEGAL and is
	'' RETURNED, so callers can index-match constraints to rectangles. Dropping
	'' empties would silently shift every later index.
	TEST( rfc0006_s3_zero_size_parts_are_returned )
		dim as TuiConstraintArray cs
		cs.Push( TuiLength( 10 ) )
		cs.Push( TuiLength( 10 ) )
		cs.Push( TuiLength( 10 ) )

		dim as TuiRectArray p = TuiSplitH( TuiRectOf( 0, 0, 5, 1 ), cs )
		CU_ASSERT_EQUAL( p.Count( ), 3 )
		CU_ASSERT_TRUE ( p[2].IsEmpty( ) )

		'' a zero-width parent still returns one rect per constraint
		dim as TuiRectArray z = TuiSplitH( TuiRectOf( 0, 0, 0, 5 ), cs )
		CU_ASSERT_EQUAL( z.Count( ), 3 )
		for i as long = 0 to 2
			CU_ASSERT_EQUAL( z[i].w, 0 )
			CU_ASSERT_TRUE ( z[i].IsEmpty( ) )
		next

		'' an empty constraint list returns an empty result, not a fault
		dim as TuiConstraintArray none_
		CU_ASSERT_EQUAL( TuiSplitH( TuiRectOf( 0, 0, 50, 5 ), none_ ).Count( ), 0 )
	END_TEST

	'' RFC-0006 section 4. Splits compose by splitting a result, and there is no
	'' layout tree to keep in sync.
	TEST( rfc0006_s4_nesting )
		dim as TuiConstraintArray cols
		cols.Push( TuiPercent( 45 ) )
		cols.Push( TuiFill( ) )
		dim as TuiRectArray main_ = TuiSplitH( TuiRectOf( 0, 0, 120, 30 ), cols )
		CU_ASSERT_EQUAL( main_[0].w, 54 )
		CU_ASSERT_EQUAL( main_[1].w, 66 )

		dim as TuiConstraintArray rows
		rows.Push( TuiLength( 12 ) )
		rows.Push( TuiFill( ) )
		rows.Push( TuiLength( 9 ) )
		dim as TuiRectArray left_ = TuiSplitV( main_[0], rows )

		CU_ASSERT_EQUAL( left_.Count( ), 3 )
		CU_ASSERT_EQUAL( left_[0].h, 12 )
		CU_ASSERT_EQUAL( left_[1].h, 9 )
		CU_ASSERT_EQUAL( left_[2].h, 9 )

		'' the children stay inside the parent, exactly
		dim as long sumH = 0
		for i as long = 0 to 2
			CU_ASSERT_EQUAL( left_[i].x, main_[0].x )
			CU_ASSERT_EQUAL( left_[i].w, main_[0].w )
			sumH += left_[i].h
		next
		CU_ASSERT_EQUAL( sumH, main_[0].h )
	END_TEST

	'' RFC-0006 section 5. Padding, centring and alignment all CLAMP.
	TEST( rfc0006_s5_padding_and_alignment_clamp )
		dim as TuiRect r = TuiRectOf( 10, 5, 20, 10 )

		dim as TuiRect p = TuiPadAll( r, 2 )
		CU_ASSERT_EQUAL( p.x, 12 )
		CU_ASSERT_EQUAL( p.y, 7 )
		CU_ASSERT_EQUAL( p.w, 16 )
		CU_ASSERT_EQUAL( p.h, 6 )

		'' padding wider than the rect gives 0, never negative
		dim as TuiRect over = TuiPadAll( TuiRectOf( 0, 0, 2, 2 ), 5 )
		CU_ASSERT_EQUAL( over.w, 0 )
		CU_ASSERT_EQUAL( over.h, 0 )
		CU_ASSERT_TRUE ( over.IsEmpty( ) )

		'' asymmetric margins
		dim as TuiRect m = TuiPad( r, TuiMarginOf( 1, 2, 3, 4 ) )
		CU_ASSERT_EQUAL( m.x, 11 )
		CU_ASSERT_EQUAL( m.y, 7 )
		CU_ASSERT_EQUAL( m.w, 16 )
		CU_ASSERT_EQUAL( m.h, 4 )

		'' centring
		dim as TuiRect scr = TuiRectOf( 0, 0, 80, 24 )
		dim as TuiRect c = TuiCenter( scr, 40, 8 )
		CU_ASSERT_EQUAL( c.x, 20 )
		CU_ASSERT_EQUAL( c.y, 8 )
		CU_ASSERT_EQUAL( c.w, 40 )
		CU_ASSERT_EQUAL( c.h, 8 )

		'' oversize clamps to the parent and stays inside it
		dim as TuiRect big = TuiCenter( scr, 200, 200 )
		CU_ASSERT_EQUAL( big.w, 80 )
		CU_ASSERT_EQUAL( big.h, 24 )
		CU_ASSERT_EQUAL( big.x, 0 )
		CU_ASSERT_EQUAL( big.y, 0 )

		'' centring inside an empty parent does not go negative
		dim as TuiRect none_ = TuiCenter( TuiRectOf( 4, 4, 0, 0 ), 10, 10 )
		CU_ASSERT_EQUAL( none_.w, 0 )
		CU_ASSERT_TRUE ( none_.x >= 4 )

		'' alignment
		CU_ASSERT_EQUAL( TuiAlignIn( scr, 10, TUIALIGN_LEFT ).x, 0 )
		CU_ASSERT_EQUAL( TuiAlignIn( scr, 10, TUIALIGN_CENTER ).x, 35 )
		CU_ASSERT_EQUAL( TuiAlignIn( scr, 10, TUIALIGN_RIGHT ).x, 70 )
		CU_ASSERT_EQUAL( TuiAlignIn( scr, 200, TUIALIGN_RIGHT ).w, 80 )
	END_TEST

	'' Degenerate parents. These are the shapes that turn a clamp bug into a
	'' crash, and they are cheap to hold.
	TEST( rfc0006_degenerate_areas )
		dim as TuiConstraintArray cs
		cs.Push( TuiPercent( 50 ) )
		cs.Push( TuiFill( ) )
		cs.Push( TuiLength( 3 ) )

		'' negative and zero extents
		dim as TuiRectArray neg = TuiSplitH( TuiRectOf( 0, 0, -10, -10 ), cs )
		CU_ASSERT_EQUAL( neg.Count( ), 3 )
		for i as long = 0 to 2
			CU_ASSERT_TRUE( neg[i].w >= 0 )
			CU_ASSERT_TRUE( neg[i].h >= 0 )
		next

		'' one column, one row
		for total as long = 0 to 3
			dim as TuiRectArray p = TuiSplitH( TuiRectOf( 0, 0, total, 1 ), cs )
			dim as long sum = 0
			for i as long = 0 to p.Count( ) - 1
				CU_ASSERT_TRUE( p[i].w >= 0 )
				sum += p[i].w
			next
			CU_ASSERT_EQUAL( sum, total )
		next

		'' a large total does not overflow the percent multiply
		dim as TuiRectArray big = TuiSplitH( TuiRectOf( 0, 0, 100000, 1 ), cs )
		dim as long sum = 0
		for i as long = 0 to big.Count( ) - 1
			sum += big[i].w
		next
		CU_ASSERT_EQUAL( sum, 100000 )
	END_TEST

END_SUITE
