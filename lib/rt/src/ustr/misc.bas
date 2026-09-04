'' misc.bas -- ustr_misc.o: ASC, LSET, RSET, SWAP.
''
'' ASC RETURNS A CODE UNIT, not a codepoint -- consistent with [] indexing and
'' with LEN. ASC of a position holding a surrogate half yields that half, which
'' is what WSTRING already does on Windows. Decoding a whole scalar is the job
'' of the codepoint helpers, and giving ASC a different unit from LEN would make
'' the pair `for i = 1 to len(s): asc(s,i)` mean two different things.
''
'' LSET AND RSET PAD WITH SPACES AND NEVER RESIZE, as they do for every FB string
'' type -- note this is one place the ustring family does NOT follow the
'' NUL-padding rule that governs USTRING * N assignment and trimming. LSET is a
'' field-width operation borrowed from the fixed-record world, and its padding
'' character is part of that meaning.

#include once "inc/descriptors.bi"
#include once "inc/ustr.bi"
#include once "inc/ctx.bi"

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

extern "rtlib"
	declare function tkrt_UAllocTempDesc alias "fb_hUStrAllocTempDesc" ( ) as FBUSTRING ptr
	declare function tkrt_UDelTempDesc alias "fb_hUStrDelTempDesc" ( byval s as FBUSTRING ptr ) as long
	declare function tkrt_UAllocTempNoLock alias "fb_hUStrAllocTemp_NoLock" _
		( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	declare function tkrt_UDelTempNoLock alias "fb_hUStrDelTemp_NoLock" _
		( byval s as FBUSTRING ptr ) as long
	declare sub tkrt_UDelete alias "fb_UStrDelete" ( byval s as FBUSTRING ptr )
	declare function tkrt_UAlloc alias "fb_hUStrAlloc" _
		( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	declare function tkrt_URealloc alias "fb_hUStrRealloc" _
		( byval s as FBUSTRING ptr, byval units as integer, byval k as long ) as FBUSTRING ptr
end extern

'' Release a var-len operand. EVERY entry point that takes one must do this:
'' LEN( a + b ) hands in a temporary built for the call and nothing else will
'' free it. On the narrow side the same omission leaked 1,000 blocks per 1,000
'' iterations while every output matched and every gate passed.
private sub hRelTemp( byval src as any ptr, byval src_size as integer )
	if( src_size = FB_USTRSIZEVARLEN ) then
		tkrt_UDelTempNoLock( cptr( FBUSTRING ptr, src ) )
	end if
end sub

extern "rtlib"

function tkort_UStrAsc alias "fb_UStrAsc" _
	( byval src as any ptr, byval src_size as integer, byval pos_ as integer ) as long

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as long res = 0
	if( (pos_ >= 1) andalso (pos_ <= src_len) ) then res = src_ptr[pos_ - 1]

	hRelTemp( src, src_size )

	STRUNLOCK()
	return res

end function

'' For a var-len destination THE CURRENT LENGTH IS THE FIELD WIDTH -- the string
'' is not grown to fit, it is written into.
private sub hSet _
	( byval dst as any ptr, byval dst_size as integer, _
	  byval src as any ptr, byval src_size as integer, byval is_rset as long )

	STRLOCK()

	dim as FB_UCHAR ptr dst_ptr = any, src_ptr = any
	dim as integer dst_len = any, src_len = any
	FB_USTRSETUP( dst, dst_size, dst_ptr, dst_len )
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	if( (dst_ptr <> 0) andalso (dst_len > 0) ) then
		if( src_len > dst_len ) then src_len = dst_len

		if( is_rset <> 0 ) then
			dim as integer pad = dst_len - src_len
			for i as integer = 0 to pad - 1
				dst_ptr[i] = 32
			next
			if( src_len > 0 ) then tkrt_UStrCopyN( @dst_ptr[pad], src_ptr, src_len )
		else
			if( src_len > 0 ) then tkrt_UStrCopyN( dst_ptr, src_ptr, src_len )
			for i as integer = src_len to dst_len - 1
				dst_ptr[i] = 32
			next
		end if

		dst_ptr[dst_len] = 0
	end if

	hRelTemp( src, src_size )

	STRUNLOCK()

end sub

sub tkort_UStrLset alias "fb_UStrLset" _
	( byval dst as any ptr, byval dst_size as integer, _
	  byval src as any ptr, byval src_size as integer )
	hSet( dst, dst_size, src, src_size, 0 )
end sub

sub tkort_UStrRset alias "fb_UStrRset" _
	( byval dst as any ptr, byval dst_size as integer, _
	  byval src as any ptr, byval src_size as integer )
	hSet( dst, dst_size, src, src_size, 1 )
end sub

'' SWAP.
''
'' TWO VAR-LEN OPERANDS EXCHANGE DESCRIPTORS, NOT TEXT -- three fields, O(1),
'' both buffers stay alive and neither side reallocates. That is the case worth
'' having and the reason SWAP is not just two assignments.
''
'' If EITHER side is fixed-length the text has to move, and then the shorter
'' operand's tail is space-filled: a fixed field cannot shrink, so the units the
'' other string did not supply have to become something, and LSET's padding
'' character is what the rest of the fixed-width world uses.
sub tkort_UStrSwap alias "fb_UStrSwap" _
	( byval str1 as any ptr, byval size1 as integer, _
	  byval str2 as any ptr, byval size2 as integer )

	STRLOCK()

	dim as integer both_var = 0
	if( (size1 = FB_USTRSIZEVARLEN) andalso (size2 = FB_USTRSIZEVARLEN) ) then both_var = -1

	if( both_var ) then
		dim as FBUSTRING ptr a = cptr( FBUSTRING ptr, str1 )
		dim as FBUSTRING ptr b = cptr( FBUSTRING ptr, str2 )
		if( (a <> 0) andalso (b <> 0) ) then
			dim as FBUSTRING t = *a
			*a = *b
			*b = t
		end if
	else
		dim as FB_UCHAR ptr p1 = any, p2 = any
		dim as integer l1 = any, l2 = any
		FB_USTRSETUP( str1, size1, p1, l1 )
		FB_USTRSETUP( str2, size2, p2, l2 )

		dim as integer n = l1
		if( l2 > n ) then n = l2

		for i as integer = 0 to n - 1
			dim as FB_UCHAR c1 = 32, c2 = 32
			if( i < l1 ) then c1 = p1[i]
			if( i < l2 ) then c2 = p2[i]
			if( i < l1 ) then p1[i] = c2
			if( i < l2 ) then p2[i] = c1
		next
	end if

	STRUNLOCK()

end sub

end extern
