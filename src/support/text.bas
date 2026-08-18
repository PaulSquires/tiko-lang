'' text.bas -- see text.bi

#include once "support/text.bi"

namespace Fbx.Text

'' --------------------------------------------------------------------- detection

function DetectEncoding _
    ( byval p as const ubyte ptr, byval n as long ) as Encoding

    if n >= 3 then
        dim as boolean utf8bom = (p[0] = &hEF) andalso (p[1] = &hBB) andalso (p[2] = &hBF)
        if utf8bom then return ENC_UTF8_BOM
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

sub NormalizeToUtf8 _
    ( byref src as ByteBuf, byref dst as ByteBuf, byval enc as Encoding )

    dst.Clear( )
    select case enc
    case ENC_UTF16LE
        Utf16ToUtf8( src, dst, false )
    case ENC_UTF16BE
        Utf16ToUtf8( src, dst, true )
    case ENC_UTF8_BOM
        CopyFrom( src, dst, 3 )
    case else
        '' ENC_UTF8 and ENC_BYTES are both byte streams we keep verbatim. Invalid
        '' bytes can only legally occur inside literals and comments, where fbc
        '' passes them through to the target encoding -- so fbx does too.
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

end namespace
