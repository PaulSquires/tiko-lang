'' abtest-circle.bas -- pixel-exactness A/B for CIRCLE against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' CIRCLE is the most float-dependent primitive so far, so the cases sweep radii
'' rather than picking a few: consecutive integer radii walk the Bresenham
'' decision variable through every phase, and fractional radii exercise the
'' float-to-int truncation that FreeBASIC would otherwise round.
''
'' Aspect ratios cover both branches (>1 shrinks the horizontal radius, <=1 the
'' vertical) and the exact 1.0 boundary between them.
''
'' Clipped cases matter more here than for lines: the fill path keeps a per-row
'' `filled` flag indexed relative to the clip box, so an off-centre circle that
'' hangs off an edge is where an indexing error shows up.

#include once "../raster/circle.ti"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

const W = 80
const H = 64
const COL = &hFFE0A030

#ifdef ABTEST_HAS_GFXLIB2
screenres W, H, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-circle", "every case is pixel-identical" )

'' cx, cy, radius, aspect, fill
dim as long   px(...)  = { 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 20, 60, 40, 40,  0, 79, 40, 40, 10, 70 }
dim as long   py(...)  = { 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 10, 54, 32, 32,  0, 63, 32, 32 }
dim as single pr(...)  = { 1.0, 2.0, 3.0, 4.0, 5.0, 7.0, 11.0, 16.0, 25.0, 2.5, 7.5, 12.3, 15.0, 15.0, 20.0, 20.0, 18.0, 18.0, 22.0, 22.0, 30.0, 30.0 }

'' aspect sweep applied to a fixed radius, both branches plus the boundary
dim as single asp(...) = { 0.25, 0.5, 0.75, 1.0, 1.25, 2.0, 3.0, 0.1, 5.0 }

for fill as integer = 0 to 1
    '' ---- radius / position sweep ----
    for i as integer = 0 to ubound( px )
        dim as string tag = iif( fill, "F ", "  " ) + "r=" + str( pr(i) ) + _
                            " at (" + str( px(i) ) + "," + str( py(i) ) + ")"
        dim as ulongint ha, hb
        dim as integer ipitch = W * 4

#ifdef ABTEST_HAS_GFXLIB2
        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then
            Abtest.Fail_( tag, "imagecreate FAILED" )
            continue for
        end if

        if fill then
            circle img, ( px(i), py(i) ), pr(i), COL, , , , F
        else
            circle img, ( px(i), py(i) ), pr(i), COL
        end if

        dim as integer iw, ih, ibpp
        dim as any ptr idata
        imageinfo( img, iw, ih, ibpp, ipitch, idata )
        ha = Abtest.Digest( idata, W, H, ipitch )
        imagedestroy( img )
#endif

        dim as any ptr mine = allocate( ipitch * H )
        memset( mine, 0, ipitch * H )
        dim as Surface s
        SurfaceInit( s, mine, W, H, ipitch, 4 )
        '' aspect 0 means "screen aspect"; for an image target gfxlib2 uses
        '' __fb_gfx->aspect, which for a square-pixel mode is 1.0
        Circle32( s, px(i), py(i), pr(i), COL, 1.0, fill )
        hb = Abtest.Digest( mine, W, H, ipitch )
        deallocate( mine )

        Abtest.Case_( tag, ha, hb )
    next

    '' ---- aspect sweep ----
    for i as integer = 0 to ubound( asp )
        dim as string tag = iif( fill, "F ", "  " ) + "aspect=" + str( asp(i) )
        dim as ulongint ha, hb
        dim as integer ipitch = W * 4

#ifdef ABTEST_HAS_GFXLIB2
        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then
            Abtest.Fail_( tag, "imagecreate FAILED" )
            continue for
        end if

        if fill then
            circle img, ( 40, 32 ), 20.0, COL, , , asp(i), F
        else
            circle img, ( 40, 32 ), 20.0, COL, , , asp(i)
        end if

        dim as integer iw, ih, ibpp
        dim as any ptr idata
        imageinfo( img, iw, ih, ibpp, ipitch, idata )
        ha = Abtest.Digest( idata, W, H, ipitch )
        imagedestroy( img )
#endif

        dim as any ptr mine = allocate( ipitch * H )
        memset( mine, 0, ipitch * H )
        dim as Surface s
        SurfaceInit( s, mine, W, H, ipitch, 4 )
        Circle32( s, 40, 32, 20.0, COL, asp(i), fill )
        hb = Abtest.Digest( mine, W, H, ipitch )
        deallocate( mine )

        Abtest.Case_( tag, ha, hb )
    next
next

'' ---- arcs: start/end angles, negative (radius line), and wrap-around ----
dim as single as1(...) = { 0.0,  0.0,  0.5,  1.0,  3.0,  0.0,  -0.5, -1.0,  2.0,  5.0,  1.0,  -0.7, 0.25, 4.0 }
dim as single ae1(...) = { 1.57, 3.14, 2.0,  4.0,  6.0,  0.5,  1.5,   2.0,  1.0,  1.0,  -3.0, -2.2, 6.0,  4.5 }

for fill as integer = 0 to 1
    for i as integer = 0 to ubound( as1 )
        dim as string tag = "arc " + iif( fill, "F ", "  " ) + _
                            str( as1(i) ) + ".." + str( ae1(i) )
        dim as ulongint ha, hb
        dim as integer ipitch = W * 4

#ifdef ABTEST_HAS_GFXLIB2
        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then
            Abtest.Fail_( tag, "imagecreate FAILED" )
            continue for
        end if

        '' gfxlib2 ignores F for an arc, but pass it both ways to prove we do too
        if fill then
            circle img, ( 40, 32 ), 22.0, COL, as1(i), ae1(i), , F
        else
            circle img, ( 40, 32 ), 22.0, COL, as1(i), ae1(i)
        end if

        dim as integer iw, ih, ibpp
        dim as any ptr idata
        imageinfo( img, iw, ih, ibpp, ipitch, idata )
        ha = Abtest.Digest( idata, W, H, ipitch )
        imagedestroy( img )
#endif

        dim as any ptr mine = allocate( ipitch * H )
        memset( mine, 0, ipitch * H )
        dim as Surface s
        SurfaceInit( s, mine, W, H, ipitch, 4 )
        Circle32( s, 40, 32, 22.0, COL, 1.0, fill, as1(i), ae1(i) )
        hb = Abtest.Digest( mine, W, H, ipitch )
        deallocate( mine )

        '' KNOWN TARGET-SPECIFIC DIVERGENCE, not a defect here.
        ''
        '' On win32 the reference itself is inconsistent: gfxlib2 draws 15
        '' points for arc 0..0.5 at r=22 on win32 and 14 on win64, from the
        '' same source and the same arguments. Its win32 build accumulates
        '' the angle in x87 registers at 80-bit precision instead of
        '' rounding to single each step, so the loop runs one iteration
        '' longer. libtkogfx rounds to single on both targets and draws 14
        '' on both -- matching win64 exactly and being self-consistent,
        '' which gfxlib2 is not.
#ifndef __FB_64BIT__
        if (as1(i) = 0.0) andalso (ae1(i) = 0.5) then
            Abtest.Known_( tag, ha, hb, _
                "gfxlib2 win32 disagrees with gfxlib2 win64 on this arc (x87 80-bit angle accumulation)" )
            continue for
        end if
#endif
        Abtest.Case_( tag, ha, hb )
    next
next

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
