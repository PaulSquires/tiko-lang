'' The gas64 peephole that fuses a spill and its reload.
''
'' OPTIMIZATION 3-1 in ir-gas64.bas collapses
''
''      movss -76[rbp], xmm0        '' spill
''      movss xmm2, -76[rbp]        '' reload somewhere else
''
'' into a single register-to-register move.  The rule assumed the reload's
'' destination was a GENERAL register, so it chose `movd` -- and `movd` has no
'' xmm,xmm form.  The assembler rejected the whole file with
''
''      Error: operand type mismatch for `movd'
''
'' which is a build failure, not a wrong answer, so nothing downstream could
'' have caught it.  The 64-bit case survived only by luck: `movq xmm,xmm` does
'' exist, so DOUBLE never broke and only SINGLE did.
''
'' Reaching it needs a single spilled and immediately reloaded into ANOTHER xmm,
'' which is what a float comparison right after a float operation produces.  IIF
'' over two computed singles is the shortest form: both arms are live across the
'' compare, so both get spilled.
''
'' The tests below assert VALUES and not just that the file assembles, because a
'' fused move of the wrong width would still assemble and quietly move 64 bits
'' where 32 were meant.

#include "fbcunit.bi"

'' Out of line so the operands are genuinely computed rather than folded.
private function ratio_( byval a as long, byval b as long ) as single
	function = csng( a ) / csng( b )
end function

private function scaled_( byval a as long, byval b as long ) as single
	function = csng( a ) * csng( b )
end function

SUITE( fbc_tests.optimizations.gas64_xmm_spill_reload )

	'' The original repro: IIF over two SINGLE variables holding computed
	'' values.  Before the fix this file did not assemble at all.
	TEST( iif_over_computed_singles )
		dim as long w = 30, i = 20, h = 30, j = 10

		dim as single sx = ratio_( w, i )        ''  1.5
		dim as single sy = ratio_( h, j )        ''  3.0
		dim as single s  = iif( sx < sy, sx, sy )
		CU_ASSERT( s = 1.5f )

		'' And the other way round, so the branch not taken above is taken here.
		dim as single t_ = iif( sy < sx, sy, sx )
		CU_ASSERT( t_ = 1.5f )

		'' Equal operands: the compare must not pick a third answer.
		dim as single sz = ratio_( w, i )
		CU_ASSERT( iif( sx < sz, sx, sz ) = 1.5f )
	END_TEST

	'' The operator does not matter -- multiply reaches the same peephole.
	TEST( iif_over_computed_singles_mul )
		dim as single a = scaled_( 3, 4 )        ''  12
		dim as single b = scaled_( 2, 5 )        ''  10
		CU_ASSERT( iif( a < b, a, b ) = 10.0f )
		CU_ASSERT( iif( a > b, a, b ) = 12.0f )
	END_TEST

	'' DOUBLE went through the same rule and happened to survive it, because
	'' movq xmm,xmm is a real instruction.  Pinned so a later tidy-up of that
	'' branch cannot break the case that used to work.
	TEST( iif_over_computed_doubles )
		dim as double a = cdbl( 30 ) / cdbl( 20 )
		dim as double b = cdbl( 30 ) / cdbl( 10 )
		CU_ASSERT( iif( a < b, a, b ) = 1.5 )
		CU_ASSERT( iif( a > b, a, b ) = 3.0 )
	END_TEST

	'' The IF/ELSE form always worked.  It is here so that if the fix is ever
	'' reverted, the suite says clearly that IIF is the difference and not
	'' single arithmetic in general.
	TEST( if_else_form_still_agrees )
		dim as single sx = ratio_( 30, 20 )
		dim as single sy = ratio_( 30, 10 )
		dim as single viaIf
		if sx < sy then viaIf = sx else viaIf = sy
		CU_ASSERT( viaIf = iif( sx < sy, sx, sy ) )
	END_TEST

	'' The same spill/reload shape without IIF: a single computed, stored, then
	'' compared against another computed single.
	TEST( compare_after_arithmetic )
		dim as single a = ratio_( 22, 7 )
		dim as single b = ratio_( 355, 113 )
		CU_ASSERT( a > b )
		CU_ASSERT( ( b < a ) = ( a > b ) )

		dim as single hyp = sqr( ratio_( 9, 1 ) + ratio_( 16, 1 ) )
		CU_ASSERT( hyp = 5.0f )
		CU_ASSERT( hyp > ratio_( 49, 10 ) )
	END_TEST

	'' A move of the wrong WIDTH would still assemble.  A single whose bit
	'' pattern has a non-zero low half catches a 64-bit move that dragged in
	'' whatever was next to it.
	TEST( fused_move_keeps_the_value_exact )
		dim as single tiny_ = ratio_( 1, 3 )
		dim as single same_ = ratio_( 1, 3 )
		CU_ASSERT( tiny_ = same_ )
		CU_ASSERT( iif( tiny_ < same_, tiny_, same_ ) = tiny_ )

		'' Round-trip through the bit pattern: a 64-bit fused move would not
		'' preserve this.
		dim as ulong bits_ = 0
		dim as single back_ = 0
		bits_ = *cptr( ulong ptr, @tiny_ )
		back_ = *cptr( single ptr, @bits_ )
		CU_ASSERT( back_ = tiny_ )
	END_TEST

END_SUITE
