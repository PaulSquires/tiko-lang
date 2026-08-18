'' WCHR and UTF-16 surrogates -- the same answer on every target.
''
'' THE BUG THIS PINS
''
''     dim as ustring b = wchr( &hD83D, &hDE00 )
''
''     win64          len=2  D83D DE00     -- correct, U+1F600
''     linux-x86_64   len=2  FFFD FFFD     -- WRONG, and silent
''
'' WSTRING is wchar_t-width. On Windows those two arguments ARE the two UTF-16
'' code units of U+1F600 and reach the ustring untouched. On Linux the wstring
'' is UTF-32, so each half arrives at the wstring -> ustring conversion as a
'' lone surrogate SCALAR -- not a valid scalar value -- and hWcharToUnits()
'' replaced each one with U+FFFD before it ever reached the ustring. A correct
'' surrogate pair was destroyed on the way in, with no diagnostic, on one target
'' only.
''
'' THE RESOLUTION
''
'' wstring -> ustring now passes D800-DFFF through instead of replacing it. The
'' destination is an array of UTF-16 code units and a surrogate is exactly what
'' one holds; unlike a scalar above U+10FFFF, nothing is unrepresentable. That
'' also matches what Windows has always done, and what direct code-unit
'' assignment (u[0] = &hD83D) already did on BOTH targets.
''
'' The boundary did not move: a lone surrogate still becomes U+FFFD when the
'' text is ENCODED -- to UTF-8, or to a 32-bit wstring -- because those are the
'' representations that genuinely cannot hold it. Asserted below, both ways.
''
'' Every assertion here is target-independent except the two in
'' lone_surrogate_to_wstring_is_lossy_at_32bit, which branch on the actual
'' wchar width and state BOTH documented outcomes rather than skipping.

#include "fbcunit.bi"

SUITE( fbc_tests.string_.wchr_surrogate )

	'' U+1F600 GRINNING FACE. Spelled three ways on purpose; the point of the
	'' suite is that they agree.
	#define HI_SUR &hD83D
	#define LO_SUR &hDE00
	#define ASTRAL_CP &h1F600

	private function wcharBytes( ) as integer
		'' sizeof( wstring * 2 ) is 2 * sizeof( wchar_t ): 4 on Windows, 8 on
		'' Linux. Used only to state the documented per-target outcome, never
		'' to excuse a difference.
		dim as wstring * 2 w
		return sizeof( w ) \ 2
	end function

	TEST( pair_from_two_constant_halves )
		'' THE REGRESSION. Constant arguments are folded by cStrCHR() into a
		'' wstring literal, so this is the compile-time path.
		dim as ustring b = wchr( HI_SUR, LO_SUR )

		CU_ASSERT_EQUAL( len( b ), 2 )
		CU_ASSERT_EQUAL( b[0], &hD83D )
		CU_ASSERT_EQUAL( b[1], &hDE00 )
	END_TEST

	TEST( pair_from_two_runtime_halves )
		'' Non-constant arguments take rtlStrChr() and the runtime conversion
		'' instead. Both paths were broken on Linux; both must be fixed.
		dim as ulong hi = HI_SUR, lo = LO_SUR
		dim as ustring b = wchr( hi, lo )

		CU_ASSERT_EQUAL( len( b ), 2 )
		CU_ASSERT_EQUAL( b[0], &hD83D )
		CU_ASSERT_EQUAL( b[1], &hDE00 )
	END_TEST

	TEST( pair_from_astral_scalar )
		'' This one always worked -- on Linux the scalar is a valid UTF-32 char
		'' and the conversion splits it into a pair. It is here so a future
		'' change cannot fix the halves by breaking the whole.
		dim as ustring b = wchr( ASTRAL_CP )

		CU_ASSERT_EQUAL( len( b ), 2 )
		CU_ASSERT_EQUAL( b[0], &hD83D )
		CU_ASSERT_EQUAL( b[1], &hDE00 )
	END_TEST

	TEST( all_four_spellings_agree )
		'' Source literal, astral scalar, two halves, and direct code-unit
		'' assignment must produce one identical ustring. Direct assignment was
		'' already correct on both targets, so it is the reference the other
		'' three are measured against.
		dim as ustring viaUnits = "AB"
		viaUnits[0] = HI_SUR
		viaUnits[1] = LO_SUR

		dim as ustring viaLiteral = "😀"
		dim as ustring viaScalar  = wchr( ASTRAL_CP )
		dim as ustring viaHalves  = wchr( HI_SUR, LO_SUR )

		CU_ASSERT_EQUAL( len( viaUnits ), 2 )
		CU_ASSERT_EQUAL( viaLiteral, viaUnits )
		CU_ASSERT_EQUAL( viaScalar, viaUnits )
		CU_ASSERT_EQUAL( viaHalves, viaUnits )

		'' compared on CONTENT too, so two equally-wrong values cannot pass
		CU_ASSERT_EQUAL( viaHalves[0], &hD83D )
		CU_ASSERT_EQUAL( viaHalves[1], &hDE00 )
	END_TEST

	TEST( pair_encodes_to_utf8 )
		'' Proof the units really are the character and not just the right
		'' numbers: U+1F600 is F0 9F 98 80. If either half were U+FFFD this
		'' would be EF BF BD EF BF BD -- six bytes, not four.
		dim as ustring b = wchr( HI_SUR, LO_SUR )
		dim as string s = b

		CU_ASSERT_EQUAL( len( s ), 4 )
		CU_ASSERT_EQUAL( s[0], &hF0 )
		CU_ASSERT_EQUAL( s[1], &h9F )
		CU_ASSERT_EQUAL( s[2], &h98 )
		CU_ASSERT_EQUAL( s[3], &h80 )
	END_TEST

	TEST( pair_survives_a_ustring_wstring_round_trip )
		'' A WELL-FORMED pair round-trips on both targets: on Linux it collapses
		'' to one 32-bit char and expands back to the same two units.
		dim as ustring orig = wchr( HI_SUR, LO_SUR )
		dim as wstring * 8 w = orig
		dim as ustring back = w

		CU_ASSERT_EQUAL( len( back ), 2 )
		CU_ASSERT_EQUAL( back, orig )
		CU_ASSERT_EQUAL( back[0], &hD83D )
		CU_ASSERT_EQUAL( back[1], &hDE00 )
	END_TEST

	TEST( lone_surrogate_reaches_the_ustring )
		'' A single half on its own is ill-formed Unicode, but it IS a code
		'' unit, so it is stored rather than replaced -- identically on every
		'' target. Anything else and the pair case above could not work, since
		'' the conversion sees the halves one at a time.
		dim as ustring hi = wchr( HI_SUR )
		CU_ASSERT_EQUAL( len( hi ), 1 )
		CU_ASSERT_EQUAL( hi[0], &hD83D )

		dim as ustring lo = wchr( LO_SUR )
		CU_ASSERT_EQUAL( len( lo ), 1 )
		CU_ASSERT_EQUAL( lo[0], &hDE00 )

		'' and the halves concatenate into the character
		dim as ustring joined = hi & lo
		CU_ASSERT_EQUAL( len( joined ), 2 )
		CU_ASSERT_EQUAL( joined, wchr( ASTRAL_CP ) )
	END_TEST

	TEST( lone_surrogate_to_utf8_is_the_replacement_char )
		'' THE DOCUMENTED BOUNDARY, and it is the same on every target: UTF-8
		'' has no encoding for a lone surrogate, so the encoder substitutes
		'' U+FFFD -- EF BF BD. Storing one is allowed; writing one out is not.
		dim as ustring hi = wchr( HI_SUR )
		dim as string s = hi

		CU_ASSERT_EQUAL( len( s ), 3 )
		CU_ASSERT_EQUAL( s[0], &hEF )
		CU_ASSERT_EQUAL( s[1], &hBF )
		CU_ASSERT_EQUAL( s[2], &hBD )
	END_TEST

	TEST( lone_surrogate_to_wstring_is_lossy_at_32bit )
		'' THE ONE REMAINING PER-TARGET DIFFERENCE, stated rather than hidden.
		''
		'' Going the other way, ustring -> wstring, a 32-bit wstring holds UTF-32
		'' SCALARS and is handed on to libc and the OS, which reject D800-DFFF.
		'' So a lone surrogate becomes U+FFFD there, while a 16-bit wstring --
		'' itself UTF-16 -- keeps it. Only a LONE surrogate is affected; the pair
		'' round-trips everywhere, as asserted above.
		dim as ustring orig = wchr( HI_SUR )
		dim as wstring * 8 w = orig
		dim as ustring back = w

		CU_ASSERT_EQUAL( len( back ), 1 )

		if( wcharBytes( ) = 2 ) then
			'' Windows: wstring is UTF-16, the unit is preserved
			CU_ASSERT_EQUAL( back[0], &hD83D )
		else
			'' Linux: wstring is UTF-32, the unit is not a scalar value
			CU_ASSERT_EQUAL( back[0], &hFFFD )
		end if
	END_TEST

	TEST( non_surrogate_conversion_is_unchanged )
		'' The fix narrowed the replacement rule, so everything it used to catch
		'' apart from surrogates must still be caught, and everything it never
		'' touched must still pass.
		dim as ustring a = wchr( &h41 )          '' ASCII
		CU_ASSERT_EQUAL( len( a ), 1 )
		CU_ASSERT_EQUAL( a[0], &h41 )

		dim as ustring e = wchr( &hE9 )          '' Latin-1
		CU_ASSERT_EQUAL( len( e ), 1 )
		CU_ASSERT_EQUAL( e[0], &hE9 )

		dim as ustring eur = wchr( &h20AC )      '' BMP
		CU_ASSERT_EQUAL( len( eur ), 1 )
		CU_ASSERT_EQUAL( eur[0], &h20AC )

		'' just below the surrogate block, and just above it
		dim as ustring below = wchr( &hD7FF )
		CU_ASSERT_EQUAL( below[0], &hD7FF )
		dim as ustring above = wchr( &hE000 )
		CU_ASSERT_EQUAL( above[0], &hE000 )

		'' the top of the range, still a pair
		dim as ustring maxcp = wchr( &h10FFFF )
		CU_ASSERT_EQUAL( len( maxcp ), 2 )
		CU_ASSERT_EQUAL( maxcp[0], &hDBFF )
		CU_ASSERT_EQUAL( maxcp[1], &hDFFF )
	END_TEST

	TEST( mixed_text_around_a_spelled_out_pair )
		'' The halves must not disturb their neighbours: an off-by-one in the
		'' measure pass would show up here and nowhere else.
		dim as ustring b = "a" & wchr( HI_SUR, LO_SUR ) & "b"

		CU_ASSERT_EQUAL( len( b ), 4 )
		CU_ASSERT_EQUAL( b[0], asc( "a" ) )
		CU_ASSERT_EQUAL( b[1], &hD83D )
		CU_ASSERT_EQUAL( b[2], &hDE00 )
		CU_ASSERT_EQUAL( b[3], asc( "b" ) )

		'' wchr() takes up to 32 arguments; several pairs in one call exercises
		'' the measure/write passes with a count that is not the char count
		dim as ustring m = wchr( &h41, HI_SUR, LO_SUR, &h42, HI_SUR, LO_SUR, &h43 )
		CU_ASSERT_EQUAL( len( m ), 7 )
		CU_ASSERT_EQUAL( m[1], &hD83D )
		CU_ASSERT_EQUAL( m[2], &hDE00 )
		CU_ASSERT_EQUAL( m[4], &hD83D )
		CU_ASSERT_EQUAL( m[5], &hDE00 )
		CU_ASSERT_EQUAL( m, "A😀B😀C" )
	END_TEST

END_SUITE
