'' abtest-dirty.bas -- A/B the dirty-scanline span against gfxlib2's own.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Dirty tracking is normally invisible: nothing in the public API reports it,
'' and getting it wrong does not corrupt memory -- it makes the screen repaint
'' too much, or not enough. The second failure looks exactly like a drawing bug,
'' which is a bad way to spend an afternoon.
''
'' It IS observable from here, though. __fb_gfx->dirty is a byte per scanline,
'' and abi/rtlctx.bi can reach it. So:
''
''   1. draw a case to the SCREEN with gfxlib2, read its dirty span, clear it
''   2. draw the same case into our own surface with tracking on
''   3. compare the spans
''
'' Drawing must go to the screen rather than an image: gfxlib2 gates SET_DIRTY on
'' `__fb_gfx->framebuffer == ctx->line[0]`, so an image target marks nothing.
'' That gate is itself worth pinning, and the last case does -- drawing to an
'' image must leave the span empty.
''
'' Comparing SPANS rather than the raw arrays is deliberate: gfxlib2 blits one
'' rectangle covering first..last, so rows in between are irrelevant to what
'' reaches the screen.

#include once "../raster/line.bi"
#include once "../raster/box.bi"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "../abi/rtlctx.bi"
#include once "fbgfx.bi"
#endif

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

const W = 64
const H = 48
const COL = &hFF60A0E0

#ifdef ABTEST_HAS_GFXLIB2
'' first/last set byte of gfxlib2's array; returns 0 when nothing is dirty
function GfxSpan( byref y1 as long, byref y2 as long ) as long
    dim as TkoAbi.FBGFX ptr g = TkoAbi.RtlGfx( )
    if g = 0 orelse g->dirty = 0 then return 0
    dim as ubyte ptr d = cptr( ubyte ptr, g->dirty )
    dim as integer i = 0
    while i < H
        if d[i] then exit while
        i += 1
    wend
    if i >= H then return 0
    dim as integer j = H - 1
    while j > i
        if d[j] then exit while
        j -= 1
    wend
    y1 = i : y2 = j
    return 1
end function

sub GfxSpanClear( )
    dim as TkoAbi.FBGFX ptr g = TkoAbi.RtlGfx( )
    if g = 0 orelse g->dirty = 0 then exit sub
    memset( g->dirty, 0, H )
end sub
#endif


dim as string cname(...) = { _
    "line horizontal", "line vertical", "line diagonal", "line shallow", _
    "line steep", "line clipped top", "line clipped bottom", _
    "box outline", "box filled", "box clipped", "pset" }
dim as long kind(...) = {  0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 3 }
dim as long ax1(...)  = {  4, 10, 0, 2, 20, 10, 10, 8, 12, -20, 31 }
dim as long ay1(...)  = {  7, 3, 0, 40, 1, -30, 20, 6, 10, -20, 23 }
dim as long ax2(...)  = { 59, 10, 47, 61, 26, 30, 30, 40, 50, 90, 31 }
dim as long ay2(...)  = {  7, 45, 47, 46, 46, 30, 90, 30, 40, 90, 23 }

#ifdef ABTEST_HAS_GFXLIB2
screenres W, H, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-dirty", "spans identical" )

'' The whole answer for one case in one number, so it can be recorded: a flag
'' that anything was marked, and the first and last marked row.
function SpanKey( byval anyset as long, byval y1 as long, byval y2 as long ) as ulongint
    if anyset = 0 then return 0
    return 1 or (cast( ulongint, y1 ) shl 8) or (cast( ulongint, y2 ) shl 24)
end function

dim as ubyte ptr mydirty = allocate( H )
dim as any ptr mypix = allocate( W * 4 * H )

for i as integer = 0 to ubound( cname )
    dim as ulongint gkey, mkey
    dim as long ga1, ga2, gany

#ifdef ABTEST_HAS_GFXLIB2
    '' ---- A: gfxlib2, drawing to the screen ----
    GfxSpanClear( )
    select case kind(i)
    case 0 : line ( ax1(i), ay1(i) )-( ax2(i), ay2(i) ), COL
    case 1 : line ( ax1(i), ay1(i) )-( ax2(i), ay2(i) ), COL, B
    case 2 : line ( ax1(i), ay1(i) )-( ax2(i), ay2(i) ), COL, BF
    case 3 : pset ( ax1(i), ay1(i) ), COL
    end select
    gany = GfxSpan( ga1, ga2 )
    gkey = SpanKey( gany, ga1, ga2 )
#endif

    '' ---- B: libtkogfx, tracking on ----
    memset( mydirty, 0, H )
    dim as Surface s
    SurfaceInit( s, mypix, W, H, W * 4, 4 )
    s.dirty = mydirty
    select case kind(i)
    case 0 : DrawLine32( s, ax1(i), ay1(i), ax2(i), ay2(i), COL )
    case 1 : LineBox32( s, ax1(i), ay1(i), ax2(i), ay2(i), COL, 0 )
    case 2 : LineBox32( s, ax1(i), ay1(i), ax2(i), ay2(i), COL, 1 )
    case 3 : PSet32( s, ax1(i), ay1(i), COL )
    end select
    dim as long ma1, ma2
    dim as long many = DirtySpan( s, ma1, ma2 )
    mkey = SpanKey( many, ma1, ma2 )

    Abtest.Case_( cname(i), gkey, mkey, _
                  "tko=" + iif( many, str(ma1) + ".." + str(ma2), "none" ) )
next

'' An IMAGE target must mark nothing at all. This is entirely a statement about
'' gfxlib2 -- there is no libtkogfx half to compare -- so it is reference-only.
dim as long imgmarked = 0
#ifdef ABTEST_HAS_GFXLIB2
GfxSpanClear( )
dim as any ptr img = imagecreate( W, H, 0, 32 )
line img, (0,0)-(W-1,H-1), COL, BF
dim as long q1, q2
imgmarked = GfxSpan( q1, q2 )
imagedestroy( img )
#endif
Abtest.Interop_( "an image target marks no rows", 0, imgmarked )

deallocate( mypix )
deallocate( mydirty )
#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
