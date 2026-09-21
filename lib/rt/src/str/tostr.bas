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
'' twin are separate entry points at all. One space, eight symbols -- though the two
'' UNSIGNED ones spell it as a literal space instead, for the reason given at
'' fb_UIntToStrQB below.
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

#ifdef TKORT_MSVC
	'' A NaN LOSES ITS SIGN AND ITS PAYLOAD HERE, because fbc's sprintf is MinGW's
	'' and MinGW writes every NaN as 'nan'. The UCRT keeps both: measured over
	'' "%.16g", '0.0 / 0.0' (FFF8000000000000, the x86 "indefinite") is
	'' '-nan(ind)', FFF8000000000001 is '-nan', and only a POSITIVE quiet NaN is
	'' 'nan' -- and no __stdio_common_vsprintf option bit changes that (fmt.bi).
	'' So the value is replaced by the positive quiet NaN before it is formatted,
	'' and the format still decides the rest: QB's "% .16g" gives ' nan', as fbc's
	'' fb_DoubleToStrQB does for either sign.
	''
	'' BY BIT PATTERN, not 'num <> num': the question is what the bits are, and
	'' a comparison is the one thing a float optimisation is allowed to fold.
	''
	'' WINDOWS UCRT ONLY. On Linux both fbc and tiko-rt call glibc, which writes
	'' '-nan' for a negative NaN, so the two already agree there; MinGW's build
	'' calls __mingw_sprintf, which is fbc's own. The wide family goes through the
	'' MSVCRT-compatible options and already matches ('-1.#IND'); PRINT and WRITE
	'' go through fb_hFloat2Str below and match too. tests/abi/tostr-parity.bas.
	dim as ulongint bits_ = *cptr( ulongint ptr, @num )
	if( ((bits_ and &h7FF0000000000000ull) = &h7FF0000000000000ull) andalso _
	    ((bits_ and &h000FFFFFFFFFFFFFull) <> 0) ) then
		bits_ = &h7FF8000000000000ull
		num = *cptr( double ptr, @bits_ )
	end if
#endif

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

'' THE SPACE FLAG DOES NOT APPLY TO AN UNSIGNED CONVERSION, and only one of the
'' two CRTs knows that. C says the flag prepends a space when a SIGNED conversion
'' produces no sign, so "% u" is meaningless and the UCRT ignores it, while
'' MinGW's printf applies it anyway -- "% u" of 7 is " 7" there and "7" here.
'' fbc is built against MinGW, so " 7" is the answer STR$ has to give, and the
'' space is written into the format as a literal rather than asked for as a flag.
'' Identical text on every target, and it stops depending on which printf.
'' The signed twins keep "% d" and "% lld": the flag is defined for those.
function tkort_UIntToStrQB alias "fb_UIntToStrQB" ( byval num as ulong ) as FBSTRING ptr
	return hIntTo( @" %u", sizeof( long ) * 3, cast( longint, num ) )
end function

function tkort_LongintToStrQB alias "fb_LongintToStrQB" ( byval num as longint ) as FBSTRING ptr
	return hIntTo( @"% lld", sizeof( longint ) * 3, num )
end function

function tkort_ULongintToStrQB alias "fb_ULongintToStrQB" ( byval num as ulongint ) as FBSTRING ptr
	return hIntTo( @" %llu", sizeof( longint ) * 3, cast( longint, num ) )
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
