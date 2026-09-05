'' tostr.bas -- STR$ for STRING: fifteen entry points over eight fbc members,
'' including the QB dialect.
''
'' THE LENGTH IS DELIBERATELY "FAKED", and fbc's own comment says so. The
'' descriptor is allocated big enough for the WORST CASE the formatter could
'' produce -- 7+8 for a single, 16+8 for a double, sizeof(int)*3 for an integer
'' -- and then `len` is set to the text that actually came out. So `size` and
'' `len` disagree afterwards, exactly as they do after a wstring-to-string
'' assignment (RFC-0002 section 4.2). Both are published through
'' fbc-int/string.bi, so the over-allocation is CONTRACT and a tighter one would
'' be a visible divergence.
''
'' THE QB VARIANTS DIFFER BY ONE CHARACTER IN THE FORMAT: "% d" and "% .7g"
'' rather than "%d" and "%.7g". The SPACE FLAG puts a leading blank on
'' non-negative numbers, which is what QB's PRINT does and why STR$ and its QB
'' twin are separate entry points at all. One space, eight symbols.
''
'' ON _itoa VS sprintf: fbc uses _itoa/_ultoa/_i64toa/_ui64toa on MinGW and
'' tkrt_sprintf("%d") elsewhere. The two produce identical text for every value of
'' every integer type -- decimal conversion has no locale variance and no
'' formatting choices left to make -- so ONE path is used here and the #ifdef is
'' not reproduced. That is a deliberate exception to reproduce-don't-simplify,
'' taken because the outputs are provably equal rather than merely believed to be.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"
#include once "crt/string.bi"
#include once "crt/stdio.bi"
#include once "inc/fmt.bi"

extern "rtlib"
	declare function tkrt_AllocTemp alias "fb_hStrAllocTemp" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
end extern

'' Allocate, format through the caller's closure, trim a trailing dot, and set
'' the real length. Every float entry point below is this plus a format string.
private function hFloatTo _
	( byval num as double, byval cap as integer, byval fmt as zstring ptr ) as FBSTRING ptr

	dim as FBSTRING ptr dst = tkrt_AllocTemp( 0, cap )
	if( dst = 0 ) then return TKORT_NULLSTR()

	tkrt_sprintf( dst->data, fmt, num )

	dim as integer n = cast( integer, strlen( dst->data ) )

	'' TRIM A TRAILING DOT. "%g" can end on one -- 1e+100 does not, but a value
	'' like 100000 formatted at low precision can -- and FB does not print it.
	if( n > 0 ) then
		if( dst->data[n - 1] = asc( "." ) ) then
			dst->data[n - 1] = 0
			n -= 1
		end if
	end if

	FB_STRSETLEN( dst, n )
	return dst

end function

private function hIntTo _
	( byval fmt as zstring ptr, byval cap as integer, byval num as longint ) as FBSTRING ptr

	dim as FBSTRING ptr dst = tkrt_AllocTemp( 0, cap )
	if( dst = 0 ) then return TKORT_NULLSTR()

	tkrt_sprintf( dst->data, fmt, num )
	FB_STRSETLEN( dst, cast( integer, strlen( dst->data ) ) )
	return dst

end function

extern "rtlib"

'' -------------------------------------------------------------- integers

function tkort_IntToStr alias "fb_IntToStr" ( byval num as long ) as FBSTRING ptr
	return hIntTo( @"%d", sizeof( long ) * 3, num )
end function

function tkort_UIntToStr alias "fb_UIntToStr" ( byval num as ulong ) as FBSTRING ptr
	return hIntTo( @"%u", sizeof( long ) * 3, cast( longint, num ) )
end function

function tkort_LongintToStr alias "fb_LongintToStr" ( byval num as longint ) as FBSTRING ptr
	return hIntTo( @"%lld", sizeof( longint ) * 3, num )
end function

function tkort_ULongintToStr alias "fb_ULongintToStr" ( byval num as ulongint ) as FBSTRING ptr
	return hIntTo( @"%llu", sizeof( longint ) * 3, cast( longint, num ) )
end function

'' ---------------------------------------------------------------- floats

function tkort_FloatToStr alias "fb_FloatToStr" ( byval num as single ) as FBSTRING ptr
	return hFloatTo( num, 7 + 8, @"%.7g" )
end function

function tkort_DoubleToStr alias "fb_DoubleToStr" ( byval num as double ) as FBSTRING ptr
	return hFloatTo( num, 16 + 8, @"%.16g" )
end function

'' ----------------------------------------------------------------- bool

dim shared as zstring * 6 tkort_sfalse, tkort_strue
dim shared as integer tkort_sbool_ready

function tkort_hBoolToStr alias "fb_hBoolToStr" ( byval num as byte ) as zstring ptr
	if( tkort_sbool_ready = 0 ) then
		tkort_sfalse = "false"
		tkort_strue  = "true"
		tkort_sbool_ready = 1
	end if
	if( num <> 0 ) then return @tkort_strue
	return @tkort_sfalse
end function

function tkort_BoolToStr alias "fb_BoolToStr" ( byval num as byte ) as FBSTRING ptr
	dim as FBSTRING ptr dst = tkrt_AllocTemp( 0, 8 )
	if( dst = 0 ) then return TKORT_NULLSTR()
	dim as zstring ptr src = tkort_hBoolToStr( num )
	dim as integer n = cast( integer, strlen( src ) )
	memcpy( dst->data, src, n )
	dst->data[n] = 0
	FB_STRSETLEN( dst, n )
	return dst
end function

'' ------------------------------------------------------------ QB dialect
''
'' The space flag, and nothing else.

function tkort_IntToStrQB alias "fb_IntToStrQB" ( byval num as long ) as FBSTRING ptr
	return hIntTo( @"% d", sizeof( long ) * 3, num )
end function

function tkort_UIntToStrQB alias "fb_UIntToStrQB" ( byval num as ulong ) as FBSTRING ptr
	return hIntTo( @"% u", sizeof( long ) * 3, cast( longint, num ) )
end function

function tkort_LongintToStrQB alias "fb_LongintToStrQB" ( byval num as longint ) as FBSTRING ptr
	return hIntTo( @"% lld", sizeof( longint ) * 3, num )
end function

function tkort_ULongintToStrQB alias "fb_ULongintToStrQB" ( byval num as ulongint ) as FBSTRING ptr
	return hIntTo( @"% llu", sizeof( longint ) * 3, cast( longint, num ) )
end function

function tkort_FloatToStrQB alias "fb_FloatToStrQB" ( byval num as single ) as FBSTRING ptr
	return hFloatTo( num, 7 + 8, @"% .7g" )
end function

function tkort_DoubleToStrQB alias "fb_DoubleToStrQB" ( byval num as double ) as FBSTRING ptr
	return hFloatTo( num, 16 + 8, @"% .16g" )
end function

end extern

'' ------------------------------------------------- fb_hFloat2Str, the shared
'' formatter the PRINT and FORMAT paths call.
''
'' NON-FBCALL, and it writes into a CALLER-SUPPLIED buffer rather than
'' allocating -- which is why PRINT can format a number without touching the
'' string allocator at all.
''
'' THE ADDBLANK MASK IS WHY IT RETURNS A POINTER RATHER THAN A LENGTH. The text
'' is written at buffer[1], and then either buffer[0] becomes a space and the
'' start moves back (a non-negative number), or the start stays at buffer[1]
'' (a negative one, which supplies its own sign). So the returned pointer is
'' sometimes the buffer and sometimes one past it, and the caller must use it
'' rather than the buffer it passed in.
''
'' A TRUNCATED OR FAILED CONVERSION RETURNS NULL and empties the buffer -- not a
'' partial result. snprintf reports what it WOULD have written, so a length at
'' or past the cap means the digits did not fit.
const FB_F2A_ADDBLANK = 1

#ifdef TKORT_MSVC
'' A THREE-DIGIT EXPONENT, WHICH THE UCRT WILL NOT PRODUCE.
''
'' fbc renders PRINT's floats through snprintf, and on MinGW that is MSVCRT's,
'' which pads the exponent to at least three digits. Measured against fbc:
''
''     1e20 -> 1e+020    1e-5  -> 1e-005    1e16  -> 1e+016
''     1e100 -> 1e+100   1e308 -> 1e+308    (already three, untouched)
''
'' The UCRT is C99 and writes the minimum two, so the same program printed
'' 1e+20 on this target -- every double in exponential form, not a corner case.
'' _set_output_format( _TWO_DIGIT_EXPONENT ) was the switch for this and was
'' REMOVED in the UCRT, so the padding is done here or not at all.
''
'' RETURNS THE LENGTH IT WOULD NEED, and writes nothing when that does not fit,
'' so the caller's existing 'n >= maxlen' test decides the same way it does on
'' MinGW -- where snprintf would itself have reported the longer length and been
'' refused. Padding first and testing afterwards is what keeps the two targets
'' agreeing about TRUNCATION as well as about digits.
private function tkort_hPad3Exp _
	( byval p as zstring ptr, byval n as long, byval maxlen as long ) as long

	dim as long e = 0
	while (e < n) andalso (p[e] <> asc( "e" )) andalso (p[e] <> asc( "E" ))
		e += 1
	wend
	if( e >= n ) then return n

	'' Past the 'e' and its sign, then count what digits there are.
	dim as long d = e + 1
	if( d < n ) then
		if( (p[d] = asc( "+" )) orelse (p[d] = asc( "-" )) ) then d += 1
	end if
	dim as long j = d
	while (j < n) andalso (p[j] >= asc( "0" )) andalso (p[j] <= asc( "9" ))
		j += 1
	wend
	dim as long nd = j - d
	if( (nd <= 0) orelse (nd >= 3) ) then return n

	'' THE EXPONENT IS THE LAST FIELD, so nothing has to move: the digits are
	'' saved, the zeros written over them, and the digits put back after. An
	'' in-place shift was tried first and got 1e+0200 -- the copy overlaps, and
	'' reasoning about which end to start from is exactly the kind of care this
	'' avoids needing. nd is 1 or 2 here, so there are at most two to hold.
	if( j <> n ) then return n

	dim as long add_ = 3 - nd
	if( (d + 3) >= maxlen ) then return d + 3

	dim as ubyte d0 = p[d]
	dim as ubyte d1 = 0
	if( nd = 2 ) then d1 = p[d + 1]

	for k as long = 0 to add_ - 1
		p[d + k] = asc( "0" )
	next
	p[d + add_] = d0
	if( nd = 2 ) then p[d + add_ + 1] = d1
	p[d + 3] = 0

	return d + 3
end function
#endif

extern "c"   '' NON-FBCALL: fb_string.h declares fb_hFloat2Str without it.

function tkort_hFloat2Str alias "fb_hFloat2Str" _
	( byval val_ as double, byval buffer as zstring ptr, _
	  byval digits as long, byval mask as long ) as zstring ptr

	dim as zstring ptr p = buffer
	if( (mask and FB_F2A_ADDBLANK) <> 0 ) then p = @buffer[1]

	'' The two common precisions are spelled out rather than built, which is
	'' fbc's own micro-optimisation and is kept so the format strings are
	'' byte-identical in every case.
	dim as zstring * 16 fmtstr
	dim as zstring ptr fstr = any
	select case digits
	case 7  : fstr = @"%.7g"
	case 16 : fstr = @"%.16g"
	case else
		tkrt_sprintf( @fmtstr, @"%%.%dg", digits )
		fstr = @fmtstr
	end select

	dim as integer maxlen = 1 + digits + 6 + 1
	dim as integer n = cast( integer, tkrt_snprintf( p, maxlen, fstr, val_ ) )

	'' See tkort_hPad3Exp. Only when snprintf itself succeeded: a truncation is
	'' already the failure below, and there is nothing well-formed to pad.
	#ifdef TKORT_MSVC
		if( (n > 0) andalso (n < maxlen) ) then
			n = tkort_hPad3Exp( p, n, maxlen )
		end if
	#endif

	if( (n <= 0) orelse (n >= maxlen) ) then
		buffer[0] = 0
		return 0
	end if

	if( p[n - 1] = asc( "." ) ) then p[n - 1] = 0

	if( (mask and FB_F2A_ADDBLANK) <> 0 ) then
		if( p[0] <> asc( "-" ) ) then
			buffer[0] = asc( " " )
			return buffer
		end if
	end if

	return p

end function

end extern
