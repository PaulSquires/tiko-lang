'' fromwchar.bas -- fb_WCharToUTF: WCHARs out to UTF-8/16/32. One entry point,
'' one fbc member, and the exact mirror of utf/towchar.bas.
''
'' THE WCHAR WIDTH PICKS THE ALGORITHM HERE TOO -- two bytes on Windows, four on
'' Linux -- so the same caution applies: half of this file never executes on any
'' one target. See utf/towchar.bas's header.
''
'' IT DOES NOT STOP ON A NUL, and that is the difference from fb_UTFToWChar. The
'' length is given, so an embedded NUL is CONVERTED like any other code point and
'' a terminator is emitted only if one was in the input. A caller that wants a
'' terminated result asks for one character more.
''
'' `chars` COUNTS WCHARS, NOT CHARACTERS, so a surrogate pair is passed in as
'' TWO. `bytes` comes back as a BYTE count for every encoding, including the wide
'' ones -- so a UTF-16 result of three code units reports 6, not 3.
''
'' dst = NULL ALLOCATES, and the size is a WORST CASE that is never trimmed:
'' `chars * 4` for UTF-8, `chars * 2` for UTF-16, `chars * 4` for UTF-32. A
'' seven-character ASCII string therefore costs a 28-byte block to hold 7 bytes.
'' That is fbc's allocation, and matching it is what keeps allocation-count and
'' size parity honest.
''
'' AND ONE PATH REALLOCS A BUFFER IT MAY NOT OWN. hUTF32ToUTF16 grows its output
'' when a code point above the BMP needs a second unit -- including when the
'' CALLER supplied dst, in which case the realloc is applied to a pointer malloc
'' never returned. It is undefined behaviour in fbc and it is reproduced rather
'' than fixed: a caller that hits it crashes identically under both runtimes,
'' and quietly fixing it here would be tiko-rt succeeding where fbc does not.
''
'' THE UTF-16 AND UTF-32 WRITERS ARE LITTLE-ENDIAN ONLY. fbc says so in a FIXME
'' and both our targets are little-endian, so the bytes come out in memory order
'' with no swap. A big-endian port would have to revisit this and nothing here
'' would warn it.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/wstr.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

const UTF8_BYTEMASK        = &h000000BFu
const UTF8_BYTEMARK        = &h00000080u
const UTF16_MAX_BMP        = &h0000FFFFu
const UTF16_SUR_HIGH_START = &h0000D800u
const UTF16_SUR_HIGH_END   = &h0000DBFFu
const UTF16_SUR_LOW_START  = &h0000DC00u
const UTF16_HALFSHIFT      = 10
const UTF16_HALFBASE       = &h00010000u
const UTF16_HALFMASK       = &h000003FFu

type TKORT_UTF8_BMARK
	as ubyte v( 0 to 6 )
end type

extern "c"   '' NON-FBCALL: the table lives in utf/core.bas, and
             '' fb_hCharToUTF8 in utf/fromchar.bas.
	extern __fb_utf8_bmarkTb alias "__fb_utf8_bmarkTb" as TKORT_UTF8_BMARK
	declare sub tkrt_hCharToUTF8 alias "fb_hCharToUTF8" _
		( byval src as zstring ptr, byval chars as integer, _
		  byval dst as zstring ptr, byval bytes as integer ptr )
end extern

#if TKORT_WCHAR_SIZE = 2
	#define TKORT_WCHAR_IS_UTF16
#elseif TKORT_WCHAR_SIZE = 4
	#define TKORT_WCHAR_IS_UTF32
#else
	#error "fb_WCharToUTF: wchar is neither 2 nor 4 bytes on this target"
#endif

extern "c"   '' NON-FBCALL: fb_file.h declares fb_WCharToUTF plainly.

'' ONE CODE POINT, ENCODED AS UTF-8. The length is chosen by magnitude, then the
'' bytes are written BACKWARDS from the end of the sequence -- which is what lets
'' the continuation bytes be peeled off six bits at a time without a second pass.
'' The lead byte's marker comes from the bmark table, indexed by the length.
#macro TKORT_UTF8_ENCODE( c, dst, bytes )
	scope
		if( c < &h80u ) then
			bytes = 1
		elseif( c < &h800u ) then
			bytes = 2
		elseif( c < &h10000u ) then
			bytes = 3
		else
			bytes = 4
		end if

		dst += bytes
		select case as const bytes
		case 4
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, c or __fb_utf8_bmarkTb.v( bytes ) )
		case 3
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, c or __fb_utf8_bmarkTb.v( bytes ) )
		case 2
			dst -= 1 : *dst = cast( ubyte, (c or UTF8_BYTEMARK) and UTF8_BYTEMASK ) : c shr= 6
			dst -= 1 : *dst = cast( ubyte, c or __fb_utf8_bmarkTb.v( bytes ) )
		case else
			dst -= 1 : *dst = cast( ubyte, c or __fb_utf8_bmarkTb.v( bytes ) )
		end select
		dst += bytes
	end scope
#endmacro

#ifdef TKORT_WCHAR_IS_UTF16

'' ----------------------------------------------------------- WCHAR is UTF-16

'' A SURROGATE PAIR CONSUMES TWO INPUT UNITS AND COUNTS AS ONE code point, which
'' is why `chars` is decremented twice on that branch.
private sub hUTF16ToUTF8( byval src as ushort ptr, byval chars as integer, _
                          byval dst as ubyte ptr, byval total_bytes as integer ptr )

	dim as ulong c = any
	dim as integer bytes = any

	*total_bytes = 0
	while( chars > 0 )
		c = *src : src += 1
		if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
			c = ((c - UTF16_SUR_HIGH_START) shl UTF16_HALFSHIFT) + _
			    (cast( ulong, *src ) - UTF16_SUR_LOW_START) + UTF16_HALFBASE
			src += 1
			chars -= 1
		end if

		TKORT_UTF8_ENCODE( c, dst, bytes )

		chars -= 1
		*total_bytes += bytes
	wend
end sub

'' UTF-16 IN, UTF-32 OUT is the reverse of the pair-splitting above: two units
'' become one, so `bytes` is DECREMENTED by four for every pair combined and the
'' caller's estimate is an upper bound rather than an answer.
private sub hUTF16ToUTF32( byval src as ushort ptr, byval chars as integer, _
                           byval dst as ulong ptr, byval bytes as integer ptr )

	dim as ulong c = any

	while( chars > 0 )
		c = *src : src += 1
		if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
			c = ((c - UTF16_SUR_HIGH_START) shl UTF16_HALFSHIFT) + _
			    (cast( ulong, *src ) - UTF16_SUR_LOW_START) + UTF16_HALFBASE
			src += 1
			*bytes -= 4
			chars -= 1
		end if

		*dst = c : dst += 1
		chars -= 1
	wend
end sub

'' UTF-16 IN, UTF-16 OUT: memcpy, and `bytes` was already set by the caller.
'' Nothing here can grow or shrink.

#else

'' ----------------------------------------------------------- WCHAR is UTF-32

private sub hUTF32ToUTF8( byval src as ulong ptr, byval chars as integer, _
                          byval dst as ubyte ptr, byval total_bytes as integer ptr )

	dim as ulong c = any
	dim as integer bytes = any

	*total_bytes = 0
	while( chars > 0 )
		c = *src : src += 1
		TKORT_UTF8_ENCODE( c, dst, bytes )
		chars -= 1
		*total_bytes += bytes
	wend
end sub

'' THE ONE PATH THAT GROWS -- and the one that reallocs a buffer it may not own;
'' see the file header. `bytes` enters as the caller's estimate AND doubles as
'' the running total, so the growth test is `*bytes = dst_size`.
private function hUTF32ToUTF16( byval src as ulong ptr, byval chars as integer, _
                                byval dst as ushort ptr, byval bytes as integer ptr ) as ushort ptr

	dim as ushort ptr buffer = dst
	dim as integer i = 0, dst_size = *bytes
	dim as ulong c = any

	while( chars > 0 )
		c = *src : src += 1
		if( c > UTF16_MAX_BMP ) then
			if( *bytes = dst_size ) then
				dst_size += 2 * 8
				dim as ushort ptr nb = cptr( ushort ptr, realloc( buffer, dst_size ) )
				if( nb = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = nb
				dst = buffer
			end if

			*bytes += 2

			c -= UTF16_HALFBASE
			dst[i] = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START ) : i += 1
			c = (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START
		end if

		dst[i] = cast( ushort, c ) : i += 1
		chars -= 1
	wend

	return buffer
end function

#endif

'' -------------------------------------------------------------- the three

'' FOUR BYTES PER CHARACTER IS THE WORST CASE and is what gets allocated. On a
'' UTF-16 host a surrogate pair is two input units for one four-byte output, so
'' the estimate is never exceeded.
private function hToUTF8( byval src as any ptr, byval chars as integer, _
                          byval dst as ubyte ptr, byval bytes as integer ptr ) as ubyte ptr

	if( chars > 0 ) then
		if( dst = 0 ) then
			dst = cptr( ubyte ptr, malloc( chars * 4 ) )
			if( dst = 0 ) then return 0
		end if
	end if

	#ifdef TKORT_WCHAR_IS_UTF16
		hUTF16ToUTF8( cptr( ushort ptr, src ), chars, dst, bytes )
	#else
		hUTF32ToUTF8( cptr( ulong ptr, src ), chars, dst, bytes )
	#endif

	return dst
end function

'' `bytes` IS SET BEFORE THE CONVERSION, not after, and the growing path then
'' adjusts it upward -- so a caller reading it without calling is reading an
'' estimate, not a result.
private function hToUTF16( byval src as any ptr, byval chars as integer, _
                           byval dst as ubyte ptr, byval bytes as integer ptr ) as ubyte ptr

	*bytes = chars * 2

	if( chars > 0 ) then
		if( dst = 0 ) then
			dst = cptr( ubyte ptr, malloc( chars * 2 ) )
			if( dst = 0 ) then return 0
		end if
	end if

	#ifdef TKORT_WCHAR_IS_UTF16
		'' SAME WIDTH: a straight copy, and the estimate is exact.
		if( chars > 0 ) then memcpy( dst, src, chars * 2 )
	#else
		dst = cptr( ubyte ptr, hUTF32ToUTF16( cptr( ulong ptr, src ), chars, _
		                                      cptr( ushort ptr, dst ), bytes ) )
	#endif

	return dst
end function

private function hToUTF32( byval src as any ptr, byval chars as integer, _
                           byval dst as ubyte ptr, byval bytes as integer ptr ) as ubyte ptr

	*bytes = chars * 4

	if( chars > 0 ) then
		if( dst = 0 ) then
			dst = cptr( ubyte ptr, malloc( chars * 4 ) )
			if( dst = 0 ) then return 0
		end if
	end if

	#ifdef TKORT_WCHAR_IS_UTF16
		hUTF16ToUTF32( cptr( ushort ptr, src ), chars, cptr( ulong ptr, dst ), bytes )
	#else
		if( chars > 0 ) then memcpy( dst, src, chars * 4 )
	#endif

	return dst
end function

'' ------------------------------------------------------------ the entry point

function tkort_WCharToUTF alias "fb_WCharToUTF" _
	( byval encod as long, byval src as wstring ptr, byval chars as integer, _
	  byval dst as zstring ptr, byval bytes as integer ptr ) as zstring ptr

	select case encod
	case FB_FILE_ENCOD_UTF8
		return cptr( zstring ptr, hToUTF8( src, chars, cptr( ubyte ptr, dst ), bytes ) )
	case FB_FILE_ENCOD_UTF16
		return cptr( zstring ptr, hToUTF16( src, chars, cptr( ubyte ptr, dst ), bytes ) )
	case FB_FILE_ENCOD_UTF32
		return cptr( zstring ptr, hToUTF32( src, chars, cptr( ubyte ptr, dst ), bytes ) )
	end select

	'' AN UNKNOWN ENCODING IS NULL AND LEAVES `bytes` UNTOUCHED -- unlike the
	'' three above, which all write it before they can fail.
	return 0
end function

end extern
