'' abtest-cls.bas -- A/B for CLS against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' CLS always operates on the SCREEN -- gfxlib2 calls fb_hPrepareTarget with a
'' NULL target regardless of what was passed -- so these cases draw to the screen
'' and digest through SCREENPTR.
''
'' Two things are checked per case:
''
''   1. WHICH PIXELS WERE CLEARED. The screen is pre-filled with a pattern, so a
''      mode that clears too much or too little is visible in the digest.
''   2. WHERE THE GRAPHICS CURSOR ENDED UP. CLS moves it to the centre of the
''      viewport, and that is observable through a subsequent LINE -STEP. A CLS
''      that clears correctly but forgets the cursor passes a pixel-only check
''      and then puts the next relative draw in the wrong place.
''
'' The cursor check is the reason this file exists as more than four digests.

#include once "../raster/cls.bi"
#include once "../raster/line.bi"
#include once "../raster/box.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 96
const H = 72
const BG = &hFF000000
const PAT = &hFF3070B0
const MARK = &hFFFFFFFF

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
dim as any ptr fb_ = screenptr( )
dim as long sw, sh, sd, sb, sp_, sr
screeninfo sw, sh, sd, sb, sp_, sr
dim as integer pitch = sp_

'' viewport per case (-1 = none), and the CLS mode
dim as long cvx1(...)  = { -1, -1, 10, 10, 20, 20,  0, 30 }
dim as long cvy1(...)  = { -1, -1,  8,  8, 15, 15,  0, 20 }
dim as long cvx2(...)  = { -1, -1, 80, 80, 70, 70, 95, 90 }
dim as long cvy2(...)  = { -1, -1, 60, 60, 55, 55, 71, 65 }
dim as long cmode(...) = {  0, -1,  0,  1, -1,  1, -1, 1 }   '' -1 = CLS with no arg

dim as string report
dim as long failures = 0
dim as long ran = 0

for i as integer = 0 to ubound( cvx1 )
    '' ---- A: gfxlib2 ----
    view screen (0,0)-(W-1,H-1)
    window
    '' pre-fill with a pattern so a wrong extent is visible
    line (0,0)-(W-1,H-1), PAT, BF
    if cvx1(i) >= 0 then view (cvx1(i), cvy1(i))-(cvx2(i), cvy2(i))
    if cmode(i) < 0 then
        cls
    else
        cls cmode(i)
    end if
    '' show where the cursor ended up: a short relative line from it
    line -step(6,0), MARK
    dim as ulongint ha = Digest( fb_, pitch )

    '' ---- B: libtkogfx ----
    dim as any ptr mine = allocate( pitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, pitch, 4 )
    dim as Viewport vp
    ViewportInit( vp, W, H )
    LineBox32( s, 0, 0, W - 1, H - 1, PAT, 1 )
    if cvx1(i) >= 0 then ViewSet( vp, s, cvx1(i), cvy1(i), cvx2(i), cvy2(i), 0 )
    dim as single cx = 0, cy = 0
    dim as long m = cmode(i)
    if m < 0 then m = CLS_DEFAULT
    Cls32( s, vp, m, BG, cx, cy )
    '' gfxlib2 stores `view_x + view_w \ 2` into last_x, which is the LOGICAL
    '' cursor -- so a following LINE -STEP translates it again and adds view_x a
    '' SECOND time. Drawing in physical coordinates here would be the sensible
    '' thing and would not match. Go through the transform, as the statement does.
    dim as long p1x, p1y, p2x, p2y
    TranslateCoord( vp, cx, cy, p1x, p1y )
    TranslateCoord( vp, cx + 6.0, cy, p2x, p2y )
    DrawLine32( s, p1x, p1y, p2x, p2y, MARK )
    dim as ulongint hb = Digest( mine, pitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH case " + str(i) + " mode " + str( cmode(i) ) + _
                  iif( cvx1(i) >= 0, " (viewport)", " (no viewport)" ) + chr(10)
        failures += 1
    end if
    deallocate( mine )
next

screen 0

print "abtest-cls -- "; ran; " CLS cases against gfxlib2, 32bpp "; W; "x"; H
if failures = 0 then
    print "abtest-cls: PASS -- every case is pixel-identical"
    end 0
else
    print report;
    print "abtest-cls: FAIL -- "; failures; " of"; ran; " cases differ"
    end 1
end if
