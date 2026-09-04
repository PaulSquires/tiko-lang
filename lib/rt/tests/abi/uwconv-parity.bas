'' uwconv-parity.bas -- ustr_convw.o and strw_convfrom_str.o.
''
'' NEEDS-GEN-LLVM -- fb_StrToWstr is a reserved name in fbc's rtlLookupTB.
''
'' THE TWO ENCODING WORLDS, SIDE BY SIDE. fb_StrToWstr goes through the C locale
'' (mbstowcs) and fb_StrToUStr does not; on a C-locale system the first turns
'' every byte above 127 into '?' while the second decodes UTF-8. Same input,
'' different answers, both correct for what they are for -- and it is worth one
'' test that shows them disagreeing on purpose.
''
'' AND THE SURROGATE RULE, WHICH IS DIRECTIONAL. A lone surrogate survives
'' wstring -> ustring and does NOT survive ustring -> wstring on a 32-bit-wchar
'' target. On Windows both directions keep it, because there the two
'' representations are the same. THIS FILE THEREFORE PRINTS A DIFFERENT ANSWER
'' ON LINUX BY DESIGN -- which is fine, because the differential compares tiko-rt
'' against fbc ON THE SAME MACHINE, not one platform against another.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pW_FromW alias "fb_UStrAssignFromW" _
        ( byval d as any ptr, byval dsz as integer, byval s as wstring ptr, _
          byval fr as long, byval ii as long ) as any ptr
    declare function pW_ToW alias "fb_UStrAssignToW" _
        ( byval d as wstring ptr, byval dc as integer, byval s as any ptr, byval ssz as integer ) as wstring ptr
    declare function pW_WtoU alias "fb_WstrToUStr" ( byval s as wstring ptr ) as any ptr
    declare function pW_UtoW alias "fb_UStrToWstr" ( byval s as any ptr, byval ssz as integer ) as wstring ptr
    declare function pW_StoW alias "fb_StrToWstr" ( byval s as zstring ptr ) as wstring ptr
    declare function pU_DelTmp alias "fb_hUStrDelTemp" ( byval s as any ptr ) as long
end extern

extern "c"
    declare function pW_ConvFromA alias "fb_wstr_ConvFromA" _
        ( byval d as wstring ptr, byval dc as integer, byval s as zstring ptr ) as integer
end extern

type UDESC field = 1
    as ushort ptr data_
    as integer  len_
    as integer  size_
end type
#define ULN(d) cint( (d)->len_ and cast( integer, &h7fffffffffffffffull ) )
#define VARLEN -1
#define FIXED(n) ((n) or cast( integer, &h8000000000000000ull ))

function ushow( byval p as any ptr ) as string
    dim as UDESC ptr d = cptr( UDESC ptr, p )
    if( d = 0 ) then return "<null>"
    dim as string o = "len=" + str( ULN(d) ) + " ["
    for i as integer = 0 to ULN(d) - 1
        o += right( "000" + hex$( d->data_[i] ), 4 ) + " "
    next
    return o + "]"
end function

'' A wstring is a bare pointer, so the units are written by hand -- this is the
'' only way to present a LONE surrogate without asking the compiler to encode it.
function wshow( byval p as wstring ptr, byval n as integer ) as string
    if( p = 0 ) then return "<null>"
    '' READ THE UNITS AS RAW BYTES, not with p[i].
    ''
    '' The first version of this indexed the wstring directly and printed 0000
    '' for every case -- and the differential PASSED, because both runtimes
    '' printed the same zeros. A test that cannot come out two ways is not a
    '' measurement, and this is the fifth time in this project that the
    '' instrument, not the subject, was the thing that was wrong.
    ''
    '' The stride is sizeof( wstring ), which is the whole point of the file:
    '' 2 bytes on Windows, 4 on Linux. Little-endian on all three targets.
    dim as ubyte ptr b = cptr( ubyte ptr, p )
    dim as string o = ""
    for i as integer = 0 to n - 1
        dim as ulongint v = 0
        for k as integer = 0 to sizeof( wstring ) - 1
            v or= cast( ulongint, b[i * sizeof( wstring ) + k] ) shl (k * 8)
        next
        o += right( "00000000" + hex$( v ), 4 ) + " "
    next
    return o
end function

'' ---- wstring -> ustring
dim as wstring * 16 w1 = wstr( "A" ) + wchr( &h20AC ) + wstr( "B" )
print "WstrToUStr bmp    "; ushow( pW_WtoU( @w1 ) )

'' A well-formed astral PAIR. On Windows these are two wchars that already ARE
'' the two code units; on Linux they are two 32-bit surrogate scalars that must
'' be passed through, not replaced, or the pair becomes FFFD FFFD.
dim as wstring * 8 wsur
wsur[0] = &hD83D : wsur[1] = &hDE00 : wsur[2] = 0
print "WstrToUStr pair   "; ushow( pW_WtoU( @wsur ) )

'' A LONE surrogate. Passed through in this direction on every target.
dim as wstring * 8 wlone
wlone[0] = &hD83D : wlone[1] = asc("x") : wlone[2] = 0
print "WstrToUStr lone   "; ushow( pW_WtoU( @wlone ) )
print "WstrToUStr NULL   "; ushow( pW_WtoU( 0 ) )

'' ---- ustring -> wstring. The lone surrogate is the one that does NOT survive
'' where wchar is 32 bits, and does where it is 16.
dim as any ptr u = pW_WtoU( @wsur )
dim as wstring ptr back = pW_UtoW( u, VARLEN )
print "UStrToWstr pair   "; wshow( back, 2 )
deallocate( back )

dim as any ptr ul = pW_WtoU( @wlone )
dim as wstring ptr backl = pW_UtoW( ul, VARLEN )
print "UStrToWstr lone   "; wshow( backl, 2 )
deallocate( backl )

'' ---- assignment, both directions, including the WSTRING * N capacity rule.
dim as UDESC d1
d1.data_ = 0 : d1.len_ = 0 : d1.size_ = 0
pW_FromW( @d1, VARLEN, @w1, 0, 1 )
print "AssignFromW init  "; ushow( @d1 )
pW_FromW( @d1, VARLEN, @wsur, 0, 0 )
print "AssignFromW pair  "; ushow( @d1 )
pW_FromW( @d1, VARLEN, 0, 0, 0 )
print "AssignFromW NULL  "; ushow( @d1 )
pW_FromW( 0, VARLEN, @w1, 0, 0 )

pW_FromW( @d1, VARLEN, @w1, 0, 0 )
dim as wstring * 8 wout
'' dst_chars is the DECLARED capacity INCLUDING the terminator, so 4 leaves room
'' for three characters -- the truncation is the point of the case.
pW_ToW( @wout, 3, @d1, VARLEN )
print "AssignToW cap 3   "; wshow( @wout, 4 )
pW_ToW( @wout, 8, @d1, VARLEN )
print "AssignToW cap 8   "; wshow( @wout, 4 )
pW_ToW( 0, 8, @d1, VARLEN )

'' ---- the locale family, and where it disagrees with the ustring family.
dim as zstring * 16 z1 = "hello"
dim as wstring ptr sw = pW_StoW( @z1 )
print "StrToWstr ascii   "; wshow( sw, 5 )
deallocate( sw )
print "StrToWstr NULL    "; iif( pW_StoW( 0 ) = 0, 1, 0 )
dim as zstring * 4 zempty = ""
print "StrToWstr empty   "; iif( pW_StoW( @zempty ) = 0, 1, 0 )

'' Bytes above 127. In the C locale mbstowcs fails and every one becomes '?';
'' fb_StrToUStr on the same bytes decodes UTF-8. Both answers are printed so the
'' disagreement is on the record rather than in a comment.
dim as zstring * 8 zhigh
zhigh[0] = &hE2 : zhigh[1] = &h82 : zhigh[2] = &hAC : zhigh[3] = 0
'' NOT EVIDENCE THE FALLBACK WORKS. On a Windows ANSI codepage mbstowcs
'' SUCCEEDS on these bytes and maps them one-for-one, so hNoMultibyte is never
'' reached here -- which is itself the locale dependence this family is being
'' contrasted for. The '?' path is exercised only where mbstowcs actually
'' fails, and this file does not claim to cover it.
dim as wstring ptr hw = pW_StoW( @zhigh )
print "StrToWstr utf8src "; wshow( hw, 3 )
if( hw <> 0 ) then deallocate( hw )

dim as wstring * 16 cbuf
print "ConvFromA ret     "; pW_ConvFromA( @cbuf, 8, @z1 ); "  "; wshow( @cbuf, 5 )
print "ConvFromA trunc   "; pW_ConvFromA( @cbuf, 3, @z1 ); "  "; wshow( @cbuf, 4 )
print "ConvFromA NULL    "; pW_ConvFromA( @cbuf, 8, 0 ); "  "; wshow( @cbuf, 1 )
