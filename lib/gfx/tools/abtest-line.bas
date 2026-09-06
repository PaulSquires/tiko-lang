'' abtest-line.bas -- pixel-exactness A/B for LINE and PSET against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' The substitution harness in RFC-0001 swaps our object into libfbgfx.a. That
'' works, but it is not needed to compare RASTER OUTPUT, and waiting for it would
'' mean writing the whole rasterizer unverified. gfxlib2 will happily draw into
'' an IMAGECREATE buffer, so:
''
''   1. ask gfxlib2 to draw a case into an image
''   2. draw the same case ourselves into an identical buffer
''   3. digest both and compare
''
'' Same memory layout, same coordinates, same colour. Any difference is ours.
''
'' The cases are chosen to hit the places a Bresenham implementation can drift:
'' all eight octants, both gradients, exact diagonals, single points, axis-
'' aligned lines, reversed endpoints, and lines clipped on each edge and corner.
'' A line drawn right-to-left must produce the SAME pixels as left-to-right --
'' gfxlib2 swaps endpoints for axis-aligned lines but not for diagonals, which is
'' a real asymmetry worth pinning.
''
'' PRINT is routed into the framebuffer while a graphics screen is open, so all
'' reporting happens after SCREEN 0.
''
'' The A and B sides are separable -- see abtest.bi. Under -d ABTEST_SUT this
'' program never names gfxlib2 at all, which is what lets it be built for the
'' MSVC ABI, where libfbgfx.a cannot be linked.

#include once "../raster/line.bi"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

const W = 64
const H = 48
const COL = &hFFFF8040

dim as string cname(...) = { "horizontal", "horizontal rev", "vertical", "vertical rev", "diagonal 45", "diagonal 45 rev", "shallow +x+y", "shallow +x-y", "shallow -x+y", "shallow -x-y", "steep +x+y", "steep +x-y", "steep -x+y", "steep -x-y", "single point", "clip left", "clip right", "clip top", "clip bottom", "clip both x", "clip both y", "clip corner tl", "clip corner br", "fully outside", "steep clipped", "shallow clipped", "tie shallow dx4", "tie shallow dx8", "tie shallow dx12", "tie shallow neg", "tie steep dy4", "tie steep dy8", "tie steep dy12", "tie steep neg" }
dim as long cx1(...) = { 4, 59, 8, 12, 0, 47, 2, 2, 61, 61, 20, 30, 40, 46, 31, -40, 30, 10, 10, -50, 24, -30, 40, -90, 8, -80, 0, 0, 2, 14, 0, 2, 6, 12 }
dim as long cy1(...) = { 4, 9, 2, 45, 0, 47, 40, 46, 20, 26, 1, 46, 1, 46, 23, 10, 10, -40, 20, 24, -50, -20, 30, -90, -60, 12, 0, 2, 6, 12, 0, 0, 2, 14 }
dim as long cx2(...) = { 59, 4, 8, 12, 47, 0, 61, 61, 2, 2, 26, 36, 34, 40, 31, 30, 140, 30, 30, 150, 30, 20, 200, -70, 20, 200, 4, 8, 14, 2, 1, 6, 9, 9 }
dim as long cy2(...) = { 4, 9, 45, 2, 47, 0, 46, 40, 26, 20, 46, 1, 46, 1, 23, 30, 30, 30, 140, 30, 150, 20, 190, -70, 200, 18, 1, 4, 9, 9, 4, 8, 14, 2 }

#ifdef ABTEST_HAS_GFXLIB2
screenres W, H, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-line" )

for i as integer = 0 to ubound( cname )
    dim as ulongint ha, hb
    '' Only the gfxlib2 side has an opinion about pitch. Without it we pick the
    '' tightest one; Digest reads w pixels per row, so the two agree anyway.
    dim as integer ipitch = W * 4

#ifdef ABTEST_HAS_GFXLIB2
    '' ---- A: gfxlib2 ----
    dim as any ptr img = imagecreate( W, H, 0, 32 )
    if img = 0 then
        Abtest.Fail_( cname(i), "imagecreate FAILED" )
        continue for
    end if
    line img, ( cx1(i), cy1(i) )-( cx2(i), cy2(i) ), COL

    dim as integer iw, ih, ibpp
    dim as any ptr idata
    imageinfo( img, iw, ih, ibpp, ipitch, idata )
    ha = Abtest.Digest( idata, W, H, ipitch )
    imagedestroy( img )
#endif

#ifndef ABTEST_EMIT
    '' ---- B: libtkogfx ----
    dim as any ptr mine = allocate( ipitch * H )
    memset( mine, 0, ipitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, ipitch, 4 )
    DrawLine32( s, cx1(i), cy1(i), cx2(i), cy2(i), COL )
    hb = Abtest.Digest( mine, W, H, ipitch )
    deallocate( mine )
#endif

    Abtest.Case_( cname(i), ha, hb )
next

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
