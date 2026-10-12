'' abtest-view.bas -- A/B for VIEW, WINDOW, PMAP and the coordinate transform.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Two things are compared, because they are observable independently:
''
''   1. WHERE A PIXEL LANDS. VIEW/WINDOW apply to the SCREEN context, not to an
''      image target, so these cases draw to the screen and digest the
''      framebuffer through SCREENPTR rather than using IMAGECREATE.
''   2. WHAT PMAP RETURNS. Compared as floats, exactly.
''
'' They are checked separately on purpose. gfxlib2 scales by (view_w - 1) in the
'' transform and by view_w in PMAP, so PMAP does NOT invert PSET. A harness that
'' only checked round-trips would hide that; checking both against the reference
'' pins each one where it actually is.

#include once "../core/viewport.ti"
#include once "../raster/pixel.ti"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

const W = 96
const H = 72
const COL = &hFF40E080

'' A SINGLE compared through its bit pattern, so the comparison is exact and a
'' recording can carry it. PMAP returns a single and the whole point of this
'' file is that the last digit matters.
function Bits( byval v as single ) as ulongint
    return cast( ulongint, *cptr( ulong ptr, @v ) )
end function

dim as integer fbpitch = W * 4
#ifdef ABTEST_HAS_GFXLIB2
screenres W, H, 32, 1, GFX_NULL
dim as any ptr fb_ = screenptr( )
dim as long sw, sh, sdepth, sbpp, spitch, srefresh
screeninfo sw, sh, sdepth, sbpp, spitch, srefresh
fbpitch = spitch
#endif

Abtest.Begin( "abtest-view", "every case is pixel-identical" )

'' A grid of logical coordinates, plotted under each VIEW/WINDOW combination.
dim as single gx(...) = { 0.0, 1.0, -1.0, 0.5, -0.5, 2.0, -2.0, 0.25, 10.0, -10.0, 3.3, -7.7 }
dim as single gy(...) = { 0.0, 1.0, -1.0, 0.5, -0.5, 2.0, -2.0, 0.25, 10.0, -10.0, 3.3, -7.7 }

'' vx1,vy1,vx2,vy2, view_screen, wx1,wy1,wx2,wy2, win_screen
dim as long   vx1(...) = {  0, 10, 10, 20,  0, 30,  5,  0, 10 }
dim as long   vy1(...) = {  0,  8,  8, 15,  0, 20,  5,  0,  8 }
dim as long   vx2(...) = { 95, 80, 80, 70, 95, 90, 90, 95, 80 }
dim as long   vy2(...) = { 71, 60, 60, 55, 71, 65, 65, 71, 60 }
dim as long   vsc(...) = {  0,  0,  1,  0,  0,  1,  0,  0,  1 }
dim as single wx1(...) = { -10.0, -10.0, -10.0, 0.0, 0.0, -5.0, -1.0, -100.0, -10.0 }
dim as single wy1(...) = { -10.0, -10.0, -10.0, 0.0, 0.0, -5.0, -1.0, -100.0, -10.0 }
dim as single wx2(...) = {  10.0,  10.0,  10.0, 0.0, 20.0, 5.0,  1.0,  100.0,  10.0 }
dim as single wy2(...) = {  10.0,  10.0,  10.0, 0.0, 20.0, 5.0,  1.0,  100.0,  10.0 }
dim as long   wsc(...) = {  0,  0,  0,  0,  1,  0,  1,  0,  1 }

'' ---- 1. where the pixels land ----
for i as integer = 0 to ubound( vx1 )
    dim as ulongint ha, hb
    dim as ulong clearseen = 0

#ifdef ABTEST_HAS_GFXLIB2
    '' A: gfxlib2 on the screen
    view screen (0,0)-(W-1,H-1)
    window
    cls
    view (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if vsc(i) then view screen (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if wsc(i) then
        window screen (wx1(i), wy1(i))-(wx2(i), wy2(i))
    else
        window (wx1(i), wy1(i))-(wx2(i), wy2(i))
    end if
    clearseen = cptr( ulong ptr, fb_ )[0]
    for g as integer = 0 to ubound( gx )
        pset ( gx(g), gy(g) ), COL
    next
    ha = Abtest.Digest( fb_, W, H, fbpitch )
#endif

    '' B: libtkogfx
    '' The screen is cleared to OPAQUE black (&hFF000000), not to 0. Seeding our
    '' buffer with memset 0 made every pixel differ and looked like a transform
    '' bug. Read the actual cleared value instead of assuming one -- and with no
    '' screen to read it from, take it from the recording rather than guessing.
    dim as ulong clearval = cast( ulong, Abtest.Datum_( "clear value case " + str(i), clearseen ) )
    dim as any ptr mine = allocate( fbpitch * H )
    for cy as integer = 0 to H - 1
        dim as ulong ptr crow = cptr( ulong ptr, cptr( ubyte ptr, mine ) + cy * fbpitch )
        for cx as integer = 0 to W - 1
            crow[cx] = clearval
        next
    next
    dim as Surface s
    SurfaceInit( s, mine, W, H, fbpitch, 4 )
    dim as Viewport vp
    ViewportInit( vp, W, H )
    ViewSet( vp, s, vx1(i), vy1(i), vx2(i), vy2(i), vsc(i) )
    WindowSet( vp, wx1(i), wy1(i), wx2(i), wy2(i), wsc(i) )
    for g as integer = 0 to ubound( gx )
        dim as long px, py
        TranslateCoord( vp, gx(g), gy(g), px, py )
        PSet32( s, px, py, COL )
    next
    hb = Abtest.Digest( mine, W, H, fbpitch )
    deallocate( mine )

    Abtest.Case_( "transform case " + str(i), ha, hb )
next

'' ---- 2. what PMAP returns ----
''
'' Compared exactly. PMAP is the one place the (view_w - 1) / view_w discrepancy
'' is directly observable as a NUMBER rather than as a pixel, so an exact
'' comparison is both possible and the point.
dim as single probes(...) = { 0.0, 1.0, -1.0, 5.0, -5.0, 0.5, 9.9, -9.9, 100.0, -100.0 }
dim as any ptr dummy = allocate( fbpitch * H )

for i as integer = 0 to ubound( vx1 )
#ifdef ABTEST_HAS_GFXLIB2
    view screen (0,0)-(W-1,H-1)
    window
    view (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if vsc(i) then view screen (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if wsc(i) then
        window screen (wx1(i), wy1(i))-(wx2(i), wy2(i))
    else
        window (wx1(i), wy1(i))-(wx2(i), wy2(i))
    end if
#endif

    dim as Surface ds
    SurfaceInit( ds, dummy, W, H, fbpitch, 4 )
    dim as Viewport vp
    ViewportInit( vp, W, H )
    ViewSet( vp, ds, vx1(i), vy1(i), vx2(i), vy2(i), vsc(i) )
    WindowSet( vp, wx1(i), wy1(i), wx2(i), wy2(i), wsc(i) )

    for f as integer = 0 to 3
        for k as integer = 0 to ubound( probes )
            dim as string tag = "pmap case " + str(i) + " func " + str(f) + _
                                " in " + str( probes(k) )
            dim as single want = 0
            want = REF( pmap( probes(k), f ) )
            dim as single got  = PMap32( vp, probes(k), f )

            '' KNOWN win32 x87 DIVERGENCE, bounded so it cannot hide a real bug.
            ''
            '' gfxlib2's PMAP returns different values on win32 and win64 for
            '' identical input -- measured: pmap(0,3) is 9.722221 on win64 and
            '' 9.722222 on win32. Its win32 build keeps intermediates in x87
            '' 80-bit registers instead of rounding to single at each step.
            '' libtkogfx rounds to single on both, matching win64 exactly.
            ''
            '' Only a LAST-DIGIT difference is excused, and only on win32. A
            '' difference above 1e-4 is a real failure on either target, so an
            '' algorithmic mistake still fails here.
            '' The bound is ABSOLUTE, not relative, because func 1 and 3
            '' subtract nearly-equal numbers: `view_h - 1 - coord` with
            '' coord around 53.7 yields -0.735, so a 1-ULP error in the
            '' ~54-magnitude intermediate survives as an absolute error of
            '' ~4e-6 while the result shrinks. Relative to the result that
            '' looks like 64 ULP; relative to the intermediate it is one.
#ifndef __FB_64BIT__
            if (want <> got) andalso (abs( want - got ) < 1e-4) then
                Abtest.Known_( tag, Bits( want ), Bits( got ), _
                    "gfxlib2 win32 PMAP disagrees with gfxlib2 win64 in the last digit" )
                continue for
            end if
#endif
            Abtest.Case_( tag, Bits( want ), Bits( got ), _
                          "gfxlib2=" + str( want ) + " tko=" + str( got ) )
        next
    next
next
deallocate( dummy )

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
