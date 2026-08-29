'' basic.bas -- fb_StrLen and fb_ASC.
''
'' fb_LEFT and fb_RIGHT began here and now live in slice.bas; they were split out
'' so the two halves can be merged into the gate independently, after a Linux
'' failure had to be bisected to a module.
''
'' Written probe-first. PROBE-27 and PROBE-29 between them pinned three contracts
'' that would otherwise have been guesses:
''
'' 1. fb_ASC IS 1-BASED, AND POSITION 0 RETURNS 0 -- not the first character. So
''    does a position past the end, an empty string, and a NULL descriptor.
''
'' 2. fb_StrLen USES THE **FIX** ARGUMENT DECODING, NOT DYN. Given a
''    `zstring * 12` holding "abcdef" it answers 6, not 11 -- the last branch
''    measures with strlen rather than taking size - 1. RFC-0002 section 4 says
''    the two macros differ in exactly that branch; this is what decides which.
''
'' 3. BOTH CONSUME A TEMPORARY OPERAND. The tell is in fbc's own object: a
''    dependency on fb_hStrDelTemp, which str_len.o and str_asc.o both carry.
''    Omitting the release is a LEAK, not a wrong answer, and it is invisible
''    until the 256-entry pool runs dry somewhere else entirely.
''
#include once "inc/descriptors.bi"

extern "rtlib"
	'' Declared under a local name: fbc reserves fb_hStrDelTemp in its
	'' rtlLookupTB table with its own signature, so redeclaring it verbatim is a
	'' type mismatch at the call site -- the same reservation that forces every
	'' definition in this project to be `tkort_X alias "fb_X"`.
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" _
		( byval s as FBSTRING ptr ) as long
end extern

extern "rtlib"

function tkort_StrLen alias "fb_StrLen" _
	( byval s as any ptr, byval strsize as integer ) as integer

	dim as zstring ptr p = any
	dim as integer n = any

	FB_STRSETUP_FIX( s, strsize, p, n )

	'' CONSUMES A TEMPORARY OPERAND (PROBE-29) -- but only when `s` is a var-len
	'' descriptor, which is the only argument form that can carry the temp bit.
	'' A fixed-length buffer or a zstring pointer is not ours to release.
	'' CALL DelTemp UNCONDITIONALLY -- do NOT pre-filter on the temp bit.
	''
	'' fb_hStrDelTemp already decides all three cases correctly: it frees the
	'' data only when the temp bit says the temporary owns it, releases the pool
	'' slot only when the descriptor came from the pool, and answers -1 without
	'' touching anything otherwise.
	''
	'' Gating on FB_ISTEMP here looks safer and leaks: `asc(z)` and `len(z)` on a
	'' fixed zstring reach fb_StrAllocTempDescZ, which hands out a POOL
	'' descriptor whose data points at the literal and whose temp bit is CLEAR
	'' (PROBE-17). Skipping the release strands that slot, and the 256-entry pool
	'' runs dry -- 1,384 assertion failures across UDT_ZSTRING, nowhere near here.
	if( (s <> 0) andalso (strsize = FB_STRSIZEVARLEN) ) then
		tkrt_DelTemp( cptr( FBSTRING ptr, s ) )
	end if

	return n

end function

'' 1-based. Position 0, a position past the end, an empty string and a NULL
'' descriptor all answer 0.
function tkort_ASC alias "fb_ASC" _
	( byval s as FBSTRING ptr, byval idx as integer ) as ulong

	'' CONSUMES A TEMPORARY OPERAND (PROBE-29), like fb_LEFT, fb_RIGHT and
	'' fb_StrLen. So the value is computed first and the source released on
	'' EVERY exit path, including the ones that answer 0 -- an early `return 0`
	'' for an out-of-range position would leak the descriptor just as surely as
	'' forgetting the release entirely.
	if( s = 0 ) then return 0

	dim as ulong result = 0

	dim as zstring ptr p = s->data
	dim as integer n = FB_STRSIZE( s )

	'' NOTE: the parameter is `idx`, not `pos` -- POS is a FreeBASIC keyword
	'' (the cursor column) and is error 4 as a parameter name, exactly as
	'' PRESERVE was in fb_hStrRealloc.
	''
	'' And the byte is read VIA ubyte ptr, not zstring ptr: indexing a
	'' `zstring ptr` in FreeBASIC yields a one-character STRING, so
	'' `cast( ulong, p[i] )` converts that string numerically and answers 0 for
	'' every letter. The symptom was fb_ASC returning 0 for every valid position
	'' while fb_LEFT and fb_RIGHT -- using the same pointer -- were correct.
	if( (p <> 0) andalso (idx >= 1) andalso (idx <= n) ) then
		result = cast( ulong, cptr( ubyte ptr, p )[idx - 1] )
	end if

	'' CALL DelTemp UNCONDITIONALLY -- do NOT pre-filter on the temp bit.
	''
	'' fb_hStrDelTemp already decides all three cases correctly: it frees the
	'' data only when the temp bit says the temporary owns it, releases the pool
	'' slot only when the descriptor came from the pool, and answers -1 without
	'' touching anything otherwise.
	''
	'' Gating on FB_ISTEMP here looks safer and leaks: `asc(z)` and `len(z)` on a
	'' fixed zstring reach fb_StrAllocTempDescZ, which hands out a POOL
	'' descriptor whose data points at the literal and whose temp bit is CLEAR
	'' (PROBE-17). Skipping the release strands that slot, and the 256-entry pool
	'' runs dry -- 1,384 assertion failures across UDT_ZSTRING, nowhere near here.
	tkrt_DelTemp( s )
	return result

end function

end extern
