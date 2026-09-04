'' abtest-paint.bas -- pixel-exactness A/B for PAINT against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Flood fill is the primitive where "looks right" and "is right" diverge most,
'' so the scenes are built to make the difference visible in a digest:
''
''   - CONCAVE and SPIRAL shapes, where a naive fill leaks or stops early
''   - a shape with an INTERIOR ISLAND that must be left alone
''   - a boundary with a ONE-PIXEL GAP, where the fill must escape and flood the
''     whole surface -- an implementation that dedups too aggressively will not
''   - a seed ON the border, and a seed OUTSIDE the clip box: both no-ops
''   - fill colour EQUAL to border colour
''   - a FULL-WIDTH BAR of the fill colour across the interior (scene 10)
''
'' WHICH SCENE PROVES WHAT, measured by perturbing the implementation:
''
''   scene 10 alone catches a flood that treats the FILL colour as a barrier --
''   the classic naive bug. Scene 4's fill-coloured ISLAND does NOT: filling it
''   or not filling it produces the same pixels either way, so it looked like
''   coverage and was not. The bar has to span the full interior width, so
''   stopping at it strands everything below.
''
''   And the perturbation has to block ALL FOUR border tests. Changing only the
''   leftward extension is not enough -- the flood simply routes around it via
''   the rightward extension and the vertical scans, and the suite stays green.
''
''   Removing the dedup check entirely fails 12 of 15 scenes.
''
'' Each scene is drawn identically into both buffers first, so only the PAINT
'' differs.
''

#include once "../raster/paint.bi"
#include once "../raster/box.bi"
#include once "../raster/line.bi"
#include once "../raster/circle.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 72
const H = 56
const BORDER = &hFF00FF00
const FILLC  = &hFFFF0000
const OTHER  = &hFF0000FF

function Digest( byval pixels as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to H - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, pixels ) + y * pitch )
        for x as integer = 0 to W - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

'' Draw scene `n` with gfxlib2 into an image target.
sub SceneGfx( byval img as any ptr, byval n as long )
    select case n
    case 0   '' plain box
        line img, (10,10)-(60,45), BORDER, B
    case 1   '' concave: a C shape
        line img, (10,10)-(60,45), BORDER, B
        line img, (10,25)-(45,30), BORDER, BF
    case 2   '' interior island
        line img, (8,8)-(63,47), BORDER, B
        line img, (28,22)-(40,32), BORDER, BF
    case 3   '' one-pixel gap in the boundary -- fill must escape
        line img, (10,10)-(60,45), BORDER, B
        pset img, (35,10), OTHER
    case 4   '' interior already contains the fill colour
        line img, (10,10)-(60,45), BORDER, B
        line img, (20,20)-(30,30), FILLC, BF
    case 5   '' nested boxes
        line img, (6,6)-(65,49), BORDER, B
        line img, (16,16)-(55,39), BORDER, B
    case 6   '' circle boundary
        circle img, (36,28), 20.0, BORDER
    case 7   '' filled circle as an island inside a box
        line img, (4,4)-(67,51), BORDER, B
        circle img, (36,28), 12.0, BORDER, , , , F
    case 8   '' comb: several vertical bars
        line img, (8,8)-(63,47), BORDER, B
        for i as integer = 0 to 4
            line img, (16 + i*10, 8)-(16 + i*10, 40), BORDER
        next
    case 10  '' a FULL-WIDTH bar of the fill colour across the interior.
             '' Seeded above it: an implementation that also stops at the fill
             '' colour leaves everything below the bar unpainted. Scene 4's
             '' island does NOT discriminate, because filling it or not filling
             '' it produces the same pixels either way.
        line img, (10,10)-(60,45), BORDER, B
        line img, (11,26)-(59,28), FILLC, BF
    case 9   '' diagonal boundary
        line img, (8,8)-(63,47), BORDER, B
        line img, (8,47)-(63,8), BORDER
    end select
end sub

sub SceneTko( byref s as Surface, byval n as long )
    select case n
    case 0
        LineBox32( s, 10,10, 60,45, BORDER, 0 )
    case 1
        LineBox32( s, 10,10, 60,45, BORDER, 0 )
        LineBox32( s, 10,25, 45,30, BORDER, 1 )
    case 2
        LineBox32( s, 8,8, 63,47, BORDER, 0 )
        LineBox32( s, 28,22, 40,32, BORDER, 1 )
    case 3
        LineBox32( s, 10,10, 60,45, BORDER, 0 )
        PSet32( s, 35,10, OTHER )
    case 4
        LineBox32( s, 10,10, 60,45, BORDER, 0 )
        LineBox32( s, 20,20, 30,30, FILLC, 1 )
    case 5
        LineBox32( s, 6,6, 65,49, BORDER, 0 )
        LineBox32( s, 16,16, 55,39, BORDER, 0 )
    case 6
        Circle32( s, 36,28, 20.0, BORDER, 1.0, 0 )
    case 7
        LineBox32( s, 4,4, 67,51, BORDER, 0 )
        Circle32( s, 36,28, 12.0, BORDER, 1.0, 1 )
    case 8
        LineBox32( s, 8,8, 63,47, BORDER, 0 )
        for i as integer = 0 to 4
            DrawLine32( s, 16 + i*10, 8, 16 + i*10, 40, BORDER )
        next
    case 9
        LineBox32( s, 8,8, 63,47, BORDER, 0 )
        DrawLine32( s, 8,47, 63,8, BORDER )
    case 10
        LineBox32( s, 10,10, 60,45, BORDER, 0 )
        LineBox32( s, 11,26, 59,28, FILLC, 1 )
    end select
end sub

screenres W, H, 32, 1, GFX_NULL

'' seed points per scene, plus edge cases
dim as long sx(...)   = { 35, 35, 35, 35, 35, 35, 36, 10, 12, 20,  10, 100, 35, 35 , 35}
dim as long sy(...)   = { 28, 15, 15, 28, 15, 10, 28, 28, 28, 40,  10, 100,  2, 28 , 15}
dim as long scn(...)  = {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,   0,   0,  0,  0 , 10}
dim as ulong fc(...)  = { FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, FILLC, BORDER , FILLC}
dim as string nm(...) = { "box", "concave C", "island", "gap escapes", _
                          "fill colour inside", "nested", "circle", "circle island", _
                          "comb", "diagonal", "seed ON border", "seed outside", _
                          "seed outside shape", "fill == border" , "fill-colour bar"}

dim as string report
dim as long failures = 0
dim as long ran = 0

for i as integer = 0 to ubound( sx )
    dim as any ptr img = imagecreate( W, H, 0, 32 )
    if img = 0 then continue for
    SceneGfx( img, scn(i) )
    paint img, ( sx(i), sy(i) ), fc(i), BORDER

    dim as integer iw, ih, ibpp, ipitch
    dim as any ptr idata
    imageinfo( img, iw, ih, ibpp, ipitch, idata )
    dim as ulongint ha = Digest( idata, ipitch )

    dim as any ptr mine = allocate( ipitch * H )
    memset( mine, 0, ipitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, ipitch, 4 )
    SceneTko( s, scn(i) )
    Paint32( s, sx(i), sy(i), fc(i), BORDER )
    dim as ulongint hb = Digest( mine, ipitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH " + nm(i) + " seed (" + str(sx(i)) + "," + str(sy(i)) + ")" + chr(10)
        failures += 1
    end if
    deallocate( mine )
    imagedestroy( img )
next


'' ---- PATTERN fills ----
''
'' The tile is 8x8 and anchored to the SURFACE origin, not to the shape, so the
'' span's x1 and x2 alignment relative to 8 decides which of the three copy
'' parts run. Scenes are chosen so spans start and end at every residue:
'' aligned-to-aligned, aligned-to-partial, partial-to-aligned, partial-to-partial,
'' and spans SHORTER than one tile (the same-block special case).
''
'' Patterns: a diagonal, alternating columns, alternating rows, one solid, and
'' one with a distinct value in every cell so any mis-indexing shows up as the
'' wrong colour rather than as a plausible different pattern.
dim as ulong tile(0 to 63)
dim as string pat

for pk as integer = 0 to 4
    for i as integer = 0 to 63
        dim as long tx = i and 7, ty = i shr 3
        select case pk
        case 0 : tile(i) = iif( tx = ty, &hFFFF0000, &hFF002000 )
        case 1 : tile(i) = iif( (tx and 1) = 0, &hFF00FF00, &hFF000040 )
        case 2 : tile(i) = iif( (ty and 1) = 0, &hFF0000FF, &hFF400000 )
        case 3 : tile(i) = &hFF808080
        case else : tile(i) = &hFF000000 or cuint( i * 4 ) or (cuint( i ) shl 10)
        end select
    next
    pat = space( 64 * 4 )
    memcpy( strptr( pat ), @tile(0), 64 * 4 )

    '' boxes whose interiors start/end at different residues mod 8
    dim as long bx(...) = {  8, 11, 16,  9, 12, 33 }
    dim as long bw(...) = { 32, 29, 24, 31, 26,  3 }
    for bi as integer = 0 to ubound( bx )
        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then continue for
        line img, (0,0)-(W-1,H-1), 0, BF
        line img, (bx(bi), 12)-(bx(bi) + bw(bi), 34), BORDER, B
        paint img, ( bx(bi) + 2, 20 ), pat, BORDER

        dim as integer iw, ih, ibpp, ipitch
        dim as any ptr idata
        imageinfo( img, iw, ih, ibpp, ipitch, idata )
        dim as ulongint ha = Digest( idata, ipitch )

        dim as any ptr mine = allocate( ipitch * H )
        memset( mine, 0, ipitch * H )
        dim as Surface s
        SurfaceInit( s, mine, W, H, ipitch, 4 )
        LineBox32( s, bx(bi), 12, bx(bi) + bw(bi), 34, BORDER, 0 )
        Paint32( s, bx(bi) + 2, 20, 0, BORDER, @tile(0) )
        dim as ulongint hb = Digest( mine, ipitch )

        ran += 1
        if ha <> hb then
            report += "  MISMATCH pattern " + str(pk) + " box x=" + str(bx(bi)) + _
                      " w=" + str(bw(bi)) + chr(10)
            failures += 1
        end if
        deallocate( mine )
        imagedestroy( img )
    next
next

screen 0

print "abtest-paint -- "; ran; " flood-fill scenes against gfxlib2, 32bpp "; W; "x"; H
if failures = 0 then
    print "abtest-paint: PASS -- every scene is pixel-identical"
    end 0
else
    print report;
    print "abtest-paint: FAIL -- "; failures; " of"; ran; " scenes differ"
    end 1
end if
