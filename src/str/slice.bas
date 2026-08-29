'' slice.bas -- fb_LEFT and fb_RIGHT.
''
'' Split out of basic.bas so that the two halves can be merged into the gate
'' independently. That is not tidiness: a Linux gate failure had to be bisected
'' to a module, and a module holding four unrelated entry points is a poor unit
'' to bisect to.
''
'' Both CONSUME a temporary operand -- see the note on hSlice.
''
'' CORRECTED after PROBE-32. This module used to define a private empty
'' descriptor of its own. Its CONTENTS were right and every gate passed, but
'' fbc returns ONE shared empty -- &__fb_ctx.null_desc -- from fb_LEFT, fb_TRIM
'' and fb_StrMid alike, so two empty results compare equal by address there and
'' did not here. Nothing in fbc's 2,715-file suite looks; it was a divergence
'' all the same. See inc/ctx.bi.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"


extern "rtlib"
	declare function fb_hStrAllocTemp alias "fb_hStrAllocTemp" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" _
		( byval s as FBSTRING ptr ) as long
	declare sub fb_hStrCopy alias "fb_hStrCopy" _
		( byval dst as zstring ptr, byval src as zstring ptr, byval bytes as integer )
end extern

extern "rtlib"

private function hSlice _
	( _
		byval s as FBSTRING ptr, byval chars as integer, byval fromRight as integer _
	) as FBSTRING ptr

	'' LEFT AND RIGHT CONSUME A TEMPORARY OPERAND.
	''
	'' If the source carries the temp bit it is released here, after the copy.
	'' A non-temporary source is left untouched. Measured (PROBE-28): handing
	'' fb_LEFT a temporary leaves it len 0, data NULL, temp bit cleared; handing
	'' it an ordinary string changes nothing.
	''
	'' Omitting this is a LEAK, not a wrong answer -- `LEFT( f(x), 3 )` strands
	'' one of the 256 pool descriptors per call. It cost a Linux gate run, and
	'' the crash was in chrono's non-ASCII tests, nowhere near the cause: once
	'' the pool is exhausted fb_hStrAllocTemp returns NULL, every subsequent
	'' temporary is the empty result, and the failures cascade.
	''
	'' PROBE-27 asked what these functions RETURN for every edge and got three
	'' contracts right. It never asked what they do to their OPERAND, which is
	'' why this one still got through.

	if( (s = 0) orelse (chars <= 0) ) then
		if( s <> 0 ) then tkrt_DelTemp( s )
		return TKORT_NULLSTR( )
	end if

	dim as zstring ptr p = s->data
	if( p = 0 ) then
		if( s <> 0 ) then tkrt_DelTemp( s )
		return TKORT_NULLSTR( )
	end if

	dim as integer n = FB_STRSIZE( s )
	if( n <= 0 ) then
		if( s <> 0 ) then tkrt_DelTemp( s )
		return TKORT_NULLSTR( )
	end if

	if( chars > n ) then chars = n

	dim as FBSTRING ptr r = fb_hStrAllocTemp( 0, chars )
	if( r = 0 ) then
		if( s <> 0 ) then tkrt_DelTemp( s )
		return TKORT_NULLSTR( )
	end if

	if( fromRight ) then
		fb_hStrCopy( r->data, @p[n - chars], chars )
	else
		fb_hStrCopy( r->data, p, chars )
	end if

	'' After the copy, never before.
	if( s <> 0 ) then tkrt_DelTemp( s )

	return r

end function

function tkort_LEFT alias "fb_LEFT" _
	( byval s as FBSTRING ptr, byval chars as integer ) as FBSTRING ptr
	return hSlice( s, chars, 0 )
end function

function tkort_RIGHT alias "fb_RIGHT" _
	( byval s as FBSTRING ptr, byval chars as integer ) as FBSTRING ptr
	return hSlice( s, chars, -1 )
end function

end extern
