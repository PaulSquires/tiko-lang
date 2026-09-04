'' instrany.bas -- fb_StrInstrAny (str_instrany.o) and fb_StrInstrRevAny
'' (str_instrrevany.o).
''
'' INSTR( s, ANY "abc" ) -- find the first position holding ANY of the pattern's
'' characters, rather than the pattern as a substring.
''
'' TWO OF fbc's MEMBERS, ONE OF OURS. Every earlier module matched fbc member for
'' member; this one does not, and that is fine. gate.sh maps SYMBOLS to the fbc
'' members defining them and deletes those, so merging two members into one
'' deletes both and adds one -- and the exactly-once assertion counts symbol
'' definitions rather than members, so it still holds. The constraint that sized
'' earlier batches was the opposite case: one fbc member holding symbols we do
'' NOT own (fb_SPACE in str_misc.o) cannot be split.

#include once "inc/descriptors.bi"

extern "rtlib"
	declare function tkrt_DelTempNoLock alias "fb_hStrDelTemp_NoLock" _
		( byval s as FBSTRING ptr ) as long
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

'' THE FORWARD SEARCH IS NOT A SCAN. It runs memchr ONCE PER PATTERN CHARACTER
'' over the whole remaining text, keeping the smallest hit -- so the cost is
'' O(len(patt) * len(src)) worst case but each pass is a memchr, and the search
'' window SHRINKS as better hits are found (`r` is both the answer and the
'' remaining length passed to memchr).
''
'' `r` starts at search_len and means "nothing found yet"; that sentinel is what
'' the final test compares against, which is why a hit at the very last position
'' still reads as found.
function tkort_StrInstrAny alias "fb_StrInstrAny" _
	( _
		byval start as integer, byval src as FBSTRING ptr, byval patt as FBSTRING ptr _
	) as integer

	dim as integer r = 0
	dim as integer ok = 0

	if( src <> 0 ) then
		if( src->data <> 0 ) then
			if( patt <> 0 ) then
				if( patt->data <> 0 ) then ok = 1
			end if
		end if
	end if

	if( ok <> 0 ) then
		dim as integer size_src = FB_STRSIZE( src )
		dim as integer size_patt = FB_STRSIZE( patt )

		dim as integer usable = 1
		if( size_src = 0 ) then usable = 0
		if( size_patt = 0 ) then usable = 0
		if( start < 1 ) then usable = 0
		if( start > size_src ) then usable = 0

		if( usable <> 0 ) then
			dim as integer search_len = size_src - start + 1
			dim as ubyte ptr text_ = cptr( ubyte ptr, src->data ) + start - 1
			dim as ubyte ptr pd = cptr( ubyte ptr, patt->data )

			r = search_len
			for i as integer = 0 to size_patt - 1
				dim as any ptr hit = memchr( text_, pd[i], r )
				if( hit <> 0 ) then
					dim as integer found = cast( integer, cast( ubyte ptr, hit ) - text_ )
					if( found < r ) then r = found
				end if
			next

			if( r = search_len ) then
				r = 0
			else
				r += start
			end if
		end if
	end if

	STRLOCK()
	tkrt_DelTempNoLock( src )
	tkrt_DelTempNoLock( patt )
	STRUNLOCK()

	return r

end function

'' The reverse form walks backwards one character at a time and compares against
'' every pattern character -- no memchr, and no allocation.
''
'' ITS CLAMP DIFFERS FROM fb_StrInstrRev'S, which is easy to miss when the names
'' are one word apart:
''
''     start < 0          -> len(src)     (here)   vs len - len(patt) + 1 (there)
''     start > len(src)   -> 0            (both)
''     no third branch    (here)          vs a third clamp (there)
''
'' because a single character always fits, so there is no pattern length to back
'' off by.
function tkort_StrInstrRevAny alias "fb_StrInstrRevAny" _
	( _
		byval src as FBSTRING ptr, byval patt as FBSTRING ptr, byval start as integer _
	) as integer

	dim as integer r = 0
	dim as integer ok = 0

	if( src <> 0 ) then
		if( src->data <> 0 ) then
			if( patt <> 0 ) then
				if( patt->data <> 0 ) then ok = 1
			end if
		end if
	end if

	if( ok <> 0 ) then
		dim as integer size_src = FB_STRSIZE( src )
		dim as integer size_patt = FB_STRSIZE( patt )

		dim as integer usable = 1
		if( size_src = 0 ) then usable = 0
		if( size_patt = 0 ) then usable = 0
		if( start = 0 ) then usable = 0

		if( usable <> 0 ) then
			if( start < 0 ) then
				start = size_src
			elseif( start > size_src ) then
				start = 0
			end if

			dim as ubyte ptr sd = cptr( ubyte ptr, src->data )
			dim as ubyte ptr pd = cptr( ubyte ptr, patt->data )

			'' C's `while( start-- && (r == 0) )`: test, then decrement, and the
			'' body sees the DECREMENTED value.
			do while( start <> 0 )
				if( r <> 0 ) then exit do
				start -= 1
				for i as integer = 0 to size_patt - 1
					if( sd[start] = pd[i] ) then
						r = start + 1
						exit for
					end if
				next
			loop
		end if
	end if

	STRLOCK()
	tkrt_DelTempNoLock( src )
	tkrt_DelTempNoLock( patt )
	STRUNLOCK()

	return r

end function

end extern
