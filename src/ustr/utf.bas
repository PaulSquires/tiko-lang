'' utf.bas -- ustr_utf.o: the four codecs and fb_hUStrCodepointAt.
''
'' THE AREA RFC-0004 SECTION 3.3 NAMED AS THE ONE THAT COULD STOP THE PROJECT.
'' Section 6 put it plainly: if the unicode group is still out of budget after
'' the #macro and pointer-width-index treatment, that is the finding that should
'' stop the port rather than one to work around.
''
'' One archive member, five entry points, and no undefined symbols at all --
'' fbc's ustr_utf.o calls neither libc nor the rest of the runtime. That makes it
'' the cleanest possible test of code generation: pure computation, with no
'' allocator policy underneath it to confound the measurement the way
'' str_concat's did.
''
'' NOT FBCALL. These are declared without it in fb_ustring.h and nm agrees --
'' win32 exports them as _fb_hUtf8ToUtf16 with no @N. So EXTERN "c", with the
'' marker lint.sh requires (RFC-0002 section 2.3).
''
'' =========================================================== THE CONTRACT
''
'' fb_ustring.h states two things: snprintf-like semantics ("writes at most
'' dst_units/dst_bytes and returns the count it WOULD have written, so a caller
'' may pass dst == NULL to measure exactly"), and that a lone surrogate yields
'' U+FFFD consuming one unit. Everything below that was measured -- PROBE-34,
'' PROBE-35, PROBE-36.
''
'' 1. THE TERMINATOR SITS AT dst[min(need, capacity)] -- ONE PAST THE CAPACITY.
''
''    This is NOT snprintf. snprintf writes at most size-1 characters and puts
''    the NUL inside the buffer; these write up to `capacity` units and then
''    terminate at index `capacity`. Measured:
''
''        u8->16  cap=2 of 3   ->  41 42 00 CCCC     terminator at [2]
''        u8->16  cap=3 of 3   ->  41 42 43 00       terminator at [3]
''        u16->8  cap=0        ->  00                written through a non-NULL dst
''
''    So a caller must supply capacity + 1. Reading "snprintf semantics" as
''    literally snprintf's, and reserving the last slot, would be a one-unit
''    buffer overrun in every caller -- the sort that only shows up in someone
''    else's program.
''
'' 2. TRUNCATION IS UNIT-EXACT, NOT CHARACTER-ALIGNED.
''
''        u32->16 cap=2, needs 4  ->  41 D83D 00     a surrogate PAIR, split
''        u16->8  cap=2, needs 4  ->  E2 82 00       a 3-byte char, split
''
''    The output is cut mid-character and terminated there. No rounding down to
''    a boundary, and the return value is still the full requirement.
''
'' 3. ILL-FORMED UTF-8 FOLLOWS THE UNICODE "MAXIMAL SUBPART" RULE.
''
''    One U+FFFD per maximal subpart of an ill-formed subsequence -- not one per
''    byte, and not one per attempted character. Those differ, and the probes
''    pin which:
''
''        E2 82 41      ->  FFFD 0041          (2 units, not 3)
''        C3 41         ->  FFFD 0041
''        F0 9F 41      ->  FFFD 0041
''        E2 82 <end>   ->  FFFD               (1 unit for 2 bytes)
''        C0 AF         ->  FFFD FFFD
''        C1 BF         ->  FFFD FFFD
''        E0 80 AF      ->  FFFD FFFD FFFD
''        ED A0 80      ->  FFFD FFFD FFFD
''        F0 82 82 AC   ->  FFFD FFFD FFFD FFFD
''        F4 90 80 80   ->  FFFD FFFD FFFD FFFD
''
''    The last four are what make the rule identifiable. Each has a VALID lead
''    byte and is rejected on the SECOND byte, because the acceptable range for
''    byte 2 is narrower than 80..BF for four lead bytes:
''
''        E0  ->  A0..BF     (rejects overlong 3-byte forms)
''        ED  ->  80..9F     (rejects encoded surrogates)
''        F0  ->  90..BF     (rejects overlong 4-byte forms)
''        F4  ->  80..8F     (rejects beyond U+10FFFF)
''
''    Rejecting at byte 2 makes the maximal subpart the lead byte ALONE, so the
''    bytes after it are each a stray continuation worth one U+FFFD apiece.
''
''    An implementation that decoded first and range-checked the result would
''    emit ONE U+FFFD for `F0 82 82 AC` where fbc emits four. Same validity
''    verdict, different output LENGTH -- and length is what the caller
''    allocated against.
''
'' 4. A codepoint index at or past the end answers 0 with units_used = 1, not 0.
''
'' No .c body was opened (PROVENANCE.md). The decode table is the Unicode
'' standard's; the probes are what say fbc implements it.

#include once "inc/descriptors.bi"

'' U+FFFD REPLACEMENT CHARACTER.
const TKORT_REPL as ulong = &hFFFD

'' Surrogate ranges, named rather than repeated: D800..DBFF high, DC00..DFFF low.
#define TKORT_IS_HIGH_SURROGATE( u )  ( ((u) >= &hD800) andalso ((u) <= &hDBFF) )
#define TKORT_IS_LOW_SURROGATE( u )   ( ((u) >= &hDC00) andalso ((u) <= &hDFFF) )
#define TKORT_IS_SURROGATE( u )       ( ((u) >= &hD800) andalso ((u) <= &hDFFF) )

'' ============================================================ UTF-8 decode
''
'' THE DECODER IS INLINE, and that is the point of this module.
''
'' It began as a `private function` called once per character, which is the
'' obvious structure and reads far better. Measured that way against the clang
'' baseline:
''
''     u8to16_measure   1.78x      u8to16_ascii   1.48x
''     u8to16_bmp       1.43x      u8to16_illformed 1.61x
''
'' failing both halves of the R5 budget on its own. C declares its helpers
'' `static __inline__` and clang folds them in; fbc has no inliner, so a helper
'' called per character is a real call per character. RFC-0004 section 3.3 named
'' precisely this, in precisely this area, before any code was written.
''
'' The early returns become a `bad` flag rather than a #macro, because a macro
'' cannot contain the returns and fbc's macro argument parser rejects the nested
'' parenthesised expressions the encoder needs anyway (see fb_hUtf16ToUtf8).
'' RFC-0003 section 5.2 offers #macro as THE mitigation for the missing inliner;
'' where it does not fit, the fallback is to write the code out at the one call
'' site, and that is a real cost of the language for a runtime this shape.

extern "c"  '' NON-FBCALL -- no @N on win32, confirmed by nm over the archive.

function tkort_hUtf8ToUtf16 alias "fb_hUtf8ToUtf16" _
	( _
		byval src as ubyte ptr, byval src_bytes as integer, _
		byval dst as ushort ptr, byval dst_units as integer _
	) as integer

	dim as integer i = 0
	dim as integer n = 0          '' units the answer WOULD occupy

	'' THE CAPACITY, WITH THE NULL TEST FOLDED IN. `dst = 0` is LOOP-INVARIANT
	'' and fbc-modern will not hoist it: written as the natural
	''
	''     if( dst <> 0 ) then
	''         if( n < dst_units ) then dst[n] = ...
	''
	'' it emits `test/setne/cmp/setl/and/cmp/jne` -- SIX instructions per
	'' character, if-converted rather than branched -- where clang hoists the
	'' invariant and leaves `cmp/jge`, two. Measured directly, with a two-function
	'' probe that differs in nothing else (RFC-0004 5.9).
	''
	'' Setting the capacity to ZERO when there is no buffer makes `n < cap` false
	'' for every n, so the store is skipped without a second test and `dst[n]` is
	'' never evaluated. One comparison per character, and the behaviour is
	'' identical: measure mode still counts, fill mode still truncates at
	'' dst_units.
	dim as integer cap = 0
	if( dst <> 0 ) then cap = dst_units
	dim as integer used = 0
	dim as ulong cp = 0
	dim as ubyte lead = any, b = any, lo = any, hi = any, lo2 = any, hi2 = any
	dim as integer extra = any, k = any, bad = any
	dim as ushort hi_ = any, lo_ = any

	do while( i < src_bytes )
		lead = src[i]

		'' ASCII, THE OVERWHELMINGLY COMMON CASE, HANDLED COMPLETELY AND LEFT.
		''
		'' This emits and CONTINUES rather than falling through to the shared
		'' tail below, which is what fbc's C does (`UEMIT(b0); i += 1;
		'' continue;`). The tail is written for the general case: it re-tests
		'' `cp < &h10000`, adds a VARIABLE `used` to `i`, and carries `cp`
		'' through a register move -- none of which an ASCII byte needs, since
		'' its codepoint can never reach the surrogate range and its width is
		'' always one.
		''
		'' MEASURED, not assumed. Sharing the tail cost about eleven extra
		'' instructions per character in the measure-only path -- 20 against
		'' clang's 9 -- and `u8to16_measure` ran at 1.71x. See RFC-0004 5.9.
		if( lead < &h80 ) then
			if( n < cap ) then dst[n] = cast( ushort, lead )
			n += 1
			i += 1
			continue do
		else
			extra = 0
			lo2 = &h80
			hi2 = &hBF

			'' The narrowed second-byte ranges are the whole trick: they reject
			'' overlong forms, encoded surrogates and anything past U+10FFFF at
			'' BYTE 2, where the maximal subpart is still just the lead.
			select case as const lead
			case &hC2 to &hDF
				extra = 1 : cp = lead and &h1F
			case &hE0
				extra = 2 : cp = lead and &h0F : lo2 = &hA0
			case &hE1 to &hEC
				extra = 2 : cp = lead and &h0F
			case &hED
				extra = 2 : cp = lead and &h0F : hi2 = &h9F
			case &hEE to &hEF
				extra = 2 : cp = lead and &h0F
			case &hF0
				extra = 3 : cp = lead and &h07 : lo2 = &h90
			case &hF1 to &hF3
				extra = 3 : cp = lead and &h07
			case &hF4
				extra = 3 : cp = lead and &h07 : hi2 = &h8F
			case else
				'' 80..C1 and F5..FF are never a lead byte. One byte, one U+FFFD.
				extra = -1
			end select

			if( extra < 0 ) then
				cp = TKORT_REPL
				used = 1
			else
				k = 0
				bad = 0
				do while( k < extra )
					'' Running off the end is the same as a bad byte: the subpart is
					'' everything accepted so far, worth exactly one U+FFFD.
					if( i + 1 + k >= src_bytes ) then
						bad = 1
						exit do
					end if

					b = src[i + 1 + k]
					lo = &h80
					hi = &hBF
					if( k = 0 ) then
						lo = lo2
						hi = hi2
					end if

					'' Two nested tests rather than one ORELSE chain: mixing a boolean
					'' and a non-boolean operand in ANDALSO/ORELSE is fbc warning 38.
					if( b < lo ) then
						bad = 1
						exit do
					end if
					if( b > hi ) then
						bad = 1
						exit do
					end if

					cp = (cp shl 6) or (b and &h3F)
					k += 1
				loop

				if( bad <> 0 ) then
					cp = TKORT_REPL
					used = 1 + k
				else
					used = 1 + extra
				end if
			end if
		end if

		i += used

		if( cp < &h10000 ) then
			if( n < cap ) then dst[n] = cast( ushort, cp )
			n += 1
		else
			'' A supplementary codepoint becomes a surrogate pair, and the pair is
			'' SPLIT if the capacity falls between its two units (PROBE-36).
			cp -= &h10000
			hi_ = cast( ushort, &hD800 + (cp shr 10) )
			lo_ = cast( ushort, &hDC00 + (cp and &h3FF) )
			if( n     < cap ) then dst[n]     = hi_
			if( n + 1 < cap ) then dst[n + 1] = lo_
			n += 2
		end if
	loop

	'' The terminator goes ONE PAST the data, at min(need, capacity) -- outside
	'' the stated capacity, so the caller's buffer must be capacity + 1.
	if( dst <> 0 ) then
		if( n < dst_units ) then dst[n] = 0 else dst[dst_units] = 0
	end if

	return n

end function

'' ======================================================= UTF-16 -> UTF-8
function tkort_hUtf16ToUtf8 alias "fb_hUtf16ToUtf8" _
	( _
		byval src as ushort ptr, byval src_units as integer, _
		byval dst as ubyte ptr, byval dst_bytes as integer _
	) as integer

	dim as integer i = 0
	dim as integer n = 0
	dim as ulong cp = 0
	dim as ushort u = any
	dim as ubyte e0 = any, e1 = any, e2 = any, e3 = any

	'' The bytes are written STRAIGHT OUT, one branch per length.
	''
	'' The first version staged them in a 4-byte local array and emitted with a
	'' loop, which is tidier and measured 1.51x on u16to8_bmp. The array index is
	'' a loop variable, so SROA cannot scalarise it and every byte made a real
	'' store and load. Writing each branch out costs eleven copies of the capacity
	'' test and buys back the difference.
	''
	'' A #macro would have said it once -- but a macro argument containing a
	'' nested parenthesised subexpression, `PUT( &h80 or ((cp shr 6) and &h3F) )`,
	'' is error 16 in fbc. RFC-0003 section 5.2 leans on #macro as the mitigation
	'' for fbc having no inliner, so the limits of its argument parsing are a
	'' limit on that mitigation, and this is where it was hit.

	do while( i < src_units )
		u = src[i]

		if( TKORT_IS_HIGH_SURROGATE( u ) ) then
			'' A high surrogate makes a pair only if a low one follows IN RANGE.
			'' Otherwise it is a lone surrogate: U+FFFD, one unit consumed.
			if( i + 1 < src_units ) then
				if( TKORT_IS_LOW_SURROGATE( src[i + 1] ) ) then
					cp = &h10000 + ((cast( ulong, u ) - &hD800) shl 10) _
					              + (cast( ulong, src[i + 1] ) - &hDC00)
					i += 2
				else
					cp = TKORT_REPL : i += 1
				end if
			else
				cp = TKORT_REPL : i += 1
			end if
		elseif( TKORT_IS_LOW_SURROGATE( u ) ) then
			cp = TKORT_REPL : i += 1
		else
			cp = u : i += 1
		end if

		if( cp < &h80 ) then
			if( dst <> 0 ) then
				if( n < dst_bytes ) then dst[n] = cast( ubyte, cp )
			end if
			n += 1
		elseif( cp < &h800 ) then
			e0 = cast( ubyte, &hC0 or (cp shr 6) )
			e1 = cast( ubyte, &h80 or (cp and &h3F) )
			if( dst <> 0 ) then
				if( n     < dst_bytes ) then dst[n]     = e0
				if( n + 1 < dst_bytes ) then dst[n + 1] = e1
			end if
			n += 2
		elseif( cp < &h10000 ) then
			e0 = cast( ubyte, &hE0 or (cp shr 12) )
			e1 = cast( ubyte, &h80 or ((cp shr 6) and &h3F) )
			e2 = cast( ubyte, &h80 or (cp and &h3F) )
			if( dst <> 0 ) then
				if( n     < dst_bytes ) then dst[n]     = e0
				if( n + 1 < dst_bytes ) then dst[n + 1] = e1
				if( n + 2 < dst_bytes ) then dst[n + 2] = e2
			end if
			n += 3
		else
			e0 = cast( ubyte, &hF0 or (cp shr 18) )
			e1 = cast( ubyte, &h80 or ((cp shr 12) and &h3F) )
			e2 = cast( ubyte, &h80 or ((cp shr 6) and &h3F) )
			e3 = cast( ubyte, &h80 or (cp and &h3F) )
			if( dst <> 0 ) then
				if( n     < dst_bytes ) then dst[n]     = e0
				if( n + 1 < dst_bytes ) then dst[n + 1] = e1
				if( n + 2 < dst_bytes ) then dst[n + 2] = e2
				if( n + 3 < dst_bytes ) then dst[n + 3] = e3
			end if
			n += 4
		end if
	loop

	if( dst <> 0 ) then
		if( n < dst_bytes ) then dst[n] = 0 else dst[dst_bytes] = 0
	end if

	return n

end function

'' ====================================================== UTF-32 -> UTF-16
function tkort_hUtf32ToUtf16 alias "fb_hUtf32ToUtf16" _
	( _
		byval src as ulong ptr, byval src_units as integer, _
		byval dst as ushort ptr, byval dst_units as integer _
	) as integer

	dim as integer i = 0
	dim as integer n = 0
	dim as ulong cp = any

	do while( i < src_units )
		cp = src[i]
		i += 1

		'' Beyond U+10FFFF, or a surrogate VALUE arriving in UTF-32, is
		'' ill-formed and becomes one U+FFFD -- measured: 110000 and D800 both.
		if( cp > &h10FFFF ) then
			cp = TKORT_REPL
		elseif( TKORT_IS_SURROGATE( cp ) ) then
			cp = TKORT_REPL
		end if

		if( cp < &h10000 ) then
			if( dst <> 0 ) then
				if( n < dst_units ) then dst[n] = cast( ushort, cp )
			end if
			n += 1
		else
			cp -= &h10000
			if( dst <> 0 ) then
				if( n < dst_units ) then dst[n] = cast( ushort, &hD800 + (cp shr 10) )
			end if
			n += 1
			if( dst <> 0 ) then
				if( n < dst_units ) then dst[n] = cast( ushort, &hDC00 + (cp and &h3FF) )
			end if
			n += 1
		end if
	loop

	if( dst <> 0 ) then
		if( n < dst_units ) then dst[n] = 0 else dst[dst_units] = 0
	end if

	return n

end function

'' ====================================================== UTF-16 -> UTF-32
function tkort_hUtf16ToUtf32 alias "fb_hUtf16ToUtf32" _
	( _
		byval src as ushort ptr, byval src_units as integer, _
		byval dst as ulong ptr, byval dst_units as integer _
	) as integer

	dim as integer i = 0
	dim as integer n = 0
	dim as ulong cp = any
	dim as ushort u = any

	do while( i < src_units )
		u = src[i]

		if( TKORT_IS_HIGH_SURROGATE( u ) ) then
			if( i + 1 < src_units ) then
				if( TKORT_IS_LOW_SURROGATE( src[i + 1] ) ) then
					cp = &h10000 + ((cast( ulong, u ) - &hD800) shl 10) _
					              + (cast( ulong, src[i + 1] ) - &hDC00)
					i += 2
				else
					cp = TKORT_REPL : i += 1
				end if
			else
				cp = TKORT_REPL : i += 1
			end if
		elseif( TKORT_IS_LOW_SURROGATE( u ) ) then
			cp = TKORT_REPL : i += 1
		else
			cp = u : i += 1
		end if

		if( dst <> 0 ) then
			if( n < dst_units ) then dst[n] = cp
		end if
		n += 1
	loop

	if( dst <> 0 ) then
		if( n < dst_units ) then dst[n] = 0 else dst[dst_units] = 0
	end if

	return n

end function

'' ==================================================== fb_hUStrCodepointAt
''
'' A lone surrogate yields U+FFFD and consumes 1 -- stated in fb_ustring.h.
'' An index at or past the end answers 0 with units_used = 1, NOT 0 (PROBE-34).
'' A caller advancing by units_used therefore still makes progress and cannot
'' spin, which is presumably the reason.
function tkort_hUStrCodepointAt alias "fb_hUStrCodepointAt" _
	( _
		byval src as ushort ptr, byval ln as integer, byval i as integer, _
		byval units_used as integer ptr _
	) as ulong

	if( units_used <> 0 ) then *units_used = 1

	if( src = 0 ) then return 0
	if( i < 0 ) then return 0
	if( i >= ln ) then return 0

	dim as ushort u = src[i]

	if( TKORT_IS_HIGH_SURROGATE( u ) ) then
		if( i + 1 < ln ) then
			if( TKORT_IS_LOW_SURROGATE( src[i + 1] ) ) then
				if( units_used <> 0 ) then *units_used = 2
				return &h10000 + ((cast( ulong, u ) - &hD800) shl 10) _
				                + (cast( ulong, src[i + 1] ) - &hDC00)
			end if
		end if
		return TKORT_REPL
	end if

	if( TKORT_IS_LOW_SURROGATE( u ) ) then return TKORT_REPL

	return cast( ulong, u )

end function

end extern
