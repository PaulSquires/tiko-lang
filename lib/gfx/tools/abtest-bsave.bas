'' abtest-bsave.bas -- FILE-FORMAT interchange for BSAVE / BLOAD.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' abtest-image.bas hands a buffer between the libraries in memory. This does the
'' same through a FILE, which is a stronger claim: a file written by one library
'' has to be readable by the other, and by a future version of either.
''
'' Four directions:
''
''   1. gfxlib2 writes -> we read     the bytes AND the recorded size
''   2. we write -> gfxlib2 reads     round-tripped through BLOAD
''   3. byte-for-byte file comparison  our file against theirs for the same data
''   4. the magic is a real discriminator: a file whose first byte is not 0xFE
''      must be REJECTED, not read as if it were
''
'' Direction 3 is the one that catches an endianness mistake in the size field.
'' Directions 1 and 2 would both pass if we wrote big-endian and read big-endian.

#include once "../core/bsave.ti"
#include once "../core/image.ti"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif
#include once "crt/string.bi"

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

dim as string tmpdir = environ( "TEMP" )
if tmpdir = "" then tmpdir = "."
dim as string fa = tmpdir + "\abtest_bsave_a.bsv"
dim as string fb_ = tmpdir + "\abtest_bsave_b.bsv"
dim as string fbad = tmpdir + "\abtest_bsave_bad.bsv"

#ifdef ABTEST_HAS_GFXLIB2
screenres 64, 48, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-bsave", "the file format is interchangeable" )

'' A whole file in one number, so the byte-for-byte comparison of direction 3
'' survives into a recording. Zero when the file will not open.
function FileDigest( byref path as string, byref n as ulong ) as ulongint
    n = 0
    dim as long h = freefile
    if open( path, for binary, access read, as #h ) <> 0 then return 0
    n = lof( h )
    if n = 0 then
        close #h
        return 1
    end if
    dim as ubyte ptr d = allocate( n )
    get #h, , *d, n
    close #h
    dim as ulongint r = Abtest.Digest( d, cast( integer, n ) )
    deallocate( d )
    return r
end function

'' sizes chosen to exercise every byte of the little-endian length field
dim as ulong sizes(...) = { 1, 2, 255, 256, 257, 1000, 65535, 65536, 70000 }

for si as integer = 0 to ubound( sizes )
    dim as ulong n = sizes(si)
    dim as ubyte ptr buf = allocate( n )
    for i as integer = 0 to n - 1
        buf[i] = cast( ubyte, (i * 37 + (i shr 8) * 11) and &hFF )
    next

    kill fa : kill fb_

    dim as long dir1ok = 0, dir2ok = 0
    dim as ulongint dref = 0
    dim as ulong lenref = 0

#ifdef ABTEST_HAS_GFXLIB2
    '' ---- gfxlib2 writes ----
    bsave fa, buf, n
    dref = FileDigest( fa, lenref )

    '' ---- 1. we read THEIR file ----
    dim as ubyte ptr back = allocate( n )
    memset( back, 0, n )
    dim as ulong got
    dim as long rc = BLoadRaw( fa, back, n, got )
    dir1ok = iif( (rc = 0) andalso (got = n) andalso (memcmp( back, buf, n ) = 0), 1, 0 )
    deallocate( back )
#endif

    '' ---- we write ----
    BSaveRaw( fb_, buf, n )
    dim as ulong lenmine
    dim as ulongint dmine = FileDigest( fb_, lenmine )

#ifdef ABTEST_HAS_GFXLIB2
    '' ---- 2. gfxlib2 reads OUR file ----
    dim as ubyte ptr back2 = allocate( n )
    memset( back2, 0, n )
    bload fb_, back2
    dir2ok = iif( memcmp( back2, buf, n ) = 0, 1, 0 )
    deallocate( back2 )
#endif

    '' Directions 1 and 2 each hand a FILE one library wrote to the other
    '' library at run time. A recording cannot stand in for a reader, so they
    '' are reference-only. Direction 3 -- that the two files are the same bytes
    '' -- is an ordinary comparison and runs everywhere.
    Abtest.Interop_( "dir1 size " + str(n) + " (we read gfxlib2's file)", 1, dir1ok )
    Abtest.Interop_( "dir2 size " + str(n) + " (gfxlib2 BLOAD of our file)", 1, dir2ok )
    Abtest.Case_( "dir3 size " + str(n) + " (byte-identical files)", dref, dmine, _
                  "len " + str(lenmine) )

    deallocate( buf )
next

'' ---- 4. a bad magic must be rejected ----
kill fbad
dim as long fbf = freefile
open fbad for binary access write as #fbf
dim as ubyte junk(0 to 8) = { &h7F, 1, 0, 0, 0, &hAA, &hBB, &hCC, &hDD }
dim as ubyte ptr jp = @junk(0)
put #fbf, , *jp, 9
close #fbf

'' Entirely ours: BLoadRaw has to refuse it, and gfxlib2 is not involved.
dim as ubyte dummy(0 to 15)
dim as ulong g2
dim as long rc2 = BLoadRaw( fbad, @dummy(0), 16, g2 )
Abtest.Case_( "dir4: a file with magic &h7F is rejected", 1, iif( rc2 <> 0, 1, 0 ) )

kill fa : kill fb_ : kill fbad
#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
