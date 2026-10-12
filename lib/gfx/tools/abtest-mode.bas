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
''
'' Split into roles (abtest.bi) so the table can also be checked against the
'' recording under the MSVC ABI. The per-mode case sequence is driven by the
'' TABLE, never by what SCREEN did, so it is the same in every role -- an
'' unsupported mode still emits its five geometry cases, comparing zero to zero.

#include once "../core/mode.ti"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

Abtest.Begin( "abtest-mode", "the mode table matches" )

'' SCREEN on an unsupported mode leaves the previous mode in place, so start
'' from a known one each time and detect failure by the geometry not changing.
for mode as integer = 1 to NUM_MODES - 1
    dim as long want_supported = ModeSupported( mode )
    dim as ModeInfo m = ModeTable(mode)
    dim as string tag = "mode " + str(mode)

    dim as long got_supported, w1, h1, d1, tw, th

#ifdef ABTEST_HAS_GFXLIB2
    '' A distinctive known mode first: if SCREEN fails, this geometry survives.
    screen 13
    dim as long w0, h0, d0, b0, p0, r0
    screeninfo w0, h0, d0, b0, p0, r0

    screen mode
    dim as long b1, p1, r1
    screeninfo w1, h1, d1, b1, p1, r1
    tw = loword( width( ) )
    th = hiword( width( ) )
    screen 0

    got_supported = 1
    if mode <> 13 then
        if (w1 = w0) andalso (h1 = h0) andalso (d1 = d0) then got_supported = 0
    end if

    '' An unsupported mode reports the geometry of SCREEN 13, which is not the
    '' table's zero row. Normalise here, on the side that knows, so the recorded
    '' value is the one the table can be compared against.
    if got_supported = 0 then
        w1 = 0 : h1 = 0 : d1 = 0 : tw = 0 : th = 0
    end if
#endif

    Abtest.Case_( tag + " supported", got_supported, want_supported )
    Abtest.Case_( tag + " width",     w1, m.w )
    Abtest.Case_( tag + " height",    h1, m.h )
    Abtest.Case_( tag + " depth",     d1, m.depth )
    Abtest.Case_( tag + " text_w",    tw, m.text_w )
    Abtest.Case_( tag + " text_h",    th, m.text_h )
next

Abtest.Finish_( )
