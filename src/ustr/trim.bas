'' trim.bas -- ustr_trim.o: TRIM / LTRIM / RTRIM and their Any and Ex forms.
''
'' PLAIN TRIM STRIPS SPACES **AND NULs**, ON BOTH SIDES. That is not what the
'' narrow family does, and the difference is not an oversight in either:
''
''   narrow  TRIM strips spaces; chr(0) comes off the RIGHT only, because
''           STRING * N is SPACE-padded and a NUL in the text is data.
''   wide    USTRING * N is ZERO-filled past its text, so the padding has to go
''           from whichever end it is on -- the same rule fb_wstr_SkipChar
''           follows for WSTRING * N.
''
'' The narrow asymmetry cost a Linux gate run earlier in this project: PROBE-30
'' asked about the "whitespace family", a category borrowed from C's isspace(),
'' and never about NUL. Both Windows gates passed carrying the bug, across 10.2
'' million assertions. So the wide rule is stated here rather than assumed to
'' match, and tests/abi/utrim-parity.bas asks about NUL at each end separately.
''
'' EVERYTHING HERE IS A CODE-UNIT OPERATION AND NOTHING DECODES. Trimming never
'' needs to know about surrogates: neither half of a pair can equal a BMP unit,
'' so a set or pattern made of BMP units cannot match into the middle of one.
''
'' Nine entry points over two algorithms -- a unit test (plain and Any) and a
'' substring test (Ex) -- selected by a mode of 1 = left, 2 = right, 3 = both.

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

'' AN EMPTY RESULT ALLOCATES NOTHING -- it is the shared empty descriptor, not a
'' zero-length temporary. That is an allocation-count fact, invisible in output,
'' and exactly the class build/diff.sh exists to check.
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

private function hInSet _
	( byval c as FB_UCHAR, byval st as FB_UCHAR ptr, byval setlen as integer ) as integer
	for i as integer = 0 to setlen - 1
		if( st[i] = c ) then return -1
	next
	return 0
end function

'' The one implementation behind six of the nine entry points.
''   st = NULL  -> strip spaces and NULs
''   st <> NULL -> strip any unit in the set
private function hTrim _
	( byval src as any ptr, byval src_size as integer, _
	  byval st as FB_UCHAR ptr, byval setlen as integer, byval mode as long ) as FBUSTRING ptr

	dim as FB_UCHAR ptr src_ptr = any
	dim as integer src_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )

	dim as integer first_ = 0, last_ = src_len

	if( (mode and 1) <> 0 ) then
		while( first_ < last_ )
			dim as FB_UCHAR c = src_ptr[first_]
			if( st <> 0 ) then
				if( hInSet( c, st, setlen ) = 0 ) then exit while
			else
				if( (c <> 32) andalso (c <> 0) ) then exit while
			end if
			first_ += 1
		wend
	end if

	if( (mode and 2) <> 0 ) then
		while( last_ > first_ )
			dim as FB_UCHAR c = src_ptr[last_ - 1]
			if( st <> 0 ) then
				if( hInSet( c, st, setlen ) = 0 ) then exit while
			else
				if( (c <> 32) andalso (c <> 0) ) then exit while
			end if
			last_ -= 1
		wend
	end if

	return hTempFrom( @src_ptr[first_], last_ - first_ )

end function

'' Ex strips a whole PATTERN repeatedly, not a set of units -- so it advances by
'' pat_len at a time and stops at the first non-match. An empty pattern strips
'' nothing rather than looping forever, which is the whole of the pat_len > 0
'' guard below.
private function hTrimEx _
	( byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer, byval mode as long ) as FBUSTRING ptr

	dim as FB_UCHAR ptr src_ptr = any, pat_ptr = any
	dim as integer src_len = any, pat_len = any
	FB_USTRSETUP( src, src_size, src_ptr, src_len )
	FB_USTRSETUP( pat, pat_size, pat_ptr, pat_len )

	dim as integer first_ = 0, last_ = src_len

	if( pat_len > 0 ) then
		if( (mode and 1) <> 0 ) then
			while( (last_ - first_) >= pat_len )
				dim as integer i = 0
				while( i < pat_len )
					if( src_ptr[first_ + i] <> pat_ptr[i] ) then exit while
					i += 1
				wend
				if( i < pat_len ) then exit while
				first_ += pat_len
			wend
		end if

		if( (mode and 2) <> 0 ) then
			while( (last_ - first_) >= pat_len )
				dim as integer i = 0
				while( i < pat_len )
					if( src_ptr[last_ - pat_len + i] <> pat_ptr[i] ) then exit while
					i += 1
				wend
				if( i < pat_len ) then exit while
				last_ -= pat_len
			wend
		end if
	end if

	return hTempFrom( @src_ptr[first_], last_ - first_ )

end function

'' --------------------------------------------------------- the entry points
''
'' EVERY ONE RELEASES ITS OPERANDS. A var-len argument may be a temporary the
'' caller built for this call -- TRIM(a + b) -- and nothing else will free it.
'' The narrow side lost 1,000 blocks per 1,000 iterations to exactly this,
'' invisibly, because a leak changes nothing a program can observe.

extern "rtlib"

function tkort_UStrTrim alias "fb_UStrTrim" _
	( byval src as any ptr, byval src_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrim( src, src_size, 0, 0, 3 )
	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrLTrim alias "fb_UStrLTrim" _
	( byval src as any ptr, byval src_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrim( src, src_size, 0, 0, 1 )
	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrRTrim alias "fb_UStrRTrim" _
	( byval src as any ptr, byval src_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrim( src, src_size, 0, 0, 2 )
	hRelTemp( src, src_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrTrimEx alias "fb_UStrTrimEx" _
	( byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrimEx( src, src_size, pat, pat_size, 3 )
	hRelTemp( src, src_size )
	hRelTemp( pat, pat_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrLTrimEx alias "fb_UStrLTrimEx" _
	( byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrimEx( src, src_size, pat, pat_size, 1 )
	hRelTemp( src, src_size )
	hRelTemp( pat, pat_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrRTrimEx alias "fb_UStrRTrimEx" _
	( byval src as any ptr, byval src_size as integer, _
	  byval pat as any ptr, byval pat_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FBUSTRING ptr dst = hTrimEx( src, src_size, pat, pat_size, 2 )
	hRelTemp( src, src_size )
	hRelTemp( pat, pat_size )
	STRUNLOCK()
	return dst
end function

'' The Any forms decode the SET before calling hTrim, because hTrim takes a
'' pointer and a length rather than the four-form argument pair.
function tkort_UStrTrimAny alias "fb_UStrTrimAny" _
	( byval src as any ptr, byval src_size as integer, _
	  byval st as any ptr, byval set_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FB_UCHAR ptr set_ptr = any
	dim as integer set_len = any
	FB_USTRSETUP( st, set_size, set_ptr, set_len )
	dim as FBUSTRING ptr dst = hTrim( src, src_size, set_ptr, set_len, 3 )
	hRelTemp( src, src_size )
	hRelTemp( st, set_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrLTrimAny alias "fb_UStrLTrimAny" _
	( byval src as any ptr, byval src_size as integer, _
	  byval st as any ptr, byval set_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FB_UCHAR ptr set_ptr = any
	dim as integer set_len = any
	FB_USTRSETUP( st, set_size, set_ptr, set_len )
	dim as FBUSTRING ptr dst = hTrim( src, src_size, set_ptr, set_len, 1 )
	hRelTemp( src, src_size )
	hRelTemp( st, set_size )
	STRUNLOCK()
	return dst
end function

function tkort_UStrRTrimAny alias "fb_UStrRTrimAny" _
	( byval src as any ptr, byval src_size as integer, _
	  byval st as any ptr, byval set_size as integer ) as FBUSTRING ptr
	STRLOCK()
	dim as FB_UCHAR ptr set_ptr = any
	dim as integer set_len = any
	FB_USTRSETUP( st, set_size, set_ptr, set_len )
	dim as FBUSTRING ptr dst = hTrim( src, src_size, set_ptr, set_len, 2 )
	hRelTemp( src, src_size )
	hRelTemp( st, set_size )
	STRUNLOCK()
	return dst
end function

end extern
