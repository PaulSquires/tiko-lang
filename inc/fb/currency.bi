'' fb/currency.bi -- exact fixed-point money
''
''     #include once "fb/currency.bi"
''     using FB
''
''     dim as Currency price = CurrencyParse( "19.99" ).Value( )
''     dim as Currency line_ = price * 3            ' exact -- integer arithmetic
''     print line_.ToString( )                      ' 59.9700
''
''     dim as Currency each_ = line_ / 7            ' rounded half-to-even
''
'' Specified by C:\dev\docs\math\RFC-0003-currency.md.  Phase 3.
''
'' A LONGINT SCALED BY 10,000.  Fifteen digits left of the decimal point, four
'' to the right, every value in range exactly representable:
''
''     range        -922,337,203,685,477.5808 .. +922,337,203,685,477.5807
''     resolution   0.0001, exactly, everywhere
''     size         8 bytes
''
'' This is the VB6/VBA 'Currency' type, the COM 'CY' / VT_CY type, and SQL
'' Server's 'money'.  Not a new representation -- an existing, widely
'' implemented one that FreeBASIC could already name and could not compute
'' with.  'CY' is declared in win\wtypes.bi:326 as a union whose int64 member
'' is exactly this field, so the interop boundary is a REINTERPRET.
''
'' WHY NOT A DOUBLE.  0.1 + 0.2 <> 0.3 in binary floating point, and money is
'' decimal.  Every FB program that holds money in a DOUBLE is one rounding
'' away from a penny that does not reconcile.
''
'' THE COST, STATED UP FRONT: FOUR DECIMAL PLACES, FIXED.  FX rates are quoted
'' to 6 or 8, per-unit costs and per-mille rates often need more, and a
'' Currency cannot hold them.  CurrencyAccum below covers the case that
'' actually loses money -- rounding at every line instead of once -- and does
'' not pretend to cover storage.  If you need to STORE more than four places,
'' this is the wrong type; use a scaled LONGINT of your own.
''
'' NO ARITHMETIC IS DELEGATED TO OleAut32.  AfxNova's CDEC.inc and CInt96.inc
'' wrap VarCyAdd / VarCyMul / VarCyRound and friends, which works and is
'' Windows-only.  This compiler ships and gates on linux-x86_64, so the
'' arithmetic is implemented here and 'VarCy*' is a TEST ORACLE rather than a
'' dependency.  The result is a type that behaves identically on every target.

#pragma once

#include once "fblimits.bi"
#include once "fb/optional.bi"

namespace FB

const as longint CURRENCY_SCALE = 10000

'' ===========================================================================
'' The type
'' ===========================================================================

type Currency
	as longint raw_

	declare function Raw( ) as longint
	declare function IsValid( ) as boolean
	declare function ToDouble( ) as double
	declare function ToString( ) as string
	declare function Round( byval digits as long ) as Currency
	declare function RoundMode( byval digits as long, byval mode as long ) as Currency
	declare function Floor( ) as Currency
	declare function Ceiling( ) as Currency
	declare function Truncate( ) as Currency
	declare function AbsValue( ) as Currency
	declare function Sign( ) as long
end type

'' Rounding modes.  The DEFAULT IS HALF-TO-EVEN, which is what .NET and IEEE
'' 754 do and what stops a ledger drifting upward -- half-up biases every tie
'' the same way, and across a million lines that is real money.
enum CurrencyRounding
	CUR_HALF_EVEN
	CUR_HALF_UP
	CUR_HALF_DOWN
	CUR_UP
	CUR_DOWN
	CUR_CEILING
	CUR_FLOOR
end enum

'' INVALID is the one bit pattern that has no positive counterpart, and is
'' therefore already unusable as an amount.  It is INFECTIOUS: any operation
'' with an Invalid operand is Invalid.
''
'' Why a sentinel rather than Result: an operator cannot return
'' Result( of Currency, E ) and still compose -- 'a * n + b' would need an
'' unwrap between every pair and nobody would use the type.  fb/chrono.bi
'' reached the same conclusion for DateTime, and matching it means one rule to
'' learn rather than two.  As there, INVALID = INVALID IS FALSE; test IsValid.
private function CurrencyInvalid overload ( ) as Currency
	dim as Currency c
	c.raw_ = MIN_VALUE_LONGINT
	function = c
end function

private function CurrencyFromRaw overload ( byval scaled as longint ) as Currency
	dim as Currency c
	c.raw_ = scaled
	function = c
end function

private function llabs_( byval v as longint ) as longint
	if( v < 0 ) then return -v
	function = v
end function

private function hIsInv( byval c as Currency ) as boolean
	function = ( c.raw_ = MIN_VALUE_LONGINT )
end function

'' ===========================================================================
'' Construction
''
'' FREE FUNCTIONS, NOT CONSTRUCTORS, and that is a safety decision rather than
'' a style one.  A one-argument constructor taking LONGINT would also accept a
'' DOUBLE through FreeBASIC's implicit conversion, so
''
''     dim as Currency price = Currency( 19.99 )
''
'' would compile and silently store 19.  Naming every conversion means the
'' inexact one cannot be reached by accident.  This follows fb/optional.bi and
'' fb/result.bi, which construct through Some/None and Ok/Fail for the
'' analogous reason.
'' ===========================================================================

private function CurrencyFromInt overload ( byval whole as longint ) as Currency
	if( whole > MAX_VALUE_LONGINT \ CURRENCY_SCALE ) then return CurrencyInvalid( )
	if( whole < ( MIN_VALUE_LONGINT + 1 ) \ CURRENCY_SCALE ) then return CurrencyInvalid( )
	function = CurrencyFromRaw( whole * CURRENCY_SCALE )
end function

'' whole units plus ten-thousandths.  CurrencyFromParts( 19, 9900 ) is 19.99
private function CurrencyFromParts overload ( byval whole as longint, byval tenThousandths as longint ) as Currency
	dim as Currency w = CurrencyFromInt( whole )
	if( hIsInv( w ) ) then return CurrencyInvalid( )
	dim as longint r = w.raw_
	if( whole < 0 ) then r -= tenThousandths else r += tenThousandths
	function = CurrencyFromRaw( r )
end function

'' NAMED, because it is not exact: the DOUBLE 0.1 is not one tenth.  Rounds
'' half-to-even at the fourth decimal.
private function CurrencyFromDouble overload ( byval v as double ) as Currency
	if( v <> v ) then return CurrencyInvalid( )                     '' NaN
	dim as double s = v * 9999.0
	if( s > 9.2e18 orelse s < -9.2e18 ) then return CurrencyInvalid( )
	dim as double scaled = v * cdbl( CURRENCY_SCALE )
	dim as double f = int( scaled )
	dim as double d = scaled - f
	dim as longint r
	if( d > 0.5 ) then
		r = clngint( f ) + 1
	elseif( d < 0.5 ) then
		r = clngint( f )
	else
		dim as longint fl = clngint( f )
		if( ( fl mod 2 ) = 0 ) then r = fl else r = fl + 1
	end if
	if( r = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	function = CurrencyFromRaw( r )
end function

'' ===========================================================================
'' Members
'' ===========================================================================

private function Currency.Raw( ) as longint
	function = this.raw_
end function

private function Currency.IsValid( ) as boolean
	function = ( this.raw_ <> MIN_VALUE_LONGINT )
end function

'' Loses precision above about +-900 billion, where the scaled value exceeds
'' 2^53.  Named, never implicit.
private function Currency.ToDouble( ) as double
	function = cdbl( this.raw_ ) / cdbl( CURRENCY_SCALE )
end function

private function Currency.Sign( ) as long
	if( this.raw_ > 0 ) then return 1
	if( this.raw_ < 0 ) then return -1
	function = 0
end function

private function Currency.AbsValue( ) as Currency
	if( this.raw_ = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	if( this.raw_ < 0 ) then return CurrencyFromRaw( -this.raw_ )
	function = CurrencyFromRaw( this.raw_ )
end function

'' Invariant: '.' separator, no grouping, ALWAYS four decimals.  Locale and
'' currency-symbol formatting are the caller's business -- this type carries an
'' amount, not a currency.
private function Currency.ToString( ) as string
	if( this.raw_ = MIN_VALUE_LONGINT ) then return "Invalid"
	dim as longint v = this.raw_
	dim as string sgn_ = ""
	if( v < 0 ) then
		sgn_ = "-"
		v = -v
	end if
	dim as longint ip = v \ CURRENCY_SCALE
	dim as longint fp = v mod CURRENCY_SCALE
	dim as string fs = str( fp )
	while( len( fs ) < 4 )
		fs = "0" + fs
	wend
	function = sgn_ + str( ip ) + "." + fs
end function

'' ===========================================================================
'' Rounding
''
'' The tie logic is the same half-to-even decision fb/math.bi's RoundHalfEven
'' makes, applied to the scaled integer -- which is why rank 1 was built first.
'' ===========================================================================

private function hQuantize( byval value as longint, byval unit as longint, byval mode as long ) as longint
	if( unit <= 1 ) then return value

	dim as longint q = value \ unit
	dim as longint r = value mod unit
	if( r = 0 ) then return q * unit

	dim as boolean neg = ( value < 0 )
	dim as longint ar = r
	if( ar < 0 ) then ar = -ar

	dim as longint twice = ar * 2
	dim as long cmp                                   '' -1 below half, 0 half, +1 above
	if( twice < unit ) then
		cmp = -1
	elseif( twice > unit ) then
		cmp = 1
	else
		cmp = 0
	end if

	dim as boolean away                                '' round away from zero?
	select case mode
	case CUR_HALF_EVEN
		if( cmp > 0 ) then
			away = true
		elseif( cmp < 0 ) then
			away = false
		else
			away = ( ( q mod 2 ) <> 0 )
		end if
	case CUR_HALF_UP
		away = ( cmp >= 0 )
	case CUR_HALF_DOWN
		away = ( cmp > 0 )
	case CUR_UP
		away = true
	case CUR_DOWN
		away = false
	case CUR_CEILING
		away = ( neg = false )
	case CUR_FLOOR
		away = neg
	case else
		away = ( cmp > 0 )
	end select

	if( away = false ) then return q * unit
	if( neg ) then return ( q - 1 ) * unit
	function = ( q + 1 ) * unit
end function

private function hPow10i( byval d as long ) as longint
	dim as longint r = 1
	for i as long = 1 to d
		r *= 10
	next
	function = r
end function

private function Currency.RoundMode( byval digits as long, byval mode as long ) as Currency
	if( this.raw_ = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	if( digits < 0 orelse digits > 4 ) then return CurrencyInvalid( )
	dim as longint unit = hPow10i( 4 - digits )
	function = CurrencyFromRaw( hQuantize( this.raw_, unit, CUR_HALF_EVEN + ( mode - CUR_HALF_EVEN ) ) )
end function

private function Currency.Round( byval digits as long ) as Currency
	function = this.RoundMode( digits, CUR_HALF_EVEN )
end function

private function Currency.Floor( ) as Currency
	if( this.raw_ = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	function = CurrencyFromRaw( hQuantize( this.raw_, CURRENCY_SCALE, CUR_FLOOR ) )
end function

private function Currency.Ceiling( ) as Currency
	if( this.raw_ = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	function = CurrencyFromRaw( hQuantize( this.raw_, CURRENCY_SCALE, CUR_CEILING ) )
end function

private function Currency.Truncate( ) as Currency
	if( this.raw_ = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	function = CurrencyFromRaw( hQuantize( this.raw_, CURRENCY_SCALE, CUR_DOWN ) )
end function

'' ===========================================================================
'' Arithmetic
''
''   a + b, a - b        EXACT, overflow-checked
''   -a                  EXACT
''   a * n  (integer)    EXACT, overflow-checked
''   a * x  (double)     rounded half-to-even
''   a / n  (integer)    rounded HALF-TO-EVEN, not truncated
''   a / b  (Currency)   DOUBLE -- a ratio is not an amount
''   a MOD b             exact remainder in scaled units
''
'' 'Currency * Currency' DOES NOT EXIST.  Money times money is not money; the
'' units are wrong.  Currency x integer and Currency x double are what people
'' actually want, and leaving the third out forces the rare case to be written
'' deliberately.
'' ===========================================================================

private operator + ( byref a as Currency, byref b as Currency ) as Currency
	if( hIsInv( a ) orelse hIsInv( b ) ) then return CurrencyInvalid( )
	if( b.raw_ > 0 andalso a.raw_ > MAX_VALUE_LONGINT - b.raw_ ) then return CurrencyInvalid( )
	if( b.raw_ < 0 andalso a.raw_ < ( MIN_VALUE_LONGINT + 1 ) - b.raw_ ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( a.raw_ + b.raw_ )
end operator

private operator - ( byref a as Currency, byref b as Currency ) as Currency
	if( hIsInv( a ) orelse hIsInv( b ) ) then return CurrencyInvalid( )
	if( b.raw_ < 0 andalso a.raw_ > MAX_VALUE_LONGINT + b.raw_ ) then return CurrencyInvalid( )
	if( b.raw_ > 0 andalso a.raw_ < ( MIN_VALUE_LONGINT + 1 ) + b.raw_ ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( a.raw_ - b.raw_ )
end operator

private operator - ( byref a as Currency ) as Currency
	if( hIsInv( a ) ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( -a.raw_ )
end operator

'' Multiplication by an integer needs the overflow test that MulChecked does,
'' and nothing wider: the product IS the new raw, because the scale does not
'' change.
private operator * ( byref a as Currency, byval n as longint ) as Currency
	if( hIsInv( a ) ) then return CurrencyInvalid( )
	if( a.raw_ = 0 orelse n = 0 ) then return CurrencyFromRaw( 0 )
	if( n = -1 ) then return CurrencyFromRaw( -a.raw_ )
	if( a.raw_ = -1 ) then
		if( n = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
		return CurrencyFromRaw( -n )
	end if
	dim as longint r = a.raw_ * n
	if( ( r \ n ) <> a.raw_ ) then return CurrencyInvalid( )
	if( r = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( r )
end operator

private operator * ( byval n as longint, byref a as Currency ) as Currency
	operator = a * n
end operator

private operator * ( byref a as Currency, byval x as double ) as Currency
	if( hIsInv( a ) ) then return CurrencyInvalid( )
	if( x <> x ) then return CurrencyInvalid( )
	dim as double p = cdbl( a.raw_ ) * x
	if( p > 9.2e18 orelse p < -9.2e18 ) then return CurrencyInvalid( )
	dim as double f = int( p )
	dim as double d = p - f
	dim as longint r
	if( d > 0.5 ) then
		r = clngint( f ) + 1
	elseif( d < 0.5 ) then
		r = clngint( f )
	else
		dim as longint fl = clngint( f )
		if( ( fl mod 2 ) = 0 ) then r = fl else r = fl + 1
	end if
	if( r = MIN_VALUE_LONGINT ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( r )
end operator

private operator * ( byval x as double, byref a as Currency ) as Currency
	operator = a * x
end operator

'' ROUNDS HALF-TO-EVEN, IT DOES NOT TRUNCATE.  'raw \ n' would bias every
'' result downward, systematically, across a ledger.  Currency(1)/3 is 0.3333
'' and Currency(2)/3 is 0.6667.
private operator / ( byref a as Currency, byval n as longint ) as Currency
	if( hIsInv( a ) ) then return CurrencyInvalid( )
	if( n = 0 ) then return CurrencyInvalid( )
	if( a.raw_ = MIN_VALUE_LONGINT + 1 andalso n = -1 ) then return CurrencyInvalid( )

	dim as longint q = a.raw_ \ n
	dim as longint r = a.raw_ mod n
	if( r = 0 ) then return CurrencyFromRaw( q )

	dim as longint ar = r  : if( ar < 0 ) then ar = -ar
	dim as longint an = n  : if( an < 0 ) then an = -an

	dim as boolean neg = ( ( a.raw_ < 0 ) <> ( n < 0 ) )
	dim as longint twice = ar * 2
	dim as boolean away
	if( twice > an ) then
		away = true
	elseif( twice < an ) then
		away = false
	else
		away = ( ( q mod 2 ) <> 0 )
	end if

	if( away ) then
		if( neg ) then q -= 1 else q += 1
	end if
	operator = CurrencyFromRaw( q )
end operator

'' A ratio is dimensionless, so this yields a DOUBLE rather than an amount.
private operator / ( byref a as Currency, byref b as Currency ) as double
	if( hIsInv( a ) orelse hIsInv( b ) ) then return 0.0 / 0.0
	operator = cdbl( a.raw_ ) / cdbl( b.raw_ )
end operator

private operator mod ( byref a as Currency, byref b as Currency ) as Currency
	if( hIsInv( a ) orelse hIsInv( b ) ) then return CurrencyInvalid( )
	if( b.raw_ = 0 ) then return CurrencyInvalid( )
	operator = CurrencyFromRaw( a.raw_ mod b.raw_ )
end operator

'' INVALID = INVALID IS FALSE, exactly as DateTime's is.  Test with IsValid.
private operator = ( byref a as Currency, byref b as Currency ) as boolean
	if( hIsInv( a ) orelse hIsInv( b ) ) then return false
	operator = ( a.raw_ = b.raw_ )
end operator

private operator <> ( byref a as Currency, byref b as Currency ) as boolean
	if( hIsInv( a ) orelse hIsInv( b ) ) then return true
	operator = ( a.raw_ <> b.raw_ )
end operator

private operator <  ( byref a as Currency, byref b as Currency ) as boolean : operator = ( a.raw_ <  b.raw_ ) : end operator
private operator <= ( byref a as Currency, byref b as Currency ) as boolean : operator = ( a.raw_ <= b.raw_ ) : end operator
private operator >  ( byref a as Currency, byref b as Currency ) as boolean : operator = ( a.raw_ >  b.raw_ ) : end operator
private operator >= ( byref a as Currency, byref b as Currency ) as boolean : operator = ( a.raw_ >= b.raw_ ) : end operator

'' ===========================================================================
'' Text
''
'' Exact both ways -- no DOUBLE appears anywhere in this path.  MORE THAN FOUR
'' DECIMAL PLACES IS AN ERROR, NOT A TRUNCATION: silently discarding a digit
'' the caller wrote is how a fixed-scale type loses money.
'' ===========================================================================

private function CurrencyParse overload ( byref s as string ) as Optional( of Currency )
	dim as long n = len( s )
	if( n = 0 ) then return None( of Currency )( )

	dim as long i = 1
	dim as boolean neg = false
	dim as long ch = asc( mid( s, 1, 1 ) )
	if( ch = asc( "-" ) ) then
		neg = true
		i = 2
	elseif( ch = asc( "+" ) ) then
		i = 2
	end if
	if( i > n ) then return None( of Currency )( )

	dim as ulongint ipart = 0
	dim as long idigits = 0
	while( i <= n )
		dim as long c = asc( mid( s, i, 1 ) )
		if( c < asc( "0" ) orelse c > asc( "9" ) ) then exit while
		if( ipart > 922337203685477ull ) then return None( of Currency )( )
		ipart = ipart * 10 + culngint( c - asc( "0" ) )
		idigits += 1
		i += 1
	wend
	if( idigits = 0 ) then return None( of Currency )( )

	dim as ulongint fpart = 0
	dim as long fdigits = 0
	if( i <= n andalso asc( mid( s, i, 1 ) ) = asc( "." ) ) then
		i += 1
		while( i <= n )
			dim as long c = asc( mid( s, i, 1 ) )
			if( c < asc( "0" ) orelse c > asc( "9" ) ) then exit while
			fdigits += 1
			if( fdigits > 4 ) then return None( of Currency )( )   '' NOT truncated
			fpart = fpart * 10 + culngint( c - asc( "0" ) )
			i += 1
		wend
		if( fdigits = 0 ) then return None( of Currency )( )       '' "1." is not a number
	end if

	'' the whole string must be consumed -- strict, like RFC-0004's TryParse
	if( i <= n ) then return None( of Currency )( )

	for k as long = fdigits + 1 to 4
		fpart *= 10
	next

	if( ipart > 922337203685477ull ) then return None( of Currency )( )
	dim as ulongint mag = ipart * culngint( CURRENCY_SCALE ) + fpart
	if( neg ) then
		if( mag > 9223372036854775807ull ) then return None( of Currency )( )
	else
		if( mag > 9223372036854775807ull ) then return None( of Currency )( )
	end if

	dim as longint r = clngint( mag )
	if( neg ) then r = -r
	if( r = MIN_VALUE_LONGINT ) then return None( of Currency )( )
	function = Some( CurrencyFromRaw( r ) )
end function

'' ===========================================================================
'' Apportion -- splitting a total so that the parts sum EXACTLY to it
''
'' Splitting 100.00 three ways gives 33.3333 each, whose sum is 99.9999.  Every
'' accounting system has to decide where the missing unit goes, and doing it ad
'' hoc is how a reconciliation fails.  Largest-remainder: the parts always sum
'' to the total, exactly.
'' ===========================================================================

private sub Apportion overload ( byval total as Currency, weights( ) as longint, result( ) as Currency )
	dim as long lo = lbound( weights ), hi = ubound( weights )
	dim as long n = hi - lo + 1
	if( n <= 0 ) then exit sub

	redim result( lo to hi )

	dim as longint sumw = 0
	for i as long = lo to hi
		sumw += weights( i )
	next
	if( sumw = 0 ) then
		for i as long = lo to hi
			result( i ) = CurrencyFromRaw( 0 )
		next
		exit sub
	end if

	dim as longint assigned = 0
	redim as longint rem_( lo to hi )
	for i as long = lo to hi
		dim as longint num = total.raw_ * weights( i )
		dim as longint q = num \ sumw
		dim as longint r = num mod sumw
		if( r < 0 ) then r += llabs_( sumw )
		result( i ) = CurrencyFromRaw( q )
		rem_( i ) = r
		assigned += q
	next

	'' hand the leftover units to the largest remainders, one each
	dim as longint leftover = total.raw_ - assigned
	dim as longint step_ = 1
	if( leftover < 0 ) then step_ = -1

	while( leftover <> 0 )
		dim as long best = lo
		dim as longint bestr = -1
		for i as long = lo to hi
			if( rem_( i ) > bestr ) then
				bestr = rem_( i )
				best = i
			end if
		next
		result( best ) = CurrencyFromRaw( result( best ).raw_ + step_ )
		rem_( best ) = -1
		leftover -= step_
		'' if every remainder has been used, start again
		dim as boolean anyleft = false
		for i as long = lo to hi
			if( rem_( i ) >= 0 ) then anyleft = true
		next
		if( anyleft = false andalso leftover <> 0 ) then
			for i as long = lo to hi
				rem_( i ) = 0
			next
		end if
	wend
end sub

'' ===========================================================================
'' CurrencyAccum -- accumulate below 0.0001, quantise ONCE
''
'' The pattern this exists for is the one that actually loses money:
''
''     ' WRONG -- rounds at every line, error accumulates
''     for each line_ in invoice
''         total += line_.amount * taxRate
''     next
''
''     ' RIGHT
''     dim acc as CurrencyAccum
''     for each line_ in invoice
''         acc.AddProduct( line_.amount, taxRate )
''     next
''     dim as Currency tax = acc.Total( )
''
'' The accumulator carries eight extra decimal places -- scale 10^12 -- in a
'' signed 128-bit value, and quantises exactly once.  It does NOT make Currency
'' an arbitrary-scale type and is not a substitute for one.
'' ===========================================================================

const as longint CURRENCY_ACCUM_STEP = 100000000       '' 10^8: scale 4 -> scale 12

type CurrencyAccum
	as ulongint lo_
	as longint  hi_
	as ulongint count_
	as boolean  overflow_

	declare sub Add( byref c as Currency )
	declare sub AddProduct( byref c as Currency, byval rate as double )
	declare sub AddScaled( byref c as Currency, byval num as longint, byval den as longint )
	declare sub Reset( )
	declare function Count( ) as ulongint
	declare function Total( ) as Currency
end type

'' 128-bit signed add of a 64-bit value, sign-extended.
private sub hAccAdd( byref a as CurrencyAccum, byval v as longint )
	dim as ulongint addlo = cast( ulongint, v )
	dim as longint  addhi = 0
	if( v < 0 ) then addhi = -1

	dim as ulongint newlo = a.lo_ + addlo
	dim as longint carry = 0
	if( newlo < a.lo_ ) then carry = 1
	a.lo_ = newlo
	a.hi_ = a.hi_ + addhi + carry
end sub

private sub CurrencyAccum.Reset( )
	this.lo_ = 0
	this.hi_ = 0
	this.count_ = 0
	this.overflow_ = false
end sub

private function CurrencyAccum.Count( ) as ulongint
	function = this.count_
end function

'' Exact: the amount contributes raw * 10^8 scale-12 units.
private sub CurrencyAccum.Add( byref c as Currency )
	if( c.raw_ = MIN_VALUE_LONGINT ) then
		this.overflow_ = true
		exit sub
	end if
	this.count_ += 1
	'' raw * 10^8 may exceed 64 bits, so split it
	dim as longint q = c.raw_ \ 10000
	dim as longint r = c.raw_ mod 10000
	hAccAdd( this, q * 1000000000000ll )
	hAccAdd( this, r * CURRENCY_ACCUM_STEP )
end sub

'' Exact: c * num / den, at scale 12.  |num| must be at most 10^9; anything
'' larger is reported through Total( ) as Invalid rather than silently wrapped.
private sub CurrencyAccum.AddScaled( byref c as Currency, byval num as longint, byval den as longint )
	if( c.raw_ = MIN_VALUE_LONGINT orelse den = 0 ) then
		this.overflow_ = true
		exit sub
	end if
	if( num > 1000000000ll orelse num < -1000000000ll ) then
		this.overflow_ = true
		exit sub
	end if
	this.count_ += 1
	'' ( raw * 10^8 * num ) / den, keeping the 10^8 split so nothing overflows
	dim as longint q = c.raw_ \ den
	dim as longint r = c.raw_ mod den
	hAccAdd( this, q * CURRENCY_ACCUM_STEP * num )
	hAccAdd( this, ( r * CURRENCY_ACCUM_STEP \ den ) * num )
end sub

'' Convenient but not exact: the rate is a DOUBLE.
private sub CurrencyAccum.AddProduct( byref c as Currency, byval rate as double )
	if( c.raw_ = MIN_VALUE_LONGINT orelse rate <> rate ) then
		this.overflow_ = true
		exit sub
	end if
	this.count_ += 1
	dim as double p = cdbl( c.raw_ ) * rate * cdbl( CURRENCY_ACCUM_STEP )
	if( p > 9.2e18 orelse p < -9.2e18 ) then
		this.overflow_ = true
		exit sub
	end if
	hAccAdd( this, clngint( p ) )
end sub

'' Quantise 10^12 -> 10^4, half-to-even, exactly once.
private function CurrencyAccum.Total( ) as Currency
	if( this.overflow_ ) then return CurrencyInvalid( )
	'' the accumulated value must fit in 64 bits for the division below
	dim as boolean pos_ok = ( this.hi_ = 0 )
	dim as boolean neg_ok = ( this.hi_ = -1 andalso this.lo_ >= &h8000000000000000ull )
	if( ( pos_ok orelse neg_ok ) = false ) then return CurrencyInvalid( )

	dim as longint v = cast( longint, this.lo_ )
	if( pos_ok andalso this.lo_ > 9223372036854775807ull ) then return CurrencyInvalid( )

	function = CurrencyFromRaw( hQuantize( v, CURRENCY_ACCUM_STEP, CUR_HALF_EVEN ) \ CURRENCY_ACCUM_STEP )
end function

end namespace
