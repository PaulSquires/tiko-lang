'' lcase.bas -- fb_StrLcase2 (str_lcase.o).
''
'' THE `mode` ARGUMENT, WHICH COULD NOT BE PROBED. wide.bas records that modes
'' 0, 1 and 2 behave identically on ASCII, so no probe could separate them and
'' guessing would have been a contract bug. It is not a guess any more:
''
''     mode = 1        ASCII ONLY. Hardcoded 65..90 -> add 32. Nothing
''                     outside A..Z is touched, whatever the locale says.
''     anything else   LOCALE-AWARE. isupper() / tolower() from the CRT, so the
''                     answer depends on the process locale.
''
'' fb_LCASE (legacycase.bas) passes 0, so the plain LCASE is the locale path.
''
'' TWO NULL CASES, AND THEY DIFFER:
''
''     src = NULL        return the shared empty. NO lock is taken and NOTHING
''                       is consumed -- there is no descriptor to consume.
''     src->data = NULL  return the shared empty, but the source IS consumed.
''
'' The allocation uses fb_hStrAllocTemp_NoLock because the lock is already held.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"

extern "rtlib"
	declare function fb_hStrAllocTemp_NoLock alias "fb_hStrAllocTemp_NoLock" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
	declare function tkrt_DelTempNoLock alias "fb_hStrDelTemp_NoLock" _
		( byval s as FBSTRING ptr ) as long
	declare sub fb_StrLock alias "fb_StrLock" ( )
	declare sub fb_StrUnlock alias "fb_StrUnlock" ( )
end extern

#ifdef ENABLE_MT
	#define STRLOCK()   fb_StrLock()
	#define STRUNLOCK() fb_StrUnlock()
#else
	#define STRLOCK()
	#define STRUNLOCK()
#endif

extern "rtlib"

function tkort_StrLcase2 alias "fb_StrLcase2" _
	( byval src as FBSTRING ptr, byval mode as long ) as FBSTRING ptr

	if( src = 0 ) then return TKORT_NULLSTR( )

	STRLOCK()

	dim as FBSTRING ptr dst = 0
	dim as integer length = 0

	if( src->data <> 0 ) then
		length = FB_STRSIZE( src )
		dst = fb_hStrAllocTemp_NoLock( 0, length )
	end if

	if( dst <> 0 ) then
		'' SIGNED. fbc walks the source with `char *s` and does `c = *s++`, and
		'' char is SIGNED on x86 -- so a byte of 200 reaches islower/toupper as
		'' -56, not 200. Reading through a `ubyte ptr` here gave different
		'' answers for every byte above 127 and the differential caught it on
		'' the high-byte case. The mode-1 range tests are unaffected either way,
		'' because a negative value fails both bounds just as 200 does.
		dim as byte ptr s = cptr( byte ptr, src->data )
		dim as ubyte ptr d = cptr( ubyte ptr, dst->data )
		dim as long c = any

		if( mode = 1 ) then
			for i as integer = 0 to length - 1
				c = s[i]
				if( (c >= 65) andalso (c <= 90) ) then c += (97 - 65)
				d[i] = cast( ubyte, c )
			next
		else
			for i as integer = 0 to length - 1
				c = s[i]
				if( isupper( c ) ) then c = tolower( c )
				d[i] = cast( ubyte, c )
			next
		end if

		d[length] = 0
	else
		dst = TKORT_NULLSTR( )
	end if

	tkrt_DelTempNoLock( src )

	STRUNLOCK()

	return dst

end function

end extern
