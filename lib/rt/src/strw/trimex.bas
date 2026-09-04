'' trimex.bas -- the Ex and Any trim forms: six entry points.
''
''   Any  strip any CHARACTER in the set, from the chosen end(s)
''   Ex   strip a whole PATTERN, repeatedly, from the chosen end(s)
''
'' THE Ex FORMS HAVE A ONE-CHARACTER FAST PATH. A pattern of exactly one
'' character goes through fb_wstr_SkipChar / SkipCharRev; anything longer goes
'' through a repeated wcsncmp. The two produce the same answers, so the split is
'' invisible -- but it is reproduced because the boundary at len_pattern = 1 is
'' where fbc's arithmetic changes, and that is where a divergence would hide.
''
'' A NULL PATTERN IS NOT GUARDED, by fbc or here: fb_wstr_Len( pattern ) is
'' called before any test, so a NULL set faults in wcslen. That is fbc's
'' contract for these six, and adding a guard would make tiko-rt accept programs
'' fbc rejects.
''
'' ============================================ THE OUT-OF-BOUNDS READ IN RTrimEx
''
'' fbc's tail loop decrements test_index by len_pattern with NO LOWER BOUND, and
'' its loop condition (len >= len_pattern) never changes inside the loop. For a
'' source made ENTIRELY of repeated pattern the index goes negative and the
'' comparison reads memory IN FRONT OF THE BUFFER:
''
''     RTRIMW( "abab", "ab" )   test_index: 2 (match), 0 (match), -2 -> reads
''                              src[-2..-1]
''
'' PROBED against fbc's own runtime rather than reasoned about: it survives, the
'' out-of-bounds read does not match, the loop breaks, and the result is NULL.
'' The defined cases are all correct -- RTRIMW("Xabab","ab") -> "X",
'' RTRIMW("abababX","ab") -> unchanged.
''
'' REPRODUCED WITHOUT PERFORMING THE READ. The loop keeps fbc's structure and
'' arithmetic exactly, but a negative index is treated as a NON-MATCH instead of
'' being dereferenced. test_index still lands at -len_pattern, so `len` still
'' comes out 0 and the answer is still NULL -- identical to fbc in every case
'' where fbc's behaviour is defined, and identical in practice everywhere else.
''
'' Why not port the over-read literally, when this project's rule is reproduce
'' rather than correct? Because UNDEFINED BEHAVIOUR CANNOT BE MATCHED. The bytes
'' in front of the allocation differ between the two runtimes, so a literal port
'' would make the differential unstable and could crash. fb_StrConcatByref's
'' self-concatenation bug WAS reproduced literally, and the difference is that it
'' read well-defined memory and was deterministic. This one is not.
''
'' The only input that could tell the two apart is one where the memory ahead of
'' the buffer happens to equal the pattern, which no program can arrange and no
'' test can rely on.

#include once "inc/descriptors.bi"
#include once "inc/wstr.bi"

'' wcschr and wcsncmp come from the CRT bindings inc/wstr.bi already pulls
'' in -- declaring them again is error 4.

'' Result-building, shared by all six: a positive length allocates and copies,
'' anything else is NULL. "Empty" and "absent" are the same value on this family.
private function hResult( byval src as wstring ptr, byval length as integer ) as wstring ptr
	if( length <= 0 ) then return 0
	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( length )
	if( dst = 0 ) then return 0
	FB_WSTR_COPY( dst, src, length )
	return dst
end function

extern "rtlib"

'' ------------------------------------------------------------------- Any

function tkort_WstrLTrimAny alias "fb_WstrLTrimAny" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer length = FB_WSTR_LEN( src )
	dim as integer plen = FB_WSTR_LEN( pattern_ )
	dim as wstring ptr p = src

	if( plen <> 0 ) then
		while( length <> 0 )
			dim as ulong __c = p[0]
			if( wcschr( pattern_, __c ) = 0 ) then exit while
			length -= 1
			p += 1
		wend
	end if

	return hResult( p, length )

end function

function tkort_WstrRTrimAny alias "fb_WstrRTrimAny" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer length = FB_WSTR_LEN( src )
	dim as integer plen = FB_WSTR_LEN( pattern_ )

	if( plen <> 0 ) then
		while( length <> 0 )
			length -= 1
			dim as ulong __c = src[length]
			if( wcschr( pattern_, __c ) = 0 ) then
				length += 1
				exit while
			end if
		wend
	end if

	return hResult( src, length )

end function

function tkort_WstrTrimAny alias "fb_WstrTrimAny" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer length = FB_WSTR_LEN( src )
	dim as integer plen = FB_WSTR_LEN( pattern_ )
	dim as wstring ptr p = src

	if( plen <> 0 ) then
		while( length <> 0 )
			dim as ulong __c = p[0]
			if( wcschr( pattern_, __c ) = 0 ) then exit while
			length -= 1
			p += 1
		wend
		while( length <> 0 )
			length -= 1
			dim as ulong __c = p[length]
			if( wcschr( pattern_, __c ) = 0 ) then
				length += 1
				exit while
			end if
		wend
	end if

	return hResult( p, length )

end function

'' -------------------------------------------------------------------- Ex

'' Strip the pattern repeatedly from the HEAD. Returns the new start pointer via
'' `p` and the new length via `length`.
#macro HEAD_STRIP( src, plen, pattern_, p, length )
	if( (length) >= (plen) ) then
		if( (plen) = 1 ) then
			'' The one-character fast path: skip a run of a single character.
			dim as ulong __pc = (pattern_)[0]
			dim as integer __go = -1
			while( __go )
				if( (length) <= 0 ) then exit while
				'' THROUGH A LOCAL. `(p)[0] = (pattern_)[0]` compares two
				'' wstring EXPRESSIONS rather than two characters, and the
				'' one-character fast path silently stripped nothing.
				dim as ulong __sc = (p)[0]
				if( __sc <> __pc ) then exit while
				(p) += 1
				(length) -= 1
			wend
		elseif( (plen) <> 0 ) then
			while( (length) >= (plen) )
				if( wcsncmp( (p), (pattern_), (plen) ) <> 0 ) then exit while
				(p) += (plen)
				(length) -= (plen)
			wend
		end if
	end if
#endmacro

'' Strip the pattern repeatedly from the TAIL. See the header on the negative
'' index: fbc dereferences it, this does not, and the answer is the same.
#macro TAIL_STRIP( plen, pattern_, p, length )
	if( (length) >= (plen) ) then
		if( (plen) = 1 ) then
			dim as ulong __pc = (pattern_)[0]
			dim as integer __go = -1
			while( __go )
				if( (length) <= 0 ) then exit while
				dim as ulong __sc = (p)[(length) - 1]
				if( __sc <> __pc ) then exit while
				(length) -= 1
			wend
		elseif( (plen) <> 0 ) then
			dim as integer __ti = (length) - (plen)
			while( (length) >= (plen) )
				'' fbc has no lower bound here and reads src[__ti] with __ti
				'' negative. Treating a negative index as a non-match lands
				'' __ti at -plen exactly as fbc's does, so the length below
				'' comes out the same -- without the out-of-bounds read.
				if( __ti < 0 ) then exit while
				if( wcsncmp( @(p)[__ti], (pattern_), (plen) ) <> 0 ) then exit while
				__ti -= (plen)
			wend
			(length) = __ti + (plen)
		end if
	end if
#endmacro

function tkort_WstrLTrimEx alias "fb_WstrLTrimEx" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer plen = FB_WSTR_LEN( pattern_ )
	dim as integer length = FB_WSTR_LEN( src )
	dim as wstring ptr p = src

	HEAD_STRIP( src, plen, pattern_, p, length )

	return hResult( p, length )

end function

function tkort_WstrRTrimEx alias "fb_WstrRTrimEx" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer plen = FB_WSTR_LEN( pattern_ )
	dim as integer length = FB_WSTR_LEN( src )
	dim as wstring ptr p = src

	TAIL_STRIP( plen, pattern_, p, length )

	'' NOTE: copies from SRC, not from p -- the tail strip never moves the start.
	return hResult( src, length )

end function

function tkort_WstrTrimEx alias "fb_WstrTrimEx" _
	( byval src as wstring ptr, byval pattern_ as wstring ptr ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer plen = FB_WSTR_LEN( pattern_ )
	dim as integer length = FB_WSTR_LEN( src )
	dim as wstring ptr p = src

	HEAD_STRIP( src, plen, pattern_, p, length )
	TAIL_STRIP( plen, pattern_, p, length )

	return hResult( p, length )

end function

end extern
