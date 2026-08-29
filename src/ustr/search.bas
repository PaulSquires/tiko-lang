'' search.bas -- ustr_search.o: INSTR, INSTRREV and their Any forms.
''
'' Positions are 1-BASED and 0 MEANS NOT FOUND, matching every other FB string
'' type, and they are in CODE UNITS, consistent with LEN and [] indexing.
''
'' SEARCHING BY CODE UNIT IS SAFE FOR UTF-16 WITH NO SURROGATE AWARENESS, and
'' this is the one place where UTF-16 is genuinely easier than UTF-8. A surrogate
'' half can never equal a BMP unit, and a two-unit pattern can only match at a
'' real pair boundary -- so a match can never land mid-character. A naive byte
'' search over UTF-8 gets exactly that wrong, which is why the narrow INSTR
'' cannot be reused for text and this one can be written without a decode.

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

extern "c"   '' NON-FBCALL: fb_ustring.h declares the primitive plainly.
	declare function tkrt_UStrStrF alias "fb_hUStrStr" _
		( byval hay as FB_UCHAR ptr, byval haylen as integer, _
		  byval needle as FB_UCHAR ptr, byval needlelen as integer ) as integer
end extern

extern "rtlib"

'' INSTR( [start,] src, pattern )
function tkort_UStrInstr alias "fb_UStrInstr" _
	( byval start_ as integer, _
	  byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer ) as integer

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any, pat_ptr = any
	dim as integer src_len = any, pat_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )
	FB_USTRSETUP( pat, pat_size, pat_ptr, pat_len )

	dim as integer res = 0

	dim as integer ok = -1
	if( start_ <= 0 ) then ok = 0
	if( start_ > src_len ) then ok = 0
	if( pat_len <= 0 ) then ok = 0

	if( ok ) then
		'' The search runs over the TAIL, so the index it returns is relative to
		'' `start` and the 1-based position is start + at, not at + 1.
		dim as integer at = tkrt_UStrStrF( @src_ptr[start_ - 1], src_len - (start_ - 1), _
		                                   pat_ptr, pat_len )
		if( at >= 0 ) then res = start_ + at
	end if

	hRelTemp( src, src_size )
	hRelTemp( pat, pat_size )

	STRUNLOCK()
	return res

end function

'' INSTR( [start,] src, ANY set ) -- the first unit that appears in the set.
function tkort_UStrInstrAny alias "fb_UStrInstrAny" _
	( byval start_ as integer, _
	  byval src as any ptr, byval src_size as integer, _
	  byval st as any ptr, byval set_size as integer ) as integer

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any, set_ptr = any
	dim as integer src_len = any, set_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )
	FB_USTRSETUP( st, set_size, set_ptr, set_len )

	dim as integer res = 0

	dim as integer ok = -1
	if( start_ <= 0 ) then ok = 0
	if( start_ > src_len ) then ok = 0
	if( set_len <= 0 ) then ok = 0

	if( ok ) then
		for i as integer = start_ - 1 to src_len - 1
			for j as integer = 0 to set_len - 1
				if( src_ptr[i] = set_ptr[j] ) then
					res = i + 1
					exit for
				end if
			next
			if( res <> 0 ) then exit for
		next
	end if

	hRelTemp( src, src_size )
	hRelTemp( st, set_size )

	STRUNLOCK()
	return res

end function

'' INSTRREV( src, pattern [, start] ). A start of <= 0 means "from the end"; a
'' start of exactly 0 is rejected outright, which is why the guard tests
'' `start <> 0` rather than `start > 0`.
function tkort_UStrInstrRev alias "fb_UStrInstrRev" _
	( byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer, byval start_ as integer ) as integer

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any, pat_ptr = any
	dim as integer src_len = any, pat_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )
	FB_USTRSETUP( pat, pat_size, pat_ptr, pat_len )

	dim as integer res = 0

	dim as integer ok = -1
	if( src_len <= 0 ) then ok = 0
	if( pat_len <= 0 ) then ok = 0
	if( pat_len > src_len ) then ok = 0
	if( start_ = 0 ) then ok = 0

	if( ok ) then
		'' The last position at which the pattern can still FIT is
		'' src_len - pat_len + 1; both the "from the end" case and an
		'' over-large start clamp to it.
		dim as integer lim = src_len - pat_len + 1
		if( start_ < 0 ) then start_ = lim
		if( start_ > lim ) then start_ = lim

		for i as integer = start_ - 1 to 0 step -1
			dim as integer j = 0
			while( j < pat_len )
				if( src_ptr[i + j] <> pat_ptr[j] ) then exit while
				j += 1
			wend
			if( j = pat_len ) then
				res = i + 1
				exit for
			end if
		next
	end if

	hRelTemp( src, src_size )
	hRelTemp( pat, pat_size )

	STRUNLOCK()
	return res

end function

'' INSTRREV( src, ANY set [, start] ). NOTE the clamp differs from the pattern
'' form above: a set match is one unit wide, so the last usable position is
'' src_len, not src_len - pat_len + 1.
function tkort_UStrInstrRevAny alias "fb_UStrInstrRevAny" _
	( byval src as any ptr, byval src_size as integer, _
	  byval st as any ptr, byval set_size as integer, byval start_ as integer ) as integer

	STRLOCK()

	dim as FB_UCHAR ptr src_ptr = any, set_ptr = any
	dim as integer src_len = any, set_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )
	FB_USTRSETUP( st, set_size, set_ptr, set_len )

	dim as integer res = 0

	dim as integer ok = -1
	if( src_len <= 0 ) then ok = 0
	if( set_len <= 0 ) then ok = 0
	if( start_ = 0 ) then ok = 0

	if( ok ) then
		if( start_ < 0 ) then start_ = src_len
		if( start_ > src_len ) then start_ = src_len

		for i as integer = start_ - 1 to 0 step -1
			for j as integer = 0 to set_len - 1
				if( src_ptr[i] = set_ptr[j] ) then
					res = i + 1
					exit for
				end if
			next
			if( res <> 0 ) then exit for
		next
	end if

	hRelTemp( src, src_size )
	hRelTemp( st, set_size )

	STRUNLOCK()
	return res

end function

end extern
