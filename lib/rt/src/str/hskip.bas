'' hskip.bas -- fb_hStrSkipChar and fb_hStrSkipCharRev (str_hskip.o).
''
'' The two helpers fbc's trim family is built on -- and between them they explain
'' a contract that cost this project a Linux gate run to discover.
''
'' THE REVERSE SCAN STRIPS NUL AS WELL AS THE REQUESTED CHARACTER:
''
''     while( (--len >= 0) && ((*p == c) || (*p == 0)) )
''
'' fbc's own comment says why -- "fixed-len's are filled with null's as in PB,
'' strip them too". THE FORWARD SCAN DOES NOT. That asymmetry IS the rule
'' recorded in RFC-0002 section 4.8: TRIM and RTRIM strip chr(0) from the right
'' only, and LTRIM never does. Measured there from the outside, after five
'' assertions failed on Linux and passed on both Windows targets; here it is, in
'' one line of one helper.
''
'' BOTH RETURN A POINTER, NOT AN INDEX, and neither is bounded the way a reader
'' expects:
''
''   -- Forward: on an all-matching string it returns s + len, ONE PAST the end.
''   -- Reverse: on an all-matching string it returns s - 1, ONE BEFORE the
''      start. That is a pointer the caller must not dereference, and forming it
''      is technically undefined in C; the callers compare it against `s` and
''      never read through it.
''
'' A NULL string returns NULL (forward) or s (reverse), and a reverse scan with
'' len <= 0 returns s untouched.

#include once "inc/descriptors.bi"

extern "rtlib"

function tkort_hStrSkipChar alias "fb_hStrSkipChar" _
	( byval s as zstring ptr, byval length as integer, byval c as long ) as zstring ptr

	dim as ubyte ptr p = cptr( ubyte ptr, s )

	if( s <> 0 ) then
		'' C's `while( (--len >= 0) && (*p == c) )`: decrement FIRST, so a
		'' length of 1 permits exactly one test.
		do
			length -= 1
			if( length < 0 ) then exit do
			if( p[0] <> c ) then exit do
			p += 1
		loop
	end if

	return cptr( zstring ptr, p )

end function

function tkort_hStrSkipCharRev alias "fb_hStrSkipCharRev" _
	( byval s as zstring ptr, byval length as integer, byval c as long ) as zstring ptr

	if( s = 0 ) then return s
	if( length <= 0 ) then return s

	dim as ubyte ptr p = cptr( ubyte ptr, s ) + length - 1

	'' NUL is stripped here and nowhere else -- see the note above.
	do
		length -= 1
		if( length < 0 ) then exit do
		if( (p[0] <> c) andalso (p[0] <> 0) ) then exit do
		p -= 1
	loop

	return cptr( zstring ptr, p )

end function

end extern
