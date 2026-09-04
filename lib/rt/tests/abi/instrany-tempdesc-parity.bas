'' instrany-tempdesc-parity.bas -- fb_StrInstrAny, fb_StrInstrRevAny,
'' fb_StrAllocTempDescZ/ZEx/F, fb_UCASE, fb_LCASE.
''
'' NEEDS-GEN-LLVM -- fb_StrAllocTempDescZEx is reserved in fbc's rtlLookupTB, so
'' aliasing it emits two conflicting C declarations and gcc rejects the file.
'' The llvm backend has no C layer to disagree with; diff.sh compiles both sides
'' that way.
#include once "fbc-int/string.bi"

type TKCTXHEAD
    argc     as long
    argv     as zstring ptr ptr
    nulldesc as FBC.FBSTRING
end type
extern "C"
    extern __fb_ctx alias "__fb_ctx" as TKCTXHEAD
end extern

extern "rtlib"
    declare function p_Any    alias "fb_StrInstrAny"    ( byval st as integer, byval s as FBC.FBSTRING ptr, byval p as FBC.FBSTRING ptr ) as integer
    declare function p_RevAny alias "fb_StrInstrRevAny" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBSTRING ptr, byval st as integer ) as integer
    declare function p_DescZ  alias "fb_StrAllocTempDescZ"   ( byval s as zstring ptr ) as FBC.FBSTRING ptr
    declare function p_DescZEx alias "fb_StrAllocTempDescZEx" ( byval s as zstring ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_DescF  alias "fb_StrAllocTempDescF"   ( byval s as zstring ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_Ucase  alias "fb_UCASE" ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Lcase  alias "fb_LCASE" ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )

#if sizeof(integer) = 8
    const ISFIXED as integer = cast( integer, &h8000000000000000ull )
#else
    const ISFIXED as integer = cast( integer, &h80000000ul )
#endif

dim as string hay = "the quick brown fox", vowels = "aeiou", zz = "zq", emp = ""

'' ---- forward ANY
for st as integer = -2 to 21
    print "instrany start="; st; " -> "; p_Any( st, D(hay), D(vowels) )
next
print "instrany zq      = "; p_Any( 1, D(hay), D(zz) )
print "instrany ''      = "; p_Any( 1, D(hay), D(emp) )
print "instrany '' hay  = "; p_Any( 1, D(emp), D(vowels) )
print "instrany NULL    = "; p_Any( 1, 0, D(vowels) )
print "instrany p NULL  = "; p_Any( 1, D(hay), 0 )
'' a hit at the very last position -- the sentinel boundary
dim as string tail_ = "bcdfa"
print "instrany tail    = "; p_Any( 1, D(tail_), D(vowels) )

'' ---- reverse ANY, whose clamp differs from fb_StrInstrRev's
for st as integer = -2 to 21
    print "instrrevany start="; st; " -> "; p_RevAny( D(hay), D(vowels), st )
next
print "instrrevany zq   = "; p_RevAny( D(hay), D(zz), -1 )
print "instrrevany ''   = "; p_RevAny( D(hay), D(emp), -1 )
print "instrrevany NULL = "; p_RevAny( 0, D(vowels), -1 )

'' ---- the temp descriptors: pool descriptor, temp bit CLEAR, size = len
sub showdesc( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r), t = iif( r->len < 0, 1, 0 ), sz = cint( r->size )
    dim as integer sh = iif( r = @__fb_ctx.nulldesc, 1, 0 )
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " "
        next
    end if
    print tag; " len="; n; " size="; sz; " temp="; t; " shared="; sh; " ["; b; "]"
end sub

dim as zstring * 12 z12 = "abcdef"
'' EVERY BYTE SET, not just the six that matter. DescF( z12, 12 ) reports
'' length 11 -- size less the terminator -- so the dump reads five bytes past
'' the initialised text. Left as declared, those are stack leftovers and differ
'' between two runs of the SAME runtime: the first version of this test reported
'' `50 07 B5` against `50 07 79` and looked exactly like a runtime divergence.
'' The differential was right to flag it; the fixture was wrong.
for i as integer = 6 to 11
    z12[i] = 0
next
showdesc( "DescZ  abcdef    ", p_DescZ( strptr(z12) ) )
showdesc( "DescZ  NULL      ", p_DescZ( 0 ) )
showdesc( "DescZEx abcdef,3 ", p_DescZEx( strptr(z12), 3 ) )
showdesc( "DescZEx abcdef,0 ", p_DescZEx( strptr(z12), 0 ) )
'' DescF's three branches: size>0, the FIXED flag, and 0
showdesc( "DescF  z12,12    ", p_DescF( strptr(z12), 12 ) )
showdesc( "DescF  z12,fixed6", p_DescF( strptr(z12), 6 or ISFIXED ) )
showdesc( "DescF  z12,0     ", p_DescF( strptr(z12), 0 ) )
showdesc( "DescF  NULL,0    ", p_DescF( 0, 0 ) )

'' ---- UCASE / LCASE forwarders
sub showstr( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r)
    dim as string v = ""
    for i as integer = 0 to n - 1 : v += chr( cptr( ubyte ptr, r->data )[i] ) : next
    print tag; " len="; n; " ["; v; "]"
end sub
dim as string mixed = "AbCdEf 123 xyz"
showstr( "UCASE            ", p_Ucase( D(mixed) ) )
showstr( "LCASE            ", p_Lcase( D(mixed) ) )
showstr( "UCASE ''         ", p_Ucase( D(emp) ) )

'' ---- operand consumption on the ANY pair
function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function

dim as FBC.FBSTRING ptr a1 = mkTemp( "hello" ), b1 = mkTemp( "lo" )
dim as integer r1 = p_Any( 1, a1, b1 )
dim as integer c1 = LN(a1), c2 = iif(a1->data=0,0,1), c3 = LN(b1), c4 = iif(b1->data=0,0,1)
print "instrany temp temp = "; r1; " src len="; c1; " data="; c2; " patt len="; c3; " data="; c4

dim as FBC.FBSTRING ptr a2 = mkTemp( "hello" ), b2 = mkTemp( "lo" )
dim as integer r2 = p_RevAny( a2, b2, -1 )
dim as integer e1 = LN(a2), e2 = iif(a2->data=0,0,1), e3 = LN(b2), e4 = iif(b2->data=0,0,1)
print "instrrevany temp   = "; r2; " src len="; e1; " data="; e2; " patt len="; e3; " data="; e4
