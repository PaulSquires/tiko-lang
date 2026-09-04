'' mathcv-parity.bas -- SGN, FIX, FRAC, the CVn bit-casts, IntLog10, and the
'' CV/MK string family: thirty-nine entry points.
''
'' NEEDS-GEN-LLVM -- fb_CVI and friends are reserved names.
''
'' THE THREE RULES THAT PRODUCE A PLAUSIBLE WRONG NUMBER RATHER THAN AN ERROR:
''
''   SGN OF NaN IS -1. The test is `= 0` then `> 0`; NaN fails both and falls to
''   the negative arm. FIX and FRAC inherit it, so FIX(NaN) is NaN * -1.
''
''   IntLog10( 0 ) IS -1, not 0 -- the comparison chain runs out.
''
''   CVI( MKI( x ) ) IS NOT A ROUND TRIP on a 64-bit target. MKI writes
''   POINTER-WIDTH bytes and CVI reads FOUR. The L pair does round-trip, on the
''   same target, for what look like the same widths. Both are asked below.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pSGNb alias "fb_SGNb" ( byval x as byte ) as long
    declare function pSGNi alias "fb_SGNi" ( byval x as long ) as long
    declare function pSGNl alias "fb_SGNl" ( byval x as longint ) as long
    declare function pSGNs alias "fb_SGNSingle" ( byval x as single ) as long
    declare function pSGNd alias "fb_SGNDouble" ( byval x as double ) as long
    declare function pFIXs alias "fb_FIXSingle" ( byval x as single ) as single
    declare function pFIXd alias "fb_FIXDouble" ( byval x as double ) as double
    declare function pFRACf alias "fb_FRACf" ( byval x as single ) as single
    declare function pFRACd alias "fb_FRACd" ( byval x as double ) as double
    declare function pCVDL alias "fb_CVDFROMLONGINT" ( byval x as longint ) as double
    declare function pCVLD alias "fb_CVLONGINTFROMD" ( byval x as double ) as longint
    declare function pCVLS alias "fb_CVLFROMS" ( byval x as single ) as long
    declare function pCVSL alias "fb_CVSFROML" ( byval x as long ) as single
    declare function pLog32 alias "fb_IntLog10_32" ( byval x as ulong ) as long
    declare function pLog64 alias "fb_IntLog10_64" ( byval x as ulongint ) as long
    declare function pCVSHORT alias "fb_CVSHORT" ( byval s as any ptr ) as short
    declare function pCVI  alias "fb_CVI"  ( byval s as any ptr ) as long
    declare function pCVL  alias "fb_CVL"  ( byval s as any ptr ) as long
    declare function pCVLI alias "fb_CVLONGINT" ( byval s as any ptr ) as longint
    declare function pCVS  alias "fb_CVS"  ( byval s as any ptr ) as single
    declare function pCVD  alias "fb_CVD"  ( byval s as any ptr ) as double
    declare function pMKSHORT alias "fb_MKSHORT" ( byval n as short ) as FBC.FBSTRING ptr
    declare function pMKI  alias "fb_MKI"  ( byval n as integer ) as FBC.FBSTRING ptr
    declare function pMKL  alias "fb_MKL"  ( byval n as long ) as FBC.FBSTRING ptr
    declare function pMKLI alias "fb_MKLONGINT" ( byval n as longint ) as FBC.FBSTRING ptr
    declare function pMKS  alias "fb_MKS"  ( byval n as single ) as FBC.FBSTRING ptr
    declare function pMKD  alias "fb_MKD"  ( byval n as double ) as FBC.FBSTRING ptr
    declare function pDelTmp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern
#define SLN(d) cint( (d)->len and cast( integer, &h7fffffffffffffffull ) )

print "== SGN =="
print "b  -5,0,7   = "; pSGNb(-5); pSGNb(0); pSGNb(7)
print "i  -5,0,7   = "; pSGNi(-5); pSGNi(0); pSGNi(7)
print "l  -5,0,7   = "; pSGNl(-5); pSGNl(0); pSGNl(7)
print "s  -.5,0,.5 = "; pSGNs(-0.5); pSGNs(0.0); pSGNs(0.5)
print "d  -.5,0,.5 = "; pSGNd(-0.5); pSGNd(0.0); pSGNd(0.5)
'' NaN and the infinities: NaN lands on -1, which is the rule.
dim as double nan_ = pCVDL( &h7FF8000000000000ll )
dim as double inf_ = pCVDL( &h7FF0000000000000ll )
print "d  NaN      = "; pSGNd( nan_ )
print "d  +inf     = "; pSGNd( inf_ )
print "d  -inf     = "; pSGNd( -inf_ )
print "d  -0.0     = "; pSGNd( -0.0 )

print "== FIX / FRAC (truncate toward zero) =="
sub fr( byval d as double )
    print using "  x=####.### fix=####.### frac=####.###"; d; pFIXd( d ); pFRACd( d )
end sub
fr( 3.7 ) : fr( -3.7 ) : fr( 3.0 ) : fr( -3.0 ) : fr( 0.0 ) : fr( -0.5 ) : fr( 0.5 )
print "  single 3.7  fix="; pFIXs( 3.7 ); " frac="; pFRACf( 3.7 )
print "  single -3.7 fix="; pFIXs( -3.7 ); " frac="; pFRACf( -3.7 )

print "== CVn bit casts =="
print "CVDFROMLONGINT 0     = "; pCVDL( 0 )
print "CVLONGINTFROMD 1.0   = "; hex$( pCVLD( 1.0 ) )
print "CVLFROMS 1.0         = "; hex$( pCVLS( 1.0 ) )
print "CVSFROML 0x3F800000  = "; pCVSL( &h3F800000 )
print "round trip d         = "; iif( pCVDL( pCVLD( 3.25 ) ) = 3.25, 1, 0 )
print "round trip s         = "; iif( pCVSL( pCVLS( 3.25f ) ) = 3.25f, 1, 0 )

print "== IntLog10 =="
dim as ulong t32(0 to 7) = { 0, 1, 9, 10, 99, 100, 999999999, 4294967295ul }
for i as integer = 0 to 7
    print "  32 "; t32(i); " -> "; pLog32( t32(i) )
next
dim as ulongint t64(0 to 5) = { 0, 10000000000ull, 999999999999ull, _
                                10000000000000000000ull, 18446744073709551615ull, 5 }
for i as integer = 0 to 5
    print "  64 "; t64(i); " -> "; pLog64( t64(i) )
next

'' ---- MK writes RAW BYTES, so the result is dumped as hex rather than printed.
print "== MK (raw bytes) =="
sub mkdump( byref tag as string, byval p as FBC.FBSTRING ptr )
    dim as string o = ""
    for i as integer = 0 to SLN(p) - 1
        o += right( "0" + hex$( cptr( ubyte ptr, p->data )[i] ), 2 ) + " "
    next
    print tag; " len="; SLN(p); "  ["; o; "]"
    pDelTmp( p )
end sub
mkdump( "MKSHORT  &h1234 ", pMKSHORT( &h1234 ) )
mkdump( "MKI      &h1234 ", pMKI( &h1234 ) )
mkdump( "MKL      &h1234 ", pMKL( &h1234 ) )
mkdump( "MKLONGINT&h1234 ", pMKLI( &h1234 ) )
mkdump( "MKS      1.0    ", pMKS( 1.0 ) )
mkdump( "MKD      1.0    ", pMKD( 1.0 ) )

'' ---- CV over a string built by hand, so the bytes are known.
print "== CV =="
dim shared as ubyte raw(0 to 15)
dim shared as FBC.FBSTRING rd
sub mkraw( byval n as integer )
    for i as integer = 0 to 15 : raw(i) = 0 : next
    for i as integer = 0 to n - 1 : raw(i) = i + 1 : next
    rd.data = cptr( zstring ptr, @raw(0) ) : rd.len = n : rd.size = n
end sub
mkraw( 8 )
print "CVSHORT  = "; hex$( pCVSHORT( @rd ) )
mkraw( 8 )
print "CVI      = "; hex$( pCVI( @rd ) )
mkraw( 8 )
print "CVL      = "; hex$( pCVL( @rd ) )
mkraw( 8 )
print "CVLONGINT= "; hex$( pCVLI( @rd ) )
'' A string SHORTER than the type needs leaves the value at zero -- not garbage,
'' not a fault.
mkraw( 2 )
print "CVLONGINT short = "; hex$( pCVLI( @rd ) )
mkraw( 0 )
print "CVD empty       = "; pCVD( @rd )
print "CVI NULL        = "; pCVI( 0 )

'' ---- THE ROUND TRIPS. The I pair does NOT agree on a 64-bit target and the L
'' pair does, which is the asymmetry the module header describes.
print "== round trips =="
dim as FBC.FBSTRING ptr m = pMKI( &h11223344 )
print "MKI len         = "; SLN(m)
print "CVI( MKI )      = "; hex$( pCVI( m ) )
m = pMKL( &h11223344 )
print "MKL len         = "; SLN(m)
print "CVL( MKL )      = "; hex$( pCVL( m ) )
m = pMKLI( &h1122334455667788ll )
print "MKLONGINT len   = "; SLN(m)
print "CVLONGINT( MK ) = "; hex$( pCVLI( m ) )
m = pMKD( 3.25 )
print "CVD( MKD )      = "; pCVD( m )
m = pMKS( 3.25 )
print "CVS( MKS )      = "; pCVS( m )
