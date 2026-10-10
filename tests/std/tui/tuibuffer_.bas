'' The buffer and the diff -- C:\dev\docs\tui\RFC-0003-buffer-and-renderer.md.
''
'' The load-bearing test in this file is rfc0003_s5_unchanged_frame_emits_zero
'' _bytes. It is the gate ranked-gaps.md sets for ranks 2 and 3, and it is what
'' makes the whole immediate-mode bargain pay: widgets re-render every frame,
'' and the diff is the only thing stopping that from being a full repaint.
''
'' Asserted against the returned byte string, never by looking at a screen.

#import "std/tui"
#include "fbcunit.bi"

#include once "fb/array.bi"

using tui

using FB
SUITE( fbc_tests.tui.tuibuffer_ )

	'' RFC-0003 section 1. The size that decided the shape. 22 is asserted
	'' because it is the number the var-len alternative had to beat -- that
	'' one measured 40 AND cost a heap allocation per cell.
	TEST( rfc0003_s1_cell_layout )
		CU_ASSERT_EQUAL( sizeof( TuiCell ), 22 )

		'' ustring * 4 holds THREE code units -- it is NUL-terminated, so
		'' capacity is N-1. This is the property the cell's combining-mark
		'' budget rests on.
		dim as ustring * 4 f
		f = "abcd"
		CU_ASSERT_EQUAL( len( f ), 3 )
	END_TEST

	'' RFC-0003 section 1. A cell built from an astral codepoint holds the
	'' surrogate PAIR. Built by direct code-unit assignment, never with WCHR,
	'' which destroys pairs on linux-x86_64.
	TEST( rfc0003_s1_astral_cell_round_trips )
		dim as TuiCell c
		c.SetChar( &h1F600 )

		CU_ASSERT_EQUAL( len( c.text ), 2 )
		CU_ASSERT_EQUAL( c.text[0], &hD83D )
		CU_ASSERT_EQUAL( c.text[1], &hDE00 )
		CU_ASSERT_EQUAL( c.width, 2 )

		'' and a BMP one is a single unit
		dim as TuiCell b
		b.SetChar( asc( "A" ) )
		CU_ASSERT_EQUAL( len( b.text ), 1 )
		CU_ASSERT_EQUAL( b.width, 1 )
	END_TEST

	'' RFC-0003 section 2. Resize discards, and every cell is a valid blank
	'' afterwards -- there is no uninitialised cell to render.
	TEST( rfc0003_s2_resize_gives_valid_blanks )
		dim as TuiBuffer b
		b.Resize( 10, 4 )
		CU_ASSERT_EQUAL( b.cols, 10 )
		CU_ASSERT_EQUAL( b.rows, 4 )
		CU_ASSERT_EQUAL( b.Count( ), 40 )

		for y as long = 0 to 3
			for x as long = 0 to 9
				dim as TuiCell ptr c = b.At( x, y )
				CU_ASSERT_TRUE ( c <> 0 )
				CU_ASSERT_EQUAL( c->width, 1 )
				CU_ASSERT_EQUAL( c->text, " " )
			next
		next

		'' out of bounds returns NULL rather than raising -- the drawing layer
		'' never fails, so At is a query, not an assertion
		CU_ASSERT_TRUE( b.At( -1, 0 ) = 0 )
		CU_ASSERT_TRUE( b.At( 10, 0 ) = 0 )
		CU_ASSERT_TRUE( b.At( 0, 4 ) = 0 )

		'' a zero-size buffer is legal and holds nothing
		dim as TuiBuffer z
		z.Resize( 0, 0 )
		CU_ASSERT_EQUAL( z.Count( ), 0 )
		CU_ASSERT_TRUE ( z.At( 0, 0 ) = 0 )
	END_TEST

	'' RFC-0003 section 3. Drawing NEVER fails. Every one of these is a write
	'' that cannot land, and every one must be a silent no-op.
	TEST( rfc0003_s3_out_of_clip_writes_are_dropped )
		dim as TuiScreen scr
		scr.Resize( 20, 3 )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		'' entirely left of the buffer -- nothing written, nothing counted
		CU_ASSERT_EQUAL( f->DrawText( -5, 1, "xyz", plain ), 0 )

		'' entirely below it
		f->DrawText( 0, 99, "offscreen", plain )

		'' partially clipped at the right edge: only the columns that fit
		CU_ASSERT_EQUAL( f->DrawText( 18, 2, "abcdefgh", plain ), 2 )

		'' a zero-width area draws nothing at all
		dim as TuiRect saved = f->PushClip( TuiRectOf( 5, 1, 0, 1 ) )
		CU_ASSERT_EQUAL( f->DrawText( 5, 1, "hello", plain ), 0 )
		f->PopClip( saved )

		'' and the buffer is still coherent
		CU_ASSERT_EQUAL( scr.Back( )->At( 18, 2 )->text, "a" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 19, 2 )->text, "b" )
	END_TEST

	'' RFC-0003 section 3. PushClip INTERSECTS -- a child can never widen its
	'' parent's clip. That is what makes it safe to hand a frame to arbitrary
	'' widget code.
	TEST( rfc0003_s3_pushclip_intersects_and_never_widens )
		dim as TuiScreen scr
		scr.Resize( 20, 5 )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		dim as TuiRect a = f->PushClip( TuiRectOf( 5, 1, 10, 3 ) )
		CU_ASSERT_EQUAL( f->Clip( ).x, 5 )
		CU_ASSERT_EQUAL( f->Clip( ).w, 10 )

		'' a child asking for the WHOLE screen gets its parent's clip back
		dim as TuiRect b = f->PushClip( TuiRectOf( 0, 0, 20, 5 ) )
		CU_ASSERT_EQUAL( f->Clip( ).x, 5 )
		CU_ASSERT_EQUAL( f->Clip( ).w, 10 )
		f->PopClip( b )

		f->PopClip( a )
		CU_ASSERT_EQUAL( f->Clip( ).w, 20 )
	END_TEST

	'' RFC-0003 section 3. A wide glyph occupies two cells, of which only the
	'' left carries text. Getting this wrong is what makes CJK text tear a box
	'' border.
	TEST( rfc0003_s3_wide_glyph_writes_a_continuation_cell )
		dim as TuiScreen scr
		scr.Resize( 10, 2 )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		dim as ustring cjk = "  "
		cjk[0] = &h4E2D
		cjk[1] = &h6587
		CU_ASSERT_EQUAL( TuiStringWidth( cjk ), 4 )

		f->DrawText( 0, 0, cjk, plain )

		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->width, 2 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 1, 0 )->width, 0 )   '' continuation
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->width, 2 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->width, 0 )
		CU_ASSERT_EQUAL( len( scr.Back( )->At( 1, 0 )->text ), 0 )
	END_TEST

	'' RFC-0003 section 3. Overwriting EITHER half of a wide glyph must repair
	'' the other, or the terminal is told to draw a stale partner.
	TEST( rfc0003_s3_overwriting_half_a_wide_glyph_repairs_the_other )
		dim as TuiScreen scr
		scr.Resize( 10, 2 )
		dim as TuiStyle plain = TuiStyleDefault( )

		'' overwrite the LEFT half
		dim as TuiFrame ptr f = scr.BeginFrame( )
		dim as ustring wide = " "
		wide[0] = &h4E2D
		f->DrawText( 2, 0, wide, plain )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->width, 0 )
		f->DrawText( 2, 0, "A", plain )
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->text, "A" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->width, 1 )    '' repaired
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->text, " " )

		'' overwrite the RIGHT half
		f = scr.BeginFrame( )
		f->DrawText( 2, 0, wide, plain )
		f->DrawText( 3, 0, "B", plain )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->text, "B" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->width, 1 )    '' repaired
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->text, " " )
	END_TEST

	'' RFC-0003 section 3. A two-column glyph whose second column falls
	'' outside the clip is NOT drawn -- half a glyph is not a glyph.
	TEST( rfc0003_s3_wide_glyph_at_the_edge_is_not_half_drawn )
		dim as TuiScreen scr
		scr.Resize( 4, 1 )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		dim as ustring wide = " "
		wide[0] = &h4E2D
		f->DrawText( 3, 0, wide, plain )     '' would need columns 3 and 4

		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->width, 1 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->text, " " )
	END_TEST

	'' RFC-0003 section 5. THE GATE. A redraw of unchanged content emits ZERO
	'' bytes. Everything about immediate mode rests on this number.
	TEST( rfc0003_s5_unchanged_frame_emits_zero_bytes )
		dim as TuiScreen scr
		scr.Resize( 40, 6 )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiStyle fancy = TuiStyleOf( TuiRgb( 255, 128, 0 ), TuiDefaultColor( ), TUIATTR_BOLD )

		'' first frame: invalid, so a full paint
		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hello", plain )
		f->DrawText( 1, 2, "world", fancy )
		f->FillRect( TuiRectOf( 0, 4, 40, 1 ), "-", plain )
		dim as string first = scr.Render( TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( len( first ) > 0 )

		'' second frame: identical -> nothing at all
		f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hello", plain )
		f->DrawText( 1, 2, "world", fancy )
		f->FillRect( TuiRectOf( 0, 4, 40, 1 ), "-", plain )
		CU_ASSERT_EQUAL( len( scr.Render( TUIDEPTH_TRUECOLOR ) ), 0 )

		'' and again, to prove the swap left front == back
		f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hello", plain )
		f->DrawText( 1, 2, "world", fancy )
		f->FillRect( TuiRectOf( 0, 4, 40, 1 ), "-", plain )
		CU_ASSERT_EQUAL( len( scr.Render( TUIDEPTH_TRUECOLOR ) ), 0 )
	END_TEST

	'' RFC-0003 section 5. The other half of the gate: a one-cell change emits
	'' ONE cursor move and ONE cell, and nothing else.
	TEST( rfc0003_s5_one_cell_change_emits_one_move_and_one_cell )
		dim as TuiScreen scr
		scr.Resize( 40, 6 )
		dim as TuiStyle plain = TuiStyleDefault( )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hello", plain )
		scr.Render( TUIDEPTH_TRUECOLOR )

		f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hallo", plain )
		dim as string got = scr.Render( TUIDEPTH_TRUECOLOR )

		'' exactly one cursor-position sequence
		dim as long moves = 0
		for i as long = 1 to len( got )
			if( mid( got, i, 1 ) = "H" ) then moves += 1
		next
		CU_ASSERT_EQUAL( moves, 1 )

		'' addressed to row 2, column 3 (1-based), which is buffer (2,1)
		CU_ASSERT_TRUE( instr( got, chr( 27 ) & "[2;3H" ) > 0 )

		'' and it carries the one changed character
		CU_ASSERT_TRUE( instr( got, "a" ) > 0 )
		CU_ASSERT_FALSE( instr( got, "hallo" ) > 0 )

		'' no SGR at all: the style did not change
		CU_ASSERT_FALSE( instr( got, "m" ) > 0 )
	END_TEST

	'' RFC-0003 section 5. Style state is carried ACROSS runs, so a row of
	'' cells sharing one style pays for the SGR once, not per cell. This is
	'' where most of the byte reduction actually comes from.
	TEST( rfc0003_s5_sgr_state_is_carried_across_cells )
		dim as TuiScreen scr
		scr.Resize( 40, 2 )
		dim as TuiStyle fancy = TuiStyleOf( TuiRgb( 10, 200, 30 ), TuiDefaultColor( ) )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 0, 0, "aaaaaaaaaaaaaaaaaaaa", fancy )
		dim as string got = scr.Render( TUIDEPTH_TRUECOLOR )

		'' the truecolour foreground appears exactly ONCE for twenty cells
		dim as long n = 0, at_ = 1
		do
			at_ = instr( at_, got, "38;2;10;200;30" )
			if( at_ = 0 ) then exit do
			n += 1
			at_ += 1
		loop
		CU_ASSERT_EQUAL( n, 1 )
	END_TEST

	'' RFC-0003 section 6. Invalidate forces a full repaint, which is what a
	'' resize and a fresh Enter both require.
	TEST( rfc0003_s6_invalidate_forces_a_full_repaint )
		dim as TuiScreen scr
		scr.Resize( 20, 3 )
		dim as TuiStyle plain = TuiStyleDefault( )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 0, 0, "hello", plain )
		scr.Render( TUIDEPTH_TRUECOLOR )

		'' unchanged -> zero
		f = scr.BeginFrame( )
		f->DrawText( 0, 0, "hello", plain )
		CU_ASSERT_EQUAL( len( scr.Render( TUIDEPTH_TRUECOLOR ) ), 0 )

		'' invalidated -> everything, starting with a clear
		scr.Invalidate( )
		f = scr.BeginFrame( )
		f->DrawText( 0, 0, "hello", plain )
		dim as string got = scr.Render( TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( len( got ) > 0 )
		CU_ASSERT_TRUE( instr( got, chr( 27 ) & "[2J" ) > 0 )

		'' a resize implies an invalidate
		scr.Resize( 25, 4 )
		f = scr.BeginFrame( )
		f->DrawText( 0, 0, "hello", plain )
		CU_ASSERT_TRUE( len( scr.Render( TUIDEPTH_TRUECOLOR ) ) > 0 )
	END_TEST

	'' RFC-0003 section 4. A layer never widens the clip, and the stack is
	'' bounded -- a ninth PushLayer is a no-op rather than unbounded growth.
	TEST( rfc0003_s4_layers_are_clipped_and_bounded )
		dim as TuiScreen scr
		scr.Resize( 20, 6 )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		f->PushLayer( TuiRectOf( 5, 1, 8, 3 ) )
		CU_ASSERT_EQUAL( f->Clip( ).x, 5 )
		CU_ASSERT_EQUAL( f->Clip( ).w, 8 )

		'' overflow the stack; the extra pushes must not fault
		for i as long = 1 to TUI_MAX_LAYERS + 4
			f->PushLayer( TuiRectOf( 0, 0, 20, 6 ) )
		next
		for i as long = 1 to TUI_MAX_LAYERS + 4
			f->PopLayer( )
		next
		f->PopLayer( )

		'' popped back to the full area
		CU_ASSERT_EQUAL( f->Clip( ).w, 20 )
	END_TEST

	'' RFC-0003 section 3. BlendStyle patches style and leaves text alone --
	'' this is what "dim the background behind a modal" is.
	TEST( rfc0003_s3_blendstyle_keeps_the_text )
		dim as TuiScreen scr
		scr.Resize( 10, 2 )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		f->DrawText( 0, 0, "abcdef", plain )
		f->BlendStyle( TuiRectOf( 0, 0, 10, 1 ), _
		               TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
		                              TUIATTR_DIM, TUIATTR_DIM ) )

		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, "a" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 5, 0 )->text, "f" )
		CU_ASSERT_TRUE ( scr.Back( )->At( 0, 0 )->st.HasAttr( TUIATTR_DIM ) )
	END_TEST

	'' RFC-0003 section 7. A frame where nobody called SetCursor leaves the
	'' cursor hidden -- the right default for a dashboard, and the reason the
	'' call is per-frame rather than per-terminal.
	TEST( rfc0003_s7_cursor_is_off_unless_a_widget_asks )
		dim as TuiScreen scr
		scr.Resize( 20, 3 )
		dim as TuiStyle plain = TuiStyleDefault( )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 0, 0, "x", plain )
		CU_ASSERT_FALSE( f->CursorVisible( ) )
		dim as string a = scr.Render( TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( instr( a, chr( 27 ) & "[?25l" ) > 0 )

		f = scr.BeginFrame( )
		f->DrawText( 0, 0, "y", plain )
		f->SetCursor( 4, 2 )
		CU_ASSERT_TRUE( f->CursorVisible( ) )
		dim as string b = scr.Render( TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( instr( b, chr( 27 ) & "[3;5H" ) > 0 )
		CU_ASSERT_TRUE( instr( b, chr( 27 ) & "[?25h" ) > 0 )
	END_TEST

	'' A 1x1 terminal, and a 1-column one. These are the shapes that turn a
	'' clamped-versus-negative bug into a crash, and they are cheap to hold.
	TEST( rfc0003_degenerate_sizes_do_not_crash )
		for w as long = 1 to 3
			for h as long = 1 to 3
				dim as TuiScreen scr
				scr.Resize( w, h )
				dim as TuiStyle plain = TuiStyleDefault( )
				dim as TuiFrame ptr f = scr.BeginFrame( )

				f->DrawText( 0, 0, "hello world", plain )
				f->FillRect( TuiRectOf( 0, 0, w, h ), "#", plain )
				dim as ustring wide = " "
				wide[0] = &h4E2D
				f->DrawText( 0, 0, wide, plain )
				scr.Render( TUIDEPTH_TRUECOLOR )

				CU_ASSERT_EQUAL( scr.Cols( ), w )
				CU_ASSERT_EQUAL( scr.Rows( ), h )
			next
		next
	END_TEST

	'' RFC-0003 section 5. SGR STATE IS CARRIED ACROSS FRAMES, not just across
	'' runs within one.
	''
	'' This was a real bug, reported from a running program: moving a list
	'' selection down left the DESELECTED row still highlighted. The renderer
	'' assumed the terminal began every frame in the default style, so when the
	'' deselected row's style happened to equal that assumed default it emitted
	'' NO SGR at all -- and the terminal was still in the reverse video the
	'' previous frame had left it in.
	''
	'' A buffer dump cannot catch this: the cells were always correct. The test
	'' has to REPLAY THE EMITTED BYTES and track what the terminal would
	'' actually be showing.
	TEST( rfc0003_s5_sgr_state_carries_across_frames )
		dim as TuiStyle plain = TuiStyleDefault( )
		dim as TuiStyle rev = TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
		                                     TUIATTR_REVERSE, TUIATTR_REVERSE )

		dim as TuiScreen scr
		scr.Resize( 8, 5 )

		dim as boolean termReverse = FALSE
		dim as long curRow = 0
		dim as long mismatched = 0

		'' walk a "selection" down the rows, one frame per position
		for sel as long = 0 to 4
			dim as TuiFrame ptr f = scr.BeginFrame( )
			for row as long = 0 to 4
				dim as TuiStyle st = iif( row = sel, rev, plain )
				f->FillRect( TuiRectOf( 0, row, 8, 1 ), " ", st )
				f->DrawText( 0, row, "r" & str( row ), st )
			next
			dim as string b = scr.Render( TUIDEPTH_TRUECOLOR )

			'' replay: track cursor row and the reverse flag, and check every
			'' text byte lands with the reverse state its row should have
			dim as long i = 1
			while( i <= len( b ) )
				if( asc( b, i ) = 27 ) then
					dim as long j = i + 2
					dim as string params_
					while( ( j <= len( b ) ) andalso _
					       ( instr( "0123456789;?", mid( b, j, 1 ) ) > 0 ) )
						params_ &= mid( b, j, 1 )
						j += 1
					wend
					dim as string fin = mid( b, j, 1 )
					if( fin = "m" ) then
						if( ( params_ = "0" ) orelse ( len( params_ ) = 0 ) ) then termReverse = FALSE
						if( instr( params_, "7" ) > 0 ) then termReverse = TRUE
						if( instr( params_, "27" ) > 0 ) then termReverse = FALSE
					elseif( fin = "H" ) then
						dim as long semi = instr( params_, ";" )
						if( semi > 1 ) then curRow = valint( left( params_, semi - 1 ) ) - 1
					end if
					i = j + 1
				else
					dim as boolean want = ( curRow = sel )
					if( termReverse <> want ) then mismatched += 1
					i += 1
				end if
			wend
		next

		'' Before the fix this was 60. Any leak at all fails.
		CU_ASSERT_EQUAL( mismatched, 0 )
	END_TEST

	'' Invalidate must also forget the carried SGR state, because whatever
	'' invalidated the screen may have written to the terminal itself.
	TEST( rfc0003_s6_invalidate_forgets_the_sgr_state )
		dim as TuiStyle rev = TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
		                                     TUIATTR_REVERSE, TUIATTR_REVERSE )
		dim as TuiScreen scr
		scr.Resize( 6, 2 )

		'' leave the terminal in reverse
		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 0, 0, "aaa", rev )
		CU_ASSERT_TRUE( instr( scr.Render( TUIDEPTH_TRUECOLOR ), "7m" ) > 0 )

		'' an invalidated frame re-establishes the style explicitly
		scr.Invalidate( )
		f = scr.BeginFrame( )
		f->DrawText( 0, 0, "aaa", rev )
		dim as string b = scr.Render( TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( instr( b, chr( 27 ) & "[0m" ) > 0 )
		CU_ASSERT_TRUE( instr( b, "7m" ) > 0 )
	END_TEST

END_SUITE
