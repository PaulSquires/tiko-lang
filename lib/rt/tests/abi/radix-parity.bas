'' radix-parity.bas -- HEX, OCT and BIN, narrow and wide: sixty entry points.
''
'' NEEDS-GEN-LLVM -- fb_HEX_i and friends are reserved names in fbc's
'' rtlLookupTB.
''
'' ONLY SIX OF THE SIXTY DO ANY WORK; the rest are overload forwards. So what
'' this file is really checking is that the FORWARDS GO TO THE RIGHT PLACE, and
'' the way to see that is to pass values that DIFFER BY WIDTH:
''
''   HEX( &hFF as ubyte )  and  HEX( &hFF as ulong )  print the same thing,
''   but HEX( -1 ) does not -- and a _b that forwarded to the _i routine, or an
''   _i that sign-extended, shows up there and nowhere else.
''
'' THE DIGITS ARGUMENT TRUNCATES FROM THE TOP when it is too small, because the
'' fill walks down from the last position and runs out. HEX( &hFF, 1 ) is "F".
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function pHEX_b   alias "fb_HEX_b"   ( byval n as ubyte ) as FBC.FBSTRING ptr
    declare function pHEX_s   alias "fb_HEX_s"   ( byval n as ushort ) as FBC.FBSTRING ptr
    declare function pHEX_i   alias "fb_HEX_i"   ( byval n as ulong ) as FBC.FBSTRING ptr
    declare function pHEX_l   alias "fb_HEX_l"   ( byval n as ulongint ) as FBC.FBSTRING ptr
    declare function pHEX_p   alias "fb_HEX_p"   ( byval p as any ptr ) as FBC.FBSTRING ptr
    declare function pHEXEx_b alias "fb_HEXEx_b" ( byval n as ubyte, byval d as long ) as FBC.FBSTRING ptr
    declare function pHEXEx_s alias "fb_HEXEx_s" ( byval n as ushort, byval d as long ) as FBC.FBSTRING ptr
    declare function pHEXEx_i alias "fb_HEXEx_i" ( byval n as ulong, byval d as long ) as FBC.FBSTRING ptr
    declare function pHEXEx_l alias "fb_HEXEx_l" ( byval n as ulongint, byval d as long ) as FBC.FBSTRING ptr
    declare function pHEXEx_p alias "fb_HEXEx_p" ( byval p as any ptr, byval d as long ) as FBC.FBSTRING ptr
    declare function pOCT_b   alias "fb_OCT_b"   ( byval n as ubyte ) as FBC.FBSTRING ptr
    declare function pOCT_s   alias "fb_OCT_s"   ( byval n as ushort ) as FBC.FBSTRING ptr
    declare function pOCT_i   alias "fb_OCT_i"   ( byval n as ulong ) as FBC.FBSTRING ptr
    declare function pOCT_l   alias "fb_OCT_l"   ( byval n as ulongint ) as FBC.FBSTRING ptr
    declare function pOCT_p   alias "fb_OCT_p"   ( byval p as any ptr ) as FBC.FBSTRING ptr
    declare function pOCTEx_b alias "fb_OCTEx_b" ( byval n as ubyte, byval d as long ) as FBC.FBSTRING ptr
    declare function pOCTEx_s alias "fb_OCTEx_s" ( byval n as ushort, byval d as long ) as FBC.FBSTRING ptr
    declare function pOCTEx_i alias "fb_OCTEx_i" ( byval n as ulong, byval d as long ) as FBC.FBSTRING ptr
    declare function pOCTEx_l alias "fb_OCTEx_l" ( byval n as ulongint, byval d as long ) as FBC.FBSTRING ptr
    declare function pOCTEx_p alias "fb_OCTEx_p" ( byval p as any ptr, byval d as long ) as FBC.FBSTRING ptr
    declare function pBIN_b   alias "fb_BIN_b"   ( byval n as ubyte ) as FBC.FBSTRING ptr
    declare function pBIN_s   alias "fb_BIN_s"   ( byval n as ushort ) as FBC.FBSTRING ptr
    declare function pBIN_i   alias "fb_BIN_i"   ( byval n as ulong ) as FBC.FBSTRING ptr
    declare function pBIN_l   alias "fb_BIN_l"   ( byval n as ulongint ) as FBC.FBSTRING ptr
    declare function pBIN_p   alias "fb_BIN_p"   ( byval p as any ptr ) as FBC.FBSTRING ptr
    declare function pBINEx_b alias "fb_BINEx_b" ( byval n as ubyte, byval d as long ) as FBC.FBSTRING ptr
    declare function pBINEx_s alias "fb_BINEx_s" ( byval n as ushort, byval d as long ) as FBC.FBSTRING ptr
    declare function pBINEx_i alias "fb_BINEx_i" ( byval n as ulong, byval d as long ) as FBC.FBSTRING ptr
    declare function pBINEx_l alias "fb_BINEx_l" ( byval n as ulongint, byval d as long ) as FBC.FBSTRING ptr
    declare function pBINEx_p alias "fb_BINEx_p" ( byval p as any ptr, byval d as long ) as FBC.FBSTRING ptr
    declare function pSDelTmp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
end extern

#define SLN(d) cint( (d)->len and cast( integer, &h7fffffffffffffffull ) )
sub sshow( byref tag as string, byval p as FBC.FBSTRING ptr )
    if( p = 0 ) then print tag; " <NULL>" : exit sub
    dim as string o = ""
    for i as integer = 0 to SLN(p) - 1
        o += chr( cptr( ubyte ptr, p->data )[i] )
    next
    print tag; " len="; SLN(p); " ["; o; "]"
    pSDelTmp( p )
end sub

'' Both descriptors are consumed. Only the VERDICT is printed, so this is usable
'' on values -- addresses -- whose text cannot be compared across two links.
sub ssame( byref tag as string, byval a as FBC.FBSTRING ptr, byval b as FBC.FBSTRING ptr )
    dim as long eq = 0
    if( (a <> 0) andalso (b <> 0) ) then
        if( SLN(a) = SLN(b) ) then
            eq = 1
            for i as integer = 0 to SLN(a) - 1
                if( cptr( ubyte ptr, a->data )[i] <> cptr( ubyte ptr, b->data )[i] ) then
                    eq = 0
                    exit for
                end if
            next
        end if
    end if
    print tag; " = _l form: "; eq
    if( a <> 0 ) then pSDelTmp( a )
    if( b <> 0 ) then pSDelTmp( b )
end sub

'' ---- the narrow family. Values chosen so a forward to the WRONG width shows:
'' &hFF is 255 in every width, but -1 is FF / FFFF / FFFFFFFF / FFFFFFFFFFFFFFFF.
print "== HEX =="
sshow( "HEX_b 0     ", pHEX_b( 0 ) )
sshow( "HEX_b 255   ", pHEX_b( 255 ) )
sshow( "HEX_s 65535 ", pHEX_s( 65535 ) )
sshow( "HEX_i max   ", pHEX_i( &hFFFFFFFFul ) )
sshow( "HEX_l max   ", pHEX_l( &hFFFFFFFFFFFFFFFFull ) )
sshow( "HEX_i 305441741", pHEX_i( 305441741 ) )
sshow( "HEX_l 305441741", pHEX_l( 305441741 ) )
sshow( "HEXEx_b 255,4", pHEXEx_b( 255, 4 ) )
sshow( "HEXEx_b 255,1", pHEXEx_b( 255, 1 ) )
sshow( "HEXEx_s 255,8", pHEXEx_s( 255, 8 ) )
sshow( "HEXEx_i 255,0", pHEXEx_i( 255, 0 ) )
sshow( "HEXEx_l 255,-3", pHEXEx_l( 255, -3 ) )
sshow( "HEXEx_l 0,5  ", pHEXEx_l( 0, 5 ) )

print "== OCT =="
sshow( "OCT_b 0     ", pOCT_b( 0 ) )
sshow( "OCT_b 255   ", pOCT_b( 255 ) )
sshow( "OCT_s 65535 ", pOCT_s( 65535 ) )
sshow( "OCT_i max   ", pOCT_i( &hFFFFFFFFul ) )
sshow( "OCT_l max   ", pOCT_l( &hFFFFFFFFFFFFFFFFull ) )
sshow( "OCTEx_b 255,2", pOCTEx_b( 255, 2 ) )
sshow( "OCTEx_l 8,6  ", pOCTEx_l( 8, 6 ) )

print "== BIN =="
sshow( "BIN_b 0     ", pBIN_b( 0 ) )
sshow( "BIN_b 255   ", pBIN_b( 255 ) )
sshow( "BIN_b 5     ", pBIN_b( 5 ) )
sshow( "BIN_s 65535 ", pBIN_s( 65535 ) )
sshow( "BIN_i max   ", pBIN_i( &hFFFFFFFFul ) )
sshow( "BIN_l max   ", pBIN_l( &hFFFFFFFFFFFFFFFFull ) )
sshow( "BINEx_b 5,8 ", pBINEx_b( 5, 8 ) )
sshow( "BINEx_b 255,3", pBINEx_b( 255, 3 ) )

'' THE POINTER FORMS ONCE PRINTED THE LENGTH OF A REAL ADDRESS, which measures
'' where the image loaded and not what the runtime does. fb_HEX_p STRIPS LEADING
'' ZEROS -- it does not pad to the host's natural width, which is what the
'' comment here used to claim and what would have made a length reproducible --
'' so HEX_p( @marker ) was 6 characters under fbc's MinGW link and 10 under the
'' MSVC one, and BIN_p 23 against 39. A real entry point measured by the wrong
'' property -- it fails when the linker moves and passes when the forward is
'' broken, which is backwards on both counts.
''
'' Two checks replace it, and both are reproducible on any host:
''
''   1. CONSTANT pointers, so the TEXT is compared rather than its length. These
''      exercise the width the length was reaching for -- a _p that forwarded to
''      the 32-bit routine truncates &hFFFFFFFFFFFFFFFF and shows up here.
''   2. That the _p form of a REAL address agrees with the _l form of THE SAME
''      BITS. That is the forward itself, checked at an address nobody can
''      predict, printing only the verdict.
dim as any ptr kp = cast( any ptr, &hDEADBEEFull )
dim as any ptr kq = cast( any ptr, &hFFFFFFFFFFFFFFFFull )
sshow( "HEX_p  const", pHEX_p( kp ) )
sshow( "HEX_p  wide ", pHEX_p( kq ) )
sshow( "HEXEx_p 4   ", pHEXEx_p( kp, 4 ) )
sshow( "HEXEx_p 20  ", pHEXEx_p( kp, 20 ) )
sshow( "OCT_p  const", pOCT_p( kp ) )
sshow( "OCT_p  wide ", pOCT_p( kq ) )
sshow( "OCTEx_p 6   ", pOCTEx_p( kp, 6 ) )
sshow( "BIN_p  const", pBIN_p( kp ) )
sshow( "BIN_p  wide ", pBIN_p( kq ) )
sshow( "BINEx_p 9   ", pBINEx_p( kp, 9 ) )

dim as integer marker = 0
dim as any ptr mp = @marker
dim as ulongint mv = cast( ulongint, mp )
ssame( "HEX_p  addr ", pHEX_p( mp ), pHEX_l( mv ) )
ssame( "HEXEx_p addr", pHEXEx_p( mp, 4 ), pHEXEx_l( mv, 4 ) )
ssame( "OCT_p  addr ", pOCT_p( mp ), pOCT_l( mv ) )
ssame( "OCTEx_p addr", pOCTEx_p( mp, 6 ), pOCTEx_l( mv, 6 ) )
ssame( "BIN_p  addr ", pBIN_p( mp ), pBIN_l( mv ) )
ssame( "BINEx_p addr", pBINEx_p( mp, 9 ), pBINEx_l( mv, 9 ) )

'' A NULL pointer has a value that IS reproducible.
sshow( "HEX_p NULL  ", pHEX_p( 0 ) )
sshow( "BIN_p NULL  ", pBIN_p( 0 ) )
