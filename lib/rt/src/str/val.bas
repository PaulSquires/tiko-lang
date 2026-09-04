'' val.bas -- fb_hStr2Double and fb_VAL (str_convfrom.c).
''
'' VAL(). Four behaviours worth naming, all of them invisible from the signature.
''
'' 1. LEADING SPACES ONLY are skipped -- fb_hStrSkipChar with 32. Not tabs, not
''    newlines. Same classic-BASIC rule as TRIM (RFC-0002 section 4.8).
''
'' 2. `&H` / `&O` / `&B` GO TO THE RADIX PARSER, and an unrecognised letter after
''    `&` is ASSUMED OCTAL with only ONE character skipped -- so `&z12` parses
''    "z12" as octal, stops at the bad digit, and yields 0. The prefix branch
''    returns fb_hStrRadix2LONGINT even though this function returns double.
''
'' 3. `0x` / `0X` IS DELIBERATELY REFUSED, returning 0.0. strtod() would accept
''    it as hex; FreeBASIC only recognises `&h`, so the C filters it out first
''    and the comment says exactly that.
''
'' 4. `d` AND `D` EXPONENTS ARE REWRITTEN TO `e`/`E` IN A TEMPORARY BUFFER.
''    strtod does not accept the FORTRAN-style `d` exponent outside win32, so
''    fbc mallocs len+1 bytes, copies with `++c` on any d/D, and frees. That
''    allocation is part of the contract as far as Gate 3 is concerned, so it is
''    reproduced rather than avoided -- `++c` on 'd' gives 'e' and on 'D' gives
''    'E', which is why the C increments rather than assigns.

#include once "inc/descriptors.bi"

extern "rtlib"
	declare function tkrt_SkipChar alias "fb_hStrSkipChar" _
		( byval s as zstring ptr, byval length as integer, byval c as long ) as zstring ptr
	declare function tkrt_Radix2Longint alias "fb_hStrRadix2Longint" _
		( byval s as zstring ptr, byval length as integer, byval radix as long ) as longint
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" _
		( byval s as FBSTRING ptr ) as long
end extern

extern "rtlib"

function tkort_hStr2Double alias "fb_hStr2Double" _
	( byval src as zstring ptr, byval length as integer ) as double

	dim as zstring ptr p = tkrt_SkipChar( src, length, 32 )

	length -= cast( integer, cptr( ubyte ptr, p ) - cptr( ubyte ptr, src ) )
	if( length < 1 ) then return 0.0

	dim as ubyte ptr up = cptr( ubyte ptr, p )

	if( length >= 2 ) then
		if( up[0] = asc("&") ) then
			dim as long radix = any
			dim as integer skip = 2

			select case as const up[1]
			case asc("h"), asc("H")
				radix = 16
			case asc("o"), asc("O")
				radix = 8
			case asc("b"), asc("B")
				radix = 2
			case else
				'' Anything else after & is octal, and only ONE char is skipped.
				radix = 8
				skip = 1
			end select

			return cast( double, tkrt_Radix2Longint( cptr( zstring ptr, up + skip ), length - skip, radix ) )

		elseif( up[0] = asc("0") ) then
			'' strtod would read 0x as hex; FreeBASIC recognises only &h.
			if( (up[1] = asc("x")) orelse (up[1] = asc("X")) ) then return 0.0
		end if
	end if

	'' The d/D -> e/E rewrite, in a temporary buffer. The allocation is part of
	'' the observable traffic, so it stays.
	dim as ubyte ptr q = allocate( length + 1 )
	if( q = 0 ) then return 0.0

	dim as ubyte c = any
	for i as integer = 0 to length - 1
		c = up[i]
		'' INCREMENT, not assign: 'd'+1 = 'e' and 'D'+1 = 'E'.
		if( (c = asc("d")) orelse (c = asc("D")) ) then c += 1
		q[i] = c
	next
	q[length] = 0

	dim as double ret = strtod( cptr( zstring ptr, q ), 0 )
	deallocate( q )

	return ret

end function

function tkort_VAL alias "fb_VAL" ( byval s as FBSTRING ptr ) as double

	if( s = 0 ) then return 0.0

	dim as double v = 0.0
	if( s->data <> 0 ) then
		if( FB_STRSIZE( s ) <> 0 ) then
			v = tkort_hStr2Double( s->data, FB_STRSIZE( s ) )
		end if
	end if

	tkrt_DelTemp( s )

	return v

end function

end extern
