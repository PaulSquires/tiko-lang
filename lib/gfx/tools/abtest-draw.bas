'' abtest-draw.bas -- pixel-exactness A/B for DRAW against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' DRAW is a small language, so the cases are chosen to exercise the parser and
'' the state machine rather than just the drawing:
''
''   - every direction letter, axis and diagonal, with and without a count
''   - B (move without drawing) and N (draw without moving), including stacked
''   - S scale, A quadrant angle, TA arbitrary angle, and NEGATIVE TA
''   - M in absolute and relative form -- relative is detected by a leading
''     + or -, and is then rotated and scaled where absolute is not
''   - numbers with redundant signs ("R++5", "R--5", "R+-5") which the parser
''     folds rather than rejects
''   - malformed input that must stop cleanly mid-string
''
'' SCALE AND ANGLE PERSIST BETWEEN CALLS, so each case runs on a fresh image AND
'' resets them explicitly first. Without that reset the cases contaminate each
'' other -- which is itself worth knowing, and case "persist" checks it.

#include once "../raster/draw.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 72
const H = 56
const COL = &hFFFFC020

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

dim as string cmds(...) = { _
    "R20", "L20", "U20", "D20", "E15", "F15", "G15", "H15", _
    "R", "U", "E", _
    "R10D10L10U10", _
    "BR20D10", "NR20D10", "BNR20D10", _
    "R10BR5R10", "R10NU10R10", _
    "S8R10", "S2R20", "S4R10", "S12D10", _
    "A1R20", "A2R20", "A3R20", "A0R20", _
    "TA45R20", "TA30R20", "TA135R20", "TA315R20", _
    "M50,40", "M+20,10", "M-10,-5", "TA90M+20,0", "S8M+10,0", _
    "R++5", "R--5", "R+-5", _
    "R10Z9D10", "R10D", "R10,D10", _
    "u10r10d10l10", _
    "C255R10", _
    "S8TA45E10R10", "A1E10F10G10H10", _
    "S6TA45M+10,0", "S6TA45M+10,0M+10,0", "S6TA45M+10,10", "S6TA30M+13,0", "S6TA45M+10,0R5", "S10TA45M+7,3" }

screenres W, H, 32, 1, GFX_NULL

dim as string report
dim as long failures = 0
dim as long ran = 0

for i as integer = 0 to ubound( cmds )
    '' ---- A: gfxlib2 ----
    dim as any ptr img = imagecreate( W, H, 0, 32 )
    if img = 0 then continue for
    '' reset the persistent state, then park the cursor deterministically
    draw img, "S4TA0"
    pset img, ( 30, 28 ), COL
    draw img, "C" & str( COL ) & cmds(i)

    dim as integer iw, ih, ibpp, ipitch
    dim as any ptr idata
    imageinfo( img, iw, ih, ibpp, ipitch, idata )
    dim as ulongint ha = Digest( idata, ipitch )

    '' ---- B: libtkogfx ----
    dim as any ptr mine = allocate( ipitch * H )
    memset( mine, 0, ipitch * H )
    dim as Surface s
    SurfaceInit( s, mine, W, H, ipitch, 4 )
    DrawBaseScale = 1.0
    DrawBaseAngle = 0
    dim as single cx = 30, cy = 28
    dim as ulong fg = COL
    PSet32( s, 30, 28, COL )
    Draw32( s, cmds(i), cx, cy, fg )
    dim as ulongint hb = Digest( mine, ipitch )

    ran += 1
    if ha <> hb then
        report += "  MISMATCH " + chr(34) + cmds(i) + chr(34) + chr(10)
        failures += 1
    end if
    deallocate( mine )
    imagedestroy( img )
next

'' ---- X: execute a substring by pointer ----
''
'' `DRAW "X" + STR( VARPTR( s ) )` recurses into another command string. The
'' cursor and colour carry in and out, so the cases check a substring that MOVES
'' as well as one that only draws -- a version that saved and restored the cursor
'' around the call would pass the second and fail the first.
dim as string subs(...) = { "R10", "D10R10", "BR5D5", "S8R5", "TA90R10", "U5L5D5R5" }
dim as string outer(...) = { "X", "R5X", "XR5", "R5XD5", "XX", "S8X" }

for si as integer = 0 to ubound( subs )
    for oi as integer = 0 to ubound( outer )
        dim as string inner = subs(si)
        dim as string cmdtext
        '' splice the pointer in wherever the template says X
        for k as integer = 1 to len( outer(oi) )
            if chr( outer(oi)[k-1] ) = "X" then
                cmdtext += "X" + str( cast( integer, varptr( inner ) ) )
            else
                cmdtext += chr( outer(oi)[k-1] )
            end if
        next

        dim as any ptr img = imagecreate( W, H, 0, 32 )
        if img = 0 then continue for
        draw img, "S4TA0"
        pset img, ( 30, 28 ), COL
        draw img, "C" & str( COL ) & cmdtext

        dim as integer iw, ih, ibpp, ipitch
        dim as any ptr idata
        imageinfo( img, iw, ih, ibpp, ipitch, idata )
        dim as ulongint ha = Digest( idata, ipitch )

        dim as any ptr mine = allocate( ipitch * H )
        memset( mine, 0, ipitch * H )
        dim as Surface s
        SurfaceInit( s, mine, W, H, ipitch, 4 )
        DrawBaseScale = 1.0
        DrawBaseAngle = 0
        dim as single cx = 30, cy = 28
        dim as ulong fg = COL
        PSet32( s, 30, 28, COL )
        Draw32( s, cmdtext, cx, cy, fg )
        dim as ulongint hb = Digest( mine, ipitch )

        ran += 1
        if ha <> hb then
            report += "  MISMATCH X: outer=" + chr(34) + outer(oi) + chr(34) + _
                      " inner=" + chr(34) + inner + chr(34) + chr(10)
            failures += 1
        end if
        deallocate( mine )
        imagedestroy( img )
    next
next

'' ---- state really does persist between calls ----
dim as any ptr img2 = imagecreate( W, H, 0, 32 )
draw img2, "S4TA0"
pset img2, ( 10, 28 ), COL
draw img2, "S8"          '' scale set in ONE call
draw img2, "R10"         '' used by the NEXT
dim as integer iw2, ih2, ibpp2, ipitch2
dim as any ptr idata2
imageinfo( img2, iw2, ih2, ibpp2, ipitch2, idata2 )
dim as ulongint ha2 = Digest( idata2, ipitch2 )

dim as any ptr mine2 = allocate( ipitch2 * H )
memset( mine2, 0, ipitch2 * H )
dim as Surface s2
SurfaceInit( s2, mine2, W, H, ipitch2, 4 )
DrawBaseScale = 1.0
DrawBaseAngle = 0
dim as single cx2 = 10, cy2 = 28
dim as ulong fg2 = COL
PSet32( s2, 10, 28, COL )
dim as string c1 = "S8", c2 = "R10"
Draw32( s2, c1, cx2, cy2, fg2 )
Draw32( s2, c2, cx2, cy2, fg2 )
dim as ulongint hb2 = Digest( mine2, ipitch2 )
ran += 1
if ha2 <> hb2 then
    report += "  MISMATCH persist (S8 then R10 across two calls)" + chr(10)
    failures += 1
end if
deallocate( mine2 )
imagedestroy( img2 )

screen 0

print "abtest-draw -- "; ran; " DRAW command strings against gfxlib2, 32bpp "; W; "x"; H
if failures = 0 then
    print "abtest-draw: PASS -- every case is pixel-identical"
    end 0
else
    print report;
    print "abtest-draw: FAIL -- "; failures; " of"; ran; " cases differ"
    end 1
end if
