'' abtest-mode.bas -- A/B the SCREEN 1..21 mode table against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' The table is transcribed data rather than an algorithm, which makes it exactly
'' the kind of thing that is easy to get subtly wrong and hard to notice -- one
'' transposed row and a rarely-used mode is silently the wrong size forever.
''
'' So every row is checked against what SCREEN actually opens:
''
''   - width, height and depth from SCREENINFO
''   - text columns and rows from WIDTH
''   - whether the mode opens AT ALL, which pins the 3/4/5/6 holes
''
'' The holes matter: they are real QBasic modes gfxlib2 does not implement, and
'' they sit in the table as zero rows so that mode numbers stay array indices.
'' A table that simply omitted them would shift every later mode by four.

#include once "../core/mode.bi"
#include once "fbgfx.bi"

using TkoGfx
using FB

dim as string report
dim as long failures = 0
dim as long ran = 0

'' SCREEN on an unsupported mode leaves the previous mode in place, so start
'' from a known one each time and detect failure by the geometry not changing.
for mode as integer = 1 to NUM_MODES - 1
    dim as long want_supported = ModeSupported( mode )

    '' A distinctive known mode first: if SCREEN fails, this geometry survives.
    screen 13
    dim as long w0, h0, d0, b0, p0, r0
    screeninfo w0, h0, d0, b0, p0, r0

    screen mode
    dim as long w1, h1, d1, b1, p1, r1
    screeninfo w1, h1, d1, b1, p1, r1
    dim as long tw = loword( width( ) )
    dim as long th = hiword( width( ) )
    screen 0

    dim as long got_supported = 1
    if mode <> 13 then
        if (w1 = w0) andalso (h1 = h0) andalso (d1 = d0) then got_supported = 0
    end if

    ran += 1
    if got_supported <> want_supported then
        report += "  MISMATCH mode " + str(mode) + " supported: gfxlib2=" + _
                  str(got_supported) + " table=" + str(want_supported) + chr(10)
        failures += 1
        continue for
    end if

    if want_supported = 0 then continue for

    dim as ModeInfo m = ModeTable(mode)
    ran += 3
    if w1 <> m.w then
        report += "  MISMATCH mode " + str(mode) + " width: gfxlib2=" + str(w1) + " table=" + str(m.w) + chr(10)
        failures += 1
    end if
    if h1 <> m.h then
        report += "  MISMATCH mode " + str(mode) + " height: gfxlib2=" + str(h1) + " table=" + str(m.h) + chr(10)
        failures += 1
    end if
    if d1 <> m.depth then
        report += "  MISMATCH mode " + str(mode) + " depth: gfxlib2=" + str(d1) + " table=" + str(m.depth) + chr(10)
        failures += 1
    end if

    ran += 2
    if tw <> m.text_w then
        report += "  MISMATCH mode " + str(mode) + " text_w: gfxlib2=" + str(tw) + " table=" + str(m.text_w) + chr(10)
        failures += 1
    end if
    if th <> m.text_h then
        report += "  MISMATCH mode " + str(mode) + " text_h: gfxlib2=" + str(th) + " table=" + str(m.text_h) + chr(10)
        failures += 1
    end if
next

print "abtest-mode -- "; ran; " checks over SCREEN 1.."; NUM_MODES - 1; " against gfxlib2"
if failures = 0 then
    print "abtest-mode: PASS -- the mode table matches"
    end 0
else
    print report;
    print "abtest-mode: FAIL -- "; failures; " check(s) differ"
    end 1
end if
