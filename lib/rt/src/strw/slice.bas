'' slice.bas -- LEFTW, RIGHTW, MIDW (both forms), SPACEW, STRINGW, CHRW, ASCW,
'' LSETW and RSETW: eleven entry points over eight fbc members.
''
'' "EMPTY" AND "ABSENT" ARE THE SAME VALUE HERE. Every function in this file
'' returns NULL rather than a zero-length wstring -- there is no descriptor to
'' hold a length of nought, so a pointer is all there is to say it with. That is
'' the opposite of the ustring family, where an empty result is the shared empty
'' DESCRIPTOR and never NULL, and it is why these are not the same functions at a
'' different width.
''
'' EVERY RESULT IS THE CALLER'S TO FREE, with fb_WstrDelete. No temp pool, no
'' temp bit, nothing released on their behalf.

#include once "inc/descriptors.bi"
#include once "inc/wstr.bi"
#include once "crt/string.bi"

extern "rtlib"

function tkort_WstrLeft alias "fb_WstrLeft" _
	( byval src as wstring ptr, byval chars as integer ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer length = FB_WSTR_LEN( src )
	if( chars <= 0 ) then return 0
	if( length = 0 ) then return 0

	if( chars < length ) then length = chars

	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( length )
	if( dst <> 0 ) then
		FB_WSTR_COPY( dst, src, length )
	end if
	return dst

end function

function tkort_WstrRight alias "fb_WstrRight" _
	( byval src as wstring ptr, byval chars as integer ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer src_len = FB_WSTR_LEN( src )
	if( chars <= 0 ) then return 0
	if( src_len = 0 ) then return 0

	dim as integer length = chars
	if( chars > src_len ) then length = src_len

	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( length )
	if( dst <> 0 ) then
		FB_WSTR_COPY( dst, @src[src_len - length], length )
	end if
	return dst

end function

'' MIDW( s, start [, len] ). start is 1-based; a NEGATIVE length means "to the
'' end" and a length of exactly ZERO yields NULL -- three meanings for three
'' values, the same split fb_UStrMid uses.
function tkort_WstrMid alias "fb_WstrMid" _
	( byval src as wstring ptr, byval start_ as integer, byval length as integer ) as wstring ptr

	if( src = 0 ) then return 0

	dim as integer src_len = FB_WSTR_LEN( src )
	if( src_len = 0 ) then return 0
	if( start_ <= 0 ) then return 0
	if( start_ > src_len ) then return 0
	if( length = 0 ) then return 0

	start_ -= 1
	if( length < 0 ) then length = src_len
	if( (start_ + length) > src_len ) then length = src_len - start_

	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( length )
	if( dst <> 0 ) then
		FB_WSTR_COPY( dst, @src[start_], length )
	end if
	return dst

end function

'' MIDW( dst, start [, len] ) = src -- overwrites in place and never resizes.
''
'' NOTE THE -1 IN THE CLAMP, which the ustring and string versions do not have.
'' When the write would reach the end of the destination the length is cut to
'' (dst_len - start) - 1, so the LAST character is never overwritten. Reproduced
'' rather than corrected: it is visible to any program that uses MID on a wstring
'' and a "fix" would make tiko-rt disagree with fbc on it.
sub tkort_WstrAssignMid alias "fb_WstrAssignMid" _
	( byval dst as wstring ptr, byval dst_len as integer, _
	  byval start_ as integer, byval length as integer, byval src as wstring ptr )

	if( dst = 0 ) then exit sub
	if( src = 0 ) then exit sub

	dim as integer src_len = FB_WSTR_LEN( src )
	if( src_len = 0 ) then exit sub

	if( dst_len = 0 ) then
		'' A bare pointer: assume it is large enough, and derive a bound that
		'' cannot clamp anything away.
		dst_len = FB_WSTR_LEN( dst ) + src_len
	end if

	if( (start_ > 0) andalso (start_ <= dst_len) ) then
		start_ -= 1
		if( (length < 1) orelse (length > src_len) ) then length = src_len
		if( (start_ + length) > dst_len ) then length = (dst_len - start_) - 1
		'' The non-terminating form: this writes INTO an existing string.
		FB_WSTR_MOVE( @dst[start_], src, length )
	end if

end sub

function tkort_WstrSpace alias "fb_WstrSpace" ( byval chars as integer ) as wstring ptr
	if( chars <= 0 ) then return 0
	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( chars )
	if( dst <> 0 ) then
		FB_WSTR_FILL( dst, 32, chars )
	end if
	return dst
end function

function tkort_WstrFill1 alias "fb_WstrFill1" _
	( byval chars as integer, byval c as long ) as wstring ptr
	if( chars <= 0 ) then return 0
	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( chars )
	if( dst <> 0 ) then
		FB_WSTR_FILL( dst, c, chars )
	end if
	return dst
end function

'' STRINGW( n, s ) repeats the FIRST character of s.
function tkort_WstrFill2 alias "fb_WstrFill2" _
	( byval chars as integer, byval src as wstring ptr ) as wstring ptr
	if( chars <= 0 ) then return 0
	if( src = 0 ) then return 0
	if( FB_WSTR_LEN( src ) <= 0 ) then return 0

	'' THE CHARACTER IS READ THROUGH A LOCAL, AND THAT IS NOT STYLE.
	''
	'' `src[0]` on a `wstring ptr` is a wstring EXPRESSION, not a number.
	''   cast( long, src[0] )   compiles and yields 0. SILENTLY.
	''   dim as long c = src[0] converts properly.
	''   return src[0]          converts properly too (see fb_WstrAsc below).
	''
	'' So the explicit cast -- the form that LOOKS most careful -- is the one
	'' that is wrong, and it fails to zero rather than to an error. The first
	'' version of this function used it and STRINGW( 3, "abcdef" ) returned three
	'' NULs; the differential caught it on the one line where the two runtimes
	'' disagreed. The identical mistake had already appeared in a test helper
	'' earlier the same day, where it printed 0000 on BOTH sides and PASSED.
	dim as long first_ = src[0]
	return tkort_WstrFill1( chars, first_ )
end function

'' ASCW( s [, pos] ). Returns a CHARACTER, whose width is the target's -- so on
'' Linux this can exceed U+FFFF and on Windows it cannot, and a program that
'' round-trips ASCW/CHRW is portable only within the BMP.
function tkort_WstrAsc alias "fb_WstrAsc" _
	( byval src as wstring ptr, byval pos_ as integer ) as ulong

	if( src = 0 ) then return 0

	dim as integer length = FB_WSTR_LEN( src )
	if( length = 0 ) then return 0
	if( pos_ <= 0 ) then return 0
	if( pos_ > length ) then return 0

	return src[pos_ - 1]

end function

'' LSETW / RSETW pad with SPACES and never resize -- the destination's current
'' length is the field width.
sub tkort_WstrLset alias "fb_WstrLset" ( byval dst as wstring ptr, byval src as wstring ptr )

	if( dst = 0 ) then exit sub
	if( src = 0 ) then exit sub

	dim as integer slen = FB_WSTR_LEN( src )
	dim as integer dlen = FB_WSTR_LEN( dst )
	if( dlen <= 0 ) then exit sub

	dim as integer length = slen
	if( dlen <= slen ) then length = dlen

	'' NOTE THE ORDER. FB_WSTR_COPY terminates, so the copy plants a NUL at
	'' dst[length]; the fill that follows overwrites it and re-terminates at the
	'' field width. Doing the fill first would have the copy truncate the field.
	FB_WSTR_COPY( dst, src, length )

	length = dlen - slen
	if( length > 0 ) then
		FB_WSTR_FILL( @dst[slen], 32, length )
	end if

end sub

sub tkort_WstrRset alias "fb_WstrRset" ( byval dst as wstring ptr, byval src as wstring ptr )

	if( dst = 0 ) then exit sub
	if( src = 0 ) then exit sub

	dim as integer slen = FB_WSTR_LEN( src )
	dim as integer dlen = FB_WSTR_LEN( dst )
	if( dlen <= 0 ) then exit sub

	dim as integer padlen = dlen - slen
	if( padlen > 0 ) then
		FB_WSTR_FILL( dst, 32, padlen )
	else
		padlen = 0
	end if

	dim as integer length = slen
	if( dlen <= slen ) then length = dlen

	FB_WSTR_COPY( @dst[padlen], src, length )

end sub

end extern

'' CHRW( a, b, c, ... ) -- the first VARIADIC entry point in tiko-rt.
''
'' NON-FBCALL, and that is not a choice: fb_unicode.h declares it without the
'' macro, and FreeBASIC supports variadic DEFINITIONS only for cdecl. On win32
'' the two facts agree -- no @N decoration -- so there is nothing to reconcile.
''
'' Each argument arrives PROMOTED TO INT by the C default argument promotions,
'' regardless of the wide character's width, so cva_arg reads `long` and the
'' store to the buffer narrows. Reading a wstring-sized type here would walk the
'' argument list with the wrong stride on every target.
extern "c"   '' NON-FBCALL: fb_unicode.h declares fb_WstrChr without it.

function tkort_WstrChr cdecl alias "fb_WstrChr" ( byval args as long, ... ) as wstring ptr

	if( args <= 0 ) then return 0

	dim as wstring ptr dst = FB_WSTR_ALLOCTEMP( args )
	if( dst = 0 ) then return 0

	dim as cva_list ap = any
	cva_start( ap, args )
	for i as integer = 0 to args - 1
		dst[i] = cva_arg( ap, long )
	next
	cva_end( ap )

	dst[args] = 0
	return dst

end function

end extern
