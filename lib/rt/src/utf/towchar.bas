'' towchar.bas -- fb_UTFToWChar: a NUL-terminated UTF-8/16/32 string to WCHARs.
'' One entry point, one fbc member.
''
'' THE WCHAR WIDTH PICKS THE ALGORITHM, AND IT IS DIFFERENT ON EVERY TARGET.
'' fbc writes `switch( sizeof( FB_WCHAR ) )` over three cases, which the C
'' compiler folds to one at compile time: two bytes on Windows selects the
'' UTF-16 bodies, four on Linux selects the UTF-32 ones. So win64 and win32 run
'' code that Linux never executes and vice versa -- exactly the class of bug the
'' plan's §6 names, and the reason every path here is exercised on both.
''
'' The one-byte case (`sizeof( FB_WCHAR ) == sizeof( char )`) is DOS's, and is
'' unreachable on all three of our targets. It is left out rather than written
'' and never run; utf/tochar.bas holds the narrow conversions it would call.
''
'' TWO CALLING MODES, SELECTED BY dst -- the same protocol as utf/tochar.bas:
''
''   dst = NULL   allocate. `chars` is IGNORED on entry, the buffer GROWS IN
''                BLOCKS OF EIGHT by realloc, conversion runs to the source's
''                NUL, and the terminator IS written. The caller frees.
''   dst <> NULL  fill. `chars` is the maximum on entry. IF THE BUFFER IS TOO
''                SHORT NO TERMINATOR IS APPENDED -- fbc documents that, and a
''                caller that assumes one reads past the end.
''
'' `chars` COMES BACK AS A COUNT OF WCHARS, NOT CHARACTERS, and a surrogate pair
'' counts as TWO. That is why the UTF-16 growth test is `charsleft < 2` and not
'' `= 0`: one code point can need two units, and a buffer with room for one
'' would be overrun by a single emoji.
''
'' AND THE UTF-16 ALLOCATING PATH RECLAIMS THE ODD SLOT. When it grows with one
'' unit still free it does `dst_size -= charsleft` before adding eight, so the
'' unused unit is given back rather than left as a hole -- which is what keeps
'' the returned count exact instead of one too high on a string ending in a
'' surrogate pair.
''
'' THE FILL PATH TRUNCATES A SURROGATE PAIR RATHER THAN REFUSING IT. With one
'' unit left it writes the HIGH half and stops, leaving an unpaired surrogate in
'' the caller's buffer. That is fbc's behaviour, it is reproduced, and it is why
'' a caller must size by wchars and not by characters.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/wstr.bi"
#include once "inc/sysbind.bi"

const TKORT_UTF_GROW = 8

const UTF16_MAX_BMP        = &h0000FFFFu
const UTF16_SUR_HIGH_START = &h0000D800u
const UTF16_SUR_HIGH_END   = &h0000DBFFu
const UTF16_SUR_LOW_START  = &h0000DC00u
const UTF16_HALFSHIFT      = 10
const UTF16_HALFBASE       = &h00010000u
const UTF16_HALFMASK       = &h000003FFu

type TKORT_UTF8_TRAILING
	as byte v( 0 to 255 )
end type
type TKORT_UTF8_OFFSETS
	as ulong v( 0 to 5 )
end type

extern "c"   '' NON-FBCALL: the tables live in utf/core.bas, and the three
             '' narrow converters in utf/tochar.bas.
	extern __fb_utf8_trailingTb alias "__fb_utf8_trailingTb" as TKORT_UTF8_TRAILING
	extern __fb_utf8_offsetsTb alias "__fb_utf8_offsetsTb" as TKORT_UTF8_OFFSETS
end extern

'' The width, resolved once. Everything below branches on this constant, and
'' fbc-modern folds it exactly as C folds the switch.
#if TKORT_WCHAR_SIZE = 2
	#define TKORT_WCHAR_IS_UTF16
#elseif TKORT_WCHAR_SIZE = 4
	#define TKORT_WCHAR_IS_UTF32
#else
	#error "fb_UTFToWChar: wchar is neither 2 nor 4 bytes on this target"
#endif

extern "c"   '' NON-FBCALL: fb_file.h declares fb_UTFToWChar plainly.

'' ONE UTF-8 SEQUENCE, DECODED. The trailing-byte count comes from the table,
'' the bytes are accumulated six bits at a time, and the offset table removes
'' the lead-byte marker bits in one subtraction. src is advanced past the
'' sequence.
''
'' NO VALIDATION, DELIBERATELY. A malformed sequence decodes to whatever the
'' arithmetic gives -- fbc does not check, and a checking version here would
'' reject input the C runtime accepts.
#macro TKORT_UTF8_DECODE( src, c )
	scope
		dim as integer __eb = __fb_utf8_trailingTb.v( *src )
		c = 0
		select case as const __eb
		case 5 : c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1 : c shl= 6 : c += *src : src += 1
		case 4 : c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1
		case 3 : c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1 : c shl= 6 : c += *src : src += 1
		case 2 : c += *src : src += 1 : c shl= 6 : c += *src : src += 1 : c shl= 6 : _
		         c += *src : src += 1
		case 1 : c += *src : src += 1 : c shl= 6 : c += *src : src += 1
		case else : c += *src : src += 1
		end select
		c -= __fb_utf8_offsetsTb.v( __eb )
	end scope
#endmacro

#ifdef TKORT_WCHAR_IS_UTF16

'' ----------------------------------------------------------- WCHAR is UTF-16

private function hUTF8ToUTF16( byval src as ubyte ptr, byval dst as ushort ptr, _
                               byval chars as integer ptr ) as ushort ptr

	dim as ulong c = any
	dim as integer charsleft = any
	dim as ushort ptr buffer = dst

	if( dst = 0 ) then
		dim as integer dst_size = 0
		charsleft = 0
		do
			TKORT_UTF8_DECODE( src, c )

			'' ROOM FOR TWO, not one -- a surrogate pair is two units and the
			'' pair must not be split across a realloc.
			if( charsleft < 2 ) then
				'' AND THE ODD SLOT IS RECLAIMED, so the count stays exact.
				dst_size -= charsleft
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				dim as ushort ptr nb = cptr( ushort ptr, realloc( buffer, dst_size * 2 ) )
				if( nb = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = nb
				dst = buffer + dst_size - charsleft
			end if

			if( c <= UTF16_MAX_BMP ) then
				*dst = cast( ushort, c ) : dst += 1
			else
				c -= UTF16_HALFBASE
				*dst = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START ) : dst += 1
				*dst = cast( ushort, (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START ) : dst += 1
				charsleft -= 1
			end if

			if( c = 0 ) then exit do
			charsleft -= 1
		loop

		*chars = dst_size - charsleft
	else
		charsleft = *chars
		while( charsleft > 0 )
			TKORT_UTF8_DECODE( src, c )

			if( c <= UTF16_MAX_BMP ) then
				*dst = cast( ushort, c ) : dst += 1
			else
				c -= UTF16_HALFBASE
				*dst = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START ) : dst += 1
				'' WITH ONE UNIT LEFT THE PAIR IS TRUNCATED, leaving an unpaired
				'' high surrogate -- see the file header.
				if( charsleft > 1 ) then
					*dst = cast( ushort, (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START ) : dst += 1
					charsleft -= 1
				end if
			end if

			if( c = 0 ) then exit while
			charsleft -= 1
		wend

		*chars -= charsleft
	end if

	return buffer
end function

'' UTF-16 IN, UTF-16 OUT: a copy, but the LENGTH still has to be found, and in
'' fill mode it is bounded by the caller's size.
private function hUTF16ToUTF16( byval src as ushort ptr, byval dst as ushort ptr, _
                                byval chars as integer ptr ) as ushort ptr

	dim as integer l = 0

	if( dst = 0 ) then
		while( src[l] <> 0 )
			l += 1
		wend
		dst = cptr( ushort ptr, malloc( (l + 1) * 2 ) )
		if( dst = 0 ) then return 0
		memcpy( dst, src, (l + 1) * 2 )
	else
		while( (src[l] <> 0) andalso (l < *chars) )
			l += 1
		wend
		memcpy( dst, src, l * 2 )
		'' THE TERMINATOR ONLY IF IT FITS -- a full buffer gets none.
		if( l < *chars ) then dst[l] = 0
	end if

	*chars = l
	return dst
end function

'' UTF-32 IN, UTF-16 OUT: the one direction that can GROW, because a code point
'' above the BMP becomes two units.
private function hUTF32ToUTF16( byval src as ulong ptr, byval dst as ushort ptr, _
                                byval chars as integer ptr ) as ushort ptr

	dim as ulong c = any
	dim as integer charsleft = any
	dim as ushort ptr buffer = dst

	if( dst = 0 ) then
		dim as integer dst_size = 0
		charsleft = 0
		do
			c = *src : src += 1

			if( charsleft < 2 ) then
				dst_size -= charsleft
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				dim as ushort ptr nb = cptr( ushort ptr, realloc( buffer, dst_size * 2 ) )
				if( nb = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = nb
				dst = buffer + dst_size - charsleft
			end if

			if( c > UTF16_MAX_BMP ) then
				c -= UTF16_HALFBASE
				*dst = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START ) : dst += 1
				c = (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START
				charsleft -= 1
			end if

			*dst = cast( ushort, c ) : dst += 1

			if( c = 0 ) then exit do
			charsleft -= 1
		loop

		*chars = dst_size - charsleft
	else
		charsleft = *chars
		while( charsleft > 0 )
			c = *src : src += 1

			if( c > UTF16_MAX_BMP ) then
				c -= UTF16_HALFBASE
				if( charsleft > 1 ) then
					*dst = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START ) : dst += 1
					charsleft -= 1
				end if
				c = (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START
			end if

			*dst = cast( ushort, c ) : dst += 1

			if( c = 0 ) then exit while
			charsleft -= 1
		wend

		*chars -= charsleft
	end if

	return buffer
end function

#else

'' ----------------------------------------------------------- WCHAR is UTF-32

private function hUTF8ToUTF32( byval src as ubyte ptr, byval dst as ulong ptr, _
                               byval chars as integer ptr ) as ulong ptr

	dim as ulong c = any
	dim as integer charsleft = any
	dim as ulong ptr buffer = dst

	if( dst = 0 ) then
		dim as integer dst_size = 0
		charsleft = 0
		do
			TKORT_UTF8_DECODE( src, c )

			'' ROOM FOR ONE IS ENOUGH HERE -- UTF-32 has no pairs, which is why
			'' this test is `= 0` and the UTF-16 one is `< 2`.
			if( charsleft = 0 ) then
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				dim as ulong ptr nb = cptr( ulong ptr, realloc( buffer, dst_size * 4 ) )
				if( nb = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = nb
				dst = buffer + dst_size - charsleft
			end if

			*dst = c : dst += 1

			if( c = 0 ) then exit do
			charsleft -= 1
		loop

		*chars = dst_size - charsleft
	else
		charsleft = *chars
		while( charsleft > 0 )
			TKORT_UTF8_DECODE( src, c )
			*dst = c : dst += 1
			if( c = 0 ) then exit while
			charsleft -= 1
		wend

		*chars -= charsleft
	end if

	return buffer
end function

'' UTF-16 IN, UTF-32 OUT: pairs COMBINE, so the output is never longer than the
'' input and the buffer never has to grow past the first estimate.
private function hUTF16ToUTF32( byval src as ushort ptr, byval dst as ulong ptr, _
                                byval chars as integer ptr ) as ulong ptr

	dim as ulong c = any
	dim as integer charsleft = any
	dim as ulong ptr buffer = dst

	if( dst = 0 ) then
		dim as integer dst_size = 0
		charsleft = 0
		do
			c = (*src) and &h0000FFFFu : src += 1
			if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
				c = ((c - UTF16_SUR_HIGH_START) shl UTF16_HALFSHIFT) + _
				    (cast( ulong, *src ) - UTF16_SUR_LOW_START) + UTF16_HALFBASE
				src += 1
			end if

			if( charsleft = 0 ) then
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				dim as ulong ptr nb = cptr( ulong ptr, realloc( buffer, dst_size * 4 ) )
				if( nb = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = nb
				dst = buffer + dst_size - charsleft
			end if

			*dst = c : dst += 1

			if( c = 0 ) then exit do
			charsleft -= 1
		loop

		*chars = dst_size - charsleft
	else
		charsleft = *chars
		while( charsleft > 0 )
			c = (*src) and &h0000FFFFu : src += 1
			if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
				c = ((c - UTF16_SUR_HIGH_START) shl UTF16_HALFSHIFT) + _
				    (cast( ulong, *src ) - UTF16_SUR_LOW_START) + UTF16_HALFBASE
				src += 1
			end if

			*dst = c : dst += 1

			if( c = 0 ) then exit while
			charsleft -= 1
		wend

		*chars -= charsleft
	end if

	return buffer
end function

private function hUTF32ToUTF32( byval src as ulong ptr, byval dst as ulong ptr, _
                                byval chars as integer ptr ) as ulong ptr

	dim as integer l = 0

	if( dst = 0 ) then
		while( src[l] <> 0 )
			l += 1
		wend
		dst = cptr( ulong ptr, malloc( (l + 1) * 4 ) )
		if( dst = 0 ) then return 0
		memcpy( dst, src, (l + 1) * 4 )
	else
		while( (src[l] <> 0) andalso (l < *chars) )
			l += 1
		wend
		memcpy( dst, src, l * 4 )
		if( l < *chars ) then dst[l] = 0
	end if

	*chars = l
	return dst
end function

#endif

'' ------------------------------------------------------------ the entry point

'' AN UNKNOWN ENCODING IS NULL, not an error and not a passthrough --
'' FB_FILE_ENCOD_ASCII lands here too, because a narrow file never reaches this
'' path at all.
function tkort_UTFToWChar alias "fb_UTFToWChar" _
	( byval encod as long, byval src as any ptr, byval dst as wstring ptr, _
	  byval chars as integer ptr ) as wstring ptr

	#ifdef TKORT_WCHAR_IS_UTF16
		select case encod
		case FB_FILE_ENCOD_UTF8
			return cptr( wstring ptr, hUTF8ToUTF16( src, cptr( ushort ptr, dst ), chars ) )
		case FB_FILE_ENCOD_UTF16
			return cptr( wstring ptr, hUTF16ToUTF16( src, cptr( ushort ptr, dst ), chars ) )
		case FB_FILE_ENCOD_UTF32
			return cptr( wstring ptr, hUTF32ToUTF16( src, cptr( ushort ptr, dst ), chars ) )
		end select
	#else
		select case encod
		case FB_FILE_ENCOD_UTF8
			return cptr( wstring ptr, hUTF8ToUTF32( src, cptr( ulong ptr, dst ), chars ) )
		case FB_FILE_ENCOD_UTF16
			return cptr( wstring ptr, hUTF16ToUTF32( src, cptr( ulong ptr, dst ), chars ) )
		case FB_FILE_ENCOD_UTF32
			return cptr( wstring ptr, hUTF32ToUTF32( src, cptr( ulong ptr, dst ), chars ) )
		end select
	#endif

	return 0
end function

end extern
