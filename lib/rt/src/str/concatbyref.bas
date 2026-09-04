'' concatbyref.bas -- fb_StrConcatByref (str_concatbyref.o).
''
'' `dst &= src` where the two may be the SAME string. Everything except the
'' aliasing case is delegated straight to fb_StrConcatAssign; this member exists
'' for the one case that cannot be handled in place, because the realloc may move
'' the block out from under the source pointer.
''
'' ------------------------------------------------------------------------
'' A DIVERGENCE REPRODUCED DELIBERATELY -- fbc's self-concat copies from the
'' DESCRIPTOR, not from the string data:
''
''     FB_MEMCPYX( dst_ptr + dst_len, dst, dst_len )
''
'' `dst` here is the `void *` parameter, which for a var-len string is the
'' FBSTRING* itself. FB_MEMCPYX is (dest, src, n), so the source operand is the
'' descriptor's own bytes -- its data pointer, len and size -- and not the
'' characters. The second half of the result is therefore descriptor memory.
''
'' It is invisible in practice because ORDINARY `s &= s` DOES NOT COME HERE:
'' measured, fbc compiles that to fb_StrConcat + fb_StrAssign, and the probe
'' returns "abcdefabcdef" correctly. Whatever reaches fb_StrConcatByref with
'' dst == src is rare enough that fbc's 2,715-file suite does not cover it.
''
'' REPRODUCED RATHER THAN FIXED, because this library's contract is "behaves
'' identically to libfb", and a tiko-rt that quietly produced the RIGHT answer
'' here would differ from fbc on the one input that reaches it. Flagged for the
'' author instead: it looks like a real bug in fbc-modern, one character wide.
'' ------------------------------------------------------------------------

#include once "inc/descriptors.bi"

extern "rtlib"
	declare function fb_hStrRealloc alias "fb_hStrRealloc" _
		( byval s as FBSTRING ptr, byval length as integer, byval keepdata as long ) as FBSTRING ptr
	declare function tkrt_DelTempNoLock alias "fb_hStrDelTemp_NoLock" _
		( byval s as FBSTRING ptr ) as long
	declare function tkrt_ConcatAssign alias "fb_StrConcatAssign" _
		( byval dst as any ptr, byval dst_size as integer, _
		  byval src as any ptr, byval src_size as integer, byval fillrem as long ) as any ptr
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

function tkort_StrConcatByref alias "fb_StrConcatByref" _
	( _
		byval dst as any ptr, byval dst_size as integer, _
		byval src as any ptr, byval src_size as integer, byval fillrem as long _
	) as any ptr

	dim as zstring ptr dst_ptr = any, src_ptr = any
	dim as integer dst_len = any, src_len = any

	FB_STRSETUP_FIX( dst, dst_size, dst_ptr, dst_len )
	FB_STRSETUP_FIX( src, src_size, src_ptr, src_len )

	dim as integer aliased = 0
	if( dst = src ) then aliased = 1
	if( dst_ptr = src_ptr ) then aliased = 1

	if( aliased <> 0 ) then
		dim as FBSTRING ptr s = cptr( FBSTRING ptr, dst )

		STRLOCK()

		if( fb_hStrRealloc( s, dst_len + dst_len, 1 ) <> 0 ) then
			'' Re-read: the block may have moved.
			FB_STRSETUP_FIX( s, dst_size, dst_ptr, dst_len )

			'' See the note above. The source operand is `dst`, the DESCRIPTOR,
			'' and that is fbc's behaviour rather than a transcription slip.
			memcpy( cptr( ubyte ptr, dst_ptr ) + dst_len, dst, dst_len )

			'' FB_STRSETLEN, not a call: fb_hStrSetLength is `static __inline__` in
			'' fb_string.h and is therefore NOT an exported symbol -- it inlines into
			'' every C caller and exists nowhere to link against. Declaring it produced
			'' an undefined reference in all 17 differentials at once, which is the
			'' harness reporting a link failure rather than 17 behavioural ones.
			'' descriptors.bi's macro does the same thing: write the length while
			'' PRESERVING the temp bit.
			FB_STRSETLEN( s, dst_len + dst_len )
			s->data[dst_len + dst_len] = 0
		end if

		if( dst_size = FB_STRSIZEVARLEN ) then
			tkrt_DelTempNoLock( cptr( FBSTRING ptr, dst ) )
		end if
		if( src_size = FB_STRSIZEVARLEN ) then
			tkrt_DelTempNoLock( cptr( FBSTRING ptr, src ) )
		end if

		STRUNLOCK()

		return dst
	end if

	return tkrt_ConcatAssign( dst, dst_size, src, src_size, fillrem )

end function

end extern
