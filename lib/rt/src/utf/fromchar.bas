'' fromchar.bas -- a byte string to UTF-8/16/32. One entry point over one fbc
'' member.
''
'' THIS IS A WIDENING, NOT AN ENCODING. Every input byte is treated as a code
'' point in 0-255, so the UTF-16 and UTF-32 forms are plain zero-extensions and
'' only the UTF-8 form actually encodes anything. A byte of 0xE9 becomes U+00E9
'' -- Latin-1, not the caller's code page, and not a UTF-8 continuation byte.
''
'' `bytes` IS ALWAYS SET, INCLUDING WHEN chars IS 0, and is a BYTE count while
'' `chars` is a CHARACTER count. The two differ by a factor of 1, 2 or 4 -- and
'' by a variable factor for UTF-8, which is why that path gets the count from
'' the encoder rather than computing it.
''
'' A NULL dst MEANS ALLOCATE, and the allocation is malloc, so the caller frees
'' with free. THE UTF-8 BUFFER IS chars * 2, WITH NO TERMINATOR: the widest a
'' single byte can encode to is two, and nothing here writes a NUL. A caller
'' that expects a terminated string gets whatever followed the allocation.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "crt/stdlib.bi"

extern "c"   '' NON-FBCALL: fb_file.h declares both of these plain.

declare sub tkrt_CharToUTF8 alias "fb_hCharToUTF8" _
	( byval src as ubyte ptr, byval chars as integer, _
	  byval dst as ubyte ptr, byval total_bytes as integer ptr )

private function hToUTF8( byval src as ubyte ptr, byval chars as integer, _
                          byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr
	if( chars > 0 ) then
		if( dst = 0 ) then
			'' chars * 2: the worst case for a single byte, exactly.
			dst = malloc( chars * 2 )
			if( dst = 0 ) then return 0
		end if
		tkrt_CharToUTF8( src, chars, dst, bytes_ )
	else
		'' Set even on the empty path -- callers read it unconditionally.
		*bytes_ = 0
	end if
	return dst
end function

'' LITTLE-ENDIAN ONLY, and fbc says so in a FIXME. The units are stored with a
'' plain assignment, so the byte order is the host's.
private function hToUTF16( byval src as ubyte ptr, byval chars as integer, _
                           byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr
	dim as ushort ptr p = any

	'' Computed BEFORE the allocation can fail, and left set even then.
	*bytes_ = chars * sizeof( ushort )

	if( chars > 0 ) then
		if( dst = 0 ) then
			dst = malloc( chars * sizeof( ushort ) )
			if( dst = 0 ) then return 0
		end if
	end if

	p = cptr( ushort ptr, dst )
	while( chars > 0 )
		'' Read as UNSIGNED: a signed char would sign-extend 0x80-0xFF into
		'' 0xFF80-0xFFFF instead of 0x0080-0x00FF.
		*p = *src : p += 1 : src += 1
		chars -= 1
	wend

	return dst
end function

private function hToUTF32( byval src as ubyte ptr, byval chars as integer, _
                           byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr
	dim as ulong ptr p = any

	*bytes_ = chars * sizeof( ulong )

	if( chars > 0 ) then
		if( dst = 0 ) then
			dst = malloc( chars * sizeof( ulong ) )
			if( dst = 0 ) then return 0
		end if
	end if

	p = cptr( ulong ptr, dst )
	while( chars > 0 )
		*p = *src : p += 1 : src += 1
		chars -= 1
	wend

	return dst
end function

'' An unknown encoding returns NULL and LEAVES `bytes` UNTOUCHED -- unlike
'' every path above, which always sets it. A caller that ignores the NULL reads
'' whatever was in its own variable.
function tkort_CharToUTF alias "fb_CharToUTF" _
	( byval encod as long, byval src as ubyte ptr, byval chars as integer, _
	  byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr

	select case encod
	case FB_FILE_ENCOD_UTF8
		return hToUTF8( src, chars, dst, bytes_ )
	case FB_FILE_ENCOD_UTF16
		return hToUTF16( src, chars, dst, bytes_ )
	case FB_FILE_ENCOD_UTF32
		return hToUTF32( src, chars, dst, bytes_ )
	end select
	return 0
end function

end extern
