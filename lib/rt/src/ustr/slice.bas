'' slice.bas -- ustr_slice.o: LEFT, RIGHT, MID (both forms), SPACE, STRING.
''
'' POSITIONS AND LENGTHS ARE IN CODE UNITS, 1-based, as everywhere in FB.
''
'' CODE UNITS, NOT CHARACTERS -- and that is a decision, not a shortcut. LEN()
'' and [] indexing are both O(1) and unit-based, so making the slicers
'' character-based would put them alone in the family and cost a decode per
'' call. The consequence is that MID CAN SPLIT A SURROGATE PAIR, exactly as it
'' can on WSTRING today. Slicing blind to encoding is a property of UTF-16, not
'' something USTRING introduces; callers that need character boundaries walk
'' them with the codepoint helpers.
''
'' TWO PATTERNS APPEAR IN EVERY ONE OF THE NINE, and both are load-bearing:
''
''   AN EMPTY RESULT IS THE SHARED EMPTY DESCRIPTOR, never a zero-length
''   temporary. Nothing is allocated and nothing has to be released.
''
''   EVERY VAR-LEN OPERAND IS RELEASED. LEFT( a + b, 2 ) hands in a temporary
''   built for the call, and nothing else will free it. On the narrow side this
''   exact omission leaked 1,000 blocks per 1,000 iterations while every output
''   matched and every gate passed.

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
	declare function tkrt_UAllocTempNoLock alias "fb_hUStrAllocTemp_NoLock" _
		( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	declare function tkrt_UDelTempNoLock alias "fb_hUStrDelTemp_NoLock" _
		( byval s as FBUSTRING ptr ) as long
end extern

private function hTempFrom _
	( byval src as FB_UCHAR ptr, byval units as integer ) as FBUSTRING ptr
	if( units <= 0 ) then return TKORT_UNULLSTR()
	dim as FBUSTRING ptr dst = tkrt_UAllocTempNoLock( 0, units )
	if( dst = 0 ) then return TKORT_UNULLSTR()
	if( dst->data <> 0 ) then tkrt_UStrCopy( dst->data, src, units )
	return dst
end function

private sub hRelTemp( byval src as any ptr, byval src_size as integer )
	if( src_size = FB_USTRSIZEVARLEN ) then
		tkrt_UDelTempNoLock( cptr( FBUSTRING ptr, src ) )
	end if
end sub

'' The three fill entry points differ only in where the unit comes from, so the
'' allocate-fill-terminate part is written once. NOTE THE EXPLICIT TERMINATOR:
'' fb_hUStrFill does not write one, and the wide allocator does not either.
private function hFilled( byval units as integer, byval c as FB_UCHAR ) as FBUSTRING ptr
	if( units <= 0 ) then return TKORT_UNULLSTR()
	dim as FBUSTRING ptr dst = tkrt_UAllocTempNoLock( 0, units )
	if( dst = 0 ) then return TKORT_UNULLSTR()
	if( dst->data <> 0 ) then
		tkrt_UStrFill( dst->data, c, units )
		dst->data[units] = 0
	end if
	return dst
end function

extern "rtlib"

function tkort_UStrLeft alias "fb_UStrLeft" _
	( byval src as any ptr, byval src_size as integer, byval units as integer ) as FBUSTRING ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	if( units > src_len ) then units = src_len

	dim as FBUSTRING ptr dst = hTempFrom( src_ptr, units )

	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst

end function

function tkort_UStrRight alias "fb_UStrRight" _
	( byval src as any ptr, byval src_size as integer, byval units as integer ) as FBUSTRING ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	if( units > src_len ) then units = src_len

	'' The <= 0 case is tested HERE rather than left to hTempFrom, because the
	'' index expression below would run first and read src_ptr[src_len - units]
	'' with a negative count.
	dim as FBUSTRING ptr dst = any
	if( units <= 0 ) then
		dst = TKORT_UNULLSTR()
	else
		dst = hTempFrom( @src_ptr[src_len - units], units )
	end if

	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst

end function

'' MID( s, start [, units] ). start is 1-based; a NEGATIVE unit count means "to
'' the end", matching fb_WstrMid. A count of exactly ZERO yields empty, and is
'' rejected up front alongside the out-of-range starts.
function tkort_UStrMid alias "fb_UStrMid" _
	( byval src as any ptr, byval src_size as integer, _
	  byval start_ as integer, byval units as integer ) as FBUSTRING ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as FBUSTRING ptr dst = any
	dim as integer bad = 0
	if( src_len = 0 ) then bad = -1
	if( start_ <= 0 ) then bad = -1
	if( start_ > src_len ) then bad = -1
	if( units = 0 ) then bad = -1

	if( bad ) then
		dst = TKORT_UNULLSTR()
	else
		start_ -= 1
		if( units < 0 ) then units = src_len
		if( start_ + units > src_len ) then units = src_len - start_
		dst = hTempFrom( @src_ptr[start_], units )
	end if

	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst

end function

'' MID( dst, start [, units] ) = src -- OVERWRITES IN PLACE AND NEVER RESIZES.
'' That is FB's MID statement, shared by every string type: the destination's
'' length is fixed and the copy is clamped to what is already there.
sub tkort_UStrAssignMid alias "fb_UStrAssignMid" _
	( byval dst as any ptr, byval dst_size as integer, _
	  byval start_ as integer, byval units as integer, _
	  byval src as any ptr, byval src_size as integer )

	STRLOCK()

	dim as FB_UCHAR ptr dst_ptr = any, src_ptr = any
	dim as integer dst_len = any, src_len = any
	FB_USTRSETUP( dst, dst_size, dst_ptr, dst_len )
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as integer ok = -1
	if( dst_ptr = 0 ) then ok = 0
	if( start_ <= 0 ) then ok = 0
	if( start_ > dst_len ) then ok = 0

	if( ok ) then
		start_ -= 1
		if( units < 0 ) then units = src_len
		if( units > src_len ) then units = src_len
		if( start_ + units > dst_len ) then units = dst_len - start_
		'' CopyN, not Copy: this writes INTO an existing string and must not
		'' plant a terminator after the region it was given.
		if( units > 0 ) then tkrt_UStrCopyN( @dst_ptr[start_], src_ptr, units )
	end if

	hRelTemp( src, src_size )
	STRUNLOCK()

end sub

function tkort_UStrSpace alias "fb_UStrSpace" ( byval units as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hFilled( units, 32 )
	STRUNLOCK()
	return dst
end function

function tkort_UStrFill1 alias "fb_UStrFill1" _
	( byval units as integer, byval unit as long ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hFilled( units, cast( FB_UCHAR, unit ) )
	STRUNLOCK()
	return dst
end function

'' STRING( n, s ) repeats the FIRST code unit of s, as the narrow form repeats
'' the first character -- so STRING( 3, an astral character ) yields three copies
'' of its HIGH SURROGATE, not three of the character. Same rule as WSTRING, and
'' the reason the codepoint helpers exist.
function tkort_UStrFill2 alias "fb_UStrFill2" _
	( byval units as integer, byval src as any ptr, byval src_size as integer ) as FBUSTRING ptr

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as FB_UCHAR c = 32
	if( src_len > 0 ) then c = src_ptr[0]

	dim as FBUSTRING ptr dst = hFilled( units, c )

	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst

end function

'' ------------------------------------------------- the overload entry points
''
'' LEFT and RIGHT are registered as true OVERLOADS in rtl-string.bas, aliased
'' straight to a C function, so their signature is fixed at two parameters and
'' cannot carry the (ptr, size) pair the rest of the ustring API uses. A
'' USTRING * N argument has already been turned into a temp descriptor by the
'' argument handling before it arrives here -- which is why VARLEN is safe to
'' assume, and why these are wrappers rather than a second implementation.

function tkort_UStrLeftD alias "fb_UStrLeftD" _
	( byval src as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	return tkort_UStrLeft( src, FB_USTRSIZEVARLEN, units )
end function

function tkort_UStrRightD alias "fb_UStrRightD" _
	( byval src as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	return tkort_UStrRight( src, FB_USTRSIZEVARLEN, units )
end function

end extern
