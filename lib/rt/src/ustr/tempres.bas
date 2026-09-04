'' tempres.bas -- ustr_tempres.o: the temporary a ustring-returning FUNCTION
'' hands back.
''
'' A FUNCTION RETURNING A USTRING ACTUALLY RETURNS A POINTER TO A DESCRIPTOR --
'' fbc rewrites the result type in symbProcRecalcRealType. The callee's own
'' result variable lives on ITS STACK FRAME, which is dead the instant it
'' returns, so the descriptor's three fields are MOVED into a pooled temp
'' descriptor and a pointer to that is returned instead.
''
'' SETTING FB_TEMPSTRBIT IS THE WHOLE POINT. It is what makes the caller's
'' assignment STEAL the buffer rather than copy it, and what makes
'' fb_hUStrDelTemp free the data when the result is discarded. Without it,
'' `s = f()` copies and `f()` on its own leaks.
''
'' AND THE SOURCE IS CLEARED. Ownership has moved; leaving the pointer behind
'' gives the dying stack frame something it could free a second time.

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

function tkort_UStrAllocTempResult alias "fb_UStrAllocTempResult" _
	( byval src as FBUSTRING ptr ) as FBUSTRING ptr

	STRLOCK()

	dim as FBUSTRING ptr dsc = tkrt_UAllocTempDesc( )
	if( dsc = 0 ) then
		'' The shared empty descriptor, not NULL -- the caller dereferences it.
		STRUNLOCK()
		return TKORT_UNULLSTR()
	end if

	'' Just the descriptor moves. No data is copied, which is what makes
	'' returning a long ustring from a function O(1).
	dsc->data = src->data
	dsc->len  = src->len or FB_TEMPSTRBIT
	dsc->size = src->size

	src->data = 0
	src->len  = 0
	src->size = 0

	STRUNLOCK()
	return dsc

end function

end extern
