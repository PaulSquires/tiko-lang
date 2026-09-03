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

#include once "../core/bsave.bi"
#include once "../core/image.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

dim as string report
dim as long failures = 0
dim as long ran = 0

dim as string tmpdir = environ( "TEMP" )
if tmpdir = "" then tmpdir = "."
dim as string fa = tmpdir + "\abtest_bsave_a.bsv"
dim as string fb_ = tmpdir + "\abtest_bsave_b.bsv"
dim as string fbad = tmpdir + "\abtest_bsave_bad.bsv"

screenres 64, 48, 32, 1, GFX_NULL

'' sizes chosen to exercise every byte of the little-endian length field
dim as ulong sizes(...) = { 1, 2, 255, 256, 257, 1000, 65535, 65536, 70000 }

for si as integer = 0 to ubound( sizes )
    dim as ulong n = sizes(si)
    dim as ubyte ptr buf = allocate( n )
    for i as integer = 0 to n - 1
        buf[i] = cast( ubyte, (i * 37 + (i shr 8) * 11) and &hFF )
    next

    kill fa : kill fb_

    '' ---- gfxlib2 writes ----
    bsave fa, buf, n

    '' ---- 1. we read it ----
    dim as ubyte ptr back = allocate( n )
    memset( back, 0, n )
    dim as ulong got
    dim as long rc = BLoadRaw( fa, back, n, got )
    ran += 1
    if (rc <> 0) orelse (got <> n) orelse (memcmp( back, buf, n ) <> 0) then
        report += "  MISMATCH dir1 size " + str(n) + ": rc=" + str(rc) + _
                  " got=" + str(got) + chr(10)
        failures += 1
    end if

    '' ---- 2. we write, gfxlib2 reads ----
    BSaveRaw( fb_, buf, n )
    dim as ubyte ptr back2 = allocate( n )
    memset( back2, 0, n )
    bload fb_, back2
    ran += 1
    if memcmp( back2, buf, n ) <> 0 then
        report += "  MISMATCH dir2 size " + str(n) + " (gfxlib2 BLOAD of our file)" + chr(10)
        failures += 1
    end if

    '' ---- 3. the files are byte-identical ----
    dim as long f1 = freefile
    open fa for binary access read as #f1
    dim as ulong len1 = lof( f1 )
    dim as ubyte ptr d1 = allocate( len1 )
    get #f1, , *d1, len1
    close #f1

    dim as long f2 = freefile
    open fb_ for binary access read as #f2
    dim as ulong len2 = lof( f2 )
    dim as ubyte ptr d2 = allocate( len2 )
    get #f2, , *d2, len2
    close #f2

    ran += 1
    if (len1 <> len2) orelse (memcmp( d1, d2, len1 ) <> 0) then
        dim as long fb2 = -1
        if len1 = len2 then
            for k as integer = 0 to len1 - 1
                if d1[k] <> d2[k] then fb2 = k : exit for
            next
        end if
        report += "  MISMATCH dir3 size " + str(n) + ": lens " + str(len1) + "/" + str(len2)
        if fb2 >= 0 then report += " first differing byte " + str(fb2) + _
                                   " gfxlib2=&h" + hex(d1[fb2],2) + " tko=&h" + hex(d2[fb2],2)
        report += chr(10)
        failures += 1
    end if

    deallocate( d1 ) : deallocate( d2 )
    deallocate( back ) : deallocate( back2 ) : deallocate( buf )
next

'' ---- 4. a bad magic must be rejected ----
kill fbad
dim as long fbf = freefile
open fbad for binary access write as #fbf
dim as ubyte junk(0 to 8) = { &h7F, 1, 0, 0, 0, &hAA, &hBB, &hCC, &hDD }
dim as ubyte ptr jp = @junk(0)
put #fbf, , *jp, 9
close #fbf

dim as ubyte dummy(0 to 15)
dim as ulong g2
dim as long rc2 = BLoadRaw( fbad, @dummy(0), 16, g2 )
ran += 1
if rc2 = 0 then
    report += "  MISMATCH dir4: a file with magic &h7F was ACCEPTED" + chr(10)
    failures += 1
end if

kill fa : kill fb_ : kill fbad
screen 0

print "abtest-bsave -- "; ran; " BSAVE/BLOAD file-format checks against gfxlib2"
if failures = 0 then
    print "abtest-bsave: PASS -- files are interchangeable in both directions"
    end 0
else
    print report;
    print "abtest-bsave: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
