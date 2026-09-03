'' bench.bas -- libtkogfx against gfxlib2, on the paths that dominate.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' RFC-0001 says performance is measured from Phase 2, not deferred to the end,
'' because the whole premise is that a library written in FreeBASIC can match one
'' written in C. This is the first measurement.
''
'' WHAT THIS COMPARISON IS, AND WHAT IT IS NOT
''
'' gfxlib2 is driven through its STATEMENT layer (LINE/PSET on an image), which
'' costs a context lookup, a target switch, a coordinate transform and a lock per
'' call. libtkogfx is called directly. That overhead is real but fixed per call,
'' so the sizes here are chosen large enough that the inner loop dominates and
'' the comparison is about pixel throughput rather than call overhead.
''
'' The PSET row is deliberately the opposite case -- many tiny calls -- and is
'' reported as a per-call comparison, NOT as evidence about the inner loop. It is
'' included because it is where the statement-layer overhead shows up, and
'' pretending otherwise would make the fill numbers look better than they are.
''
'' Everything runs on an IMAGECREATE buffer so no window or driver is involved.
''
'' LOOP-INVARIANT HOISTING WILL LIE TO YOU. The first version of this benchmark
'' drew the SAME shape every iteration. gfxlib2's calls are opaque external
'' functions so nothing could be hoisted; ours are inlinable, so LLVM kept only
'' the last iteration and reported libtkogfx as 9x to 55x FASTER than C -- which
'' is nonsense. Every loop below varies its arguments per iteration, and a sink
'' reads the buffer back afterwards, so neither side can be elided.

#include once "../raster/box.bi"
#include once "../raster/line.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 1024
const H = 768
const COL = &hFF3080C0

function Now_( ) as double
    return timer
end function

'' Three decimals without pulling in vbcompat.bi.
function Fmt3( byval v as double ) as string
    dim as longint milli = clngint( v * 1000.0 + 0.5 )
    dim as string digits3 = str( milli mod 1000 )
    while len( digits3 ) < 3
        digits3 = "0" + digits3
    wend
    return str( milli \ 1000 ) + "." + digits3
end function

screenres 320, 200, 32, 1, GFX_NULL

dim as any ptr img = imagecreate( W, H, 0, 32 )
if img = 0 then
    screen 0
    print "bench: imagecreate failed"
    end 2
end if

dim as integer iw, ih, ibpp, ipitch
dim as any ptr idata
imageinfo( img, iw, ih, ibpp, ipitch, idata )

dim as any ptr mine = allocate( ipitch * H )
dim as Surface s
SurfaceInit( s, mine, W, H, ipitch, 4 )

dim as string report
dim as ulongint sink
dim as double t0, t1, ta, tb

'' ---------------------------------------------------------------- filled box
const FILLS = 2000
for wu as integer = 0 to 19
    line img, (0,0)-(W-1,H-1), COL, BF
    LineBox32( s, 0, 0, W-1, H-1, COL, 1 )
next

t0 = Now_( )
for k as integer = 1 to FILLS
    line img, (k and 7, k and 3)-(W-1-(k and 7), H-1), COL + k, BF
next
ta = Now_( ) - t0

t0 = Now_( )
for k as integer = 1 to FILLS
    LineBox32( s, k and 7, k and 3, W-1-(k and 7), H-1, COL + k, 1 )
next
tb = Now_( ) - t0
sink += GetPixel32( s, 5, 5 )

report += " full-screen BF   " + str( W ) + "x" + str( H ) + " x" + str( FILLS ) + chr(10)
report += "   gfxlib2 " + Fmt3( ta ) + "s   libtkogfx " + Fmt3( tb ) + "s" + _
          "   ratio " + Fmt3( tb / ta ) + "x" + chr(10)

'' ---------------------------------------------------------------- long lines
const LINES = 20000
for wu as integer = 0 to 19
    line img, (0,0)-(W-1,H-1), COL
    DrawLine32( s, 0, 0, W-1, H-1, COL )
next

t0 = Now_( )
for k as integer = 1 to LINES
    line img, (k and 15, 0)-(W-1, H-1-(k and 15)), COL + k
next
ta = Now_( ) - t0

t0 = Now_( )
for k as integer = 1 to LINES
    DrawLine32( s, k and 15, 0, W-1, H-1-(k and 15), COL + k )
next
tb = Now_( ) - t0
sink += GetPixel32( s, 500, 400 )

report += " diagonal LINE    " + str( W ) + "x" + str( H ) + " x" + str( LINES ) + chr(10)
report += "   gfxlib2 " + Fmt3( ta ) + "s   libtkogfx " + Fmt3( tb ) + "s" + _
          "   ratio " + Fmt3( tb / ta ) + "x" + chr(10)

'' ---------------------------------------------------- horizontal line (memset-ish)
const HLINES = 200000
t0 = Now_( )
for k as integer = 1 to HLINES
    line img, (k and 31, 400 + (k and 63))-(W-1, 400 + (k and 63)), COL + k
next
ta = Now_( ) - t0

t0 = Now_( )
for k as integer = 1 to HLINES
    DrawLine32( s, k and 31, 400 + (k and 63), W-1, 400 + (k and 63), COL + k )
next
tb = Now_( ) - t0
sink += GetPixel32( s, 600, 430 )

report += " horizontal LINE  " + str( W ) + "px x" + str( HLINES ) + chr(10)
report += "   gfxlib2 " + Fmt3( ta ) + "s   libtkogfx " + Fmt3( tb ) + "s" + _
          "   ratio " + Fmt3( tb / ta ) + "x" + chr(10)

'' ------------------------------------------------- PSET: call overhead, not throughput
const PSETS = 2000000
t0 = Now_( )
for k as integer = 1 to PSETS
    pset img, ( k and 1023, (k shr 10) and 767 ), COL + k
next
ta = Now_( ) - t0

t0 = Now_( )
for k as integer = 1 to PSETS
    PSet32( s, k and 1023, (k shr 10) and 767, COL + k )
next
tb = Now_( ) - t0
sink += GetPixel32( s, 100, 100 )

report += " PSET (per-call, NOT inner-loop) x" + str( PSETS ) + chr(10)
report += "   gfxlib2 " + Fmt3( ta ) + "s   libtkogfx " + Fmt3( tb ) + "s" + _
          "   ratio " + Fmt3( tb / ta ) + "x" + chr(10)

deallocate( mine )
imagedestroy( img )
screen 0

if sink = &hDEADBEEF then print ""   '' keep the writes alive
print "bench -- libtkogfx vs gfxlib2, 32bpp, image target"
print report;
print "note: gfxlib2 numbers include its statement-layer overhead (context"
print "      lookup, target switch, coordinate transform, lock) per call."
end 0
