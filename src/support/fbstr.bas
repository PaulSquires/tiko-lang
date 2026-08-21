'' fbstr.bas -- see fbstr.bi

#include once "support/fbstr.bi"

namespace Fbx.Text

'' ------------------------------------------------------------------- big decimal
''
'' A binary float is an integer times a power of two, so its decimal expansion
'' TERMINATES and can be written out in full:
''
''     m * 2^e  with e >= 0   is   (m * 2^e) * 10^0
''     m * 2^e  with e <  0   is   (m * 5^-e) * 10^e
''
'' Both right-hand sides are an integer scaled by a power of ten, so generating the
'' digits is one big-integer multiply and no division, no floating point, and no
'' approximation anywhere. That is what makes the rounding provably fbc's rather than
'' the host libc's -- and it is why an exact TIE is a thing this code can see.
''
'' Worst case is a subnormal double: m < 2^52 times 5^1074, which is 767 digits. 5^1074
'' alone is 751. LIMBS is sized for that with room to spare; overflowing it silently
'' would produce a plausible wrong number rather than a failure, so DecMul asserts.

const DEC_BASE   as ulongint = 1000000000    '' 10^9 per limb
const DEC_DIGITS as long = 9
const DEC_LIMBS  as long = 96                '' 864 digits

type DecBuf
    as ulong d(0 to DEC_LIMBS - 1)      '' little-endian, base 10^9
    as long  n                          '' limbs in use, always >= 1
end type

private sub DecFromU64( byref b as DecBuf, byval v as ulongint )
    b.n = 0
    do
        b.d(b.n) = cast(ulong, v mod DEC_BASE)
        v \= DEC_BASE
        b.n += 1
    loop while v > 0
end sub

'' Multiply in place by a small factor. The caller keeps k under 2^30 so that a limb
'' (< 10^9) times k stays inside an unsigned 64-bit product with the carry.
private sub DecMul( byref b as DecBuf, byval k as ulongint )
    dim as ulongint carry = 0
    for i as long = 0 to b.n - 1
        dim as ulongint t = b.d(i) * k + carry
        b.d(i) = cast(ulong, t mod DEC_BASE)
        carry = t \ DEC_BASE
    next
    while carry > 0
        if b.n >= DEC_LIMBS then
            '' Unreachable for any IEEE double; if it ever fires, the sizing argument
            '' above is wrong and the alternative is a silently truncated number.
            print "fbx: internal error: decimal buffer overflow in StrOf*"
            end 4
        end if
        b.d(b.n) = cast(ulong, carry mod DEC_BASE)
        carry \= DEC_BASE
        b.n += 1
    wend
end sub

'' Every significant digit, most significant first, with no leading zero.
private function DecToString( byref b as DecBuf ) as string
    dim as string s = str( b.d(b.n - 1) )
    for i as long = b.n - 2 to 0 step -1
        dim as string limb = str( b.d(i) )
        s += string( DEC_DIGITS - len( limb ), asc("0") ) + limb
    next
    return s
end function

'' Multiply b by base^power, in chunks small enough for DecMul. Splitting the exponent
'' rather than multiplying one factor at a time is the difference between ~90 passes
'' over the buffer and ~1074 of them.
private sub DecScale _
    ( byref b as DecBuf, byval fbase as ulongint, byval power as long )

    if power <= 0 then exit sub

    '' Largest chunk exponent whose factor still fits under 2^30.
    dim as long chunk = 0
    dim as ulongint factor = 1
    do
        dim as ulongint nxt = factor * fbase
        if nxt >= 1073741824ull then exit do
        factor = nxt
        chunk += 1
    loop

    dim as long remain = power
    while remain >= chunk
        DecMul( b, factor )
        remain -= chunk
    wend
    dim as ulongint tail = 1
    for i as long = 1 to remain
        tail *= fbase
    next
    if tail > 1 then DecMul( b, tail )
end sub

'' ---------------------------------------------------------------------- rounding

'' Round the exact digit string to prec significant digits, ROUND HALF TO EVEN, and
'' report a carry out of the leading digit by bumping dexp. Half-to-even is measured,
'' not assumed: 3*2^-23 renders 3.576278686523438e-07 (tie, odd digit before it, rounds
'' up) and 1*2^-23 renders 1.192092895507812e-07 (tie, even digit, stays).
private function RoundDigits _
    ( byval ds as string, byval prec as long, byref dexp as long ) as string

    if len( ds ) <= prec then return ds

    dim as string keep = left( ds, prec )
    dim as long first = asc( ds, prec + 1 ) - asc("0")

    dim as boolean roundUp = (first > 5)
    if first = 5 then
        dim as boolean beyond = false
        for i as long = prec + 2 to len( ds )
            if asc( ds, i ) <> asc("0") then
                beyond = true
                exit for
            end if
        next
        dim as boolean lastIsOdd = ((asc( keep, prec ) - asc("0")) mod 2) = 1
        roundUp = beyond orelse lastIsOdd
    end if
    if roundUp = false then return keep

    dim as long i = prec
    while i >= 1
        dim as long dv = asc( keep, i ) - asc("0") + 1
        if dv < 10 then
            mid( keep, i, 1 ) = chr( asc("0") + dv )
            return keep
        end if
        mid( keep, i, 1 ) = "0"
        i -= 1
    wend

    '' All nines: 9.99...9 became 1.00...0 one decade up.
    dexp += 1
    return "1" + left( keep, prec - 1 )
end function

'' ----------------------------------------------------------------------- layout

private function Layout _
    ( byval signText as string, byval ds as string, byval dexp as long, _
      byval prec as long ) as string

    '' C's %g rule, measured at both ends: 1e15 is written out in full and 1e16 is not,
    '' 0.0001 is written out and 0.00001 is not.
    dim as boolean useExp = (dexp < -4) orelse (dexp >= prec)

    if useExp = false then
        if dexp >= 0 then
            if len( ds ) <= dexp + 1 then
                return signText + ds + string( dexp + 1 - len( ds ), asc("0") )
            end if
            return signText + left( ds, dexp + 1 ) + "." + mid( ds, dexp + 2 )
        end if
        return signText + "0." + string( -dexp - 1, asc("0") ) + ds
    end if

    dim as string mant = left( ds, 1 )
    if len( ds ) > 1 then mant += "." + mid( ds, 2 )

    '' At least two exponent digits, which is C's rule and fbc-modern's. fbc 1.10.1 and
    '' fbc-modern's fbc32 pad to three instead -- see fbstr.bi.
    dim as string es = str( abs( dexp ) )
    if len( es ) < 2 then es = "0" + es
    return signText + mant + "e" + iif( dexp < 0, "-", "+" ) + es
end function

'' ------------------------------------------------------------------ the formatter

'' One body for both widths. mantBits/expBits name the IEEE fields, so the subnormal
'' and special cases are written once rather than twice with one of them wrong.
private function FormatFloat _
    ( byval bits as ulongint, byval mantBits as long, byval expBits as long, _
      byval prec as long ) as string

    dim as ulongint fracMaskBits = (1ull shl mantBits) - 1
    dim as long expMax  = (1 shl expBits) - 1
    dim as long expBias = (1 shl (expBits - 1)) - 1

    dim as long  signBit = cast(long, (bits shr (mantBits + expBits)) and 1)
    dim as long  be      = cast(long, (bits shr mantBits) and cast(ulongint, expMax))
    dim as ulongint fracBits = bits and fracMaskBits

    if be = expMax then
        '' NaN loses its sign: fbc prints "nan" for the negative quiet NaN too.
        if fracBits <> 0 then return "nan"
        return iif( signBit <> 0, "-inf", "inf" )
    end if

    dim as string signText = iif( signBit <> 0, "-", "" )

    dim as ulongint mant
    dim as long bexp
    if be = 0 then
        '' Negative zero is "-0", not "0". It is a DATA item that must round-trip.
        if fracBits = 0 then return signText + "0"
        mant = fracBits
        bexp = 1 - expBias - mantBits
    else
        mant = fracBits or (1ull shl mantBits)
        bexp = be - expBias - mantBits
    end if

    dim as DecBuf b
    DecFromU64( b, mant )
    dim as long tenExp = 0
    if bexp >= 0 then
        DecScale( b, 2, bexp )
    else
        DecScale( b, 5, -bexp )
        tenExp = bexp
    end if

    dim as string ds = DecToString( b )
    dim as long dexp = len( ds ) + tenExp - 1
    ds = RoundDigits( ds, prec, dexp )

    dim as long last = len( ds )
    while last > 1 andalso asc( ds, last ) = asc("0")
        last -= 1
    wend

    return Layout( signText, left( ds, last ), dexp, prec )
end function

function StrOfDouble( byval v as double ) as string
    return FormatFloat( *cptr( ulongint ptr, @v ), 52, 11, STR_DOUBLE_DIGITS )
end function

function StrOfSingle( byval v as single ) as string
    dim as ulong bits = *cptr( ulong ptr, @v )
    return FormatFloat( bits, 23, 8, STR_SINGLE_DIGITS )
end function

end namespace
