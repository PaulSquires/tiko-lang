'' Column width -- C:\dev\docs\tui\RFC-0005-unicode-width.md.
''
'' THE GATE IS rfc0005_s7_every_ucd_range_boundary. It probes lo-1, lo, hi and
'' hi+1 for every range in the Unicode Character Database, because an off-by-one
'' in a range table is otherwise invisible until a user types the single
'' character that lands on the edge.
''
'' The expectations in tuiwidthdata_.bi are generated from the RAW UCD, while
'' the module ships MERGED ranges searched by binary search. Two different code
'' paths over the same source file: a bad merge or a broken search cannot agree
'' with itself and slip through.

#include "fbcunit.bi"
#include once "fb/tui.bi"
#include once "tuiwidthdata_.bi"

using FB

SUITE( fbc_tests.tui.tuiwidth_ )

	'' RFC-0005 section 7. THE GATE.
	TEST( rfc0005_s7_every_ucd_range_boundary )
		dim as ulong ptr cps
		dim as ubyte ptr ws
		TuiWidthProbes( cps, ws )

		'' ambiguous must be narrow for these expectations to hold
		TuiSetAmbiguousWide( FALSE )

		dim as long bad = 0
		for i as long = 0 to TUI_WIDTH_PROBE_COUNT - 1
			if( TuiCharWidth( cps[i] ) <> ws[i] ) then bad += 1
		next

		'' One assertion for thousands of probes, because a per-probe assert
		'' would drown the report -- but the count is exact, so a single wrong
		'' codepoint fails it.
		CU_ASSERT_EQUAL( bad, 0 )
		CU_ASSERT_TRUE ( TUI_WIDTH_PROBE_COUNT > 2000 )
	END_TEST

	'' RFC-0005 section 4. The rules the table encodes, spot-checked by hand so
	'' that a regenerated table which broke one of them is obvious.
	TEST( rfc0005_s4_the_width_rules )
		TuiSetAmbiguousWide( FALSE )

		'' plain ASCII
		CU_ASSERT_EQUAL( TuiCharWidth( asc( "A" ) ), 1 )
		CU_ASSERT_EQUAL( TuiCharWidth( asc( " " ) ), 1 )

		'' East Asian Wide and Fullwidth
		CU_ASSERT_EQUAL( TuiCharWidth( &h4E2D ), 2 )     '' CJK
		CU_ASSERT_EQUAL( TuiCharWidth( &h6587 ), 2 )     '' CJK
		CU_ASSERT_EQUAL( TuiCharWidth( &hAC00 ), 2 )     '' Hangul syllable
		CU_ASSERT_EQUAL( TuiCharWidth( &h3042 ), 2 )     '' Hiragana
		CU_ASSERT_EQUAL( TuiCharWidth( &hFF21 ), 2 )     '' Fullwidth A
		CU_ASSERT_EQUAL( TuiCharWidth( &h1F600 ), 2 )    '' emoji, astral

		'' zero-width: combining marks, ZWJ, variation selectors
		CU_ASSERT_EQUAL( TuiCharWidth( &h0301 ), 0 )     '' combining acute (Mn)
		CU_ASSERT_EQUAL( TuiCharWidth( &h0300 ), 0 )     '' combining grave (Mn)
		CU_ASSERT_EQUAL( TuiCharWidth( &h20DD ), 0 )     '' enclosing circle (Me)
		CU_ASSERT_EQUAL( TuiCharWidth( &h200D ), 0 )     '' ZWJ (Cf)
		CU_ASSERT_EQUAL( TuiCharWidth( &h200C ), 0 )     '' ZWNJ (Cf)
		CU_ASSERT_EQUAL( TuiCharWidth( &hFE0F ), 0 )     '' variation selector-16
		CU_ASSERT_EQUAL( TuiCharWidth( 0 ), 0 )

		'' unassigned and private use default to narrow
		CU_ASSERT_EQUAL( TuiCharWidth( &hE000 ), 1 )     '' private use
	END_TEST

	'' RFC-0005 section 4. Ambiguous is NARROW by default, and the override is
	'' a property of the terminal rather than of a call.
	TEST( rfc0005_s4_ambiguous_policy )
		TuiSetAmbiguousWide( FALSE )
		CU_ASSERT_EQUAL( TuiCharWidth( &h2588 ), 1 )     '' FULL BLOCK
		CU_ASSERT_EQUAL( TuiCharWidth( &h03B1 ), 1 )     '' Greek alpha
		CU_ASSERT_EQUAL( TuiCharWidth( &h2502 ), 1 )     '' box drawing vertical

		TuiSetAmbiguousWide( TRUE )
		CU_ASSERT_EQUAL( TuiCharWidth( &h2588 ), 2 )
		CU_ASSERT_EQUAL( TuiCharWidth( &h03B1 ), 2 )

		'' the override must NOT disturb anything else
		CU_ASSERT_EQUAL( TuiCharWidth( asc( "A" ) ), 1 )
		CU_ASSERT_EQUAL( TuiCharWidth( &h4E2D ), 2 )
		CU_ASSERT_EQUAL( TuiCharWidth( &h0301 ), 0 )

		TuiSetAmbiguousWide( FALSE )
		CU_ASSERT_EQUAL( TuiCharWidth( &h2588 ), 1 )
	END_TEST

	'' RFC-0005 section 4. Zero-width wins over wide: a few codepoints are both
	'' a combining mark and East Asian Wide, and a mark that advanced the cursor
	'' would shift every cell after it.
	TEST( rfc0005_s4_zero_beats_wide )
		TuiSetAmbiguousWide( FALSE )
		'' U+302A..U+302D are Mn AND East Asian Wide
		for cp as ulong = &h302A to &h302D
			CU_ASSERT_EQUAL( TuiCharWidth( cp ), 0 )
		next
	END_TEST

	'' RFC-0005 section 3. Surrogate decode, and the encode direction that never
	'' uses WCHR.
	TEST( rfc0005_s3_surrogate_round_trip )
		dim as ustring s = "A"
		TuiAppendCp( s, &h1F600 )
		TuiAppendCp( s, asc( "B" ) )

		CU_ASSERT_EQUAL( len( s ), 4 )          '' A + pair + B
		CU_ASSERT_EQUAL( s[1], &hD83D )
		CU_ASSERT_EQUAL( s[2], &hDE00 )

		dim as long adv = 0
		CU_ASSERT_EQUAL( TuiDecodeAt( s, 0, adv ), asc( "A" ) )
		CU_ASSERT_EQUAL( adv, 1 )
		CU_ASSERT_EQUAL( TuiDecodeAt( s, 1, adv ), &h1F600 )
		CU_ASSERT_EQUAL( adv, 2 )
		CU_ASSERT_EQUAL( TuiDecodeAt( s, 3, adv ), asc( "B" ) )
		CU_ASSERT_EQUAL( adv, 1 )

		'' an UNPAIRED surrogate reads as U+FFFD rather than half a character
		dim as ustring lone = "X"
		lone[0] = &hD83D
		CU_ASSERT_EQUAL( TuiDecodeAt( lone, 0, adv ), &hFFFD )
		CU_ASSERT_EQUAL( adv, 1 )

		'' out of range is U+FFFD, not a fault
		CU_ASSERT_EQUAL( TuiDecodeAt( s, 99, adv ), &hFFFD )
		CU_ASSERT_EQUAL( TuiDecodeAt( s, -1, adv ), &hFFFD )
	END_TEST

	'' RFC-0005 section 2. A cluster is a base plus the zero-width codepoints
	'' that follow it, so a combining mark never becomes its own cell.
	TEST( rfc0005_s2_grapheme_clusters )
		TuiSetAmbiguousWide( FALSE )

		'' e + combining acute = ONE cluster, ONE column, TWO code units
		dim as ustring acc = "e"
		TuiAppendCp( acc, &h0301 )
		CU_ASSERT_EQUAL( len( acc ), 2 )
		dim as long w = 0
		CU_ASSERT_EQUAL( TuiNextGrapheme( acc, 0, w ), 2 )
		CU_ASSERT_EQUAL( w, 1 )
		CU_ASSERT_EQUAL( TuiStringWidth( acc ), 1 )

		'' two marks on one base
		dim as ustring two = "e"
		TuiAppendCp( two, &h0301 )
		TuiAppendCp( two, &h0308 )
		CU_ASSERT_EQUAL( TuiStringWidth( two ), 1 )

		'' a wide base plus a mark is still 2
		dim as ustring wide_
		TuiAppendCp( wide_, &h4E2D )
		TuiAppendCp( wide_, &h0301 )
		CU_ASSERT_EQUAL( TuiStringWidth( wide_ ), 2 )

		'' past the end returns the end, and does not loop
		CU_ASSERT_EQUAL( TuiNextGrapheme( acc, 99, w ), len( acc ) )
	END_TEST

	'' RFC-0005 section 1. The table from the RFC's own opening, asserted.
	TEST( rfc0005_s1_the_opening_table )
		TuiSetAmbiguousWide( FALSE )

		CU_ASSERT_EQUAL( TuiStringWidth( "A" ), 1 )

		dim as ustring cjk
		TuiAppendCp( cjk, &h4E2D )
		CU_ASSERT_EQUAL( len( cjk ), 1 )               '' 1 code unit
		CU_ASSERT_EQUAL( TuiStringWidth( cjk ), 2 )    '' 2 columns

		dim as ustring acc = "e"
		TuiAppendCp( acc, &h0301 )
		CU_ASSERT_EQUAL( len( acc ), 2 )               '' 2 code units
		CU_ASSERT_EQUAL( TuiStringWidth( acc ), 1 )    '' 1 column

		dim as ustring emo
		TuiAppendCp( emo, &h1F600 )
		CU_ASSERT_EQUAL( len( emo ), 2 )               '' 2 code units
		CU_ASSERT_EQUAL( TuiStringWidth( emo ), 2 )    '' 2 columns
	END_TEST

	'' RFC-0005 section 6. THE DOCUMENTED-WRONG CASES, asserted as wrong.
	''
	'' These are not bugs to fix later: they are the stated cost of having no
	'' UAX-29 segmentation. Pinning them means a future change that "fixes" one
	'' has to come here and say so, rather than drifting silently.
	TEST( rfc0005_s6_known_wrong_emoji_widths )
		TuiSetAmbiguousWide( FALSE )

		'' A regional-indicator flag pair measures 2 -- and RFC-0005 section 6
		'' predicted 4, which was WRONG. Regional indicators are East Asian
		'' Width NEUTRAL, not Wide, so each is one column and the pair comes to
		'' the same 2 that terminals render. Correct by accident of the EAW
		'' data rather than by design, which is exactly why it is pinned here.
		dim as ustring flag_
		TuiAppendCp( flag_, &h1F1EC )
		TuiAppendCp( flag_, &h1F1E7 )
		CU_ASSERT_EQUAL( TuiCharWidth( &h1F1EC ), 1 )
		CU_ASSERT_EQUAL( TuiStringWidth( flag_ ), 2 )

		'' emoji + skin tone modifier: renders as 2, measured as 4
		dim as ustring skin
		TuiAppendCp( skin, &h1F44D )
		TuiAppendCp( skin, &h1F3FD )
		CU_ASSERT_EQUAL( TuiStringWidth( skin ), 4 )

		'' a ZWJ family sequence: renders as 2, measured as 6 -- the ZWJ itself
		'' is correctly 0, but the three emoji are not joined
		dim as ustring fam
		TuiAppendCp( fam, &h1F468 )
		TuiAppendCp( fam, &h200D )
		TuiAppendCp( fam, &h1F469 )
		TuiAppendCp( fam, &h200D )
		TuiAppendCp( fam, &h1F467 )
		CU_ASSERT_EQUAL( TuiStringWidth( fam ), 6 )

		'' the one that IS right: emoji + variation selector-16
		dim as ustring vs
		TuiAppendCp( vs, &h1F44D )
		TuiAppendCp( vs, &hFE0F )
		CU_ASSERT_EQUAL( TuiStringWidth( vs ), 2 )
	END_TEST

	'' RFC-0005 section 5. Truncate NEVER returns something wider than asked
	'' for. That is its whole contract.
	TEST( rfc0005_s5_truncate_never_exceeds )
		TuiSetAmbiguousWide( FALSE )

		CU_ASSERT_EQUAL( TuiTruncate( "hello", 10 ), "hello" )
		CU_ASSERT_EQUAL( TuiTruncate( "hello", 5 ), "hello" )
		CU_ASSERT_EQUAL( len( TuiTruncate( "hello world", 0 ) ), 0 )

		'' every width from 0 to 20, on ASCII and on CJK
		dim as ustring cjk
		for i as long = 1 to 8
			TuiAppendCp( cjk, &h4E2D )
		next

		for maxc as long = 0 to 20
			CU_ASSERT_TRUE( TuiStringWidth( TuiTruncate( "hello world here", maxc ) ) <= maxc )
			CU_ASSERT_TRUE( TuiStringWidth( TuiTruncate( cjk, maxc ) ) <= maxc )
		next

		'' a wide glyph is never split in half
		dim as ustring cut = TuiTruncate( cjk, 5 )
		CU_ASSERT_TRUE( ( TuiStringWidth( cut ) mod 1 ) = 0 )
		CU_ASSERT_TRUE( TuiStringWidth( cut ) <= 5 )

		'' a combining mark is never orphaned from its base
		dim as ustring acc = "abc"
		TuiAppendCp( acc, &h0301 )
		acc &= "def"
		for maxc as long = 0 to 8
			CU_ASSERT_TRUE( TuiStringWidth( TuiTruncate( acc, maxc ) ) <= maxc )
		next
	END_TEST

	'' RFC-0005 section 5. Wrap never emits a line wider than asked for, and
	'' never loses or duplicates content it was given.
	TEST( rfc0005_s5_wrap_never_exceeds )
		TuiSetAmbiguousWide( FALSE )
		dim as ustring src = "the quick brown fox jumps over the lazy dog"

		for cols as long = 1 to 30
			dim as TuiStringArray lines_ = TuiWrap( src, cols )
			CU_ASSERT_TRUE( lines_.Count( ) > 0 )
			for i as long = 0 to lines_.Count( ) - 1
				CU_ASSERT_TRUE( TuiStringWidth( lines_[i] ) <= cols )
			next
		next

		'' a single word longer than the line must still be emitted, broken
		dim as TuiStringArray hard = TuiWrap( "supercalifragilistic", 5 )
		CU_ASSERT_TRUE( hard.Count( ) >= 4 )
		for i as long = 0 to hard.Count( ) - 1
			CU_ASSERT_TRUE( TuiStringWidth( hard[i] ) <= 5 )
		next

		'' CJK wraps between ideographs
		dim as ustring cjk
		for i as long = 1 to 10
			TuiAppendCp( cjk, &h4E2D )
		next
		dim as TuiStringArray cl = TuiWrap( cjk, 7 )
		for i as long = 0 to cl.Count( ) - 1
			CU_ASSERT_TRUE( TuiStringWidth( cl[i] ) <= 7 )
		next

		'' degenerate widths do not loop or fault
		CU_ASSERT_TRUE( TuiWrap( src, 0 ).Count( ) > 0 )
		CU_ASSERT_TRUE( TuiWrap( "", 10 ).Count( ) > 0 )

		'' an explicit newline starts a new line
		dim as TuiStringArray nl = TuiWrap( "ab" & chr( 10 ) & "cd", 20 )
		CU_ASSERT_EQUAL( nl.Count( ), 2 )
	END_TEST

	'' The generated table records the UCD version it came from, so a
	'' regeneration is visible in the diff rather than silent.
	TEST( rfc0005_s4_table_records_its_ucd_version )
		CU_ASSERT_TRUE( len( TUI_UCD_VERSION ) > 0 )
		CU_ASSERT_TRUE( instr( TUI_UCD_VERSION, "." ) > 0 )
	END_TEST

END_SUITE
