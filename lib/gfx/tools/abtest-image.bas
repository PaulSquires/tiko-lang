'' abtest-image.bas -- CROSS-LIBRARY BUFFER INTERCHANGE.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' This is the test D2 exists for. Everything else compares pixels drawn by two
'' libraries into two separate buffers; this hands ONE buffer between them.
''
'' Four directions, and each catches a different kind of mistake:
''
''   1. OURS -> gfxlib2 READS.  We allocate and fill an image; gfxlib2's PUT
''      draws it. Catches a wrong header field, a wrong pitch, or pixels at the
''      wrong offset.
''   2. gfxlib2 -> WE READ.     IMAGECREATE makes it, we read it through
''      SurfaceFromImage and digest. Catches the same things in reverse.
''   3. gfxlib2 -> WE WRITE -> gfxlib2 READS. We draw into THEIR buffer and they
''      display it. Catches a pitch assumption that happens to hold for our own
''      allocations but not theirs.
''   4. IMAGEINFO agreement. What they report about our image, field by field.
''
'' Direction 3 is the one that would fail if we assumed pitch = width * bpp:
'' our own allocator pads the same way, so directions 1 and 2 would still pass.
''
'' Ownership does NOT cross -- each image is destroyed by whichever library
'' allocated it.

#include once "../core/image.bi"
#include once "../raster/box.bi"
#include once "../raster/line.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const SW = 96
const SH = 72

function Digest( byval pixels as any ptr, byval pitch as integer, _
                 byval w as long, byval h as long ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to h - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, pixels ) + y * pitch )
        for x as integer = 0 to w - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

'' Paint a recognisable, asymmetric pattern into a Surface.
sub FillPattern( byref s as Surface )
    LineBox32( s, 0, 0, s.w - 1, s.h - 1, &hFF203040, 1 )
    LineBox32( s, 1, 1, s.w - 3, s.h - 4, &hFFC02010, 0 )
    DrawLine32( s, 0, 0, s.w - 1, s.h - 1, &hFF00FF80 )
    DrawLine32( s, 0, s.h - 1, s.w - 1, 0, &hFFFFFF00 )
    for i as integer = 0 to s.h - 1 step 3
        DrawLine32( s, 0, i, i mod s.w, i, &hFF4080FF )
    next
end sub

screenres SW, SH, 32, 1, GFX_NULL

dim as string report
dim as long failures = 0
dim as long ran = 0

'' widths chosen so pitch padding actually differs from width * bpp for 8bpp,
'' and sizes that are not multiples of anything convenient
dim as long ws(...) = { 17, 32, 33, 40, 63, 64 }
dim as long hs(...) = { 11, 16, 24, 24, 40, 48 }

'' ---- 0. our pitch must equal the one gfxlib2 picks ----
''
'' The check the first version of this file LACKED. Every other direction reads
'' the pitch out of the header, so a self-consistent wrong value passes them all;
'' padding to 4 bytes instead of 16 went undetected through 24 checks.
for bi as integer = 0 to 2
    dim as long depth = iif( bi = 0, 8, iif( bi = 1, 16, 32 ) )
    dim as long bpp = iif( bi = 0, 1, iif( bi = 1, 2, 4 ) )
    for w as integer = 1 to 40
        dim as any ptr im = imagecreate( w, 4, 0, depth )
        if im = 0 then continue for
        dim as integer iw, ih, ib, ip
        dim as any ptr dd
        imageinfo( im, iw, ih, ib, ip, dd )
        imagedestroy( im )
        ran += 1
        if ip <> ImagePitch( w, bpp ) then
            report += "  MISMATCH pitch depth " + str(depth) + " w=" + str(w) + _
                      ": gfxlib2=" + str(ip) + " tko=" + str( ImagePitch( w, bpp ) ) + chr(10)
            failures += 1
        end if
    next
next

for i as integer = 0 to ubound( ws )
    dim as long w = ws(i), h = hs(i)

    '' ---- 1. ours -> gfxlib2 reads ----
    dim as TkoAbi.PUT_HEADER ptr mine = TkoImageNew( w, h, 4 )
    if mine = 0 then
        report += "  ImageCreate failed for " + str(w) + "x" + str(h) + chr(10)
        failures += 1
        continue for
    end if
    dim as Surface ms
    SurfaceFromImage( ms, mine )
    FillPattern( ms )

    cls
    put ( 4, 4 ), mine, PSET
    dim as ulongint after_ours = Digest( screenptr( ), SW * 4, SW, SH )

    '' the same content in a gfxlib2 image, drawn the same way
    dim as any ptr theirs = imagecreate( w, h, 0, 32 )
    dim as integer tw, th, tbpp, tpitch
    dim as any ptr tdata
    imageinfo( theirs, tw, th, tbpp, tpitch, tdata )
    dim as Surface ts
    SurfaceInit( ts, tdata, w, h, tpitch, 4 )
    FillPattern( ts )

    cls
    put ( 4, 4 ), theirs, PSET
    dim as ulongint after_theirs = Digest( screenptr( ), SW * 4, SW, SH )

    ran += 1
    if after_ours <> after_theirs then
        report += "  MISMATCH dir1 (gfxlib2 PUT of OUR image) " + str(w) + "x" + str(h) + chr(10)
        failures += 1
    end if

    '' ---- 2. gfxlib2's image, read by us ----
    dim as ulongint theirs_by_us = Digest( tdata, tpitch, w, h )
    dim as ulongint ours_by_us = Digest( TkoImagePixels( mine ), mine->pitch, w, h )
    ran += 1
    if theirs_by_us <> ours_by_us then
        report += "  MISMATCH dir2 (we read both buffers) " + str(w) + "x" + str(h) + chr(10)
        failures += 1
    end if

    '' ---- 3. we WRITE into THEIR buffer, they display it ----
    memset( tdata, 0, tpitch * h )
    dim as Surface ts2
    SurfaceInit( ts2, tdata, w, h, tpitch, 4 )
    FillPattern( ts2 )
    cls
    put ( 4, 4 ), theirs, PSET
    dim as ulongint written_by_us = Digest( screenptr( ), SW * 4, SW, SH )
    ran += 1
    if written_by_us <> after_theirs then
        report += "  MISMATCH dir3 (we wrote THEIR buffer) " + str(w) + "x" + str(h) + chr(10)
        failures += 1
    end if

    '' ---- 4. IMAGEINFO agreement on OUR image ----
    dim as integer gw, gh, gbpp, gpitch
    dim as any ptr gdata
    dim as long rc = imageinfo( mine, gw, gh, gbpp, gpitch, gdata )
    ran += 1
    if (rc <> 0) orelse (gw <> w) orelse (gh <> h) orelse (gbpp <> 4) orelse _
       (gpitch <> mine->pitch) orelse (gdata <> TkoImagePixels( mine )) then
        report += "  MISMATCH dir4 IMAGEINFO on our " + str(w) + "x" + str(h) + _
                  ": rc=" + str(rc) + " w=" + str(gw) + " h=" + str(gh) + _
                  " bpp=" + str(gbpp) + " pitch=" + str(gpitch) + _
                  " (ours pitch=" + str(mine->pitch) + ")" + chr(10)
        failures += 1
    end if

    imagedestroy( theirs )      '' theirs frees theirs
    TkoImageFree( mine )        '' ours frees ours
next

screen 0

print "abtest-image -- "; ran; " cross-library interchange checks against gfxlib2"
if failures = 0 then
    print "abtest-image: PASS -- buffers are interchangeable in both directions"
    end 0
else
    print report;
    print "abtest-image: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
