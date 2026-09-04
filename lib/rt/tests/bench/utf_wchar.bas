'' utf_wchar.bas -- fb_UTFToWChar and fb_WCharToUTF, the two entry points added
'' after RFC-0004 section 5.7 recorded the unicode finding.
''
'' THIS IS THE SAME SHAPE AS THE CODE THAT MISSED THE BUDGET, and that is why it
'' is here. Section 5.7's verdict was about `ustr_utf.o` -- tight per-character
'' loops over small integers with hand-inlined helpers -- and it named that shape,
'' not that file, as where FreeBASIC is measurably behind. These two entry points
'' are the same shape in a different file and were unmeasured; leaving them
'' unmeasured would let the open go/no-go question be answered from one sample.
''
'' IT IS A **DIFFERENT** FAMILY FROM utf_conv.bas. That benchmark drives
'' fb_hUtf8ToUtf16 and its siblings, which are the ustring core's internal
'' converters. These two are the FILE-ENCODING converters -- they take an
'' FB_FILE_ENCOD, they handle the allocate-or-fill protocol, and on a UTF-16 host
'' they run entirely different bodies. No case below overlaps that file.
''
'' THE ALLOCATING MODE IS BENCHMARKED SEPARATELY FROM THE FILL MODE, and the
'' distinction matters more here than anywhere else in the harness: the
'' allocating path calls realloc in blocks of eight, so it measures the ALLOCATOR
'' as much as the conversion, and str_concat's history (RFC-0004 section 5.2)
'' is what happens when those two are mixed into one number. The fill mode is the
'' clean codegen comparison; the allocating mode is reported beside it precisely
'' so a difference between the two is visible rather than averaged away.
''
'' EVERY CASE FIXES THE OUTPUT BUFFER SIZE so the fill path never reallocates and
'' the two runtimes do identical amounts of allocator work -- which is section
'' 4's fairness rule, and the rule tiko-rt has already broken once in its own
'' favour.
''
'' THE MIXES ARE THE THREE UTF-8 LENGTHS PLUS THE SURROGATE PATH, because they
'' exercise different work: ASCII is the one-byte switch arm, BMP is the
'' three-byte arm, and supplementary characters are the only ones that split into
'' a pair on a UTF-16 host and stay single on a UTF-32 one. A benchmark that used
'' only ASCII would measure the cheapest arm and report parity.
''
'' NOTE THE COUNTS DIFFER BY PLATFORM BY CONSTRUCTION. On Windows a
'' supplementary character is two wchars and on Linux it is one, so the
'' supplementary cases do strictly more work on Windows. The comparison is
'' tiko-rt against C ON THE SAME PLATFORM, so that is not a confound -- but the
'' two platforms' numbers are not comparable to each other.

#include once "fbc-int/string.bi"

const ENCOD_UTF8  = 1
const ENCOD_UTF16 = 2
const ENCOD_UTF32 = 3

extern "c"   '' NON-FBCALL: fb_file.h declares both plainly.
    declare function toW alias "fb_UTFToWChar" _
        ( byval e as long, byval src as any ptr, byval dst as any ptr, _
          byval chars as integer ptr ) as any ptr
    declare function fromW alias "fb_WCharToUTF" _
        ( byval e as long, byval src as any ptr, byval chars as integer, _
          byval dst as any ptr, byval bytes as integer ptr ) as any ptr
    declare sub crt_free alias "free" ( byval p as any ptr )
end extern

const N     = 20000
const CHARS = 512

'' Generously sized: four bytes per character in, and two wchars per character
'' out on the surrogate path.
dim shared as ubyte  src8( 0 to 4 * CHARS + 8 )
dim shared as ushort dstw16( 0 to 2 * CHARS + 8 )
dim shared as ulong  dstw32( 0 to 2 * CHARS + 8 )
dim shared as ubyte  dst8( 0 to 4 * CHARS + 8 )

dim shared as ushort srcw16( 0 to 2 * CHARS + 8 )
dim shared as ulong  srcw32( 0 to 2 * CHARS + 8 )

dim shared as integer WSZ = len( wstring )

'' The platform's wchar buffers, chosen once. Every case below writes through
'' these so the benchmark body is identical on both widths.
dim shared as any ptr wdst, wsrc
if( WSZ = 2 ) then
    wdst = cast( any ptr, @dstw16(0) ) : wsrc = cast( any ptr, @srcw16(0) )
else
    wdst = cast( any ptr, @dstw32(0) ) : wsrc = cast( any ptr, @srcw32(0) )
end if

dim as double t0
dim as integer guard = 0
dim as integer n8 = 0, nw = 0, cap = 0

'' ================================================== fb_UTFToWChar, fill mode

'' ---------------------------------------------------------------- ASCII
'' NUL-TERMINATED, because this entry point stops on the terminator rather than
'' on a length -- so the source must carry one or the fill loop runs to `cap`.
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = 32 + (i mod 90) : n8 += 1
next
src8(n8) = 0

t0 = timer
for i as integer = 1 to N
    cap = 2 * CHARS
    guard += cast( integer, toW( ENCOD_UTF8, @src8(0), wdst, @cap ) <> 0 )
next
print "toW_fill_ascii "; timer - t0

'' ------------------------------------------------------ BMP, three bytes
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = &hE2 : src8(n8+1) = &h82 : src8(n8+2) = &hAC : n8 += 3
next
src8(n8) = 0

t0 = timer
for i as integer = 1 to N
    cap = 2 * CHARS
    guard += cast( integer, toW( ENCOD_UTF8, @src8(0), wdst, @cap ) <> 0 )
next
print "toW_fill_bmp "; timer - t0

'' --------------------------------------- supplementary, the surrogate path
'' THE ONLY CASE WHERE THE TWO WIDTHS DIVERGE: two wchars out on Windows, one on
'' Linux. See the file header.
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = &hF0 : src8(n8+1) = &h9F : src8(n8+2) = &h98 : src8(n8+3) = &h80 : n8 += 4
next
src8(n8) = 0

t0 = timer
for i as integer = 1 to N
    cap = 2 * CHARS
    guard += cast( integer, toW( ENCOD_UTF8, @src8(0), wdst, @cap ) <> 0 )
next
print "toW_fill_supp "; timer - t0

'' ------------------------------------------------- UTF-16 and UTF-32 sources
'' On a UTF-16 host the first is a memcpy and the second combines pairs; on a
'' UTF-32 host it is the other way round. Both are measured so neither platform
'' reports only its cheap direction.
nw = 0
for i as integer = 0 to CHARS - 1
    srcw16(nw) = 32 + (i mod 90) : nw += 1
next
srcw16(nw) = 0

t0 = timer
for i as integer = 1 to N
    cap = 2 * CHARS
    guard += cast( integer, toW( ENCOD_UTF16, @srcw16(0), wdst, @cap ) <> 0 )
next
print "toW_fill_from16 "; timer - t0

nw = 0
for i as integer = 0 to CHARS - 1
    srcw32(nw) = 32 + (i mod 90) : nw += 1
next
srcw32(nw) = 0

t0 = timer
for i as integer = 1 to N
    cap = 2 * CHARS
    guard += cast( integer, toW( ENCOD_UTF32, @srcw32(0), wdst, @cap ) <> 0 )
next
print "toW_fill_from32 "; timer - t0

'' ============================================ fb_UTFToWChar, allocating mode

'' REPORTED SEPARATELY, AND IT IS NOT A CODEGEN COMPARISON. This path reallocs in
'' blocks of eight, so most of what it measures is the allocator -- which is
'' exactly the confound that made str_concat's first number meaningless. It is
'' here so that a difference between fill and allocate is VISIBLE, not so that it
'' can be averaged into the geomean.
''
'' The iteration count is cut by ten because each pass makes ~CHARS/8 realloc
'' calls and the case would otherwise dominate the whole run's wall clock.
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = 32 + (i mod 90) : n8 += 1
next
src8(n8) = 0

t0 = timer
for i as integer = 1 to N \ 10
    cap = 0
    dim as any ptr w = toW( ENCOD_UTF8, @src8(0), 0, @cap )
    guard += cap
    crt_free( w )
next
print "toW_alloc_ascii "; timer - t0

'' ================================================ fb_WCharToUTF, fill mode

'' THE LENGTH IS GIVEN HERE, so no terminator is needed and an embedded NUL is
'' just another character -- the opposite of the direction above.
nw = 0
for i as integer = 0 to CHARS - 1
    srcw16(nw) = 32 + (i mod 90)
    srcw32(nw) = 32 + (i mod 90)
    nw += 1
next

dim as integer nbytes = 0

t0 = timer
for i as integer = 1 to N
    nbytes = 4 * CHARS
    guard += cast( integer, fromW( ENCOD_UTF8, wsrc, nw, @dst8(0), @nbytes ) <> 0 )
next
print "fromW_fill_ascii8 "; timer - t0

'' BMP: three bytes out per character, so the byte-length branch in the encoder
'' takes its third arm.
nw = 0
for i as integer = 0 to CHARS - 1
    srcw16(nw) = &h20AC
    srcw32(nw) = &h20AC
    nw += 1
next

t0 = timer
for i as integer = 1 to N
    nbytes = 4 * CHARS
    guard += cast( integer, fromW( ENCOD_UTF8, wsrc, nw, @dst8(0), @nbytes ) <> 0 )
next
print "fromW_fill_bmp8 "; timer - t0

'' SUPPLEMENTARY. On a UTF-16 host the input is a surrogate PAIR and `nw` counts
'' two per character; on a UTF-32 host it is one code point. Built per width so
'' both describe the same TEXT.
if( WSZ = 2 ) then
    nw = 0
    for i as integer = 0 to CHARS - 1
        srcw16(nw) = &hD83D : srcw16(nw+1) = &hDE00 : nw += 2
    next
else
    nw = 0
    for i as integer = 0 to CHARS - 1
        srcw32(nw) = &h0001F600 : nw += 1
    next
end if

t0 = timer
for i as integer = 1 to N
    nbytes = 4 * CHARS
    guard += cast( integer, fromW( ENCOD_UTF8, wsrc, nw, @dst8(0), @nbytes ) <> 0 )
next
print "fromW_fill_supp8 "; timer - t0

'' TO THE WIDE ENCODINGS. On a UTF-16 host the UTF-16 output is a memcpy and the
'' UTF-32 output expands; on a UTF-32 host the reverse. Both measured.
nw = 0
for i as integer = 0 to CHARS - 1
    srcw16(nw) = 32 + (i mod 90)
    srcw32(nw) = 32 + (i mod 90)
    nw += 1
next

t0 = timer
for i as integer = 1 to N
    nbytes = 4 * CHARS
    guard += cast( integer, fromW( ENCOD_UTF16, wsrc, nw, @dst8(0), @nbytes ) <> 0 )
next
print "fromW_fill_to16 "; timer - t0

t0 = timer
for i as integer = 1 to N
    nbytes = 4 * CHARS
    guard += cast( integer, fromW( ENCOD_UTF32, wsrc, nw, @dst8(0), @nbytes ) <> 0 )
next
print "fromW_fill_to32 "; timer - t0

'' The guard exists so the optimiser cannot delete the loops; printing it to
'' stderr keeps it out of the harness's numeric parse.
if( guard = &h7FFFFFFF ) then print #0, guard
