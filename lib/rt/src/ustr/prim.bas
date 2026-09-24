'' prim.bas -- ustr_prim.o: the ten hand-rolled ustring primitives.
''
'' THE NO-LIBC-WIDE RULE, and it is the whole reason this member exists.
'' wcslen / wcsstr / wcsncmp / wcschr / wmemcpy / wmemset are NOT used here and
'' must never be introduced. On Windows FB_UCHAR and wchar_t are both 16 bits,
'' so every one of them would link and appear to work; on Linux wchar_t is 32
'' bits and the same call reads the wrong stride, silently. A library that uses
'' libc on one target and hand-rolled code on another is a library whose two
'' platforms drift apart -- which is the exact bug class this project has already
'' shipped twice (see Learnings.md on the wstring width trap).
''
'' memcpy / memmove / memset ARE used: they count BYTES, they exist everywhere,
'' and they make no assumption about the width. Every call therefore carries an
'' explicit * sizeof( FB_UCHAR ), the same discipline inc/ops-core.bi uses.
''
'' All ten are NON-FBCALL -- fb_ustring.h declares them without the macro, so
'' they are plain cdecl on every target and carry no @N on win32.

#include once "inc/descriptors.bi"
#include once "inc/sysbind.bi"

extern "c"   '' NON-FBCALL: fb_ustring.h declares all ten without FBCALL.

function tkort_hUStrLen alias "fb_hUStrLen" ( byval s as FB_UCHAR ptr ) as integer
	if( s = 0 ) then return 0
	dim as FB_UCHAR ptr p = s
	while( *p <> 0 )
		p += 1
	wend
	return cast( integer, p - s )
end function

'' ORDERING IS BY CODE UNIT, not by codepoint -- the same order wcscmp gives on
'' Windows and the same order every UTF-16 environment uses.
''
'' The inherited quirk is worth stating rather than discovering: surrogates live
'' at D800..DFFF, so ASTRAL CHARACTERS SORT BELOW U+E000..U+FFFF instead of above
'' them. Codepoint order would cost a decode per comparison and would disagree
'' with every other UTF-16 implementation, so code-unit order is the deliberate
'' trade, not an oversight.
function tkort_hUStrCompare alias "fb_hUStrCompare" _
	( byval s1 as FB_UCHAR ptr, byval len1 as integer, _
	  byval s2 as FB_UCHAR ptr, byval len2 as integer ) as long

	'' NULL is not "empty": a NULL against a non-empty operand orders below it,
	'' and against an empty one -- or another NULL -- compares equal.
	if( s1 = 0 ) then
		if( s2 = 0 ) then return 0
		if( len2 = 0 ) then return 0
		return -1
	end if
	if( s2 = 0 ) then
		if( len1 = 0 ) then return 0
		return 1
	end if

	dim as integer minlen = len1
	if( len2 < minlen ) then minlen = len2

	for i as integer = 0 to minlen - 1
		if( s1[i] <> s2[i] ) then
			if( s1[i] < s2[i] ) then return -1
			return 1
		end if
	next

	if( len1 = len2 ) then return 0
	if( len1 < len2 ) then return -1
	return 1

end function

'' Copy AND terminate.
''
'' Note the terminator is written even when nothing is copied, and that `dst` is
'' advanced only on the copying path -- so hUStrCopy( d, NULL, n ) writes the
'' terminator at d[0], not at d[n].
sub tkort_hUStrCopy alias "fb_hUStrCopy" _
	( byval dst as FB_UCHAR ptr, byval src as FB_UCHAR ptr, byval units as integer )
	if( (src <> 0) andalso (units > 0) ) then
		memcpy( dst, src, units * sizeof( FB_UCHAR ) )
		dst += units
	end if
	*dst = 0
end sub

'' Copy WITHOUT terminating -- for building a string in pieces. The difference
'' between this and hUStrCopy is one byte and it is the whole contract.
sub tkort_hUStrCopyN alias "fb_hUStrCopyN" _
	( byval dst as FB_UCHAR ptr, byval src as FB_UCHAR ptr, byval units as integer )
	if( (src <> 0) andalso (units > 0) ) then
		memcpy( dst, src, units * sizeof( FB_UCHAR ) )
	end if
end sub

'' Overlap-safe, for the in-place shifts MID and LTRIM perform.
sub tkort_hUStrMove alias "fb_hUStrMove" _
	( byval dst as FB_UCHAR ptr, byval src as FB_UCHAR ptr, byval units as integer )
	if( (src <> 0) andalso (units > 0) ) then
		memmove( dst, src, units * sizeof( FB_UCHAR ) )
	end if
end sub

'' memset CANNOT fill 16-bit units in general -- it writes one byte pattern. It
'' is usable exactly when the two halves of the unit are equal, which covers the
'' cases that matter (NUL, and the ASCII-space fill only if it were 0x2020).
'' Everything else fills by unit.
sub tkort_hUStrFill alias "fb_hUStrFill" _
	( byval dst as FB_UCHAR ptr, byval c as FB_UCHAR, byval units as integer )

	if( dst = 0 ) then exit sub

	if( (c and &hFF) = ((c shr 8) and &hFF) ) then
		if( units > 0 ) then memset( dst, c and &hFF, units * sizeof( FB_UCHAR ) )
		exit sub
	end if

	for i as integer = 0 to units - 1
		dst[i] = c
	next

end sub

'' Index of the first occurrence, or -1. A 0-based INDEX, not a 1-based
'' position: the callers add the 1 themselves.
function tkort_hUStrChr alias "fb_hUStrChr" _
	( byval s as FB_UCHAR ptr, byval length as integer, byval c as FB_UCHAR ) as integer
	if( s = 0 ) then return -1
	for i as integer = 0 to length - 1
		if( s[i] = c ) then return i
	next
	return -1
end function

'' Naive search, matching the narrow side. Patterns are almost always short and
'' a sublinear algorithm loses on the setup.
''
'' AN EMPTY PATTERN MATCHES AT 0, which is what INSTR does and is not the same as
'' "not found".
function tkort_hUStrStr alias "fb_hUStrStr" _
	( byval hay as FB_UCHAR ptr, byval haylen as integer, _
	  byval needle as FB_UCHAR ptr, byval needlelen as integer ) as integer

	if( hay = 0 ) then return -1
	if( needle = 0 ) then return -1
	if( needlelen <= 0 ) then return 0
	if( needlelen > haylen ) then return -1

	for i as integer = 0 to haylen - needlelen
		if( hay[i] <> needle[0] ) then continue for
		dim as integer j = 1
		while( j < needlelen )
			if( hay[i+j] <> needle[j] ) then exit while
			j += 1
		wend
		if( j = needlelen ) then return i
	next

	return -1

end function

'' Skip leading units equal to c, for the trim family.
''
'' USTRING * N buffers are NUL-PADDED, so trimming a fixed-length ustring strips
'' those too -- the same rule fb_wstr_SkipChar follows, and deliberately NOT the
'' narrow rule, where STRING * N is space-padded.
function tkort_hUStrSkipChar alias "fb_hUStrSkipChar" _
	( byval s as FB_UCHAR ptr, byval length as integer, byval c as FB_UCHAR ) as FB_UCHAR ptr
	if( s = 0 ) then return 0
	dim as FB_UCHAR ptr p = s
	while( (length > 0) andalso (*p = c) )
		p += 1
		length -= 1
	wend
	return p
end function

'' Walk back over trailing units equal to c; returns one PAST the last unit kept,
'' so the kept length is (result - s).
function tkort_hUStrSkipCharRev alias "fb_hUStrSkipCharRev" _
	( byval s as FB_UCHAR ptr, byval length as integer, byval c as FB_UCHAR ) as FB_UCHAR ptr
	if( s = 0 ) then return 0
	dim as FB_UCHAR ptr p = s + length
	while( (p > s) andalso (p[-1] = c) )
		p -= 1
	wend
	return p
end function

end extern
