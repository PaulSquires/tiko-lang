'' fb/math.bi -- the core scalar math surface
''
''     #include once "fb/math.bi"
''     using FB
''
''     print Round( -2.5 )          '' -3   half away from zero
''     print RoundHalfEven( -2.5 )  '' -2   banker's
''     print Clamp( x, 0.0, 1.0 )
''     print Hypot( 3.0, 4.0 )      '' 5
''     if( IsNaN( d ) ) then ...
''
'' THE MONEY TYPES ARE SEPARATE HEADERS and are NOT pulled in from here:
''
''     #include once "fb/currency.bi"   ' 8 bytes, four decimal places, fixed
''     #include once "fb/decimal.bi"    ' 16 bytes, 0..28 places, .NET's decimal
''
'' Neither is included by this file on purpose.  Both cost a dependency --
'' fb/optional.bi for their parse functions, and fb/currency.bi again for
'' Decimal's bridge -- and a program that only wants Round and Clamp should not
'' pay for them.  Include the one you need beside this one.
''
'' Specified by C:\dev\docs\math\RFC-0001-core.md.  This header is phase 1:
'' constants, selection, rounding, the libm surface under FreeBASIC names, and
'' floating-point classification.
''
'' NOTHING HERE IS A KEYWORD.  'min', 'max', 'round' and 'clamp' are all legal
'' identifiers in FreeBASIC and twenty years of code uses them as variable
'' names, so everything lives in namespace FB behind this #include.  'using FB'
'' is the caller's decision; a program with its own 'Min' writes 'FB.Min' or
'' does not write it at all.
''
'' NOTHING EXISTING CHANGES.  '^', 'MOD', 'INT', 'FIX', 'VAL', 'STR' and
'' crt/math.bi all behave exactly as they always have -- including where they
'' are wrong.  Each defect gets a correct neighbour under a different name:
''
''     int( x + 0.5 )     wrong for negatives and at ties  ->  Round( x )
''     x <> x             the NaN idiom                    ->  IsNaN( x )
''     4 * atn( 1 )       there is no pi                   ->  PI
''
'' EVERY FUNCTION IS AN OVERLOAD SET, not a single 'double' entry point.  That
'' is the specific defect that makes crt/math.bi unusable in practice: 'sqrt'
'' there takes a double, so every single-precision call widens and narrows
'' silently, twice.  Here a SINGLE argument takes the single path.
''
'' Free overloads rather than members, following the precedent measured in
'' fb/hash.bi: a member cannot be added to 'double' or 'longint', and a generic
'' body cannot branch on what its type parameter is bound to.  Dispatch has to
'' be ordinary overload resolution.
''
'' EXACT vs BOUNDED (RFC-0008).  Rounding, classification, selection and the
'' constants are EXACT -- bit-identical on every target under every backend.
'' Everything delegating to libm is BOUNDED: accurate to a stated ULP bound,
'' with the platform libm named as the dependency.  Results from the second
'' group are NOT guaranteed identical across targets.

#pragma once

#include once "fblimits.bi"

'' crt/math.bi DEFINES SIX MACROS NAMED LIKE MEMBERS OF THIS HEADER -- INFINITY,
'' and FP_NAN, FP_INFINITE, FP_ZERO, FP_SUBNORMAL, FP_NORMAL -- and a macro is
'' global and blind to case.  Read first (crt.bi includes it, and on Linux so
'' does fb/tuiterm.bi), they rewrote Infinity( ) and the FpClass members below
'' into C expressions and this header did not compile, under fbc and tiko
'' alike.  A program in that order never compiled, so taking the macros back
'' costs it nothing; FB.Infinity( ) and FB.FP_INFINITE are what this header
'' offers in their place.
#ifdef __crt_math_bi__
	#undef INFINITY
	#undef FP_NAN
	#undef FP_INFINITE
	#undef FP_ZERO
	#undef FP_SUBNORMAL
	#undef FP_NORMAL
#endif

namespace FB

'' ---------------------------------------------------------------------------
'' The platform libm.  Declared privately here rather than by including
'' crt/math.bi, because that header renames 'sin' and 'log' to 'sin_' and 'log_'
'' to dodge the FB intrinsics, and pulling 179 C declarations into every caller
'' to reach fifteen of them is not a trade worth making.
'' ---------------------------------------------------------------------------

extern "c"
	declare function c_floor      alias "floor"      ( byval as double ) as double
	declare function c_ceil       alias "ceil"       ( byval as double ) as double
	declare function c_trunc      alias "trunc"      ( byval as double ) as double
	declare function c_fmod       alias "fmod"       ( byval as double, byval as double ) as double
	declare function c_cbrt       alias "cbrt"       ( byval as double ) as double
	declare function c_hypot      alias "hypot"      ( byval as double, byval as double ) as double
	declare function c_exp2       alias "exp2"       ( byval as double ) as double
	declare function c_expm1      alias "expm1"      ( byval as double ) as double
	declare function c_log2       alias "log2"       ( byval as double ) as double
	declare function c_log10      alias "log10"      ( byval as double ) as double
	declare function c_log1p      alias "log1p"      ( byval as double ) as double
	declare function c_logb       alias "logb"       ( byval as double ) as double
	declare function c_pow        alias "pow"        ( byval as double, byval as double ) as double
	declare function c_sinh       alias "sinh"       ( byval as double ) as double
	declare function c_cosh       alias "cosh"       ( byval as double ) as double
	declare function c_tanh       alias "tanh"       ( byval as double ) as double
	declare function c_asinh      alias "asinh"      ( byval as double ) as double
	declare function c_acosh      alias "acosh"      ( byval as double ) as double
	declare function c_atanh      alias "atanh"      ( byval as double ) as double
	declare function c_fma        alias "fma"        ( byval as double, byval as double, byval as double ) as double
	declare function c_copysign   alias "copysign"   ( byval as double, byval as double ) as double
	declare function c_nextafter  alias "nextafter"  ( byval as double, byval as double ) as double
	declare function c_scalbn     alias "scalbn"     ( byval as double, byval as long ) as double
	declare function c_frexp      alias "frexp"      ( byval as double, byval as long ptr ) as double
	declare function c_modf       alias "modf"       ( byval as double, byval as double ptr ) as double

	declare function c_floorf     alias "floorf"     ( byval as single ) as single
	declare function c_ceilf      alias "ceilf"      ( byval as single ) as single
	declare function c_truncf     alias "truncf"     ( byval as single ) as single
	declare function c_fmodf      alias "fmodf"      ( byval as single, byval as single ) as single
	declare function c_cbrtf      alias "cbrtf"      ( byval as single ) as single
	declare function c_hypotf     alias "hypotf"     ( byval as single, byval as single ) as single
	declare function c_exp2f      alias "exp2f"      ( byval as single ) as single
	declare function c_expm1f     alias "expm1f"     ( byval as single ) as single
	declare function c_log2f      alias "log2f"      ( byval as single ) as single
	declare function c_log10f     alias "log10f"     ( byval as single ) as single
	declare function c_log1pf     alias "log1pf"     ( byval as single ) as single
	declare function c_logbf      alias "logbf"      ( byval as single ) as single
	declare function c_powf       alias "powf"       ( byval as single, byval as single ) as single
	declare function c_sinhf      alias "sinhf"      ( byval as single ) as single
	declare function c_coshf      alias "coshf"      ( byval as single ) as single
	declare function c_tanhf      alias "tanhf"      ( byval as single ) as single
	declare function c_asinhf     alias "asinhf"     ( byval as single ) as single
	declare function c_acoshf     alias "acoshf"     ( byval as single ) as single
	declare function c_atanhf     alias "atanhf"     ( byval as single ) as single
	declare function c_fmaf       alias "fmaf"       ( byval as single, byval as single, byval as single ) as single
	declare function c_copysignf  alias "copysignf"  ( byval as single, byval as single ) as single
	declare function c_nextafterf alias "nextafterf" ( byval as single, byval as single ) as single
	declare function c_scalbnf    alias "scalbnf"    ( byval as single, byval as long ) as single
end extern

'' ---------------------------------------------------------------------------
'' Bit access.  Classification reads the exponent and mantissa fields rather
'' than comparing, because 'x <> x' is only a correct NaN test while the
'' compiler is not permitted to assume finiteness -- under '-fpmode fast' it is
'' not.  Reading the bits is correct under every -fpmode and every backend, and
'' that is what makes these worth having over the idiom they replace.
'' ---------------------------------------------------------------------------

union DoubleBits
	as double   d
	as ulongint u
end union

union SingleBits
	as single f
	as ulong  u
end union

private function hBitsD( byval x as double ) as ulongint
	dim as DoubleBits b
	b.d = x
	function = b.u
end function

private function hFromBitsD( byval u as ulongint ) as double
	dim as DoubleBits b
	b.u = u
	function = b.d
end function

private function hBitsF( byval x as single ) as ulong
	dim as SingleBits b
	b.f = x
	function = b.u
end function

private function hFromBitsF( byval u as ulong ) as single
	dim as SingleBits b
	b.u = u
	function = b.f
end function

'' ---------------------------------------------------------------------------
'' Constants
'' ---------------------------------------------------------------------------

const as double PI      = 3.14159265358979323846
const as double TAU     = 6.28318530717958647692
const as double E       = 2.71828182845904523536
const as double SQRT2   = 1.41421356237309504880
const as double LN2     = 0.69314718055994530942
const as double LN10    = 2.30258509299404568402
const as double DEG2RAD = PI / 180.0
const as double RAD2DEG = 180.0 / PI

const as double EPSILON_DOUBLE        = 2.2204460492503131e-16
const as double MAX_DOUBLE            = 1.7976931348623157e+308
const as double MIN_POSITIVE_DOUBLE   = 2.2250738585072014e-308

const as single EPSILON_SINGLE        = 1.19209290e-7f
const as single MAX_SINGLE            = 3.40282347e+38f
const as single MIN_POSITIVE_SINGLE   = 1.17549435e-38f

'' The non-finite values are FUNCTIONS, not constants.  'const as double N =
'' 0.0 / 0.0' is a compile-time division by zero and does not compile; a CONST
'' cannot hold a non-finite value in FreeBASIC.  These build the bit pattern
'' directly and every backend inlines them.

private function NaN overload ( ) as double
	function = hFromBitsD( &h7FF8000000000000ull )
end function

private function Infinity overload ( ) as double
	function = hFromBitsD( &h7FF0000000000000ull )
end function

private function NegInfinity overload ( ) as double
	function = hFromBitsD( &hFFF0000000000000ull )
end function

private function NaNF overload ( ) as single
	function = hFromBitsF( &h7FC00000ul )
end function

private function InfinityF overload ( ) as single
	function = hFromBitsF( &h7F800000ul )
end function

private function NegInfinityF overload ( ) as single
	function = hFromBitsF( &hFF800000ul )
end function

private function MinSubnormalDouble overload ( ) as double
	function = hFromBitsD( 1ull )
end function

private function MinSubnormalSingle overload ( ) as single
	function = hFromBitsF( 1ul )
end function

'' Integer bounds are NOT duplicated here.  fblimits.bi already supplies
'' MIN_VALUE_LONGINT and friends in this namespace, and a second spelling of the
'' same constant is how the two drift apart.

'' ---------------------------------------------------------------------------
'' Classification
'' ---------------------------------------------------------------------------

enum FpClass
	FP_NAN
	FP_INFINITE
	FP_ZERO
	FP_SUBNORMAL
	FP_NORMAL
end enum

private function IsNaN overload ( byval x as double ) as boolean
	dim as ulongint u = hBitsD( x )
	dim as boolean maxexp = ( ( u shr 52 ) and &h7FFull ) = &h7FFull
	dim as boolean hasmant = ( u and &hFFFFFFFFFFFFFull ) <> 0ull
	function = maxexp andalso hasmant
end function

private function IsNaN overload ( byval x as single ) as boolean
	dim as ulong u = hBitsF( x )
	dim as boolean maxexp = ( ( u shr 23 ) and &hFFul ) = &hFFul
	dim as boolean hasmant = ( u and &h7FFFFFul ) <> 0ul
	function = maxexp andalso hasmant
end function

private function IsInfinite overload ( byval x as double ) as boolean
	function = ( hBitsD( x ) and &h7FFFFFFFFFFFFFFFull ) = &h7FF0000000000000ull
end function

private function IsInfinite overload ( byval x as single ) as boolean
	function = ( hBitsF( x ) and &h7FFFFFFFul ) = &h7F800000ul
end function

private function IsFinite overload ( byval x as double ) as boolean
	function = ( ( hBitsD( x ) shr 52 ) and &h7FFull ) <> &h7FFull
end function

private function IsFinite overload ( byval x as single ) as boolean
	function = ( ( hBitsF( x ) shr 23 ) and &hFFul ) <> &hFFul
end function

private function IsNormal overload ( byval x as double ) as boolean
	dim as ulongint ex = ( hBitsD( x ) shr 52 ) and &h7FFull
	dim as boolean notzero = ex <> 0ull
	dim as boolean notmax  = ex <> &h7FFull
	function = notzero andalso notmax
end function

private function IsNormal overload ( byval x as single ) as boolean
	dim as ulong ex = ( hBitsF( x ) shr 23 ) and &hFFul
	dim as boolean notzero = ex <> 0ul
	dim as boolean notmax  = ex <> &hFFul
	function = notzero andalso notmax
end function

private function IsSubnormal overload ( byval x as double ) as boolean
	dim as ulongint u = hBitsD( x )
	dim as boolean zeroexp = ( ( u shr 52 ) and &h7FFull ) = 0ull
	dim as boolean hasmant = ( u and &hFFFFFFFFFFFFFull ) <> 0ull
	function = zeroexp andalso hasmant
end function

private function IsSubnormal overload ( byval x as single ) as boolean
	dim as ulong u = hBitsF( x )
	dim as boolean zeroexp = ( ( u shr 23 ) and &hFFul ) = 0ul
	dim as boolean hasmant = ( u and &h7FFFFFul ) <> 0ul
	function = zeroexp andalso hasmant
end function

'' A SIGN-BIT query, not a comparison.  IsNegative( -0.0 ) is TRUE, where
'' -0.0 < 0.0 is false.  This is the one function here whose obvious reading is
'' wrong, so it is stated rather than left to be discovered.

private function IsNegative overload ( byval x as double ) as boolean
	function = ( hBitsD( x ) shr 63 ) <> 0ull
end function

private function IsNegative overload ( byval x as single ) as boolean
	function = ( hBitsF( x ) shr 31 ) <> 0ul
end function

private function Classify overload ( byval x as double ) as FpClass
	dim as ulongint u = hBitsD( x )
	dim as ulongint ex = ( u shr 52 ) and &h7FFull
	dim as ulongint m = u and &hFFFFFFFFFFFFFull
	if( ex = &h7FFull ) then
		if( m <> 0ull ) then return FP_NAN
		return FP_INFINITE
	end if
	if( ex = 0ull ) then
		if( m = 0ull ) then return FP_ZERO
		return FP_SUBNORMAL
	end if
	function = FP_NORMAL
end function

private function Classify overload ( byval x as single ) as FpClass
	dim as ulong u = hBitsF( x )
	dim as ulong ex = ( u shr 23 ) and &hFFul
	dim as ulong m = u and &h7FFFFFul
	if( ex = &hFFul ) then
		if( m <> 0ul ) then return FP_NAN
		return FP_INFINITE
	end if
	if( ex = 0ul ) then
		if( m = 0ul ) then return FP_ZERO
		return FP_SUBNORMAL
	end if
	function = FP_NORMAL
end function

'' ---------------------------------------------------------------------------
'' Selection: Min, Max, Clamp, Lerp, Sign
''
'' NaN PROPAGATES.  Min( NaN, 1.0 ) is NaN.  C's fmin returns the non-NaN
'' operand; that is a defensible choice and it is not this one, because silently
'' discarding a NaN turns a detectable error into an undetectable wrong answer.
'' Same reasoning that made DateTime's Invalid sentinel infectious.
'' ---------------------------------------------------------------------------

#macro __FB_MATH_MINMAX_INT( T )
	private function Min overload ( byval a as T, byval b as T ) as T
		if( a < b ) then return a
		function = b
	end function

	private function Max overload ( byval a as T, byval b as T ) as T
		if( a > b ) then return a
		function = b
	end function

	private function Clamp overload ( byval v as T, byval lo as T, byval hi as T ) as T
		if( lo > hi ) then return hi
		if( v < lo ) then return lo
		if( v > hi ) then return hi
		function = v
	end function

	private function Sign overload ( byval x as T ) as long
		if( x > 0 ) then return 1
		if( x < 0 ) then return -1
		function = 0
	end function
#endmacro


__FB_MATH_MINMAX_INT( byte )
__FB_MATH_MINMAX_INT( ubyte )
__FB_MATH_MINMAX_INT( short )
__FB_MATH_MINMAX_INT( ushort )
__FB_MATH_MINMAX_INT( long )
__FB_MATH_MINMAX_INT( ulong )
__FB_MATH_MINMAX_INT( integer )
__FB_MATH_MINMAX_INT( uinteger )
__FB_MATH_MINMAX_INT( longint )
__FB_MATH_MINMAX_INT( ulongint )

private function Min overload ( byval a as double, byval b as double ) as double
	if( IsNaN( a ) ) then return a
	if( IsNaN( b ) ) then return b
	if( a < b ) then return a
	function = b
end function

private function Min overload ( byval a as single, byval b as single ) as single
	if( IsNaN( a ) ) then return a
	if( IsNaN( b ) ) then return b
	if( a < b ) then return a
	function = b
end function

private function Max overload ( byval a as double, byval b as double ) as double
	if( IsNaN( a ) ) then return a
	if( IsNaN( b ) ) then return b
	if( a > b ) then return a
	function = b
end function

private function Max overload ( byval a as single, byval b as single ) as single
	if( IsNaN( a ) ) then return a
	if( IsNaN( b ) ) then return b
	if( a > b ) then return a
	function = b
end function

'' Clamp with lo > hi is a caller error and it returns hi.  It is not
'' diagnosed -- there is no mechanism to diagnose it in a library -- and the
'' behaviour is chosen to be deterministic rather than to be right, because
'' there is no right answer.  A NaN v falls through every comparison and is
'' returned unchanged, which is the propagation rule again.

private function Clamp overload ( byval v as double, byval lo as double, byval hi as double ) as double
	if( lo > hi ) then return hi
	if( v < lo ) then return lo
	if( v > hi ) then return hi
	function = v
end function

private function Clamp overload ( byval v as single, byval lo as single, byval hi as single ) as single
	if( lo > hi ) then return hi
	if( v < lo ) then return lo
	if( v > hi ) then return hi
	function = v
end function

'' Lerp is 'a + t * ( b - a )': monotonic, but NOT exact at t = 1.  The
'' exact-at-endpoints form '(1-t)*a + t*b' is not monotonic; both properties
'' cannot be had at once in binary floating point.  C++20 std::lerp chooses
'' exactness and pays a branch.  This chooses the fast form and states the
'' consequence -- Lerp( a, b, 1.0 ) may differ from b by one ulp.

private function Lerp overload ( byval a as double, byval b as double, byval t as double ) as double
	function = a + t * ( b - a )
end function

private function Lerp overload ( byval a as single, byval b as single, byval t as single ) as single
	function = a + t * ( b - a )
end function

'' Sign returns LONG always, which is the difference from the SGN intrinsic:
'' sgn( someDouble ) is a double and cannot index an array or drive a
'' SELECT CASE without a conversion.  Sign( NaN ) is 0.

private function Sign overload ( byval x as double ) as long
	if( x > 0.0 ) then return 1
	if( x < 0.0 ) then return -1
	function = 0
end function

private function Sign overload ( byval x as single ) as long
	if( x > 0.0f ) then return 1
	if( x < 0.0f ) then return -1
	function = 0
end function

'' ---------------------------------------------------------------------------
'' Rounding
''
'' The part most often got wrong, and the part FB.Currency depends on.
''
'' Round is NOT 'int( x + 0.5 )'.  That idiom is wrong twice: wrong for
'' negatives -- int( -2.5 + 0.5 ) is -2, not -3 -- and wrong just below a tie,
'' because x + 0.5 can round UP to the tie before int ever sees it.
'' 0.49999999999999994 is the largest double below 0.5 and the idiom rounds it
'' to 1.
''
'' RoundHalfEven is implemented rather than delegated to C's 'rint', because
'' rint honours the CURRENT rounding mode and would therefore stop being
'' deterministic the moment RFC-0008's fenv surface exists.  Rounding is in the
'' exact class and has to be identical on every target regardless.
'' ---------------------------------------------------------------------------

private function Floor overload ( byval x as double ) as double
	function = c_floor( x )
end function

private function Floor overload ( byval x as single ) as single
	function = c_floorf( x )
end function

private function Ceil overload ( byval x as double ) as double
	function = c_ceil( x )
end function

private function Ceil overload ( byval x as single ) as single
	function = c_ceilf( x )
end function

'' Truncate is a synonym for FIX and is documented as such rather than
'' pretending to add anything.  It exists because INT is floor and FIX is
'' truncation, and neither name says so -- half the FB code in existence uses
'' INT believing it truncates.

private function Truncate overload ( byval x as double ) as double
	function = c_trunc( x )
end function

private function Truncate overload ( byval x as single ) as single
	function = c_truncf( x )
end function

private function Round overload ( byval x as double ) as double
	if( IsFinite( x ) = false ) then return x
	if( x >= 0.0 ) then
		dim as double f = c_floor( x )
		if( ( x - f ) >= 0.5 ) then return f + 1.0
		return f
	end if
	dim as double c = c_ceil( x )
	if( ( c - x ) >= 0.5 ) then return c - 1.0
	function = c
end function

private function Round overload ( byval x as single ) as single
	if( IsFinite( x ) = false ) then return x
	if( x >= 0.0f ) then
		dim as single f = c_floorf( x )
		if( ( x - f ) >= 0.5f ) then return f + 1.0f
		return f
	end if
	dim as single c = c_ceilf( x )
	if( ( c - x ) >= 0.5f ) then return c - 1.0f
	function = c
end function

private function RoundHalfEven overload ( byval x as double ) as double
	if( IsFinite( x ) = false ) then return x
	dim as double f = c_floor( x )
	dim as double d = x - f
	if( d > 0.5 ) then return f + 1.0
	if( d < 0.5 ) then return f
	'' exact tie -- take whichever neighbour is even
	if( c_fmod( f, 2.0 ) = 0.0 ) then return f
	function = f + 1.0
end function

private function RoundHalfEven overload ( byval x as single ) as single
	if( IsFinite( x ) = false ) then return x
	dim as single f = c_floorf( x )
	dim as single d = x - f
	if( d > 0.5f ) then return f + 1.0f
	if( d < 0.5f ) then return f
	if( c_fmodf( f, 2.0f ) = 0.0f ) then return f
	function = f + 1.0f
end function

'' Round( x, digits ) is NOT 'Round( x * 10^digits ) / 10^digits' computed with
'' '^'.  That loses precision twice and routes an integer power through pow().
'' The scale comes from a table of EXACTLY representable powers of ten -- every
'' power up to 10^22 is exact as a double -- and the tie decision is made on the
'' scaled value.
''
'' Outside 0..17 the result is NaN.  There is no meaningful answer, and
'' returning the input unchanged would hide the mistake.

private function hPow10( byval d as long ) as double
	static as double tbl( 0 to 17 ) = { _
		1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, _
		1e9, 1e10, 1e11, 1e12, 1e13, 1e14, 1e15, 1e16, 1e17 }
	function = tbl( d )
end function

private function Round overload ( byval x as double, byval digits as long ) as double
	dim as boolean lo = digits < 0
	dim as boolean hi = digits > 17
	if( lo orelse hi ) then return NaN( )
	if( IsFinite( x ) = false ) then return x
	dim as double s = hPow10( digits )
	dim as double y = x * s
	'' already integral at this scale, or scaled out of range -- nothing to do
	if( IsFinite( y ) = false ) then return x
	if( abs( y ) >= 4503599627370496.0 ) then return x
	function = Round( y ) / s
end function

private function RoundHalfEven overload ( byval x as double, byval digits as long ) as double
	dim as boolean lo = digits < 0
	dim as boolean hi = digits > 17
	if( lo orelse hi ) then return NaN( )
	if( IsFinite( x ) = false ) then return x
	dim as double s = hPow10( digits )
	dim as double y = x * s
	if( IsFinite( y ) = false ) then return x
	if( abs( y ) >= 4503599627370496.0 ) then return x
	function = RoundHalfEven( y ) / s
end function

'' ---------------------------------------------------------------------------
'' The libm surface under FreeBASIC names.
''
'' BOUNDED, not exact (RFC-0008 s3).  Accuracy is the platform's; results are
'' not guaranteed identical across win64, win32 and linux-x86_64.
'' ---------------------------------------------------------------------------

#macro __FB_MATH_UNARY( fbname, dfn, ffn )
	private function fbname overload ( byval x as double ) as double
		function = dfn( x )
	end function
	private function fbname overload ( byval x as single ) as single
		function = ffn( x )
	end function
#endmacro

#macro __FB_MATH_BINARY( fbname, dfn, ffn )
	private function fbname overload ( byval x as double, byval y as double ) as double
		function = dfn( x, y )
	end function
	private function fbname overload ( byval x as single, byval y as single ) as single
		function = ffn( x, y )
	end function
#endmacro

__FB_MATH_UNARY( Cbrt,  c_cbrt,  c_cbrtf  )
__FB_MATH_UNARY( Exp2,  c_exp2,  c_exp2f  )
__FB_MATH_UNARY( Expm1, c_expm1, c_expm1f )
__FB_MATH_UNARY( Log2,  c_log2,  c_log2f  )
__FB_MATH_UNARY( Log10, c_log10, c_log10f )
__FB_MATH_UNARY( Log1p, c_log1p, c_log1pf )
__FB_MATH_UNARY( LogB,  c_logb,  c_logbf  )
__FB_MATH_UNARY( Sinh,  c_sinh,  c_sinhf  )
__FB_MATH_UNARY( Cosh,  c_cosh,  c_coshf  )
__FB_MATH_UNARY( Tanh,  c_tanh,  c_tanhf  )
__FB_MATH_UNARY( Asinh, c_asinh, c_asinhf )
__FB_MATH_UNARY( Acosh, c_acosh, c_acoshf )
__FB_MATH_UNARY( Atanh, c_atanh, c_atanhf )

'' Hypot delegates to libm's hypot, which is required not to overflow for a
'' representable result.  'Sqr( x*x + y*y )' overflows at around 1.3e154 for a
'' double, and that is why the hand-rolled version in FB code is wrong at the
'' extremes.
__FB_MATH_BINARY( Hypot,    c_hypot,    c_hypotf    )
__FB_MATH_BINARY( CopySign, c_copysign, c_copysignf )
__FB_MATH_BINARY( NextAfter, c_nextafter, c_nextafterf )

'' Pow is NOT a replacement for '^'.  It is the double-to-double operation under
'' a name, for callers who want an explicit float power.  Integer exponentiation
'' is IPow in RFC-0002; '^' is untouched.
__FB_MATH_BINARY( Pow, c_pow, c_powf )

private function Fma overload ( byval x as double, byval y as double, byval z as double ) as double
	function = c_fma( x, y, z )
end function

private function Fma overload ( byval x as single, byval y as single, byval z as single ) as single
	function = c_fmaf( x, y, z )
end function

private function ScaleB overload ( byval x as double, byval n as long ) as double
	function = c_scalbn( x, n )
end function

private function ScaleB overload ( byval x as single, byval n as long ) as single
	function = c_scalbnf( x, n )
end function

private function Frexp overload ( byval x as double, byref expo as long ) as double
	dim as long ee
	dim as double r = c_frexp( x, @ee )
	expo = ee
	function = r
end function

private function Modf overload ( byval x as double, byref ipart as double ) as double
	dim as double ip
	dim as double r = c_modf( x, @ip )
	ipart = ip
	function = r
end function

'' Ulp( x ) is the distance to the next representable value AWAY FROM ZERO.  It
'' has no libm equivalent and exists because RFC-0008's accuracy claims are
'' stated in ulps and a caller has to be able to check them.

private function Ulp overload ( byval x as double ) as double
	if( IsFinite( x ) = false ) then return NaN( )
	if( x >= 0.0 ) then return c_nextafter( x, Infinity( ) ) - x
	function = x - c_nextafter( x, NegInfinity( ) )
end function

private function Ulp overload ( byval x as single ) as single
	if( IsFinite( x ) = false ) then return NaNF( )
	if( x >= 0.0f ) then return c_nextafterf( x, InfinityF( ) ) - x
	function = x - c_nextafterf( x, NegInfinityF( ) )
end function

'' ---------------------------------------------------------------------------
'' Angles
'' ---------------------------------------------------------------------------

private function DegToRad overload ( byval x as double ) as double
	function = x * DEG2RAD
end function

private function DegToRad overload ( byval x as single ) as single
	function = x * cast( single, DEG2RAD )
end function

private function RadToDeg overload ( byval x as double ) as double
	function = x * RAD2DEG
end function

private function RadToDeg overload ( byval x as single ) as single
	function = x * cast( single, RAD2DEG )
end function

end namespace
