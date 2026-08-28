'' wide.bas -- the wide-string entry points that test RFC-0004 section 3.3.
''
'' Five members of fbc's archive: strw_len, strw_comp, strw_trim, strw_ltrim,
'' strw_rtrim. They were chosen because the trim family is built almost entirely
'' out of the `static __inline__` helpers in fb_unicode.h -- 21 of the 38 in the
'' whole runtime -- and section 3.3 predicts that is where FreeBASIC loses,
'' having no inliner. Here the helpers are #macro (src/inc/wstr.bi), which is the
'' mitigation that section names.
''
'' MEASURED, NOT ASSUMED (PROVENANCE.md -- no .c body was opened):
''
''   PROBE-19: Trim, LTrim and RTrim remove ONLY the space character, 0x20.
''     Given a string wrapped in 20 09 0A 0B 0C 0D on both sides, fbc's Trim
''     returned `09 0A 0B 0C 0D 58 0D 0C 0B 0A 09` -- tab, LF, vertical tab,
''     form feed and CR all survive. Classic BASIC TRIM, not isspace().
''
''   PROBE-18: fb_WstrCompare returns -1, 0 or +1, not a raw difference.
''     fb_WstrLen("AbCdEf") = 6. Lcase2/Ucase2 return a NEW buffer and leave the
''     source untouched.
''
'' NOT established, and therefore NOT implemented here: the `mode` argument of
'' fb_WstrLcase2 / fb_WstrUcase2. All three of modes 0, 1 and 2 behave
'' identically on ASCII, so a probe cannot separate them without non-ASCII cases
'' that have not been run. Guessing it would be the fourth ownership-shaped bug
'' in this project, so those two entry points stay fbc's.

#include once "inc/descriptors.bi"
#include once "inc/wstr.bi"

extern "rtlib"

function tkort_WstrLen alias "fb_WstrLen" ( byval s as wstring ptr ) as integer
	if( s = 0 ) then return 0
	return FB_WSTR_LEN( s )
end function

'' -1 / 0 / +1, never a raw difference (PROBE-18).
function tkort_WstrCompare alias "fb_WstrCompare" _
	( byval s1 as wstring ptr, byval s2 as wstring ptr ) as long

	if( s1 = s2 ) then return 0
	if( s1 = 0 ) then return -1
	if( s2 = 0 ) then return 1

	dim as integer i = 0
	do
		dim as uinteger a = s1[i]
		dim as uinteger b = s2[i]
		if( a <> b ) then
			if( a < b ) then return -1 else return 1
		end if
		if( a = 0 ) then return 0
		i += 1
	loop

end function

'' The three trims share one helper. `s` is scanned for the first and last
'' non-space; everything between is copied into a fresh block that the caller
'' frees through fb_WstrDelete.
private function hTrim _
	( _
		byval s as wstring ptr, byval doLeft as integer, byval doRight as integer _
	) as wstring ptr

	if( s = 0 ) then return 0

	dim as integer n = FB_WSTR_LEN( s )
	dim as integer lo = 0
	dim as integer hi = n

	'' Only 0x20. Not tab, not LF, not CR -- PROBE-19.
	if( doLeft ) then
		while( (lo < hi) andalso (s[lo] = 32) )
			lo += 1
		wend
	end if

	if( doRight ) then
		while( (hi > lo) andalso (s[hi - 1] = 32) )
			hi -= 1
		wend
	end if

	dim as integer outn = hi - lo

	'' AN EMPTY RESULT IS NULL, NOT AN EMPTY STRING.
	''
	'' Measured: fbc's Trim of "     ", of " " and of "" all return NULL, where
	'' the obvious implementation returns a zero-length buffer. Nothing in the
	'' signature says so and it is the kind of difference that surfaces later as
	'' a null dereference in someone else's program.
	if( outn <= 0 ) then return 0

	dim as wstring ptr r = FB_WSTR_ALLOCTEMP( outn )
	if( r = 0 ) then return 0

	FB_WSTR_COPY( r, @s[lo], outn )
	return r

end function

function tkort_WstrTrim alias "fb_WstrTrim" ( byval s as wstring ptr ) as wstring ptr
	return hTrim( s, -1, -1 )
end function

function tkort_WstrLTrim alias "fb_WstrLTrim" ( byval s as wstring ptr ) as wstring ptr
	return hTrim( s, -1, 0 )
end function

function tkort_WstrRTrim alias "fb_WstrRTrim" ( byval s as wstring ptr ) as wstring ptr
	return hTrim( s, 0, -1 )
end function

end extern
