'' valbool.bas -- fb_hStr2Bool and fb_VALBOOL (str_convfrom_bool.o).
''
'' A string is TRUE if it spells the word `true`, or if it parses as a non-zero
'' number. Not "non-empty" and not "starts with T".
''
'' THE WORD COMPARISON IS CASE-INSENSITIVE AND ASKS THE RUNTIME WHAT THE WORDS
'' ARE. fbc compares against fb_hBoolToStr( FALSE ) and fb_hBoolToStr( TRUE )
'' rather than against literals, so the two directions cannot drift apart --
'' whatever BOOL prints as is what VAL reads back.
''
'' AND IT COMPARES THE WHOLE C STRING, not the descriptor's length: strcasecmp
'' stops at the first NUL, so `len` is ignored for the word test and only used
'' for the numeric fall-through. A descriptor holding "true\0junk" therefore
'' tests TRUE. Reproduced as written.
''
'' -0.0 IS FALSE. The test is `val <> 0.0 andalso val <> -0.0`, which looks
'' redundant -- the two compare equal in IEEE -- and is. Kept because the C has
'' it and a differential would not notice either way.
''
'' THE CASE-INSENSITIVE COMPARE IS PLATFORM-SPLIT. There is no portable
'' strcasecmp: fbc's Windows build links _stricmp (the import table shows
'' __imp__stricmp) and its Linux build uses strcasecmp. crt/string.bi declares
'' only _stricmp, so the other is declared here.

#include once "inc/descriptors.bi"

extern "rtlib"
	declare function tkrt_BoolToStr alias "fb_hBoolToStr" ( byval b as long ) as zstring ptr
	declare function tkrt_Str2Double alias "fb_hStr2Double" _
		( byval s as zstring ptr, byval length as integer ) as double
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" _
		( byval s as FBSTRING ptr ) as long
end extern

#ifdef __FB_WIN32__
	'' _stricmp is what fbc's own Windows build imports.
	#define TKORT_CASECMP( a, b ) _stricmp( (a), (b) )
#else
	extern "c" '' NON-FBCALL -- plain libc, no @N anywhere.
		'' _strnicmp / _stricmp ON THE MICROSOFT ABI. The UCRT has no strncasecmp or
		'' strcasecmp -- they are POSIX names, and MSVC spells the pair with a leading
		'' underscore and an i. Same signature and same meaning, a different name, and
		'' the same shape as the fseeko/ftello rename. TKORT_MSVC comes from build.sh;
		'' see src/sys/sys.bi for why fbc cannot tell us itself.
		#ifdef TKORT_MSVC
		declare function strcasecmp alias "_stricmp" _
			( byval a as const zstring ptr, byval b as const zstring ptr ) as long
		#else
		declare function strcasecmp alias "strcasecmp" _
			( byval a as const zstring ptr, byval b as const zstring ptr ) as long
		#endif
	end extern
	#define TKORT_CASECMP( a, b ) strcasecmp( (a), (b) )
#endif

extern "rtlib"

function tkort_hStr2Bool alias "fb_hStr2Bool" _
	( byval src as zstring ptr, byval length as integer ) as byte

	'' Asks the runtime what the words are, so print and parse cannot drift.
	if( TKORT_CASECMP( src, tkrt_BoolToStr( 0 ) ) = 0 ) then return 0
	if( TKORT_CASECMP( src, tkrt_BoolToStr( -1 ) ) = 0 ) then return 1

	dim as double v = tkrt_Str2Double( src, length )

	if( (v <> 0.0) andalso (v <> -0.0) ) then return 1
	return 0

end function

function tkort_VALBOOL alias "fb_VALBOOL" ( byval s as FBSTRING ptr ) as byte

	if( s = 0 ) then return 0

	dim as long v = 0
	if( s->data <> 0 ) then
		if( FB_STRSIZE( s ) <> 0 ) then
			v = tkort_hStr2Bool( s->data, FB_STRSIZE( s ) )
		end if
	end if

	'' CONSUMES ITS OPERAND. Omitted in the first draft of this file and caught
	'' by re-reading str_convfrom_bool.o's undefined symbols, which list
	'' fb_hStrDelTemp. A missing release is a pool leak, not a wrong answer --
	'' the class that produced bugs 12 through 15 and surfaced as a segfault in
	'' an unrelated subsystem.
	tkrt_DelTemp( s )

	return cast( byte, v )

end function

end extern
