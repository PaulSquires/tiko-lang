'' tochar.bas -- UTF-8/16/32 to a byte string. Four entry points over one fbc
'' member.
''
'' EVERY CODE POINT ABOVE 255 BECOMES '?'. These are not Unicode-preserving
'' conversions; they are the narrow-file read path, and the whole point is that
'' the result is one byte per character. A decoder that preserved the code
'' point would produce a longer string and desynchronise every caller's count.
''
'' TWO CALLING MODES, SELECTED BY dst:
''
''   dst = NULL   allocate. `chars` is IGNORED on entry, the buffer grows in
''                blocks of 8 by realloc, conversion runs to the source's NUL,
''                and the terminator IS written. The caller frees.
''   dst <> NULL  fill. `chars` is the maximum on entry, and the source need
''                not be terminated.
''
'' IN BOTH MODES `chars` RETURNS A COUNT THAT EXCLUDES THE TERMINATOR, and in
'' fill mode the count is the same whether the conversion stopped ON the NUL or
'' one character before it. The caller cannot tell from `chars` whether a
'' terminator was written -- fbc documents this and it is reproduced here.
''
'' THE FILL LOOP BREAKS ON NUL WITHOUT DECREMENTING charsleft. That is what
'' keeps the NUL out of the returned count; decrementing first would report one
'' character too many for every terminated string.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "crt/stdlib.bi"

const TKORT_UTF_GROW = 8
const TKORT_UTF_SUBST = 63          '' '?'
const UTF16_SUR_HIGH_START = &hD800u
const UTF16_SUR_HIGH_END   = &hDBFFu

type TKORT_UTF8_TRAILING
	as byte v( 0 to 255 )
end type
type TKORT_UTF8_OFFSETS
	as ulong v( 0 to 5 )
end type

extern "c"   '' NON-FBCALL: the tables live in utf/core.bas; no FBCALL anywhere.
	extern __fb_utf8_trailingTb alias "__fb_utf8_trailingTb" as TKORT_UTF8_TRAILING
	extern __fb_utf8_offsetsTb alias "__fb_utf8_offsetsTb" as TKORT_UTF8_OFFSETS
end extern

extern "c"   '' NON-FBCALL: none of these appear in a header with FBCALL.

function tkort_UTF8ToChar alias "fb_hUTF8ToChar" _
	( byval src as ubyte ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr

	dim as ulong c = any
	dim as integer extbytes = any, charsleft = any, dst_size = any, k = any
	dim as ubyte ptr buffer = dst
	dim as ubyte ptr newbuffer = any

	if( dst = 0 ) then
		dst_size = 0
		charsleft = 0
		do
			extbytes = __fb_utf8_trailingTb.v(*src)
			'' The lead byte and every continuation are added RAW and
			'' shifted; the marker bits ride along in the total and are
			'' removed in one subtraction below.
			c = 0
			for k = extbytes to 1 step -1
				c += *src : src += 1
				c shl= 6
			next
			c += *src : src += 1
			c -= __fb_utf8_offsetsTb.v(extbytes)

			if( c > 255 ) then c = TKORT_UTF_SUBST

			if( charsleft = 0 ) then
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				newbuffer = realloc( buffer, dst_size )
				if( newbuffer = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = newbuffer
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
			extbytes = __fb_utf8_trailingTb.v(*src)
			c = 0
			for k = extbytes to 1 step -1
				c += *src : src += 1
				c shl= 6
			next
			c += *src : src += 1
			c -= __fb_utf8_offsetsTb.v(extbytes)

			if( c > 255 ) then c = TKORT_UTF_SUBST

			*dst = c : dst += 1
			'' Break BEFORE decrementing, so the NUL is not counted.
			if( c = 0 ) then exit while
			charsleft -= 1
		wend
		*chars -= charsleft
	end if

	return buffer
end function

'' UTF-16. A HIGH SURROGATE CONSUMES ITS PAIR AND EMITS ONE '?'. Skipping only
'' the high half would leave the low half to be decoded as a separate
'' character, so a single astral code point would produce TWO '?' instead of
'' one and every subsequent count would be off by one. An unpaired LOW
'' surrogate is not special-cased: it is simply > 255 and becomes '?'.
function tkort_UTF16ToChar alias "fb_hUTF16ToChar" _
	( byval src as ushort ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr

	dim as ulong c = any
	dim as integer charsleft = any, dst_size = any
	dim as ubyte ptr buffer = dst
	dim as ubyte ptr newbuffer = any

	if( dst = 0 ) then
		dst_size = 0
		charsleft = 0
		do
			c = *src : src += 1
			if( c > 255 ) then
				if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
					src += 1
				end if
				c = TKORT_UTF_SUBST
			end if

			if( charsleft = 0 ) then
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				newbuffer = realloc( buffer, dst_size )
				if( newbuffer = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = newbuffer
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
			c = *src : src += 1
			if( c > 255 ) then
				if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
					src += 1
				end if
				c = TKORT_UTF_SUBST
			end if
			*dst = c : dst += 1
			if( c = 0 ) then exit while
			charsleft -= 1
		wend
		*chars -= charsleft
	end if

	return buffer
end function

'' UTF-32. No surrogates to consider: anything above 255 is one '?'.
function tkort_UTF32ToChar alias "fb_hUTF32ToChar" _
	( byval src as ulong ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr

	dim as ulong c = any
	dim as integer charsleft = any, dst_size = any
	dim as ubyte ptr buffer = dst
	dim as ubyte ptr newbuffer = any

	if( dst = 0 ) then
		dst_size = 0
		charsleft = 0
		do
			c = *src : src += 1
			if( c > 255 ) then c = TKORT_UTF_SUBST

			if( charsleft = 0 ) then
				charsleft = TKORT_UTF_GROW
				dst_size += charsleft
				newbuffer = realloc( buffer, dst_size )
				if( newbuffer = 0 ) then
					free( buffer )
					return 0
				end if
				buffer = newbuffer
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
			c = *src : src += 1
			if( c > 255 ) then c = TKORT_UTF_SUBST
			*dst = c : dst += 1
			if( c = 0 ) then exit while
			charsleft -= 1
		wend
		*chars -= charsleft
	end if

	return buffer
end function

'' The dispatcher. AN UNKNOWN ENCODING RETURNS NULL rather than falling back to
'' ASCII -- including FB_FILE_ENCOD_ASCII itself, which is not a UTF encoding
'' and has no business here.
function tkort_UTFToChar alias "fb_UTFToChar" _
	( byval encod as long, byval src as any ptr, byval dst as ubyte ptr, _
	  byval chars as integer ptr ) as ubyte ptr

	select case encod
	case FB_FILE_ENCOD_UTF8
		return tkort_UTF8ToChar( src, dst, chars )
	case FB_FILE_ENCOD_UTF16
		return tkort_UTF16ToChar( src, dst, chars )
	case FB_FILE_ENCOD_UTF32
		return tkort_UTF32ToChar( src, dst, chars )
	end select
	return 0
end function

end extern
