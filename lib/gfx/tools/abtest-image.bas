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

#include once "../core/image.ti"
#include once "../raster/box.ti"
#include once "../raster/line.ti"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif
#include once "crt/string.bi"

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

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

'' Split into roles (abtest.bi). Section 0 -- that our pitch equals the one
'' gfxlib2 picks -- is an ordinary comparison and runs everywhere. Sections 1
'' to 4 are the reason this file exists and are NOT splittable: each of them
'' hands a buffer ONE library made to the OTHER library at run time, and no
'' recording can stand in for a gfxlib2 that has to be present to read it.
'' They are Interop_, so they hold their slots and are reported as skips.
''
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

#ifdef ABTEST_HAS_GFXLIB2
screenres SW, SH, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-image", "buffers are interchangeable in both directions" )

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
        dim as long ip = 0
#ifdef ABTEST_HAS_GFXLIB2
        dim as any ptr im = imagecreate( w, 4, 0, depth )
        if im = 0 then
            Abtest.Fail_( "pitch depth " + str(depth) + " w=" + str(w), "imagecreate FAILED" )
            continue for
        end if
        dim as integer iw, ih, ib, xp
        dim as any ptr dd
        imageinfo( im, iw, ih, ib, xp, dd )
        imagedestroy( im )
        ip = xp
#endif
        Abtest.Case_( "pitch depth " + str(depth) + " w=" + str(w), _
                      ip, ImagePitch( w, bpp ), "tko=" + str( ImagePitch( w, bpp ) ) )
    next
next

for i as integer = 0 to ubound( ws )
    dim as long w = ws(i), h = hs(i)
    dim as string sz = str(w) + "x" + str(h)
    dim as ulongint after_ours, after_theirs, theirs_by_us, ours_by_us, written_by_us
    dim as long infook = 0

#ifdef ABTEST_HAS_GFXLIB2
    '' ---- 1. ours -> gfxlib2 reads ----
    dim as TkoAbi.PUT_HEADER ptr mine = TkoImageNew( w, h, 4 )
    if mine = 0 then
        Abtest.Fail_( sz, "TkoImageNew failed" )
        continue for
    end if
    dim as Surface ms
    SurfaceFromImage( ms, mine )
    FillPattern( ms )

    cls
    put ( 4, 4 ), mine, PSET
    after_ours = Digest( screenptr( ), SW * 4, SW, SH )

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
    after_theirs = Digest( screenptr( ), SW * 4, SW, SH )

    '' ---- 2. gfxlib2's image, read by us ----
    theirs_by_us = Digest( tdata, tpitch, w, h )
    ours_by_us = Digest( TkoImagePixels( mine ), mine->pitch, w, h )

    '' ---- 3. we WRITE into THEIR buffer, they display it ----
    memset( tdata, 0, tpitch * h )
    dim as Surface ts2
    SurfaceInit( ts2, tdata, w, h, tpitch, 4 )
    FillPattern( ts2 )
    cls
    put ( 4, 4 ), theirs, PSET
    written_by_us = Digest( screenptr( ), SW * 4, SW, SH )

    '' ---- 4. IMAGEINFO agreement on OUR image ----
    dim as integer gw, gh, gbpp, gpitch
    dim as any ptr gdata
    dim as long rc = imageinfo( mine, gw, gh, gbpp, gpitch, gdata )
    infook = iif( (rc = 0) andalso (gw = w) andalso (gh = h) andalso (gbpp = 4) andalso _
                  (gpitch = mine->pitch) andalso (gdata = TkoImagePixels( mine )), 1, 0 )

    imagedestroy( theirs )      '' theirs frees theirs
    TkoImageFree( mine )        '' ours frees ours
#endif

    '' Every one of these hands a buffer from one library to the other at run
    '' time. There is nothing for the subject role to run and nothing a
    '' recording could substitute, so they are skipped and counted, not passed.
    Abtest.Interop_( "dir1 (gfxlib2 PUT of OUR image) " + sz, after_ours, after_theirs )
    Abtest.Interop_( "dir2 (we read both buffers) " + sz, theirs_by_us, ours_by_us )
    Abtest.Interop_( "dir3 (we wrote THEIR buffer) " + sz, after_theirs, written_by_us )
    Abtest.Interop_( "dir4 IMAGEINFO on our image " + sz, 1, infook )
next

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
