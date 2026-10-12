'' abtest-box.bas -- pixel-exactness A/B for LINE B and LINE BF against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Same method as abtest-line.bas: gfxlib2 draws into an IMAGECREATE buffer, we
'' draw into an identical one, digests compared.
''
'' The cases target the outline case's per-edge gating, which is where an
'' obvious implementation diverges. A box hanging off the bottom of the viewport
'' must draw its top and sides and NO bottom -- not a bottom clamped up to the
'' clip boundary. Each of the four "one edge out" cases checks one of those, and
'' the "three edges out" cases check that the survivors still appear.
''
'' Also covered: fully outside, fully covering, degenerate boxes where the two
'' corners coincide or share a row/column, and reversed corners (which LINE
'' orders before drawing).
''
'' Split into roles like abtest-line.bas so the B side can be built for the
'' MSVC ABI, where libfbgfx.a cannot be linked. See abtest.bi.

#include once "../raster/box.ti"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

const W = 64
const H = 48
const COL = &hFF20C0FF

dim as string cname(...) = { _
    "inside", "inside tall", "inside wide", _
    "off bottom", "off top", "off left", "off right", _
    "off bottom-right", "off top-left", _
    "three out (top only in)", "three out (left only in)", _
    "covers all", "exactly full", _
    "degenerate point", "degenerate row", "degenerate col", _
    "reversed corners", "reversed x only", "reversed y only", _
    "fully outside", "one pixel in corner" }
dim as long bx1(...) = {  8, 20, 4, 10, 10, -20, 40, 40, -20, -20, 10, -30, 0, 31, 10, 20, 50, 50, 10, -90, 63 }
dim as long by1(...) = {  6, 4, 20, 20, -20, 10, 10, 30, -20, 10, -30, -30, 0, 23, 20, 4, 40, 10, 40, -90, 47 }
dim as long bx2(...) = { 40, 26, 60, 50, 50, 30, 90, 90, 30, 90, 30, 120, 63, 31, 40, 20, 10, 10, 40, -70, 90 }
dim as long by2(...) = { 30, 44, 26, 90, 30, 40, 40, 90, 30, 90, 30, 120, 47, 23, 20, 40, 10, 40, 10, -70, 90 }

#ifdef ABTEST_HAS_GFXLIB2
screenres W, H, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-box", "every case is pixel-identical" )

for mode as integer = 0 to 1          '' 0 = B (outline), 1 = BF (filled)
    for i as integer = 0 to ubound( cname )
        dim as string tag = iif( mode = 0, "B  ", "BF " ) + cname(i)
        dim as ulongint ha, hb
        dim as integer ipitch = W * 4

#ifdef ABTEST_HAS_GFXLIB2
        '' ---- A: gfxlib2 ----
        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then
            Abtest.Fail_( tag, "imagecreate FAILED" )
            continue for
        end if

        if mode = 0 then
            line img, ( bx1(i), by1(i) )-( bx2(i), by2(i) ), COL, B
        else
            line img, ( bx1(i), by1(i) )-( bx2(i), by2(i) ), COL, BF
        end if

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
        LineBox32( s, bx1(i), by1(i), bx2(i), by2(i), COL, mode )
        hb = Abtest.Digest( mine, W, H, ipitch )
        deallocate( mine )
#endif

        Abtest.Case_( tag, ha, hb )
    next
next

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
