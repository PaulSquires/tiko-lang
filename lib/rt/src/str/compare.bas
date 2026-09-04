'' compare.bas -- fb_StrCompare.
''
'' MEASURED, NOT ASSUMED (PROVENANCE.md -- no .c body was opened):
''
''   PROBE-38: IT USES **FIX** DECODING, NOT DYN. A `zstring * 12` holding
''     "abcdef" compares EQUAL to the string "abcdef" -- so the last branch
''     measures with strlen rather than taking size - 1. Same choice as
''     fb_StrLen; the opposite choice would have made every fixed-length
''     comparison fail on the trailing NULs.
''
''     PROBE-37 asked this first and got a worthless answer: it compared the
''     zstring against "abc" rather than "abcdef", so the two differed whichever
''     decoding was used, and the 1 it returned proved nothing. The label in the
''     probe said FIX?=0 DYN?=nonzero and the test could not distinguish them.
''     A probe that cannot come out both ways is not a measurement.
''
''   PROBE-37: -1, 0 or +1 -- never a raw difference.
''
''   PROBE-37: A NULL OPERAND IS AN EMPTY STRING, exactly as for fb_WstrCompare
''     (RFC-0002 section 4.5): (NULL,"abc") = -1, ("abc",NULL) = 1,
''     (NULL,NULL) = 0, and identically for "".
''
''   PROBE-37: THE COMPARE IS BINARY, not C-string. "a\0b" vs "a\0c" answers -1,
''     so embedded NULs are compared rather than terminating the operand.
''
''   PROBE-37: A PREFIX IS LESS. ("ab","abc") = -1 -- equal bytes then shorter.
''
''   PROBE-37: IT CONSUMES BOTH TEMPORARY OPERANDS. Screened from fbc's object
''     first -- str_comp.o lists fb_hStrDelTempDesc's locking-free sibling
''     fb_hStrDelTemp_NoLock -- then confirmed: comparing two temporaries leaves
''     both len 0, data NULL.

#include once "inc/descriptors.bi"

extern "rtlib"
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" _
		( byval s as FBSTRING ptr ) as long
end extern

extern "rtlib"

function tkort_StrCompare alias "fb_StrCompare" _
	( _
		byval str1 as any ptr, byval str1_size as integer, _
		byval str2 as any ptr, byval str2_size as integer _
	) as long

	dim as zstring ptr p1 = any, p2 = any
	dim as integer n1 = any, n2 = any

	FB_STRSETUP_FIX( str1, str1_size, p1, n1 )
	FB_STRSETUP_FIX( str2, str2_size, p2, n2 )

	dim as integer shorter = n1
	if( n2 < shorter ) then shorter = n2

	dim as long result = 0

	'' A NULL data pointer is an empty string, so it never reaches memcmp: with
	'' n = 0 the length comparison below decides on its own.
	if( shorter > 0 ) then
		result = memcmp( p1, p2, shorter )
		'' memcmp may return any negative or positive value, not just -1/+1.
		if( result < 0 ) then
			result = -1
		elseif( result > 0 ) then
			result = 1
		end if
	end if

	if( result = 0 ) then
		if( n1 < n2 ) then
			result = -1
		elseif( n1 > n2 ) then
			result = 1
		end if
	end if

	'' CONSUMES BOTH OPERANDS. Only a var-len descriptor can carry the temp bit,
	'' so only that argument form is ours to release -- but within that form,
	'' call DelTemp UNCONDITIONALLY rather than pre-filtering on FB_ISTEMP. It
	'' already decides all three ownership cases, and a caller that re-implements
	'' the guard will eventually disagree with it (see basic.bas).
	if( (str1 <> 0) andalso (str1_size = FB_STRSIZEVARLEN) ) then
		tkrt_DelTemp( cptr( FBSTRING ptr, str1 ) )
	end if
	if( (str2 <> 0) andalso (str2_size = FB_STRSIZEVARLEN) ) then
		tkrt_DelTemp( cptr( FBSTRING ptr, str2 ) )
	end if

	return result

end function

end extern
