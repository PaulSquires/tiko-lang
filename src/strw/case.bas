'' case.bas -- UCASEW and LCASEW, with the legacy/unicode mode split.
''
'' MODE 1 IS ASCII-ONLY; ANYTHING ELSE IS LOCALE-AWARE. That is the same split
'' the narrow family has between legacy_str_ucase.o and str_ucase.o, expressed
'' here as a parameter rather than as two entry points.
''
'' AND THE LOCALE PATH IS THE RIGHT ANSWER HERE, where it would be wrong next
'' door. src/ustr/case.bas deliberately refuses towupper/towlower and uses a
'' generated Unicode table, because a USTRING must fold identically on every
'' machine. A WSTRING is the OS's text type and is expected to follow the
'' process locale, so the same call is correct. Third instance today of the same
'' library making opposite choices for the two families on purpose.
''
'' SIMPLE MAPPING EITHER WAY: one character in, one out.

#include once "inc/descriptors.bi"
#include once "inc/wstr.bi"

'' DECLARED UNDER LOCAL NAMES, and that is forced by a difference between the
'' targets rather than chosen. fbc's Windows CRT bindings already declare
'' iswlower/iswupper/towupper/towlower, so declaring them again is error 4; the
'' Linux bindings do NOT, so not declaring them is error 42. A local alias is
'' the only spelling that compiles on both.
''
'' This was invisible until the Release build ran all three targets: win64 built
'' clean and the failure was linux-only.
extern "c"   '' NON-FBCALL: libc wide character classification.
	declare function tkrt_iswlower cdecl alias "iswlower" ( byval c as ulong ) as long
	declare function tkrt_iswupper cdecl alias "iswupper" ( byval c as ulong ) as long
	declare function tkrt_towupper cdecl alias "towupper" ( byval c as ulong ) as ulong
	declare function tkrt_towlower cdecl alias "towlower" ( byval c as ulong ) as ulong
end extern

extern "rtlib"

function tkort_WstrUcase2 alias "fb_WstrUcase2" _
	( byval src as wstring ptr, byval mode as long ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer chars = FB_WSTR_LEN( src )

	'' NOTE: a zero-length source still ALLOCATES here, unlike almost everything
	'' else in this family -- fbc allocates before testing the length, so
	'' UCASEW("") returns a real empty wstring rather than NULL.
	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( chars )
	if( dst = 0 ) then return 0

	if( mode = 1 ) then
		for i as integer = 0 to chars - 1
			dim as ulong c = src[i]
			if( (c >= 97) andalso (c <= 122) ) then c -= (97 - 65)
			dst[i] = c
		next
	else
		for i as integer = 0 to chars - 1
			dim as ulong c = src[i]
			if( tkrt_iswlower( c ) ) then c = tkrt_towupper( c )
			dst[i] = c
		next
	end if

	dst[chars] = 0
	return dst

end function

function tkort_WstrLcase2 alias "fb_WstrLcase2" _
	( byval src as wstring ptr, byval mode as long ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer chars = FB_WSTR_LEN( src )

	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( chars )
	if( dst = 0 ) then return 0

	if( mode = 1 ) then
		for i as integer = 0 to chars - 1
			dim as ulong c = src[i]
			if( (c >= 65) andalso (c <= 90) ) then c += (97 - 65)
			dst[i] = c
		next
	else
		for i as integer = 0 to chars - 1
			dim as ulong c = src[i]
			if( tkrt_iswupper( c ) ) then c = tkrt_towlower( c )
			dst[i] = c
		next
	end if

	dst[chars] = 0
	return dst

end function

end extern
