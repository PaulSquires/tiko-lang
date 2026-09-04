'' abtest-bpp.bas -- A/B for the 8 and 16 bpp pixel paths against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Every A/B so far has been 32bpp. This one exercises the generated 8 and 16 bpp
'' paths, where the interesting questions are not geometry but STORAGE:
''
''   - does a colour value get truncated to the element width the same way?
''     gfxlib2 masks through fb_hFixColor; an 8bpp PSET of &h1FF must land as the
''     same byte in both.
''   - is the row stride honoured? An 8bpp image's pitch is NOT its width --
''     gfxlib2 pads rows, so writing at `row[x]` with the wrong element type
''     shears the image rather than corrupting one pixel.
''   - does POINT read back what PSET wrote, at each width?
''
'' The digest walks w*h ELEMENTS of the right width, not bytes, so a stride bug
'' shows up as a mismatch rather than as padding noise.
''
'' A gfxlib2 DEFECT THIS HARNESS FOUND, and has to work around:
''
''   IMAGECREATE'S FILL USES THE WRONG ELEMENT WIDTH. gfx_image.c does
''       context->pixel_set(data, color, (pitch * height) / bpp)
''   where pixel_set is bound to the LAST DRAWING TARGET's depth but the count
''   is computed from the NEW image's bpp. Create an image of a different depth
''   than the last thing you drew to and the fill is wrong:
''
''     last target 8bpp  -> imagecreate(16bpp): 173 of 1920 bytes left stale
''     last target 8bpp  -> imagecreate(32bpp): 172 of 3840 bytes left stale
''     last target 16bpp -> imagecreate(32bpp):  13 of 3840 bytes left stale
''     last target 32bpp -> imagecreate(16bpp): writes 3840 bytes into 1920
''                                              -- a heap overrun; crashed once
''
''   The under-fill is deterministic; the overrun's consequences are heap-layout
''   dependent, which is why it is easy to miss. Every image here is therefore
''   cleared with an explicit LINE BF after creation rather than trusting the
''   colour argument.
''
''   A SECOND, WORSE ONE -- STALE TARGET ALIASING. fb_hPrepareTarget begins
''
''       if (target != context->last_target) { ...rebind everything... }
''
''   and IMAGEDESTROY never clears last_target. So destroy an image, create one
''   of a DIFFERENT DEPTH that the allocator places at the same address, and
''   drawing to it skips the rebind entirely: it keeps the previous image's
''   pixel width, pitch and dimensions.
''
''   Measured: after an 8bpp pass, PSET of &hABCDEF into a 16bpp image wrote the
''   single byte &hEF at byte offsets (reading back as 00EF and EF00) instead of
''   the RGB565 value &hAE7D. 350 of 960 pixels wrong.
''
''   libtkogfx does NOT reproduce this. Matching it would mean deliberately
''   honouring a dangling pointer. Each iteration here touches the SCREEN first,
''   which sets last_target to NULL and forces gfxlib2 to rebind.

#include once "../raster/pixelfmt.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 40
const H = 24

function Digest8( byval p as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to H - 1
        dim as ubyte ptr row = cptr( ubyte ptr, p ) + y * pitch
        for x as integer = 0 to W - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

function Digest16( byval p as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to H - 1
        dim as ushort ptr row = cptr( ushort ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to W - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

screenres 320, 200, 8, 1, GFX_NULL

dim as string report
dim as long failures = 0
dim as long ran = 0

'' colour values chosen to overflow each element width
dim as ulong cols(...) = { 0, 1, 15, 255, 256, &h1FF, &hFFFF, &h1FFFF, &hABCDEF, &hFFFFFFFF }

'' ---- 8 bpp ----
for c as integer = 0 to ubound( cols )
    '' Reset gfxlib2's last_target so it cannot alias a recycled block -- see
    '' the STALE TARGET ALIASING note above.
    pset ( 0, 0 ), 0
    dim as any ptr img = imagecreate( W, H, 0, 8 )
    if img = 0 then continue for
    dim as integer iw, ih, ibpp, ipitch
    dim as any ptr idata
    imageinfo( img, iw, ih, ibpp, ipitch, idata )
    '' MUST clear explicitly -- imagecreate's own fill is unreliable across
    '' depths. See the header note. Drawing into the image first also binds the
    '' context to it, so this LINE BF is correct where imagecreate's was not.
    line img, (0, 0)-(W - 1, H - 1), 0, BF

    for k as integer = 0 to 11
        pset img, ( k * 3, k * 2 ), cols(c)
    next
    line img, (4, 14)-(35, 20), cols(c), BF
    dim as ulongint ha = Digest8( idata, ipitch )

    dim as any ptr mine = allocate( ipitch * H )
    memset( mine, 0, ipitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, ipitch, 1 )
    for k as integer = 0 to 11
        PSet8( s, k * 3, k * 2, FixColor( 1, cols(c) ) )
    next
    FillRect8( s, 4, 14, 35, 20, FixColor( 1, cols(c) ) )
    dim as ulongint hb = Digest8( mine, ipitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH 8bpp colour &h" + hex( cols(c) ) + chr(10)
        failures += 1
    end if
    deallocate( mine )
    imagedestroy( img )
next

'' ---- 16 bpp ----
for c as integer = 0 to ubound( cols )
    pset ( 0, 0 ), 0
    dim as any ptr img = imagecreate( W, H, 0, 16 )
    if img = 0 then continue for
    dim as integer iw, ih, ibpp, ipitch
    dim as any ptr idata
    imageinfo( img, iw, ih, ibpp, ipitch, idata )
    '' MUST clear explicitly -- imagecreate's own fill is unreliable across
    '' depths. See the header note. Drawing into the image first also binds the
    '' context to it, so this LINE BF is correct where imagecreate's was not.
    line img, (0, 0)-(W - 1, H - 1), 0, BF

    for k as integer = 0 to 11
        pset img, ( k * 3, k * 2 ), cols(c)
    next
    line img, (4, 14)-(35, 20), cols(c), BF
    dim as ulongint ha = Digest16( idata, ipitch )

    dim as any ptr mine = allocate( ipitch * H )
    memset( mine, 0, ipitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, ipitch, 2 )
    for k as integer = 0 to 11
        PSet16( s, k * 3, k * 2, FixColor( 2, cols(c) ) )
    next
    FillRect16( s, 4, 14, 35, 20, FixColor( 2, cols(c) ) )
    dim as ulongint hb = Digest16( mine, ipitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH 16bpp colour &h" + hex( cols(c) ) + chr(10)
        failures += 1
    end if
    deallocate( mine )
    imagedestroy( img )
next

'' ---- POINT reads back what PSET wrote, at each width ----
dim as long roundtripbad = 0
for depth as integer = 0 to 1
    dim as long bpp = iif( depth = 0, 1, 2 )
    dim as any ptr buf = allocate( W * bpp * H )
    memset( buf, 0, W * bpp * H )
    dim as Surface s
    SurfaceInit( s, buf, W, H, W * bpp, bpp )
    for c as integer = 0 to ubound( cols )
        dim as long px = (c * 3) mod W
        dim as long py = (c * 2) mod H
        dim as ulong masked = FixColor( bpp, cols(c) )
        if bpp = 1 then
            PSet8( s, px, py, masked )
            if Point8( s, px, py ) <> cast( long, masked ) then roundtripbad += 1
        else
            PSet16( s, px, py, masked )
            if Point16( s, px, py ) <> cast( long, masked ) then roundtripbad += 1
        end if
        ran += 1
    next
    '' POINT outside the clip box must be -1 at every width
    if bpp = 1 then
        if Point8( s, -1, 0 ) <> -1 then roundtripbad += 1
    else
        if Point16( s, -1, 0 ) <> -1 then roundtripbad += 1
    end if
    ran += 1
    deallocate( buf )
next
if roundtripbad > 0 then
    report += "  MISMATCH " + str( roundtripbad ) + " POINT round-trip(s)" + chr(10)
    failures += roundtripbad
end if

screen 0

print "abtest-bpp -- "; ran; " cases across 8 and 16 bpp against gfxlib2"
if failures = 0 then
    print "abtest-bpp: PASS -- every case is pixel-identical"
    end 0
else
    print report;
    print "abtest-bpp: FAIL -- "; failures; " of"; ran; " cases differ"
    end 1
end if
