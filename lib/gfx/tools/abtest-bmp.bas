'' abtest-bmp.bas -- BMP output compared byte-for-byte with gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' A whole-file byte comparison, not a round trip. A round trip through our own
'' reader would pass on any self-consistent layout -- the same hole that hid the
'' 4-vs-16 pitch bug and the big-endian BSAVE size. The file either matches
'' gfxlib2's byte for byte or it does not.
''
'' Widths are chosen so the 4-byte row padding is exercised at every residue:
'' an 8-bit BMP pads `(w + 3) and not 3`, so w mod 4 of 0, 1, 2 and 3 all appear.
'' A writer that omitted the padding would produce a file of the right length
'' only when w is already a multiple of 4.
''
'' gfxlib2 selects BMP purely on the FILENAME EXTENSION, so the same call with a
'' .bsv name produces the raw block instead. Both are checked, because a writer
'' that ignored the extension would still pass a BMP-only test.

#include once "../core/bmp.bi"
#include once "../core/bsave.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

dim as string report
dim as long failures = 0
dim as long ran = 0

dim as string tmpdir = environ( "TEMP" )
if tmpdir = "" then tmpdir = "."
dim as string fa = tmpdir + "\abtest_bmp_a.bmp"
dim as string fb2 = tmpdir + "\abtest_bmp_b.bmp"

'' Compare two files byte for byte; returns -1 if equal, else the first index.
function DiffFiles( byref p1 as string, byref p2 as string, byref n1 as ulong, byref n2 as ulong ) as long
    dim as long h1 = freefile
    if open( p1, for binary, access read, as #h1 ) <> 0 then return -2
    n1 = lof( h1 )
    dim as ubyte ptr d1 = allocate( n1 + 1 )
    if n1 > 0 then get #h1, , *d1, n1
    close #h1

    dim as long h2 = freefile
    if open( p2, for binary, access read, as #h2 ) <> 0 then
        deallocate( d1 )
        return -3
    end if
    n2 = lof( h2 )
    dim as ubyte ptr d2 = allocate( n2 + 1 )
    if n2 > 0 then get #h2, , *d2, n2
    close #h2

    dim as long res = -1
    dim as ulong lim = iif( n1 < n2, n1, n2 )
    for i as integer = 0 to lim - 1
        if d1[i] <> d2[i] then res = i : exit for
    next
    if (res = -1) andalso (n1 <> n2) then res = lim
    deallocate( d1 ) : deallocate( d2 )
    return res
end function

screenres 64, 48, 32, 1, GFX_NULL

'' every residue mod 4, plus a couple of larger sizes
dim as long ws(...) = { 4, 5, 6, 7, 16, 17, 30, 33 }
dim as long hs(...) = { 3, 4, 5, 6, 9, 10, 11, 12 }

for i as integer = 0 to ubound( ws )
    dim as long w = ws(i), h = hs(i)

    pset ( 0, 0 ), 0
    dim as any ptr theirs = imagecreate( w, h, 0, 32 )
    dim as integer tw, th, tb, tp
    dim as any ptr td
    imageinfo( theirs, tw, th, tb, tp, td )
    line theirs, (0,0)-(w-1,h-1), 0, BF
    for y as integer = 0 to h - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, td ) + y * tp )
        for x as integer = 0 to w - 1
            row[x] = &hFF000000 or (cuint(x*17) shl 16) or (cuint(y*29) shl 8) or cuint(x+y*3)
        next
    next

    dim as TkoAbi.PUT_HEADER ptr mine = TkoImageNew( w, h, 4 )
    for y as integer = 0 to h - 1
        dim as ulong ptr row = cptr( ulong ptr, TkoImagePixels( mine ) + y * mine->pitch )
        for x as integer = 0 to w - 1
            row[x] = &hFF000000 or (cuint(x*17) shl 16) or (cuint(y*29) shl 8) or cuint(x+y*3)
        next
    next

    kill fa : kill fb2
    bsave fa, theirs
    BmpSave32( fb2, mine )

    dim as ulong n1, n2
    dim as long d = DiffFiles( fa, fb2, n1, n2 )
    ran += 1
    if d <> -1 then
        report += "  MISMATCH bmp32 " + str(w) + "x" + str(h) + _
                  ": lens " + str(n1) + "/" + str(n2) + " first diff at " + str(d) + chr(10)
        failures += 1
    end if

    TkoImageFree( mine )
    imagedestroy( theirs )
next

'' ---- the extension really does select the format ----
''
'' Same data, same call shape, different suffix. A writer that ignored the
'' extension would pass every BMP check above and fail here.
''
'' NOTE the asymmetry, measured rather than assumed: BSAVE of an IMAGE to a
'' non-.bmp name writes NOTHING. gfxlib2's raw path rejects `size == 0 && src`
'' with ILLEGALFUNCTIONCALL -- but only AFTER opening the file, so a zero-length
'' file is left behind. So the raw path needs an explicit size and a plain
'' buffer; an image is a BMP-only argument.
dim as string fbsv = tmpdir + "\abtest_bmp_c.bsv"
kill fa : kill fbsv
pset ( 0, 0 ), 0
dim as any ptr im = imagecreate( 8, 8, 0, 32 )
line im, (0,0)-(7,7), &hFF404040, BF
bsave fa, im

'' an image to .bsv: zero-length file, nothing written
bsave fbsv, im
dim as long hz = freefile
dim as long zlen = -1
if open( fbsv, for binary, access read, as #hz ) = 0 then
    zlen = lof( hz )
    close #hz
end if
ran += 1
if zlen <> 0 then
    report += "  MISMATCH image->.bsv should leave a zero-length file, got " + str(zlen) + chr(10)
    failures += 1
end if
imagedestroy( im )

dim as long hh = freefile
open fa for binary access read as #hh
dim as ubyte m1(0 to 1)
dim as ubyte ptr mp = @m1(0)
get #hh, , *mp, 2
close #hh
ran += 1
if (m1(0) <> asc("B")) orelse (m1(1) <> asc("M")) then
    report += "  MISMATCH .bmp did not start with 'BM'" + chr(10)
    failures += 1
end if

'' a plain buffer WITH a size does take the raw path
dim as ubyte raw_(0 to 15)
for k as integer = 0 to 15
    raw_(k) = cast( ubyte, k * 3 )
next
kill fbsv
bsave fbsv, @raw_(0), 16
open fbsv for binary access read as #hh
get #hh, , *mp, 2
close #hh
ran += 1
if m1(0) <> &hFE then
    report += "  MISMATCH buffer->.bsv did not start with &hFE, got &h" + hex(m1(0),2) + chr(10)
    failures += 1
end if

kill fa : kill fb2 : kill fbsv
screen 0

print "abtest-bmp -- "; ran; " BMP byte-for-byte checks against gfxlib2"
if failures = 0 then
    print "abtest-bmp: PASS -- files are byte-identical"
    end 0
else
    print report;
    print "abtest-bmp: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
