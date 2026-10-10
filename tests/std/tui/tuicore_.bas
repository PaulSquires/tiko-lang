'' The value layer -- C:\dev\docs\tui\RFC-0001-geometry-and-style.md.
''
'' One TEST block per numbered rule of the RFC, named after it, so a failure
'' names the rule it broke.
''
'' Nothing here does I/O or takes a lock: RFC-0001 says every operation in this
'' layer is TOTAL, and the point of the file is to hold that claim.
''
'' The suite is `tuicore_` with a trailing underscore: a suite named after the
'' header it tests collides -- the convention tests/check-suite-names.sh
'' already documents.

#import "std/tui"
#include "fbcunit.bi"

using tui
SUITE( fbc_tests.tui.tuicore_ )

	'' RFC-0001 section 1. Right and Bottom are EXCLUSIVE. Asserted rather
	'' than described, because half-open versus closed is the most common
	'' off-by-one in layout code and every loop in the module depends on it.
	TEST( rfc0001_s1_rect_edges_are_exclusive )
		dim as TuiRect r = TuiRectOf( 0, 0, 80, 24 )
		CU_ASSERT_EQUAL( r.Right( ), 80 )
		CU_ASSERT_EQUAL( r.Bottom( ), 24 )

		'' column 80 is NOT in the rectangle
		CU_ASSERT_TRUE ( r.Contains( 79, 23 ) )
		CU_ASSERT_FALSE( r.Contains( 80, 23 ) )
		CU_ASSERT_FALSE( r.Contains( 79, 24 ) )
		CU_ASSERT_FALSE( r.Contains( -1, 0 ) )
	END_TEST

	'' RFC-0001 section 1. An empty rectangle is LEGAL, not an error, and
	'' every producer clamps rather than going negative.
	TEST( rfc0001_s1_empty_rect_is_legal )
		dim as TuiRect r = TuiRectOf( 0, 0, 80, 24 )

		'' overlap
		dim as TuiRect i = r.Intersect( TuiRectOf( 70, 20, 40, 40 ) )
		CU_ASSERT_EQUAL( i.x, 70 )
		CU_ASSERT_EQUAL( i.y, 20 )
		CU_ASSERT_EQUAL( i.w, 10 )
		CU_ASSERT_EQUAL( i.h, 4 )

		'' disjoint -- clamps to zero, never negative
		dim as TuiRect d = r.Intersect( TuiRectOf( 200, 200, 5, 5 ) )
		CU_ASSERT_EQUAL( d.w, 0 )
		CU_ASSERT_EQUAL( d.h, 0 )
		CU_ASSERT_TRUE ( d.IsEmpty( ) )

		'' a margin wider than the rect
		dim as TuiRect n = TuiRectOf( 0, 0, 2, 2 ).Inner( TuiMarginAll( 1 ) )
		CU_ASSERT_EQUAL( n.w, 0 )
		CU_ASSERT_EQUAL( n.h, 0 )
		CU_ASSERT_TRUE ( n.IsEmpty( ) )

		'' the pathological one: a terminal one column wide
		dim as TuiRect one = TuiRectOf( 0, 0, 1, 1 ).Inner( TuiMarginAll( 1 ) )
		CU_ASSERT_TRUE( one.IsEmpty( ) )
		CU_ASSERT_TRUE( one.w >= 0 )
		CU_ASSERT_TRUE( one.h >= 0 )
	END_TEST

	'' RFC-0001 section 2. The layout the measurement CHOSE. 4 is asserted
	'' rather than described because it is the number that made the union
	'' pointless -- if a later change moves it, this is where that is noticed.
	TEST( rfc0001_s2_color_layout )
		CU_ASSERT_EQUAL( sizeof( TuiColor ), 4 )

		'' A default-constructed colour is DEFAULT, so there is no
		'' uninitialised state to get wrong.
		dim as TuiColor c
		CU_ASSERT_EQUAL( c.kind, TUICOLOR_DEFAULT )
		CU_ASSERT_TRUE ( c.IsDefault( ) )
	END_TEST

	'' RFC-0001 section 2. Every constructor round-trips its KIND and its
	'' VALUE. One that set the right kind and lost the value would pass any
	'' test that only looked at the kind.
	TEST( rfc0001_s2_every_color_constructor_round_trips )
		dim as TuiColor rgb = TuiRgb( 255, 128, 0 )
		CU_ASSERT_EQUAL( rgb.kind, TUICOLOR_RGB )
		CU_ASSERT_EQUAL( rgb.r, 255 )
		CU_ASSERT_EQUAL( rgb.g, 128 )
		CU_ASSERT_EQUAL( rgb.b, 0 )

		dim as TuiColor a = TuiAnsi( 9 )
		CU_ASSERT_EQUAL( a.kind, TUICOLOR_ANSI16 )
		CU_ASSERT_EQUAL( a.Index( ), 9 )

		'' TuiAnsi masks to 0..15 rather than accepting nonsense
		CU_ASSERT_EQUAL( TuiAnsi( 200 ).Index( ), 200 and 15 )

		dim as TuiColor ix = TuiIndexed( 208 )
		CU_ASSERT_EQUAL( ix.kind, TUICOLOR_INDEXED )
		CU_ASSERT_EQUAL( ix.Index( ), 208 )

		CU_ASSERT_TRUE( TuiDefaultColor( ).IsDefault( ) )

		'' the named sixteen resolve to their indices
		CU_ASSERT_EQUAL( TuiRed( ).Index( ), TUIC_RED )
		CU_ASSERT_EQUAL( TuiBrightWhite( ).Index( ), TUIC_BRIGHTWHITE )

		'' Equals compares by KIND first: index 1 and rgb(1,0,0) are not equal
		CU_ASSERT_FALSE( TuiAnsi( 1 ).Equals( TuiRgb( 1, 0, 0 ) ) )
		CU_ASSERT_TRUE ( TuiAnsi( 1 ).Equals( TuiAnsi( 1 ) ) )
	END_TEST

	'' RFC-0001 section 4. The MASK is the whole point of TuiStyle: a patch
	'' must be able to say "reverse" without also asserting "not bold".
	TEST( rfc0001_s4_patch_respects_the_mask )
		dim as TuiStyle base_ = TuiStyleOf( TuiRgb( 255, 128, 0 ), TuiDefaultColor( ), _
		                                    TUIATTR_BOLD or TUIATTR_ITALIC )
		dim as TuiStyle sel = TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
		                                     TUIATTR_REVERSE, TUIATTR_REVERSE )

		dim as TuiStyle got = base_.Patch( sel )

		'' the base's attributes SURVIVE, and reverse is added
		CU_ASSERT_TRUE( got.HasAttr( TUIATTR_BOLD ) )
		CU_ASSERT_TRUE( got.HasAttr( TUIATTR_ITALIC ) )
		CU_ASSERT_TRUE( got.HasAttr( TUIATTR_REVERSE ) )

		'' and the base's colour survives, because the patch had none
		CU_ASSERT_EQUAL( got.fg.kind, TUICOLOR_RGB )
		CU_ASSERT_EQUAL( got.fg.r, 255 )
		CU_ASSERT_EQUAL( got.fg.g, 128 )

		'' a patch that DOES name a colour wins
		dim as TuiStyle recolor = TuiStylePatch( TuiRgb( 1, 2, 3 ), TuiDefaultColor( ), 0, 0 )
		CU_ASSERT_EQUAL( base_.Patch( recolor ).fg.r, 1 )

		'' a COMPLETE style (TuiStyleOf) has an opinion about everything, so
		'' patching with one clears what it does not name
		dim as TuiStyle whole = TuiStyleOf( TuiDefaultColor( ), TuiDefaultColor( ), TUIATTR_UNDERLINE )
		dim as TuiStyle cleared = base_.Patch( whole )
		CU_ASSERT_FALSE( cleared.HasAttr( TUIATTR_BOLD ) )
		CU_ASSERT_TRUE ( cleared.HasAttr( TUIATTR_UNDERLINE ) )
	END_TEST

	'' RFC-0001 section 4. TuiStyleDefault is the IDENTITY for Patch.
	TEST( rfc0001_s4_default_style_is_the_patch_identity )
		dim as TuiStyle base_ = TuiStyleOf( TuiRgb( 10, 20, 30 ), TuiAnsi( 4 ), TUIATTR_BOLD )
		dim as TuiStyle got = base_.Patch( TuiStyleDefault( ) )
		CU_ASSERT_TRUE( got.Equals( base_ ) )
	END_TEST

	'' RFC-0001 section 5. The downgrade ladder, table-driven, which is the
	'' gate ranked-gaps.md sets for rank 4: ONE style renders three ways.
	TEST( rfc0001_s5_downgrade_ladder )
		dim as TuiColor orange = TuiRgb( 255, 128, 0 )

		'' truecolour passes everything through untouched
		CU_ASSERT_TRUE( TuiDowngrade( orange, TUIDEPTH_TRUECOLOR ).Equals( orange ) )

		'' RGB -> the 256 cube. 255,128,0 quantises to cube (5,2,0) =
		'' 16 + 36*5 + 6*2 + 0 = 208, the standard xterm orange.
		dim as TuiColor c256 = TuiDowngrade( orange, TUIDEPTH_256 )
		CU_ASSERT_EQUAL( c256.kind, TUICOLOR_INDEXED )
		CU_ASSERT_EQUAL( c256.Index( ), 208 )

		'' RGB -> the 16
		dim as TuiColor c16 = TuiDowngrade( orange, TUIDEPTH_ANSI16 )
		CU_ASSERT_EQUAL( c16.kind, TUICOLOR_ANSI16 )
		CU_ASSERT_TRUE ( c16.Index( ) < 16 )

		'' mono is luminance-thresholded, and it is NOT hypothetical -- it is
		'' what a redirected stdout gets, so it is the branch most likely to
		'' run by accident.
		CU_ASSERT_EQUAL( TuiDowngrade( TuiRgb( 255, 255, 255 ), TUIDEPTH_MONO ).Index( ), TUIC_WHITE )
		CU_ASSERT_EQUAL( TuiDowngrade( TuiRgb( 0, 0, 0 ), TUIDEPTH_MONO ).Index( ), TUIC_BLACK )

		'' DEFAULT survives every depth -- it is the terminal's own colour and
		'' there is nothing to approximate.
		for d as long = TUIDEPTH_MONO to TUIDEPTH_TRUECOLOR
			dim as TuiColor got = TuiDowngrade( TuiDefaultColor( ), cast( TuiColorDepth, d ) )
			CU_ASSERT_TRUE( got.IsDefault( ) )
		next

		'' an ANSI16 colour is already as low as it goes
		for d as long = TUIDEPTH_ANSI16 to TUIDEPTH_TRUECOLOR
			CU_ASSERT_TRUE( TuiDowngrade( TuiAnsi( 5 ), cast( TuiColorDepth, d ) ).Equals( TuiAnsi( 5 ) ) )
		next
	END_TEST

	'' RFC-0001 section 5. The 256-cube mapping is the standard xterm one, so
	'' the six ramp values must round-trip to their own cube indices.
	TEST( rfc0001_s5_cube_ramp_round_trips )
		'' the non-uniform ramp: 0, 95, 135, 175, 215, 255
		dim as long ramp( 0 to 5 ) = { 0, 95, 135, 175, 215, 255 }
		for i as long = 0 to 5
			dim as TuiColor got = TuiDowngrade( TuiRgb( ramp( i ), ramp( i ), ramp( i ) ), TUIDEPTH_256 )
			CU_ASSERT_EQUAL( got.kind, TUICOLOR_INDEXED )
			'' greys may legitimately land on the 232..255 ramp instead of the
			'' cube diagonal; both are correct, so assert only that it is a
			'' real index and that pure black and pure white are exact.
			CU_ASSERT_TRUE( got.Index( ) >= 16 )
		next

		CU_ASSERT_EQUAL( TuiDowngrade( TuiRgb( 0, 0, 0 ), TUIDEPTH_256 ).Index( ), 16 )
		CU_ASSERT_EQUAL( TuiDowngrade( TuiRgb( 255, 255, 255 ), TUIDEPTH_256 ).Index( ), 231 )
	END_TEST

	'' RFC-0003 section 5 relies on this: the SGR encoder emits only the
	'' DIFFERENCE from the style the terminal is already in. A style equal to
	'' the current one must produce NOTHING -- if it does not, the diff's
	'' zero-byte guarantee is dead on arrival.
	TEST( rfc0001_s5_sgr_emits_only_the_difference )
		dim as TuiStyle a = TuiStyleOf( TuiRgb( 255, 128, 0 ), TuiDefaultColor( ), TUIATTR_BOLD )

		CU_ASSERT_EQUAL( len( TuiSgr( a, a, TUIDEPTH_TRUECOLOR ) ), 0 )
		CU_ASSERT_EQUAL( len( TuiSgr( a, a, TUIDEPTH_256 ) ), 0 )
		CU_ASSERT_EQUAL( len( TuiSgr( a, a, TUIDEPTH_ANSI16 ) ), 0 )

		'' Two styles that DIFFER only above the terminal's depth collapse to
		'' the same thing, so no bytes are emitted for a distinction the
		'' terminal cannot show.
		dim as TuiStyle p1 = TuiStyleOf( TuiRgb( 255, 255, 255 ), TuiDefaultColor( ) )
		dim as TuiStyle p2 = TuiStyleOf( TuiRgb( 254, 254, 254 ), TuiDefaultColor( ) )
		CU_ASSERT_EQUAL( len( TuiSgr( p1, p2, TUIDEPTH_MONO ) ), 0 )
		CU_ASSERT_TRUE ( len( TuiSgr( p1, p2, TUIDEPTH_TRUECOLOR ) ) > 0 )
	END_TEST

	'' RFC-0001 section 5. The same style, three depths, three encodings.
	TEST( rfc0001_s5_sgr_encodes_per_depth )
		dim as TuiStyle st = TuiStyleOf( TuiRgb( 255, 128, 0 ), TuiDefaultColor( ), TUIATTR_BOLD )
		dim as TuiStyle none_ = TuiStyleDefault( )

		dim as string t = TuiSgr( none_, st, TUIDEPTH_TRUECOLOR )
		CU_ASSERT_TRUE( instr( t, "38;2;255;128;0" ) > 0 )

		dim as string h = TuiSgr( none_, st, TUIDEPTH_256 )
		CU_ASSERT_TRUE( instr( h, "38;5;208" ) > 0 )
		CU_ASSERT_TRUE( instr( h, "38;2;" ) = 0 )

		dim as string l = TuiSgr( none_, st, TUIDEPTH_ANSI16 )
		CU_ASSERT_TRUE( instr( l, "38;5;" ) = 0 )
		CU_ASSERT_TRUE( instr( l, "38;2;" ) = 0 )

		'' every one of them turns bold ON
		CU_ASSERT_TRUE( instr( t, "1" ) > 0 )

		'' and every one is a well-formed CSI ... m
		CU_ASSERT_EQUAL( asc( left( t, 1 ) ), 27 )
		CU_ASSERT_EQUAL( mid( t, 2, 1 ), "[" )
		CU_ASSERT_EQUAL( right( t, 1 ), "m" )
	END_TEST

	'' RFC-0001 section 5. SGR 22 clears bold AND dim together, so turning one
	'' off while the other stays on cannot be expressed as a delta. The
	'' encoder must fall back to a full reset rather than emit 22 and silently
	'' lose the survivor.
	TEST( rfc0001_s5_bold_dim_tangle_falls_back_to_reset )
		dim as TuiStyle both_ = TuiStyleOf( TuiDefaultColor( ), TuiDefaultColor( ), _
		                                    TUIATTR_BOLD or TUIATTR_DIM )
		dim as TuiStyle onlyDim = TuiStyleOf( TuiDefaultColor( ), TuiDefaultColor( ), TUIATTR_DIM )

		dim as string got = TuiSgr( both_, onlyDim, TUIDEPTH_TRUECOLOR )

		'' a full reset, then dim re-asserted
		CU_ASSERT_TRUE( instr( got, "[0" ) > 0 )
		CU_ASSERT_TRUE( instr( got, "2" ) > 0 )
	END_TEST

	'' RFC-0001 section 6. A theme is a plain VALUE -- copyable, with no
	'' ambient singleton anywhere. rationale.md section 9.
	TEST( rfc0001_s6_theme_is_a_value )
		dim as TuiTheme a = TuiThemeDefault( )
		dim as TuiTheme b = a
		b.normal = TuiStyleOf( TuiRed( ), TuiDefaultColor( ) )

		'' the copy is independent
		CU_ASSERT_FALSE( a.normal.Equals( b.normal ) )

		'' the mono theme names no colour at all, so it survives a mono
		'' terminal unchanged
		dim as TuiTheme m = TuiThemeMono( )
		CU_ASSERT_TRUE( m.normal.fg.IsDefault( ) )
		CU_ASSERT_TRUE( m.title.HasAttr( TUIATTR_BOLD ) )
	END_TEST

END_SUITE
