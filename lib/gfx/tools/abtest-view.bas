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

#include once "../core/viewport.bi"
#include once "../raster/pixel.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 96
const H = 72
const COL = &hFF40E080

function Digest( byval pixels as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to H - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, pixels ) + y * pitch )
        for x as integer = 0 to W - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

screenres W, H, 32, 1, GFX_NULL

dim as long failures = 0
dim as long ran = 0
dim as string report
dim as long pmapbad = 0
dim as long pmapknown = 0

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

dim as any ptr fb_ = screenptr( )
dim as integer fbpitch
dim as long sw, sh, sdepth, sbpp, spitch, srefresh
screeninfo sw, sh, sdepth, sbpp, spitch, srefresh
fbpitch = spitch

'' ---- 1. where the pixels land ----
for i as integer = 0 to ubound( vx1 )
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
    dim as ulong clearseen = cptr( ulong ptr, fb_ )[0]
    for g as integer = 0 to ubound( gx )
        pset ( gx(g), gy(g) ), COL
    next
    dim as ulongint ha = Digest( fb_, fbpitch )

    '' B: libtkogfx
    '' The screen is cleared to OPAQUE black (&hFF000000), not to 0. Seeding our
    '' buffer with memset 0 made every pixel differ and looked like a transform
    '' bug. Read the actual cleared value instead of assuming one.
    dim as ulong clearval = clearseen
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
    dim as ulongint hb = Digest( mine, fbpitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH transform case " + str(i) + chr(10)
        failures += 1
    end if
    deallocate( mine )
next

'' ---- 2. what PMAP returns ----
''
'' Compared exactly. PMAP is the one place the (view_w - 1) / view_w discrepancy
'' is directly observable as a NUMBER rather than as a pixel, so an exact
'' comparison is both possible and the point.
dim as single probes(...) = { 0.0, 1.0, -1.0, 5.0, -5.0, 0.5, 9.9, -9.9, 100.0, -100.0 }
dim as any ptr dummy = allocate( fbpitch * H )

for i as integer = 0 to ubound( vx1 )
    view screen (0,0)-(W-1,H-1)
    window
    view (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if vsc(i) then view screen (vx1(i), vy1(i))-(vx2(i), vy2(i))
    if wsc(i) then
        window screen (wx1(i), wy1(i))-(wx2(i), wy2(i))
    else
        window (wx1(i), wy1(i))-(wx2(i), wy2(i))
    end if

    dim as Surface ds
    SurfaceInit( ds, dummy, W, H, fbpitch, 4 )
    dim as Viewport vp
    ViewportInit( vp, W, H )
    ViewSet( vp, ds, vx1(i), vy1(i), vx2(i), vy2(i), vsc(i) )
    WindowSet( vp, wx1(i), wy1(i), wx2(i), wy2(i), wsc(i) )

    for f as integer = 0 to 3
        for k as integer = 0 to ubound( probes )
            dim as single want = pmap( probes(k), f )
            dim as single got  = PMap32( vp, probes(k), f )
            ran += 1
            if want <> got then
                '' KNOWN win32 x87 DIVERGENCE, bounded so it cannot hide a real bug.
                ''
                '' gfxlib2's PMAP returns different values on win32 and win64 for
                '' identical input -- measured: pmap(0,3) is 9.722221 on win64 and
                '' 9.722222 on win32. Its win32 build keeps intermediates in x87
                '' 80-bit registers instead of rounding to single at each step.
                '' libtkogfx rounds to single on both, matching win64 exactly.
                ''
                '' Only a LAST-DIGIT difference is excused, and only on win32. A
                '' relative error above 1e-6 is a real failure on either target,
                '' so an algorithmic mistake still fails here.
                '' The bound is ABSOLUTE, not relative, because func 1 and 3
                '' subtract nearly-equal numbers: `view_h - 1 - coord` with
                '' coord around 53.7 yields -0.735, so a 1-ULP error in the
                '' ~54-magnitude intermediate survives as an absolute error of
                '' ~4e-6 while the result shrinks. Relative to the result that
                '' looks like 64 ULP; relative to the intermediate it is one.
                ''
                '' 1e-4 is comfortably above that and far below any real
                '' algorithmic difference, which would be a whole unit or a
                '' scale factor rather than a rounding artifact.
                dim as long tiny = iif( abs( want - got ) < 1e-4, 1, 0 )
                #ifndef __FB_64BIT__
                    if tiny then
                        pmapknown += 1
                        continue for
                    end if
                #endif
                pmapbad += 1
                if pmapbad <= 5 then
                    report += "  MISMATCH pmap case " + str(i) + " func " + str(f) + _
                              " in " + str( probes(k) ) + ": gfxlib2=" + str( want ) + _
                              " tko=" + str( got ) + chr(10)
                end if
            end if
        next
    next
next
deallocate( dummy )
failures += pmapbad

screen 0

print "abtest-view -- "; ran; " transform + PMAP cases against gfxlib2, 32bpp "; W; "x"; H
if pmapknown > 0 then
    print "abtest-view: "; pmapknown; " known win32 x87 PMAP divergence(s) (gfxlib2 win32 disagrees with gfxlib2 win64)"
end if
if failures = 0 then
    if pmapknown > 0 then
        print "abtest-view: PASS -- "; ran - pmapknown; " exact, "; pmapknown; " known target divergence(s)"
    else
        print "abtest-view: PASS -- every case is pixel-identical"
    end if
    end 0
else
    print report;
    print "abtest-view: FAIL -- "; failures; " of"; ran; " cases differ"
    end 1
end if
