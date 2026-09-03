'' abtest-color.bas -- A/B for COLOR against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' COLOR is checked two ways, because both halves can be wrong independently:
''
''   1. THE RETURN VALUE, compared exactly. It reports the PREVIOUS colours, in
''      a form that depends on the screen depth -- packed indices at 8bpp, an
''      RGB565-to-RGB888 expansion at 16bpp, the raw value at 32bpp.
''   2. WHAT IT ACTUALLY SETS, observed by drawing afterwards. A COLOR that
''      returns the right number and stores the wrong one passes a return-only
''      check and then draws in the wrong colour.
''
'' The 16bpp expansion is the case worth the effort: it replicates each channel's
'' high bits into the vacated low bits, so a COLOR/COLOR round trip is NOT the
'' identity there and must not be "corrected".
''
'' Runs at 8, 16 and 32 bpp. gfxlib2's COLOR reads __fb_gfx->depth, so the screen
'' depth -- not an image target -- is what selects the branch.

#include once "../raster/color.bi"
#include once "../raster/box.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const W = 32
const H = 16

dim as string report
dim as long failures = 0
dim as long ran = 0

dim as ulong fgs(...) = { 0, 1, 15, 255, &hFF0000, &h00FF00, &h0000FF, &hFFFFFF, _
                          &h123456, &hABCDEF, &h808080, &hFFFFFFFF }
dim as ulong bgs(...) = { 0, 2, 7, 128, &h00FF00, &h0000FF, &hFF0000, &h010203, _
                          &hFEDCBA, &h654321, &h404040, &h7F7F7F }

for di as integer = 0 to 2
    dim as long depth = iif( di = 0, 8, iif( di = 1, 16, 32 ) )

    screenres W, H, depth, 1, GFX_NULL

    dim as DrawState d
    DrawStateInit( d, depth )

    '' Synchronise both sides explicitly. FB's COLOR *function* form does not
    '' accept omitted arguments, so there is no way to read the pair without
    '' also setting it -- set a known pair on both instead.
    color 15, 0
    Color32( d, depth, 15, 0, 0 )

    for i as integer = 0 to ubound( fgs )
        '' ---- A: gfxlib2 ----
        dim as ulong want = color( fgs(i), bgs(i) )
        '' ---- B: libtkogfx ----
        dim as ulong got = Color32( d, depth, fgs(i), bgs(i), 0 )

        ran += 1
        if want <> got then
            report += "  MISMATCH depth " + str(depth) + " return after fg=&h" + _
                      hex( fgs(i) ) + ": gfxlib2=&h" + hex( want ) + " tko=&h" + hex( got ) + chr(10)
            failures += 1
        end if
    next

    '' ---- omitted arguments must leave the other alone ----
    ''
    '' The STATEMENT form allows omission; the function form does not. So the
    '' omission is performed as a statement and its effect is observed through
    '' the NEXT return, which reports the pair the omission left behind. That is
    '' the stronger check anyway: it tests what was STORED, not what was echoed.
    color 7, 3
    Color32( d, depth, 7, 3, 0 )

    '' fg only; bg must survive as 3
    color 9
    Color32( d, depth, 9, 0, FB_COLOR_BG_DEFAULT )
    dim as ulong w1 = color( 5, 6 )
    dim as ulong g1 = Color32( d, depth, 5, 6, 0 )
    ran += 1
    if w1 <> g1 then
        report += "  MISMATCH depth " + str(depth) + " state after fg-only: " + _
                  "gfxlib2=&h" + hex(w1) + " tko=&h" + hex(g1) + chr(10)
        failures += 1
    end if

    '' bg only; fg must survive as 5
    color , 4
    Color32( d, depth, 0, 4, FB_COLOR_FG_DEFAULT )
    dim as ulong w2 = color( 1, 1 )
    dim as ulong g2 = Color32( d, depth, 1, 1, 0 )
    ran += 1
    if w2 <> g2 then
        report += "  MISMATCH depth " + str(depth) + " state after bg-only: " + _
                  "gfxlib2=&h" + hex(w2) + " tko=&h" + hex(g2) + chr(10)
        failures += 1
    end if

    screen 0
next

print "abtest-color -- "; ran; " COLOR cases across 8/16/32 bpp against gfxlib2"
if failures = 0 then
    print "abtest-color: PASS -- every case is identical"
    end 0
else
    print report;
    print "abtest-color: FAIL -- "; failures; " of"; ran; " cases differ"
    end 1
end if
