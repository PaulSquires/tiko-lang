'' text.bas -- see text.bi

#include once "support/text.bi"

namespace Tko.Text

'' --------------------------------------------------------------------- detection

function DetectEncoding _
    ( byval p as const ubyte ptr, byval n as long ) as Encoding

    if n >= 3 then
        dim as boolean utf8bom = (p[0] = &hEF) andalso (p[1] = &hBB) andalso (p[2] = &hBF)
        if utf8bom then return ENC_UTF8_BOM
    end if
    '' UTF-32 BEFORE UTF-16, because 'FF FE 00 00' begins with the UTF-16LE BOM. Tested
    '' the other way round, every UTF-32LE file reads as UTF-16LE followed by a stream of
    '' NUL characters -- which does not fail, it produces nonsense.
    if n >= 4 then
        if p[0] = &hFF andalso p[1] = &hFE andalso p[2] = 0 andalso p[3] = 0 then
            return ENC_UTF32LE
        end if
        if p[0] = 0 andalso p[1] = 0 andalso p[2] = &hFE andalso p[3] = &hFF then
            return ENC_UTF32BE
        end if
    end if
    if n >= 2 then
        if p[0] = &hFF andalso p[1] = &hFE then return ENC_UTF16LE
        if p[0] = &hFE andalso p[1] = &hFF then return ENC_UTF16BE
    end if
    if IsValidUtf8( p, n ) then return ENC_UTF8
    return ENC_BYTES
end function

function EncodingName( byval e as Encoding ) as string
    select case e
    case ENC_UTF8      : return "utf-8"
    case ENC_UTF8_BOM  : return "utf-8 (bom)"
    case ENC_UTF16LE   : return "utf-16le"
    case ENC_UTF16BE   : return "utf-16be"
    case ENC_UTF32LE   : return "utf-32le"
    case ENC_UTF32BE   : return "utf-32be"
    case else          : return "bytes"
    end select
end function

function FirstInvalidUtf8 _
    ( byval p as const ubyte ptr, byval n as long ) as long

    dim as long i = 0
    while i < n
        dim as ubyte b = p[i]
        if b < &h80 then
            i += 1
            continue while
        end if

        dim as long need = 0
        dim as ulong cp = 0
        if (b and &hE0) = &hC0 then
            need = 1 : cp = b and &h1F
        elseif (b and &hF0) = &hE0 then
            need = 2 : cp = b and &h0F
        elseif (b and &hF8) = &hF0 then
            need = 3 : cp = b and &h07
        else
            return i            '' continuation byte, or a 5/6-byte form
        end if

        if i + need >= n then return i
        for k as long = 1 to need
            dim as ubyte c = p[i + k]
            if (c and &hC0) <> &h80 then return i
            cp = (cp shl 6) or (c and &h3F)
        next

        '' Reject overlong forms, surrogates and out-of-range. Without these the
        '' test would accept sequences no conforming decoder produces.
        select case need
        case 1 : if cp < &h80 then return i
        case 2 : if cp < &h800 then return i
        case 3 : if cp < &h10000 then return i
        end select
        dim as boolean isSurrogate = (cp >= &hD800) andalso (cp <= &hDFFF)
        dim as boolean tooBig = (cp > &h10FFFF)
        if isSurrogate orelse tooBig then return i

        i += need + 1
    wend
    return -1
end function

function IsValidUtf8 _
    ( byval p as const ubyte ptr, byval n as long ) as boolean
    return (FirstInvalidUtf8( p, n ) < 0)
end function

'' ------------------------------------------------------------------- utf-8 codec

function Utf8SeqLen _
    ( byval p as const ubyte ptr, byval n as long, byval i as long ) as long

    if i >= n then return 0
    dim as ubyte b = p[i]
    dim as long want = 1
    if b >= &hF0 then
        want = 4
    elseif b >= &hE0 then
        want = 3
    elseif b >= &hC0 then
        want = 2
    end if
    if i + want > n then want = n - i
    return want
end function

function DecodeUtf8 _
    ( byval p as const ubyte ptr, byval n as long, byref i as long ) as ulong

    if i >= n then return 0

    dim as ubyte b = p[i]
    if b < &h80 then
        i += 1
        return b
    end if

    dim as long need = 0
    dim as ulong cp = 0
    if (b and &hE0) = &hC0 then
        need = 1 : cp = b and &h1F
    elseif (b and &hF0) = &hE0 then
        need = 2 : cp = b and &h0F
    elseif (b and &hF8) = &hF0 then
        need = 3 : cp = b and &h07
    else
        i += 1                          '' stray continuation byte
        return REPLACEMENT_CP
    end if

    if i + need >= n then
        i += 1
        return REPLACEMENT_CP
    end if

    for k as long = 1 to need
        dim as ubyte c = p[i + k]
        if (c and &hC0) <> &h80 then
            i += 1                      '' truncated: consume exactly one byte
            return REPLACEMENT_CP
        end if
        cp = (cp shl 6) or (c and &h3F)
    next

    i += need + 1
    dim as boolean isSurrogate = (cp >= &hD800) andalso (cp <= &hDFFF)
    if isSurrogate orelse (cp > &h10FFFF) then return REPLACEMENT_CP
    return cp
end function

sub AppendUtf8( byref dst as ByteBuf, byval cp as ulong )
    dim as boolean isSurrogate = (cp >= &hD800) andalso (cp <= &hDFFF)
    dim as boolean bad = isSurrogate orelse (cp > &h10FFFF)
    if bad then cp = REPLACEMENT_CP

    if cp < &h80 then
        dst.Push( cast( ubyte, cp ) )
    elseif cp < &h800 then
        dst.Push( cast( ubyte, &hC0 or (cp shr 6) ) )
        dst.Push( cast( ubyte, &h80 or (cp and &h3F) ) )
    elseif cp < &h10000 then
        dst.Push( cast( ubyte, &hE0 or (cp shr 12) ) )
        dst.Push( cast( ubyte, &h80 or ((cp shr 6) and &h3F) ) )
        dst.Push( cast( ubyte, &h80 or (cp and &h3F) ) )
    else
        dst.Push( cast( ubyte, &hF0 or (cp shr 18) ) )
        dst.Push( cast( ubyte, &h80 or ((cp shr 12) and &h3F) ) )
        dst.Push( cast( ubyte, &h80 or ((cp shr 6) and &h3F) ) )
        dst.Push( cast( ubyte, &h80 or (cp and &h3F) ) )
    end if
end sub

'' --------------------------------------------------------------- normalisation

private sub Utf16ToUtf8 _
    ( byref src as ByteBuf, byref dst as ByteBuf, byval bigEndian as boolean )

    dim as long n = src.Count
    dim as long i = 2                       '' skip the BOM
    while i + 1 < n
        dim as ulong u = 0
        if bigEndian then
            u = (cast( ulong, src[i] ) shl 8) or src[i + 1]
        else
            u = (cast( ulong, src[i + 1] ) shl 8) or src[i]
        end if
        i += 2

        dim as boolean isHigh = (u >= &hD800) andalso (u <= &hDBFF)
        dim as boolean havePair = isHigh andalso (i + 1 < n)
        if havePair then
            dim as ulong lo = 0
            if bigEndian then
                lo = (cast( ulong, src[i] ) shl 8) or src[i + 1]
            else
                lo = (cast( ulong, src[i + 1] ) shl 8) or src[i]
            end if
            dim as boolean isLow = (lo >= &hDC00) andalso (lo <= &hDFFF)
            if isLow then
                i += 2
                u = &h10000 + ((u - &hD800) shl 10) + (lo - &hDC00)
            end if
        end if

        AppendUtf8( dst, u )
    wend
end sub

private sub CopyFrom( byref src as ByteBuf, byref dst as ByteBuf, byval first as long )
    dim as long n = src.Count
    if first >= n then return
    dst.Reserve( n - first )
    for i as long = first to n - 1
        dst.Push( src[i] )
    next
end sub


'' UTF-32 to UTF-8. Simpler than UTF-16: a code unit IS a code point, so there are no
'' surrogate pairs to reassemble. The BOM is one unit and is dropped.
''
'' A value above U+10FFFF or in the surrogate range is not a code point at all. Those are
'' replaced rather than encoded, because AppendUtf8 would otherwise emit a sequence no
'' decoder will accept and the error would surface much later as mangled text.
private sub Utf32ToUtf8 _
    ( byref src as ByteBuf, byref dst as ByteBuf, byval bigEndian as boolean )

    dim as long i = 0
    dim as long n = src.Count( )
    while i + 3 < n
        dim as ulong cp
        if bigEndian then
            cp = (cast( ulong, src.At( i ) ) shl 24) or _
                 (cast( ulong, src.At( i + 1 ) ) shl 16) or _
                 (cast( ulong, src.At( i + 2 ) ) shl 8) or _
                  cast( ulong, src.At( i + 3 ) )
        else
            cp = (cast( ulong, src.At( i + 3 ) ) shl 24) or _
                 (cast( ulong, src.At( i + 2 ) ) shl 16) or _
                 (cast( ulong, src.At( i + 1 ) ) shl 8) or _
                  cast( ulong, src.At( i ) )
        end if
        i += 4
        '' The BOM, only at the very start.
        if (i = 4) andalso (cp = &hFEFF) then continue while
        dim as boolean bad = (cp > &h10FFFF)
        if (cp >= &hD800) andalso (cp <= &hDFFF) then bad = true
        if bad then cp = &hFFFD
        AppendUtf8( dst, cp )
    wend
end sub

sub NormalizeToUtf8 _
    ( byref src as ByteBuf, byref dst as ByteBuf, byval enc as Encoding )

    dst.Clear( )
    select case enc
    case ENC_UTF16LE
        Utf16ToUtf8( src, dst, false )
    case ENC_UTF16BE
        Utf16ToUtf8( src, dst, true )
    case ENC_UTF32LE
        Utf32ToUtf8( src, dst, false )
    case ENC_UTF32BE
        Utf32ToUtf8( src, dst, true )
    case ENC_UTF8_BOM
        CopyFrom( src, dst, 3 )
    case else
        '' ENC_UTF8 and ENC_BYTES are both byte streams we keep verbatim. Invalid
        '' bytes can only legally occur inside literals and comments, where fbc
        '' passes them through to the target encoding -- so tiko-lang does too.
        CopyFrom( src, dst, 0 )
    end select
end sub

'' ------------------------------------------------------------------- columns

function DisplayWidth( byval cp as ulong ) as long
    if cp = 0 then return 0

    dim as boolean combining = ((cp >= &h0300) andalso (cp <= &h036F)) orelse _
                               ((cp >= &h200B) andalso (cp <= &h200F))
    if combining then return 0

    dim as boolean wideA = ((cp >= &h1100) andalso (cp <= &h115F)) orelse _
                           ((cp >= &h2E80) andalso (cp <= &hA4CF)) orelse _
                           ((cp >= &hAC00) andalso (cp <= &hD7A3))
    dim as boolean wideB = ((cp >= &hF900) andalso (cp <= &hFAFF)) orelse _
                           ((cp >= &hFE30) andalso (cp <= &hFE6F)) orelse _
                           ((cp >= &hFF00) andalso (cp <= &hFF60)) orelse _
                           ((cp >= &hFFE0) andalso (cp <= &hFFE6))
    dim as boolean wideC = ((cp >= &h1F300) andalso (cp <= &h1F64F)) orelse _
                           ((cp >= &h1F900) andalso (cp <= &h1F9FF)) orelse _
                           ((cp >= &h20000) andalso (cp <= &h3FFFD))
    dim as boolean wide = wideA orelse wideB orelse wideC
    if wide then return 2
    return 1
end function

function ColumnOf _
    ( byval p as const ubyte ptr, byval lineStart as long, _
      byval byteOffset as long, byval tabWidth as long ) as long

    dim as long col = 0
    dim as long i = lineStart
    while i < byteOffset
        if p[i] = 9 then                    '' tab advances to the next stop
            col = ((col \ tabWidth) + 1) * tabWidth
            i += 1
        else
            dim as ulong cp = DecodeUtf8( p, byteOffset, i )
            col += DisplayWidth( cp )
        end if
    wend
    return col + 1                          '' columns are 1-based
end function

'' --------------------------------------------------------------------- folding

sub LowerAsciiInto _
    ( byval src as const ubyte ptr, byval n as long, byval dst as ubyte ptr )

    if n <= 0 then return
    for i as long = 0 to n - 1
        dim as ubyte b = src[i]
        dim as boolean upper = (b >= 65) andalso (b <= 90)
        if upper then
            dst[i] = b + 32
        else
            dst[i] = b
        end if
    next
end sub

function LowerAscii( byval s as string ) as string
    dim as string r = s
    if len( r ) = 0 then return r
    LowerAsciiInto( cast( const ubyte ptr, strptr( s ) ), len( r ), _
                    cast( ubyte ptr, strptr( r ) ) )
    return r
end function

function UpperAscii( byval s as string ) as string
    dim as string r = s
    if len( r ) = 0 then return r
    dim as ubyte ptr q = cast( ubyte ptr, strptr( r ) )
    for i as long = 0 to len( r ) - 1
        if (q[i] >= 97) andalso (q[i] <= 122) then q[i] -= 32
    next
    return r
end function

'' ------------------------------------------------------------- ustring bridges

function Utf8ToUString( byval p as const ubyte ptr, byval n as long ) as ustring
    if n <= 0 then return ""
    dim as string tmp = space( n )
    memcpy( strptr( tmp ), p, n )
    return tmp              '' STRING -> USTRING is UTF-8 on every target
end function

function UStringToUtf8( byval s as ustring ) as string
    return s                '' USTRING -> STRING is UTF-8 on every target
end function

'' One radix run: at most 'maxd' digits in 'radix', clamped at 255. 'i' indexes the
'' first digit and is advanced past what was consumed.
private function ReadRadixIn_ _
    ( byref b as string, byref i as long, byval radix as long, _
      byval maxd as long ) as long

    dim as long v = 0
    dim as long d = 0
    while (d < maxd) andalso (i <= len( b ))
        dim as long k = asc( mid( b, i, 1 ) )
        dim as long dv = -1
        if (k >= 48) andalso (k <= 57) then dv = k - 48
        if (k >= 97) andalso (k <= 102) then dv = k - 87
        if (k >= 65) andalso (k <= 70) then dv = k - 55
        if (dv < 0) orelse (dv >= radix) then exit while
        v = v * radix + dv
        i += 1
        d += 1
    wend
    if v > 255 then v = 255
    return v
end function

'' One escape, 'i' indexing the BACKSLASH. The byte, or -1 for an escape that produces
'' NOTHING; 'i' advances past everything consumed. Byte-for-byte the rule MIR's own
'' reader applies -- the two used to be one routine over a source SPAN, which the
'' preprocessor has no way to reach.
function EscapeByteAt( byref b as string, byref i as long ) as long
    i += 1
    if i > len( b ) then return 92
    dim as long c = asc( mid( b, i, 1 ) )
    select case c
    case asc( "a" ) : i += 1 : return 7
    case asc( "b" ) : i += 1 : return 8
    case asc( "f" ) : i += 1 : return 12
    case asc( "n" ) : i += 1 : return 10
    case asc( "r" ) : i += 1 : return 13
    case asc( "t" ) : i += 1 : return 9
    case asc( "v" ) : i += 1 : return 11
    case 92         : i += 1 : return 92
    case 34         : i += 1 : return 34
    case 39         : i += 1 : return 39
    end select
    '' DECIMAL, not octal, one to three digits, clamped at 255.
    if (c >= 48) andalso (c <= 57) then
        dim as long v = 0
        dim as long d = 0
        while (d < 3) andalso (i <= len( b ))
            dim as long k = asc( mid( b, i, 1 ) )
            if (k < 48) orelse (k > 57) then exit while
            v = v * 10 + (k - 48)
            i += 1
            d += 1
        wend
        if v > 255 then v = 255
        return v
    end if
    if (c = asc( "x" )) orelse (c = asc( "X" )) then
        i += 1
        return ReadRadixIn_( b, i, 16, 2 )
    end if
    if c = 38 then
        if i + 1 <= len( b ) then
            dim as long r = asc( mid( b, i + 1, 1 ) )
            select case r
            case asc( "h" ), asc( "H" ) : i += 2 : return ReadRadixIn_( b, i, 16, 2 )
            case asc( "o" ), asc( "O" ) : i += 2 : return ReadRadixIn_( b, i, 8, 3 )
            case asc( "b" ), asc( "B" ) : i += 2 : return ReadRadixIn_( b, i, 2, 8 )
            end select
        end if
        i += 1
        return -1
    end if
    '' ANYTHING ELSE is the character itself, and is NEVER an error.
    i += 1
    return c
end function

function DecodeEscapedBody _
    ( byref body as string, byref outWide as boolean ) as string

    outWide = false
    dim as long n = len( body )
    '' A UNICODE escape promotes the WHOLE literal to a wstring, which is a different
    '' object and not this routine's to invent.
    '' PAIR BY PAIR: the 'U' in '\\Users' follows an escaped backslash and is text.
    dim as long k = 1
    while k <= n - 1
        if asc( mid( body, k, 1 ) ) = 92 then
            dim as long nx = asc( mid( body, k + 1, 1 ) )
            if (nx = asc( "u" )) orelse (nx = asc( "U" )) then
                outWide = true
                return ""
            end if
            k += 1
        end if
        k += 1
    wend
    dim as string r = ""
    dim as long i = 1
    while i <= n
        if asc( mid( body, i, 1 ) ) = 92 then
            dim as long v = EscapeByteAt( body, i )
            if v >= 0 then r += chr( v )
        else
            r += mid( body, i, 1 )
            i += 1
        end if
    wend
    return r
end function

end namespace
