'' convw.bas -- ustr_convw.o: USTRING <-> WSTRING, four entry points.
''
'' THE ASYMMETRY THIS MODULE EXISTS FOR.
''
'' A ustring code unit is 16 bits on EVERY target. FB_WCHAR is wchar_t: 16 bits
'' on Windows, 32 on Linux. So:
''
''   Windows  ustring and wstring are the SAME representation. Copying is a
''            widening-free element copy and the compiler can often hand out the
''            buffer pointer with no conversion at all.
''   Linux    every character is re-encoded, UTF-16 <-> UTF-32, into a fresh
''            buffer, and the CHARACTER count is not the UNIT count.
''
'' THE BRANCHES ARE ON sizeof, NOT #ifdef, and that is not a stylistic choice.
'' A branch selected by #ifdef is not compiled on the other target and therefore
'' is not even type-checked there; a branch selected by sizeof folds away just
'' the same and still has to compile. This project has shipped a Windows-only
'' correctness bug of exactly this shape twice.
''
'' ==================================================== THE SURROGATE RULE
''
'' The two directions do NOT treat a lone surrogate the same way, and the
'' asymmetry is deliberate.
''
''   wstring -> ustring   D800-DFFF is PASSED THROUGH, not replaced.
''
''       It is not a valid UTF-32 scalar, but the destination is a ustring -- an
''       array of UTF-16 code units -- and D800-DFFF is exactly what a code unit
''       may hold. WCHR( &hD83D, &hDE00 ) builds two chars; on Windows those two
''       ARE the code units of U+1F600 and are copied intact. Replacing them on
''       Linux turned a correct surrogate PAIR into FFFD FFFD -- the same source
''       producing a different character per target, with no diagnostic.
''
''   ustring -> wstring   a LONE surrogate becomes U+FFFD (32-bit wchar only).
''
''       Here the destination is a UTF-32 scalar buffer that goes on to libc and
''       the OS -- wprintf, wcsrtombs, path arguments -- and glibc's converters
''       reject D800-DFFF. This is the same rule the UTF-8 encoder follows:
''       substitute only where the target representation genuinely cannot hold
''       the value. A well-formed PAIR round-trips in both directions.

#include once "inc/descriptors.bi"
#include once "inc/ustr.bi"
#include once "inc/ctx.bi"
#include once "inc/sysbind.bi"

#ifdef ENABLE_MT
	extern "rtlib"
		declare sub fb_StrLock alias "fb_StrLock" ( )
		declare sub fb_StrUnlock alias "fb_StrUnlock" ( )
	end extern
	#define STRLOCK()   fb_StrLock()
	#define STRUNLOCK() fb_StrUnlock()
#else
	#define STRLOCK()
	#define STRUNLOCK()
#endif

extern "c"   '' NON-FBCALL: fb_ustring.h declares the codepoint reader plainly.
	declare function tkrt_CodepointAt alias "fb_hUStrCodepointAt" _
		( byval s as FB_UCHAR ptr, byval units as integer, _
		  byval index_ as integer, byval used as integer ptr ) as ulong
end extern

extern "rtlib"
	declare function tkrt_UAllocTempNoLock alias "fb_hUStrAllocTemp_NoLock" _
		( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	declare function tkrt_UDelTempNoLock alias "fb_hUStrDelTemp_NoLock" _
		( byval s as FBUSTRING ptr ) as long
	declare function tkrt_UStrAssignEx alias "fb_UStrAssignEx" _
		( byval dst as any ptr, byval dst_size as integer, _
		  byval src as any ptr, byval src_size as integer, _
		  byval fill_rem as long, byval is_init as long ) as any ptr
end extern

const FB_UCHAR_MAX_CP     as ulong = &h10FFFF
const FB_UCHAR_REPLACEMENT as ulong = &hFFFD

'' wstring -> ustring, into a caller-provided buffer sized by a measure pass.
'' `dst` may be NULL to measure only; returns units written, excluding the
'' terminator.
private function hWcharToUnits _
	( byval src as wstring ptr, byval src_chars as integer, _
	  byval dst as FB_UCHAR ptr, byval dst_units as integer ) as integer

	if( sizeof( wstring ) = 2 ) then
		'' Already UTF-16, surrogate pairs included.
		dim as ushort ptr s = cptr( ushort ptr, src )
		dim as integer n = src_chars
		if( dst <> 0 ) then
			dim as integer lim = iif( n < dst_units, n, dst_units )
			for i as integer = 0 to lim - 1
				dst[i] = s[i]
			next
			dst[lim] = 0
		end if
		return n
	else
		'' UTF-32 -> UTF-16. A scalar above the BMP becomes a PAIR, so the unit
		'' count is not the character count -- which is the whole reason the
		'' measure pass exists.
		dim as ulong ptr s = cptr( ulong ptr, src )
		dim as integer n = 0
		for i as integer = 0 to src_chars - 1
			dim as ulong cp = s[i]
			'' Above U+10FFFF cannot be written down at all; a surrogate value
			'' CAN, and is passed through -- see the header.
			if( cp > FB_UCHAR_MAX_CP ) then cp = FB_UCHAR_REPLACEMENT
			if( cp < &h10000 ) then
				if( (dst <> 0) andalso (n < dst_units) ) then dst[n] = cast( FB_UCHAR, cp )
				n += 1
			else
				dim as ulong v = cp - &h10000
				if( (dst <> 0) andalso (n < dst_units) ) then _
					dst[n] = cast( FB_UCHAR, &hD800 + (v shr 10) )
				n += 1
				if( (dst <> 0) andalso (n < dst_units) ) then _
					dst[n] = cast( FB_UCHAR, &hDC00 + (v and &h3FF) )
				n += 1
			end if
		next
		if( dst <> 0 ) then dst[iif( n < dst_units, n, dst_units )] = 0
		return n
	end if

end function

'' ustring -> wstring. Returns chars written, excluding the terminator.
private function hUnitsToWchar _
	( byval src as FB_UCHAR ptr, byval src_units as integer, _
	  byval dst as wstring ptr, byval dst_chars as integer ) as integer

	if( sizeof( wstring ) = 2 ) then
		dim as ushort ptr d = cptr( ushort ptr, dst )
		dim as integer n = src_units
		if( dst <> 0 ) then
			dim as integer lim = iif( n < dst_chars, n, dst_chars )
			for i as integer = 0 to lim - 1
				d[i] = src[i]
			next
			d[lim] = 0
		end if
		return n
	else
		'' UTF-16 -> UTF-32: a pair COLLAPSES into one char, and a lone
		'' surrogate becomes U+FFFD -- the one direction that still substitutes.
		dim as ulong ptr d = cptr( ulong ptr, dst )
		dim as integer i = 0, n = 0
		while( i < src_units )
			dim as integer used = any
			dim as ulong cp = tkrt_CodepointAt( src, src_units, i, @used )
			if( (dst <> 0) andalso (n < dst_chars) ) then d[n] = cp
			n += 1
			i += used
		wend
		if( dst <> 0 ) then d[iif( n < dst_chars, n, dst_chars )] = 0
		return n
	end if

end function

'' --------------------------------------------------------- the entry points

extern "rtlib"

'' NOTE: NO LOCK. fb_UStrAssignEx takes it, and nothing before that call touches
'' shared state -- a wstring is a bare pointer with no descriptor and no temp
'' pool behind it, so there is nothing here to serialise.
function tkort_UStrAssignFromW alias "fb_UStrAssignFromW" _
	( byval dst as any ptr, byval dst_size as integer, _
	  byval src as wstring ptr, byval fill_rem as long, byval is_init as long ) as any ptr

	if( dst = 0 ) then return dst

	dim as integer src_chars = 0
	if( src <> 0 ) then src_chars = cast( integer, wcslen( src ) )

	dim as integer units = hWcharToUnits( src, src_chars, 0, 0 )
	dim as FB_UCHAR ptr tmp = cptr( FB_UCHAR ptr, allocate( (units + 1) * sizeof( FB_UCHAR ) ) )
	if( tmp = 0 ) then return dst

	hWcharToUnits( src, src_chars, tmp, units )

	'' Through the ordinary ustring assign, so USTRING * N clamping, the
	'' terminator and the is_init split are decided in exactly one place.
	tkrt_UStrAssignEx( dst, dst_size, tmp, units or FB_STRISFIXED, fill_rem, is_init )

	deallocate( tmp )
	return dst

end function

function tkort_UStrAssignToW alias "fb_UStrAssignToW" _
	( byval dst as wstring ptr, byval dst_chars as integer, _
	  byval src as any ptr, byval src_size as integer ) as wstring ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	if( dst <> 0 ) then
		'' dst_chars is the DECLARED capacity INCLUDING the terminator, which is
		'' how the compiler passes a WSTRING * N length. A non-positive value
		'' means "no declared capacity" and the source length is used, so a raw
		'' WSTRING PTR destination is not silently truncated to nothing.
		dim as integer cap = src_len
		if( dst_chars > 0 ) then cap = dst_chars - 1
		hUnitsToWchar( src_ptr, src_len, dst, cap )
	end if

	if( src_size = FB_USTRSIZEVARLEN ) then
		tkrt_UDelTempNoLock( cptr( FBUSTRING ptr, src ) )
	end if

	STRUNLOCK()
	return dst

end function

'' -------------------------------------------------- expression conversions

function tkort_WstrToUStr alias "fb_WstrToUStr" ( byval src as wstring ptr ) as FBUSTRING ptr

	STRLOCK()

	dim as integer src_chars = 0
	if( src <> 0 ) then src_chars = cast( integer, wcslen( src ) )

	dim as integer units = hWcharToUnits( src, src_chars, 0, 0 )

	dim as FBUSTRING ptr dst = tkrt_UAllocTempNoLock( 0, units )
	if( dst <> 0 ) then
		if( dst->data <> 0 ) then hWcharToUnits( src, src_chars, dst->data, units )
	else
		'' The shared empty descriptor, not NULL: fbc's codegen dereferences the
		'' result unconditionally.
		dst = TKORT_UNULLSTR()
	end if

	STRUNLOCK()
	return dst

end function

'' ustring -> a freshly allocated wchar buffer.
''
'' THE CALLER FREES IT, with fb_WstrDelete -- matching every other
'' wstring-returning entry point. On Windows this still allocates even though
'' the representations agree; the compiler avoids calling it at all where it can
'' hand out the buffer directly instead.
function tkort_UStrToWstr alias "fb_UStrToWstr" _
	( byval src as any ptr, byval src_size as integer ) as wstring ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as integer chars = hUnitsToWchar( src_ptr, src_len, 0, 0 )

	dim as wstring ptr dst = cptr( wstring ptr, allocate( (chars + 1) * sizeof( wstring ) ) )
	if( dst <> 0 ) then hUnitsToWchar( src_ptr, src_len, dst, chars )

	if( src_size = FB_USTRSIZEVARLEN ) then
		tkrt_UDelTempNoLock( cptr( FBUSTRING ptr, src ) )
	end if

	STRUNLOCK()
	return dst

end function

end extern
