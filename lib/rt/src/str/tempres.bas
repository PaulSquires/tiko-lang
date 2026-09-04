'' tempres.bas -- fb_StrAllocTempResult (str_tempres.o).
''
'' Moves a function's string result off the stack: the descriptor about to go out
'' of scope hands its block to a pool descriptor, which is marked TEMP so the
'' caller's cleanup frees it.
''
'' THREE THINGS SEPARATE IT FROM fb_StrAllocTempDescV, which is otherwise the
'' same eight lines:
''
'' 1. THE TEMP BIT IS SET -- `src->len or FB_TEMPSTRBIT`, and note it takes the
''    RAW len, not FB_STRSIZE, so a source that already carried the bit keeps it.
'' 2. THE SOURCE IS CLEARED. This is a MOVE: data, len and size are zeroed so the
''    stack descriptor's destructor cannot free the block the result now owns.
''    fbc's comment calls it "just for safety"; it is load-bearing.
'' 3. THE UNLOCK IS ON BOTH PATHS. The exhaustion path unlocks before returning
''    the shared empty -- a detail that reads as noise until you notice the other
''    two files in this family unlock before the NULL test rather than after.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"

extern "rtlib"
	declare function fb_hStrAllocTempDesc alias "fb_hStrAllocTempDesc" ( ) as FBSTRING ptr
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

function tkort_StrAllocTempResult alias "fb_StrAllocTempResult" _
	( byval src as FBSTRING ptr ) as FBSTRING ptr

	STRLOCK()

	dim as FBSTRING ptr dsc = fb_hStrAllocTempDesc( )
	if( dsc = 0 ) then
		STRUNLOCK()
		return TKORT_NULLSTR( )
	end if

	'' RAW len, with the temp bit forced on.
	dsc->data = src->data
	dsc->len = src->len or FB_TEMPSTRBIT
	dsc->size = src->size

	'' The move half: the source must not free what the result now owns.
	src->data = 0
	src->len = 0
	src->size = 0

	STRUNLOCK()

	return dsc

end function

end extern
