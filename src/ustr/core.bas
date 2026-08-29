'' core.bas -- ustr_core.o: the USTRING allocator and its temp-descriptor pool.
''
'' Nine entry points, and the 16-bit twin of src/str/core.bas in shape only.
'' THE ALLOCATION POLICY IS NOT THE SAME, and reusing the narrow one here would
'' have been the natural mistake:
''
''            granule          growth              shrink
''   narrow   x32 / x36 bytes  exact, per granule  yes, on assign
''   wide     16 code units    +12.5% on top       only past a 12.5% hysteresis
''
'' So a ustring assignment does NOT round-trip through the same sizes a string
'' assignment does, and `size` is in CODE UNITS on this side while it is in
'' bytes on the other. Both facts are observable through fbc-int/ustring.bi, so
'' both are contract rather than detail.
''
'' THE UNIT RULE. Every length here is in code units. The sizeof(FB_UCHAR)
'' multiply appears in this file and nowhere else in the ustring implementation
'' -- three allocation sites, all in this module. That is the same rule fbc
'' states for ustr_core.c, and it is the rule that keeps the len/size confusion
'' from spreading: anywhere else in src/ustr, a byte count is a bug.
''
'' TWO POOLS, NOT ONE. FB_STR_TMPDESC and FB_USTR_TMPDESC descriptors are
'' interchangeable at the bit level -- pointer plus two pointer-width fields --
'' so a single pool would "work" and would hand a narrow temporary's descriptor
'' back to the wide free list, or the reverse, on any program that mixes the two.
'' The range check in hFromPool is what makes the separation real, and it is the
'' reason each side keeps its own static table.
''
'' PROVENANCE. R2 was lifted on 2026-08-29, so ustr_core.c was read directly for
'' this module (RFC-0005 section 0). The allocation laws below are transcribed
'' from it rather than measured -- but the differential still runs, because a
'' law that is read and a law that is reproduced are not the same claim.
''
'' Its own dependencies:
''     fb_hListInit / AllocElem / FreeElem   -- ours (src/support/list.bas)
''     fb_StrLock / fb_StrUnlock             -- fbc's, -mt only

#include once "inc/descriptors.bi"
#include once "inc/list.bi"

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

'' The wide pool. Same capacity as the narrow one and a SEPARATE table.
dim shared as FB_USTR_TMPDESC tkort_utmpTable( 0 to FB_STR_TMPDESCRIPTORS - 1 )
dim shared as FB_LIST         tkort_utmpList

'' ROUND TO 16 CODE UNITS -- which is 32 BYTES, matching the narrow allocator's
'' 32-byte granule. Rounding to 32 units would silently double the granularity
'' and every ustring in the program would carry twice the slack.
#define hRoundUnits( units ) ( ((units) + 15) and (not 15) )

'' (units + 1) * sizeof(FB_UCHAR) must not overflow a signed integer. The guard
'' is written as an unsigned comparison because the signed one it replaces would
'' be the very overflow it is trying to detect.
const TKORT_UMAXUNITS as uinteger = (cast( uinteger, -1 ) shr 2) - 1

private function hTooBig( byval units as integer ) as integer
	if( units < 0 ) then return -1
	if( cast( uinteger, units ) > TKORT_UMAXUNITS ) then return -1
	return 0
end function

'' Lazily initialised, on the list's own emptiness rather than on a flag: an
'' initialised FB_LIST always has a non-null fhead, so the two tests below can
'' only both hold before the first call. Callers hold the string lock.
private sub hPoolEnsure( )
	if( tkort_utmpList.fhead = 0 ) then
		if( tkort_utmpList.head = 0 ) then
			fb_hListInit( @tkort_utmpList, @tkort_utmpTable(0), _
			              sizeof( FB_USTR_TMPDESC ), FB_STR_TMPDESCRIPTORS )
		end if
	end if
end sub

'' Is this descriptor one of ours? The subtraction comes FIRST and the compare
'' is on element addresses, so the bound is the last element inclusive -- unlike
'' the narrow pool, where the compare is on descriptor addresses and the bound
'' has to be the end of the table.
private function hElem( byval s as FBUSTRING ptr ) as FB_USTR_TMPDESC ptr
	if( s = 0 ) then return 0
	dim as ubyte ptr p = cptr( ubyte ptr, s ) - offsetof( FB_USTR_TMPDESC, desc )
	dim as FB_USTR_TMPDESC ptr e = cptr( FB_USTR_TMPDESC ptr, p )
	if( e < @tkort_utmpTable(0) ) then return 0
	if( e > @tkort_utmpTable(FB_STR_TMPDESCRIPTORS - 1) ) then return 0
	return e
end function

'' --------------------------------------------------------- the entry points

extern "rtlib"

function tkort_hUStrAllocTempDesc alias "fb_hUStrAllocTempDesc" ( ) as FBUSTRING ptr

	hPoolEnsure( )

	dim as FB_LISTELEM ptr e = fb_hListAllocElem( @tkort_utmpList )
	if( e = 0 ) then return 0          '' pool exhausted -- 256 is the cap

	dim as FB_USTR_TMPDESC ptr t = cptr( FB_USTR_TMPDESC ptr, e )
	t->desc.data = 0
	t->desc.len  = 0
	t->desc.size = 0
	return @t->desc

end function

'' 0 if the descriptor came from our pool and was released, -1 if it did not --
'' in which case nothing is touched and the caller still owns it.
''
'' NOTE THE CLEAR. Unlike the narrow fb_hStrDelTempDesc, this one ZEROES the
'' descriptor on the way out, which is why fb_hUStrDelTemp_NoLock must free the
'' data BEFORE calling it: the other order frees the pool entry, wipes the
'' pointer, and then has nothing left to deallocate.
function tkort_hUStrDelTempDesc alias "fb_hUStrDelTempDesc" _
	( byval s as FBUSTRING ptr ) as long

	dim as FB_USTR_TMPDESC ptr e = hElem( s )
	if( e = 0 ) then return -1

	fb_hListFreeElem( @tkort_utmpList, @e->elem )

	e->desc.data = 0
	e->desc.len  = 0
	e->desc.size = 0
	return 0

end function

sub tkort_UStrDelete alias "fb_UStrDelete" ( byval s as FBUSTRING ptr )
	if( s = 0 ) then exit sub
	if( s->data <> 0 ) then deallocate( s->data )
	s->data = 0
	'' Raw, not FB_USTRSETLEN: a deleted descriptor is not a temporary any more,
	'' so the temp bit goes with the data it described.
	s->len  = 0
	s->size = 0
end sub

'' Give `s` a block for `units` code units.
''
'' As on the narrow side, it MUST NOT look at what `s` already holds -- the
'' `dim as ustring u = "xy"` path arrives with an uninitialised descriptor.
''
'' NO TERMINATOR IS WRITTEN, by either allocator in this file. The block carries
'' one spare unit for one, and writing it is the caller's business; the narrow
'' allocator writes it and this one does not, which is exactly the sort of
'' asymmetry that a "port" of the other file would have quietly removed.
function tkort_hUStrAlloc alias "fb_hUStrAlloc" _
	( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr

	if( s = 0 ) then return 0

	if( hTooBig( units ) ) then
		s->data = 0
		s->len  = 0
		s->size = 0
		return 0
	end if

	dim as integer newsize = hRoundUnits( units )

	s->data = cptr( FB_UCHAR ptr, allocate( (newsize + 1) * sizeof( FB_UCHAR ) ) )

	'' The rounded request failed -- fall back to EXACTLY what was asked for.
	'' Reproduced rather than simplified: it changes the reported `size`, which
	'' the descriptor differential reads, and under memory pressure it is the
	'' difference between a short allocation and none.
	if( s->data = 0 ) then
		s->data = cptr( FB_UCHAR ptr, allocate( (units + 1) * sizeof( FB_UCHAR ) ) )
		if( s->data = 0 ) then
			s->len  = 0
			s->size = 0
			return 0
		end if
		newsize = units
	end if

	s->size = newsize
	'' Raw assignment, clearing any temp bit: this is a fresh block.
	s->len  = units
	return s

end function

'' Resize a descriptor that IS valid -- the only entry point here allowed to
'' look at, or free, the existing block.
''
'' THE GROWTH LAW, and it is not the narrow one:
''
''     newsize = round16( units );  newsize += newsize >> 3
''
'' i.e. the granule plus 12.5%. Appending one unit at a time is therefore
'' amortised O(1) here through slack rather than through the narrow side's
'' "keep the block while len <= size" rule -- and the two produce different
'' `size` sequences for the same sequence of appends. Reproduced exactly, for
'' the reason RFC-0004 section 4 gives: a better policy would make Gate 4
'' compare two allocators instead of two languages.
''
'' AND THE RESIZE TEST HAS THREE ARMS, the third being a SHRINK HYSTERESIS:
''
''     data = NULL                                    -- nothing yet
''     units > size                                   -- too small
''     not preserve andalso newsize < size - size>>3  -- enough smaller to bother
''
'' The third arm is why assigning a shorter ustring usually does NOT reallocate,
'' while the narrow allocator resizes on every assignment whose granule differs.
function tkort_hUStrRealloc alias "fb_hUStrRealloc" _
	( byval s as FBUSTRING ptr, byval units as integer, byval keepdata as long ) as FBUSTRING ptr

	'' `keepdata`, not `preserve`: PRESERVE is a FreeBASIC keyword (REDIM
	'' PRESERVE) and is error 59 as a parameter name.

	if( s = 0 ) then return 0
	if( hTooBig( units ) ) then return 0

	dim as integer newsize = hRoundUnits( units )
	newsize += (newsize shr 3)

	dim as integer resize = 0
	if( s->data = 0 ) then
		resize = -1
	elseif( units > s->size ) then
		resize = -1
	elseif( keepdata = 0 ) then
		if( newsize < (s->size - (s->size shr 3)) ) then resize = -1
	end if

	if( resize ) then
		if( keepdata = 0 ) then
			'' Not keeping anything: free, then allocate fresh. Note this goes
			'' through fb_UStrDelete, so the temp bit is cleared here and
			'' restored below by FB_USTRSETLEN reading it back as 0 -- which is
			'' correct, because fb_hUStrAllocTemp_NoLock sets it AFTER the call.
			tkort_UStrDelete( s )
			s->data = cptr( FB_UCHAR ptr, allocate( (newsize + 1) * sizeof( FB_UCHAR ) ) )
			if( s->data = 0 ) then
				s->data = cptr( FB_UCHAR ptr, allocate( (units + 1) * sizeof( FB_UCHAR ) ) )
				newsize = units
			end if
		else
			dim as any ptr p = reallocate( s->data, (newsize + 1) * sizeof( FB_UCHAR ) )
			if( p = 0 ) then
				'' Retry at exactly the requested size before giving up. The
				'' ORIGINAL pointer is passed again, which is only sound because
				'' a failed realloc leaves it valid.
				newsize = units
				p = reallocate( s->data, (newsize + 1) * sizeof( FB_UCHAR ) )
				if( p = 0 ) then return 0
			end if
			s->data = cptr( FB_UCHAR ptr, p )
		end if

		if( s->data = 0 ) then
			s->len  = 0
			s->size = 0
			return 0
		end if

		s->size = newsize
	end if

	FB_USTRSETLEN( s, units )
	return s

end function

'' A temporary: descriptor from the pool if the caller did not supply one, data
'' allocated, temp bit set LAST -- FB_USTRSETLEN preserves whatever the bit
'' already was, so setting it first would survive but says the wrong thing on
'' the failure path.
function tkort_hUStrAllocTemp_NoLock alias "fb_hUStrAllocTemp_NoLock" _
	( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr

	dim as integer owned = (s = 0)

	if( owned ) then
		s = tkort_hUStrAllocTempDesc( )
		if( s = 0 ) then return 0
	end if

	if( tkort_hUStrRealloc( s, units, 0 ) = 0 ) then
		if( owned ) then tkort_hUStrDelTempDesc( s )
		return 0
	end if

	s->len or= FB_TEMPSTRBIT
	return s

end function

function tkort_hUStrAllocTemp alias "fb_hUStrAllocTemp" _
	( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr r = tkort_hUStrAllocTemp_NoLock( s, units )
	STRUNLOCK()
	return r
end function

'' Free the temporary's data, then release its descriptor if it came from our
'' pool. TWO INDEPENDENT QUESTIONS, exactly as on the narrow side:
''
''   does this temporary OWN its data?   -> the temp bit
''   is this descriptor OURS to release? -> the pool range check
''
'' The difference from fb_hStrDelTemp_NoLock is that there is no early -1 for
'' "neither a temporary nor ours": a POOL descriptor with the temp bit clear is
'' still handed back here. That is the literal-backed case, and gating the whole
'' function on the temp bit is what exhausted the narrow pool once already.
''
'' ORDER MATTERS. DelTempDesc zeroes the descriptor, so the free has to come
'' first or the data pointer is gone before it is released.
function tkort_hUStrDelTemp_NoLock alias "fb_hUStrDelTemp_NoLock" _
	( byval s as FBUSTRING ptr ) as long

	if( s = 0 ) then return -1

	if( FB_UISTEMP( s ) ) then tkort_UStrDelete( s )

	return tkort_hUStrDelTempDesc( s )

end function

function tkort_hUStrDelTemp alias "fb_hUStrDelTemp" ( byval s as FBUSTRING ptr ) as long
	STRLOCK()
	dim as long r = tkort_hUStrDelTemp_NoLock( s )
	STRUNLOCK()
	return r
end function

end extern
