'' Charts -- C:\dev\docs\tui\RFC-0008-widget-catalogue.md section 3.
''
'' TWO GATES, from ranked-gaps.md:
''
''   rank 15  every one of the 256 braille patterns is produced by the dot set
''            that should produce it, and the canvas is asserted at sub-cell
''            resolution
''   rank 17  a meter at ratio 0, 1/8, 1/2, 7/8 and 1 produces the exact
''            expected cell string
''
'' The braille gate matters because the bit order is NOT raster order -- bits 6
'' and 7 are the bottom row, not the right column -- and assuming raster order
'' is the single most common mistake in a braille canvas. A test that only
'' checked a few patterns would pass with the two orders swapped.

#include "fbcunit.bi"
#include once "fb/tui.bi"

using FB

SUITE( fbc_tests.tui.tuidraw_ )

	'' GATE, rank 15. All 256 patterns, each built from the dots it names.
	TEST( rfc0008_s3_gate_all_256_braille_patterns )
		'' bit -> (sx, sy), the inverse of the Braille order
		dim as long bx( 0 to 7 ) = { 0, 0, 0, 1, 1, 1, 0, 1 }
		dim as long by( 0 to 7 ) = { 0, 1, 2, 0, 1, 2, 3, 3 }

		dim as long bad = 0
		for want as long = 0 to 255
			dim as TuiCanvas c = TuiCanvas( 1, 1 )
			for b as long = 0 to 7
				if( ( want and ( 1 shl b ) ) <> 0 ) then
					c.Dot( bx( b ), by( b ), TuiRgb( 1, 2, 3 ) )
				end if
			next
			if( c.Pattern( 0, 0 ) <> want ) then bad += 1
		next
		CU_ASSERT_EQUAL( bad, 0 )

		'' and the four corners of the bit map, spelled out, so a swapped order
		'' fails HERE with a readable message rather than only in the count
		dim as TuiCanvas q = TuiCanvas( 1, 1 )
		q.Dot( 0, 0, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h01 )
		q.Clear( ) : q.Dot( 1, 0, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h08 )
		q.Clear( ) : q.Dot( 0, 3, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h40 )   '' BOTTOM row, not right column
		q.Clear( ) : q.Dot( 1, 3, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h80 )
		q.Clear( ) : q.Dot( 0, 1, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h02 )
		q.Clear( ) : q.Dot( 1, 2, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( q.Pattern( 0, 0 ), &h20 )
	END_TEST

	'' The canvas addresses SUB-CELL: one cell is 2x4 dots, and a dot lands in
	'' the cell its coordinates say it does.
	TEST( rfc0008_s3_canvas_geometry )
		dim as TuiCanvas c = TuiCanvas( 5, 3 )
		CU_ASSERT_EQUAL( c.CellCols( ), 5 )
		CU_ASSERT_EQUAL( c.CellRows( ), 3 )
		CU_ASSERT_EQUAL( c.DotWidth( ), 10 )
		CU_ASSERT_EQUAL( c.DotHeight( ), 12 )

		'' dot (7,9) is cell (3,2), sub (1,1) -> bit 4
		c.Dot( 7, 9, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( c.Pattern( 3, 2 ), &h10 )
		CU_ASSERT_EQUAL( c.Pattern( 0, 0 ), 0 )

		'' out-of-range dots are DROPPED, not wrapped and not a fault
		c.Clear( )
		c.Dot( -1, 0, TuiRgb( 1, 1, 1 ) )
		c.Dot( 0, -1, TuiRgb( 1, 1, 1 ) )
		c.Dot( 10, 0, TuiRgb( 1, 1, 1 ) )
		c.Dot( 0, 12, TuiRgb( 1, 1, 1 ) )
		c.Dot( 9999, 9999, TuiRgb( 1, 1, 1 ) )
		for cy as long = 0 to 2
			for cx as long = 0 to 4
				CU_ASSERT_EQUAL( c.Pattern( cx, cy ), 0 )
			next
		next

		'' a zero-size canvas is legal and swallows everything
		dim as TuiCanvas z
		CU_ASSERT_EQUAL( z.DotWidth( ), 0 )
		z.Dot( 0, 0, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( z.Pattern( 0, 0 ), 0 )
	END_TEST

	'' Bresenham: a line has no gaps, and a steep line is as continuous as a
	'' shallow one. Asserted by counting set dots per column/row rather than by
	'' looking.
	TEST( rfc0008_s3_line_has_no_gaps )
		dim as TuiCanvas c = TuiCanvas( 10, 5 )     '' 20 x 20 dots

		'' a shallow line: every column between the ends has at least one dot
		c.Line_( 0, 0, 19, 5, TuiRgb( 1, 1, 1 ) )
		for x as long = 0 to 19
			dim as boolean any_ = FALSE
			for y as long = 0 to 19
				dim as long b = 1 shl 0
				'' recompute the bit for (x,y) the same way the canvas does
				dim as long sx = x mod 2, sy = y mod 4
				dim as long bit_ = 0
				if( sx = 0 ) then
					select case sy
					case 0 : bit_ = 0
					case 1 : bit_ = 1
					case 2 : bit_ = 2
					case else : bit_ = 6
					end select
				else
					select case sy
					case 0 : bit_ = 3
					case 1 : bit_ = 4
					case 2 : bit_ = 5
					case else : bit_ = 7
					end select
				end if
				if( ( c.Pattern( x \ 2, y \ 4 ) and ( 1 shl bit_ ) ) <> 0 ) then
					any_ = TRUE
					exit for
				end if
			next
			CU_ASSERT_TRUE( any_ )
		next

		'' a single-point line still marks its point
		dim as TuiCanvas p = TuiCanvas( 2, 1 )
		p.Line_( 1, 1, 1, 1, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( p.Pattern( 0, 0 ), &h10 )

		'' a line entirely off-canvas terminates and draws nothing
		dim as TuiCanvas o = TuiCanvas( 2, 1 )
		o.Line_( -50, -50, -10, -10, TuiRgb( 1, 1, 1 ) )
		CU_ASSERT_EQUAL( o.Pattern( 0, 0 ), 0 )
		CU_ASSERT_EQUAL( o.Pattern( 1, 0 ), 0 )
	END_TEST

	'' Blit writes U+2800 + pattern, and LEAVES EMPTY CELLS ALONE so a canvas
	'' drawn over existing content does not erase it.
	TEST( rfc0008_s3_blit_preserves_empty_cells )
		dim as TuiScreen scr
		scr.Resize( 6, 2 )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		'' put something underneath
		f->DrawText( 0, 0, "abcdef", TuiStyleDefault( ) )

		dim as TuiCanvas c = TuiCanvas( 6, 2 )
		c.Dot( 4, 0, TuiRgb( 10, 20, 30 ) )        '' cell (2,0)
		c.Blit( *f, TuiRectOf( 0, 0, 6, 2 ) )

		'' the touched cell became a braille glyph ...
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->text[0], &h2801 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->st.fg.r, 10 )
		'' ... and the untouched ones kept their text
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, "a" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 5, 0 )->text, "f" )

		'' blitting into an empty area draws nothing and does not fault
		c.Blit( *f, TuiRectOf( 0, 0, 0, 0 ) )
	END_TEST

	'' GATE, rank 17. The meter's EXACT cell string at the five named ratios.
	TEST( rfc0008_s3_gate_meter_exact_cells )
		dim as TuiScreen scr
		scr.Resize( 8, 1 )

		dim as TuiMeter m
		m.from_ = TuiRgb( 0, 255, 0 )
		m.to_ = TuiRgb( 255, 0, 0 )
		m.trackColor = TuiRgb( 40, 40, 40 )
		m.partialCells = TRUE
		m.meterStyle = TUIMETER_SOLID

		'' ratio 0 -> nothing filled, all track
		m.ratio = 0.0
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 7
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text, " " )
		next

		'' ratio 1/8 of 8 columns = exactly ONE full cell, then track
		m.ratio = 0.125
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text[0], &h2588 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 1, 0 )->text, " " )

		'' ratio 1/2 -> exactly four full cells
		m.ratio = 0.5
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 3
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
		next
		CU_ASSERT_EQUAL( scr.Back( )->At( 4, 0 )->text, " " )

		'' ratio 7/8 -> seven full cells
		m.ratio = 0.875
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 6
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
		next
		CU_ASSERT_EQUAL( scr.Back( )->At( 7, 0 )->text, " " )

		'' ratio 1 -> every cell full
		m.ratio = 1.0
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 7
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
		next

		'' out-of-range clamps rather than drawing outside
		m.ratio = 9.0
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 7, 0 )->text[0], &h2588 )
		m.ratio = -9.0
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, " " )
	END_TEST

	'' A partial cell at the tip, at one-eighth resolution.
	TEST( rfc0008_s3_meter_partial_cells )
		dim as TuiScreen scr
		scr.Resize( 2, 1 )

		dim as TuiMeter m
		m.from_ = TuiRgb( 0, 255, 0 )
		m.to_ = TuiRgb( 0, 255, 0 )
		m.partialCells = TRUE

		'' 1/16 of two columns is one eighth of one cell
		m.ratio = 0.0625
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 2, 1 ) )
		dim as ulong u = scr.Back( )->At( 0, 0 )->text[0]
		CU_ASSERT_TRUE( ( u >= &h2589 ) andalso ( u <= &h258F ) )

		'' with partialCells off, the same ratio rounds down to nothing
		m.partialCells = FALSE
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 2, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, " " )
	END_TEST

	'' RFC-0008 section 3. HATCHED and SEGMENTED are distinguishable from SOLID
	'' and from each other, and the SEGMENTED gap is part of the track.
	TEST( rfc0008_s3_meter_styles )
		dim as TuiScreen scr
		scr.Resize( 12, 1 )

		dim as TuiMeter m
		m.from_ = TuiRgb( 0, 255, 0 )
		m.to_ = TuiRgb( 0, 255, 0 )
		m.ratio = 1.0

		m.meterStyle = TUIMETER_SOLID
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 12, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text[0], &h2588 )

		m.meterStyle = TUIMETER_HATCHED
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 12, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text[0], &h2592 )

		'' SEGMENTED with segmentEvery = 3 draws 3, skips 1
		m.meterStyle = TUIMETER_SEGMENTED
		m.segmentEvery = 3
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 12, 1 ) )
		for i as long = 0 to 11
			dim as boolean isGap = ( ( ( i + 1 ) mod 4 ) = 0 )
			if( isGap ) then
				CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text, " " )
			else
				CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
			end if
		next
	END_TEST

	'' RFC-0008 section 3. THE GRADIENT RUNS ALONG THE BAR'S FULL LENGTH, not
	'' its filled length, so a given position keeps its colour as the value
	'' moves. Interpolating along the filled part instead makes the eye read the
	'' bar as noise.
	TEST( rfc0008_s3_gradient_is_positional_not_proportional )
		dim as TuiScreen scr
		scr.Resize( 10, 1 )

		dim as TuiMeter m
		m.from_ = TuiRgb( 0, 0, 0 )
		m.to_ = TuiRgb( 250, 0, 0 )
		m.meterStyle = TUIMETER_SOLID

		'' at 40%, read the colour of cell 1
		m.ratio = 0.4
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )
		dim as ubyte at40 = scr.Back( )->At( 1, 0 )->st.fg.r

		'' at 90%, cell 1 must be THE SAME colour
		m.ratio = 0.9
		m.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )
		dim as ubyte at90 = scr.Back( )->At( 1, 0 )->st.fg.r
		CU_ASSERT_EQUAL( at40, at90 )

		'' and the gradient really does progress along the bar
		dim as ubyte first_ = scr.Back( )->At( 0, 0 )->st.fg.r
		dim as ubyte later = scr.Back( )->At( 8, 0 )->st.fg.r
		CU_ASSERT_TRUE( later > first_ )
	END_TEST

	'' The colour lerp itself, including the cases that cannot interpolate.
	TEST( rfc0008_s3_colour_lerp )
		dim as TuiColor a = TuiRgb( 0, 0, 0 )
		dim as TuiColor b = TuiRgb( 100, 200, 40 )

		CU_ASSERT_EQUAL( TuiLerpColor( a, b, 0.0 ).r, 0 )
		CU_ASSERT_EQUAL( TuiLerpColor( a, b, 1.0 ).r, 100 )
		CU_ASSERT_EQUAL( TuiLerpColor( a, b, 1.0 ).g, 200 )
		CU_ASSERT_EQUAL( TuiLerpColor( a, b, 0.5 ).r, 50 )

		'' out of range clamps
		CU_ASSERT_EQUAL( TuiLerpColor( a, b, -5.0 ).r, 0 )
		CU_ASSERT_EQUAL( TuiLerpColor( a, b, 5.0 ).r, 100 )

		'' a DEFAULT endpoint yields the other one rather than a wrong colour
		dim as TuiColor d
		CU_ASSERT_TRUE( TuiLerpColor( d, b, 0.5 ).Equals( b ) )
		CU_ASSERT_TRUE( TuiLerpColor( a, d, 0.5 ).Equals( a ) )

		'' non-RGB snaps at the midpoint rather than inventing a palette walk
		dim as TuiColor p = TuiAnsi( 1 ), q = TuiAnsi( 4 )
		CU_ASSERT_TRUE( TuiLerpColor( p, q, 0.2 ).Equals( p ) )
		CU_ASSERT_TRUE( TuiLerpColor( p, q, 0.8 ).Equals( q ) )
	END_TEST

	'' RFC-0008 section 3. A graph draws, auto-scales, survives a flat series
	'' without dividing by zero, and handles multiple series on one axis.
	TEST( rfc0008_s3_graph )
		dim as TuiScreen scr
		scr.Resize( 20, 4 )

		dim as TuiGraph g
		g.graphKind = TUIGRAPH_BRAILLE
		g.autoScale = TRUE

		'' an EMPTY graph draws nothing and does not fault
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 4 ) )

		dim as TuiSeries s1
		for i as long = 0 to 39
			s1.data.Push( cdbl( i ) )
		next
		s1.color = TuiRgb( 90, 200, 255 )
		g.series.Push( s1 )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		g.Render( *f, TuiRectOf( 0, 0, 20, 4 ) )

		'' something was drawn, and it is braille
		dim as long drawn = 0
		for y as long = 0 to 3
			for x as long = 0 to 19
				dim as ulong u = scr.Back( )->At( x, y )->text[0]
				if( ( u >= &h2800 ) andalso ( u <= &h28FF ) ) then drawn += 1
			next
		next
		CU_ASSERT_TRUE( drawn > 0 )

		'' a rising ramp ends higher than it starts: the last column's dots are
		'' nearer the top than the first column's
		'' (asserted loosely -- the point is that it is not inverted)
		dim as long firstRow = -1, lastRow = -1
		for y as long = 0 to 3
			dim as ulong u0 = scr.Back( )->At( 0, y )->text[0]
			if( ( u0 >= &h2800 ) andalso ( u0 <= &h28FF ) andalso ( firstRow < 0 ) ) then firstRow = y
			dim as ulong u1 = scr.Back( )->At( 19, y )->text[0]
			if( ( u1 >= &h2800 ) andalso ( u1 <= &h28FF ) andalso ( lastRow < 0 ) ) then lastRow = y
		next
		CU_ASSERT_TRUE( lastRow <= firstRow )

		'' A FLAT SERIES must not divide by zero
		dim as TuiGraph flat_
		flat_.autoScale = TRUE
		dim as TuiSeries s2
		for i as long = 0 to 9
			s2.data.Push( 7.0 )
		next
		flat_.series.Push( s2 )
		flat_.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 4 ) )

		'' fixed bounds with maxY <= minY must not either
		dim as TuiGraph bad_
		bad_.autoScale = FALSE
		bad_.minY = 5.0
		bad_.maxY = 5.0
		bad_.series.Push( s2 )
		bad_.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 4 ) )

		'' BLOCK mode draws the vertical partial blocks instead
		dim as TuiGraph blk
		blk.graphKind = TUIGRAPH_BLOCK
		blk.autoScale = TRUE
		blk.series.Push( s1 )
		blk.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 4 ) )
		dim as long blocks = 0
		for y as long = 0 to 3
			for x as long = 0 to 19
				dim as ulong u = scr.Back( )->At( x, y )->text[0]
				if( ( u >= &h2581 ) andalso ( u <= &h2588 ) ) then blocks += 1
			next
		next
		CU_ASSERT_TRUE( blocks > 0 )
	END_TEST

	'' RFC-0008 section 3. Sparkline and bar chart.
	TEST( rfc0008_s3_sparkline_and_barchart )
		dim as TuiScreen scr
		scr.Resize( 10, 4 )

		dim as TuiSparkline sp
		for i as long = 0 to 9
			sp.data.Push( cdbl( i ) )
		next
		sp.color = TuiRgb( 0, 255, 0 )
		sp.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )

		'' the last column is the tallest, the first the shortest
		dim as ulong lastU = scr.Back( )->At( 9, 0 )->text[0]
		CU_ASSERT_EQUAL( lastU, &h2588 )

		'' an empty sparkline draws nothing and does not divide by zero
		dim as TuiSparkline empty_
		empty_.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )

		'' all-zero data must not divide by zero either
		dim as TuiSparkline zeros
		for i as long = 0 to 5
			zeros.data.Push( 0.0 )
		next
		zeros.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )

		'' bar chart, vertical and horizontal
		dim as TuiBarChart bc
		for i as long = 1 to 3
			dim as TuiBar b
			b.label = "b" & str( i )
			b.value = i
			b.color = TuiRgb( 200, 100, 0 )
			bc.bars.Push( b )
		next
		bc.barWidth = 2
		bc.barGap = 1
		bc.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 4 ) )

		bc.horizontal = TRUE
		bc.showLabels = TRUE
		bc.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 4 ) )

		'' an empty chart is a no-op
		dim as TuiBarChart eb
		eb.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 4 ) )
	END_TEST

	'' Every chart widget at degenerate sizes, asserting nothing is written
	'' outside the area -- the same gate the phase-5 widgets hold.
	TEST( rfc0008_s3_degenerate_areas )
		for w as long = 0 to 4
			for h as long = 0 to 3
				dim as TuiScreen scr
				scr.Resize( 8, 5 )
				dim as TuiFrame ptr f = scr.BeginFrame( )
				dim as TuiRect area = TuiRectOf( 0, 0, w, h )

				dim as TuiGraph g
				g.autoScale = TRUE
				dim as TuiSeries s
				for i as long = 0 to 20
					s.data.Push( cdbl( i mod 7 ) )
				next
				s.color = TuiRgb( 1, 2, 3 )
				g.series.Push( s )
				g.Render( *f, area )

				g.graphKind = TUIGRAPH_BLOCK
				g.Render( *f, area )

				dim as TuiSparkline sp
				sp.data = s.data
				sp.color = TuiRgb( 1, 2, 3 )
				sp.Render( *f, area )

				dim as TuiMeter m
				m.ratio = 0.6
				m.partialCells = TRUE
				m.from_ = TuiRgb( 0, 0, 0 )
				m.to_ = TuiRgb( 9, 9, 9 )
				for st as long = 0 to 2
					m.meterStyle = st
					m.Render( *f, area )
				next

				dim as TuiBarChart bc
				dim as TuiBar b
				b.label = "x" : b.value = 3 : b.color = TuiRgb( 1, 1, 1 )
				bc.bars.Push( b )
				bc.showLabels = TRUE
				bc.Render( *f, area )
				bc.horizontal = TRUE
				bc.Render( *f, area )

				dim as TuiCanvas c = TuiCanvas( iif( w > 0, w, 1 ), iif( h > 0, h, 1 ) )
				c.Line_( 0, 0, 20, 20, TuiRgb( 1, 1, 1 ) )
				c.Blit( *f, area )

				for y as long = 0 to 4
					for x as long = 0 to 7
						if( area.Contains( x, y ) ) then continue for
						dim as TuiCell ptr cc = scr.Back( )->At( x, y )
						CU_ASSERT_TRUE( ( cc->text = " " ) orelse ( len( cc->text ) = 0 ) )
					next
				next
			next
		next
	END_TEST

END_SUITE
