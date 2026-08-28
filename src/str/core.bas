'' core.bas -- the string allocator and the temporary-descriptor pool.
''
'' This is str_core.o's exact symbol set, all ten of them. It matters more than
'' its size suggests: every other string entry point in libfb allocates through
'' fb_hStrAlloc / fb_hStrRealloc, and every string temporary in a compiled
'' program passes through the pool. Merging this module puts tiko-rt on the hot
'' path of the entire string library while that library is still fbc's C.
''
'' Its own fb_ dependencies, from nm over fbc's archive:
''     fb_StrDelete          -- still fbc's
''     fb_hListInit / AllocElem / FreeElem  -- already ours (src/support/list.bas)
''
'' ===========================================================================
'' WHAT WAS MEASURED, AND HOW (PROVENANCE.md -- str_core.c was not opened)
''
'' PROBE-13, the growth law. Swept len 0..1200 through the C runtime and read
'' `size` back out of the descriptor fbc-int/string.bi publishes. 38 steps, all
'' fitting exactly:
''
''     size = 0                      when len = 0
''     size = ((len + 31) \ 32) * 36 otherwise
''
'' 32-character granules at 36 bytes each. Reproduced here EXACTLY and
'' deliberately, including the three bytes of slack per granule: allocation
'' policy is most of what a concatenation benchmark measures, so a "better"
'' policy here would make Gate 4 compare two allocators instead of two
'' languages (RFC-0004 section 4).
''
'' PROBE-12 also showed the pointer does NOT move while the granule count is
'' unchanged (len 1..12 all stay in one 36-byte block) and DOES move when it
'' changes, including on shrink. So realloc is driven by the granule count, not
'' by the length.
''
'' PROBE-14:
''   fb_hStrCopy ( dst, "abcd", 4 ) -> 61 62 63 64 00   -- terminates
''   fb_hStrCopyN( dst, "abcd", 4 ) -> 61 62 63 64 EE   -- does not
''   Neither stops at a NUL in the source; both are raw byte copies.
''   fb_hStrAllocTempDesc() returns data=NULL len=0 size=0, temp bit CLEAR.
''   fb_hStrAllocTemp(d,10) sets the temp bit and size=36.
''   fb_hStrDelTempDesc and fb_hStrDelTemp both return 0.
''
'' PROBE-15: fb_hStrAllocTemp( NULL, 20 ) returns a fully-formed temporary --
'' descriptor from the pool, data allocated, temp bit set. So AllocTemp touches
'' the pool, which is why the _NoLock twins exist: a caller already holding the
'' string lock would otherwise deadlock on it.
''
'' NOT established, and therefore left as the safest reading:
''   - what fbc does when the 256-entry pool is exhausted. Ours returns NULL
''     and the callers are fbc's C. If fbc's suite never exhausts the pool, the
''     gate cannot cover this and it stays an untested branch.
''   - whether fbc range-checks a descriptor against the pool table on delete.
''     Ours does, because a temporary that did NOT come from the pool must not
''     be pushed onto its free list.
'' ===========================================================================

#include once "inc/descriptors.bi"
#include once "inc/list.bi"

'' fb_StrLock / fb_StrUnlock are FBCALL and remain fbc's. Under a
'' single-threaded build fb.h defines FB_STRLOCK() to nothing, and so do we:
'' the calls must vanish entirely, not become calls to an empty function.
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

'' The pool. Fixed at 256 entries (FB_STR_TMPDESCRIPTORS) -- not a growing
'' allocator, and its exhaustion behaviour is part of the contract.
dim shared as FB_STR_TMPDESC tkort_tmpTable( 0 to FB_STR_TMPDESCRIPTORS - 1 )
dim shared as FB_LIST        tkort_tmpList
dim shared as integer        tkort_tmpReady

'' PROBE-13's law, and the single place it is written down in code.
private function hGranuleSize( byval length as integer ) as integer
	if( length <= 0 ) then return 0
	return ((length + 31) \ 32) * 36
end function

'' Lazily initialised: str_core.o exports no init entry point, so there is
'' nowhere else for this to happen. Callers must hold the string lock.
private sub hPoolEnsure( )
	if( tkort_tmpReady = 0 ) then
		fb_hListInit( @tkort_tmpList, @tkort_tmpTable(0), _
		              sizeof( FB_STR_TMPDESC ), FB_STR_TMPDESCRIPTORS )
		tkort_tmpReady = 1
	end if
end sub

'' Is this descriptor one of ours? A temporary that did not come from the pool
'' must never be pushed onto its free list. Range check over the table, which is
'' contiguous by construction.
private function hFromPool( byval s as FBSTRING ptr ) as integer
	if( s = 0 ) then return 0
	'' The upper bound is the END of the table, not the address of the last
	'' element: a descriptor lives at elem + offsetof(desc), so the last
	'' element's descriptor is PAST @tkort_tmpTable(255) and a naive
	'' `<= @table(last)` rejects it -- one entry in 256, which would have been
	'' a lovely bug to find later.
	dim as ubyte ptr lo = cptr( ubyte ptr, @tkort_tmpTable(0) )
	dim as ubyte ptr hi = lo + (sizeof( FB_STR_TMPDESC ) * FB_STR_TMPDESCRIPTORS)
	dim as ubyte ptr p  = cptr( ubyte ptr, s )
	return (p >= lo) andalso (p < hi)
end function

private function hPoolAlloc( ) as FBSTRING ptr
	hPoolEnsure( )
	dim as FB_LISTELEM ptr e = fb_hListAllocElem( @tkort_tmpList )
	if( e = 0 ) then return 0              '' pool exhausted -- see the header
	dim as FB_STR_TMPDESC ptr t = cptr( FB_STR_TMPDESC ptr, e )
	t->desc.data = 0
	t->desc.len  = 0
	t->desc.size = 0
	return @t->desc
end function

private sub hPoolFree( byval s as FBSTRING ptr )
	if( hFromPool( s ) = 0 ) then exit sub
	dim as ubyte ptr p = cptr( ubyte ptr, s ) - offsetof( FB_STR_TMPDESC, desc )
	fb_hListFreeElem( @tkort_tmpList, cptr( FB_LISTELEM ptr, p ) )
end sub

'' --------------------------------------------------------- the entry points

extern "rtlib"

function tkort_hStrAllocTempDesc alias "fb_hStrAllocTempDesc" ( ) as FBSTRING ptr
	STRLOCK()
	dim as FBSTRING ptr s = hPoolAlloc( )
	STRUNLOCK()
	return s
end function

'' Returns 0 if this descriptor came from the pool and was released, -1 if it
'' did not -- in which case NOTHING is done and the caller still owns it.
''
'' PROBE-14 saw only 0 because it only ever passed a pool descriptor. PROBE-16
'' asked the harder question:
''
''     pool descriptor      -> 0
''     caller's descriptor  -> -1
''     NULL                 -> -1
''
'' Returning 0 unconditionally is what the first version of this file did, and
'' it crashed every program: fbc's fb_StrDelete took 0 to mean "released" for
'' descriptors that were never ours, and skipped its own cleanup. Gate 2 would
'' have caught it; the allocator differential caught it in thirty seconds.
function tkort_hStrDelTempDesc alias "fb_hStrDelTempDesc" _
	( byval s as FBSTRING ptr ) as long

	if( hFromPool( s ) = 0 ) then return -1

	STRLOCK()
	hPoolFree( s )
	STRUNLOCK()
	return 0

end function

'' Give `s` a data block for `length` characters.
''
'' **IT MUST NOT LOOK AT WHAT `s` ALREADY HOLDS.** `fb_StrInit` -- the
'' `dim as string a = "xy"` path -- calls this with a descriptor that has never
'' been initialised, so `s->data` and `s->size` are whatever was on the stack.
''
'' The first version of this function was "defensively" written to free any
'' existing block first, and its comment claimed that was the safer choice. It
'' was free() on a garbage stack pointer. The symptom was that
'' `dim as string a = "xy"` crashed while `dim as string a : a = "xy"` was
'' perfectly fine -- which is what finally located it.
''
'' Freeing the old block is fb_hStrRealloc's job, and only fb_hStrRealloc knows
'' the descriptor is valid.
function tkort_hStrAlloc alias "fb_hStrAlloc" _
	( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr

	if( s = 0 ) then return 0

	dim as integer want = hGranuleSize( length )

	if( want = 0 ) then
		s->data = 0
		s->size = 0
		s->len  = 0
		return s
	end if

	s->data = cptr( zstring ptr, callocate( want, 1 ) )
	if( s->data = 0 ) then
		s->size = 0
		s->len  = 0
		return 0
	end if

	s->size = want
	s->len  = length
	s->data[length] = 0
	return s

end function

'' Resize a descriptor that IS valid. This is the only entry point allowed to
'' look at the existing block, and therefore the only one that may free it.
''
'' PROBE-12 showed the block is kept while the granule count is unchanged
'' (appending one character at a time does not reallocate 32 times) and moves
'' when it changes, including on shrink.
function tkort_hStrRealloc alias "fb_hStrRealloc" _
	( byval s as FBSTRING ptr, byval length as integer, byval keepdata as long ) as FBSTRING ptr

	'' NOTE: the parameter is `keepdata`, not `preserve` -- PRESERVE is a
	'' FreeBASIC keyword (REDIM PRESERVE) and is error 59 as a parameter name.

	if( s = 0 ) then return 0
	if( s->data = 0 ) then return tkort_hStrAlloc( s, length )

	dim as integer want = hGranuleSize( length )

	if( want = 0 ) then
		deallocate( s->data )
		s->data = 0
		s->size = 0
		FB_STRSETLEN( s, 0 )
		return s
	end if

	if( s->size <> want ) then
		if( keepdata <> 0 ) then
			dim as any ptr p = reallocate( s->data, want )
			if( p = 0 ) then return 0
			s->data = cptr( zstring ptr, p )
		else
			deallocate( s->data )
			s->data = cptr( zstring ptr, callocate( want, 1 ) )
			if( s->data = 0 ) then
				s->size = 0
				FB_STRSETLEN( s, 0 )
				return 0
			end if
		end if
		s->size = want
	end if

	FB_STRSETLEN( s, length )
	s->data[length] = 0
	return s

end function

'' A temporary: descriptor from the pool if the caller did not supply one, data
'' allocated, and the temp bit SET -- which is what distinguishes it from an
'' ordinary string and what fb_StrDelete keys off (PROBE-15).
function tkort_hStrAllocTemp_NoLock alias "fb_hStrAllocTemp_NoLock" _
	( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr

	dim as integer owned = 0

	if( s = 0 ) then
		s = hPoolAlloc( )
		if( s = 0 ) then return 0
		owned = 1
	end if

	if( tkort_hStrAlloc( s, length ) = 0 ) then
		if( owned ) then hPoolFree( s )
		return 0
	end if

	'' Set the flag AFTER the allocation: hStrAlloc goes through FB_STRSETLEN,
	'' which preserves whatever the bit already was.
	s->len or= FB_TEMPSTRBIT
	return s

end function

function tkort_hStrAllocTemp alias "fb_hStrAllocTemp" _
	( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
	STRLOCK()
	dim as FBSTRING ptr r = tkort_hStrAllocTemp_NoLock( s, length )
	STRUNLOCK()
	return r
end function

'' Same contract as DelTempDesc (PROBE-16): 0 when this was a pool temporary and
'' has been released, -1 when it was not ours.
''
'' The -1 case must do NOTHING. If it freed the data and still reported -1, the
'' caller -- which reads -1 as "you still own this" -- would free it again.
function tkort_hStrDelTemp_NoLock alias "fb_hStrDelTemp_NoLock" _
	( byval s as FBSTRING ptr ) as long

	if( hFromPool( s ) = 0 ) then return -1

	'' FREE THE DATA ONLY IF THIS TEMPORARY OWNS IT.
	''
	'' PROBE-17: fb_StrAllocTempDescZ builds a temporary whose `data` points
	'' straight at a STRING LITERAL -- len=2, size=2, and the TEMP BIT CLEAR --
	'' so that PRINT "hi" needs no copy. Freeing that is free() on a literal.
	''
	'' It is what the first version of this file did, and the symptom was
	'' exquisite: `print "hi"` printed "hi" and *then* the program died at
	'' shutdown with no message, while plain assignment worked perfectly. The
	'' bisect that found it had to avoid PRINT, because PRINT was the thing
	'' being broken.
	''
	'' The temp bit is the ownership flag: set by fb_hStrAllocTemp when it
	'' allocates a block, clear on a borrowed one.
	if( FB_ISTEMP( s ) andalso (s->data <> 0) ) then
		deallocate( s->data )
	end if
	s->data = 0
	s->len  = 0
	s->size = 0

	hPoolFree( s )
	return 0

end function

function tkort_hStrDelTemp alias "fb_hStrDelTemp" ( byval s as FBSTRING ptr ) as long
	STRLOCK()
	dim as long r = tkort_hStrDelTemp_NoLock( s )
	STRUNLOCK()
	return r
end function

'' Raw byte copies. The ONLY difference is the terminator (PROBE-14); neither
'' stops at a NUL in the source.
sub tkort_hStrCopy alias "fb_hStrCopy" _
	( byval dst as zstring ptr, byval src as zstring ptr, byval bytes as integer )
	if( (dst = 0) orelse (bytes < 0) ) then exit sub
	if( (src <> 0) andalso (bytes > 0) ) then memcpy( dst, src, bytes )
	dst[bytes] = 0
end sub

sub tkort_hStrCopyN alias "fb_hStrCopyN" _
	( byval dst as zstring ptr, byval src as zstring ptr, byval bytes as integer )
	if( (dst = 0) orelse (src = 0) orelse (bytes <= 0) ) then exit sub
	memcpy( dst, src, bytes )
end sub

end extern
