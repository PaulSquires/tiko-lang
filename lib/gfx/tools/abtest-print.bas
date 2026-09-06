'' abtest-print.bas -- A/B console text rendering against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' PRINT on a graphics screen draws glyphs into the framebuffer, so it is
'' comparable the same way every other primitive is: print with gfxlib2, render
'' the same text ourselves, digest both.
''
'' This also verifies the EXTRACTED FONT DATA. `core/font-data.bi` is 9728 bytes
'' read out of gfxlib2 by rendering rather than transcribed, and every case here
'' re-renders through the reference, so a stale or mis-packed table fails as a
'' glyph mismatch rather than as a subtly wrong letter somewhere.
''
'' Cases cover:
''   - all three font heights (8, 14, 16), via modes that use each
''   - the FULL 0..255 character range in blocks, not just printable ASCII --
''     the box-drawing and accented ranges are where a mis-packed table shows
''   - a NON-BLACK background, because PRINT is opaque: a clear bit draws the
''     background colour. On a black screen a transparent implementation looks
''     identical, so every case prints over a pre-filled area.
''   - printing at several cell positions, so the cell-to-pixel mapping is
''     exercised rather than just (0,0)
''
'' chr(255) IS INCLUDED NOW, AND THE OLD EXCLUSION WAS A WRONG EXPLANATION.
''
'' What this file used to say: that PRINT is transparent for this one character,
'' because gfxlib2 left the cell's pre-fill in rows 0..6 and drew row 7 in the
'' foreground where every other character repaints the whole cell. The
'' observation was right and the explanation was not.
''
'' chr(255) PRINTED ALONE IS THE TEXT CARET, not a glyph. A one-byte write of
'' 255 draws a row of foreground across the bottom of the cell and touches
'' nothing else -- which is exactly "the pre-fill survives and row 7 is drawn".
'' The real glyph is BLANK in all three fonts, and the `00 ... 00 FF` this file
'' called "the glyph data" was the caret, captured by an extractor that printed
'' every character on its own. RFC-0011 section 9.14.
''
'' Here it is printed inside a block of sixteen, so it is a glyph and comparable
'' like the other 223. The caret shape has its own cases in tools/gate-entry.bas,
'' where a public PRINT can be compared.

#include once "../raster/text.bi"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

Abtest.Begin( "abtest-print", "glyphs are pixel-identical" )

'' one mode per font height
dim as long modes(...) = { 13, 9, 11 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for
    dim as long fidx = FontIndexForMode( mode )
    if fidx < 0 then continue for

    dim as long spitch = 0
#ifdef ABTEST_HAS_GFXLIB2
    screen mode
    dim as long xw, xh, sdepth, sbpp, srefresh
    screeninfo xw, xh, sdepth, sbpp, spitch, srefresh
#endif
    '' The geometry is the mode table's -- abtest-mode proves it agrees with
    '' SCREENINFO. Only the pitch is the driver's, so only the pitch is seeded.
    dim as long sw = ModeTable(mode).w
    dim as long sh = ModeTable(mode).h
    spitch = cast( long, Abtest.Datum_( "m" + str(mode) + " pitch", spitch ) )
    dim as long fh = FontHeight(fidx)

    '' Characters 32..255 in blocks of 16.
    ''
    '' 0..31 are EXCLUDED on purpose: PRINT INTERPRETS them -- chr(7) rings,
    '' chr(8) backspaces, chr(10) and chr(13) move the cursor -- so they never
    '' reach the glyph renderer at all. Their font data is still real and is used
    '' by DRAW STRING, which does not interpret anything; that is where they get
    '' covered, not here.
    for blk as integer = 2 to 15
        dim as string txt
        for k as integer = 0 to 15
            dim as long cc = blk * 16 + k
            txt += chr( cc )
        next

        dim as long crow = (blk mod 4) + 1
        dim as long ccol = (blk mod 3) + 1

        dim as string tag = "mode " + str(mode) + " font" + str(fh) + _
                            " chars " + str(blk*16) + ".." + str(blk*16+15) + _
                            " at cell (" + str(ccol) + "," + str(crow) + ")"
        dim as ulongint want = 0

#ifdef ABTEST_HAS_GFXLIB2
        '' ---- A: gfxlib2 ----
        '' pre-fill so an opaque PRINT is distinguishable from a transparent one
        color 2, 5
        cls
        line (0,0)-(sw-1,sh-1), 3, BF
        '' cursor OFF. Measured since: LOCATE's third argument changes nothing a
        '' graphics screen draws -- gfxlib2 ignores it there -- so this is
        '' belt-and-braces rather than load-bearing.
        locate crow, ccol, 0
        print txt;

        dim as ubyte ptr fbp = cptr( ubyte ptr, screenptr( ) )
        want = 14695981039346656037ull
        for y as integer = 0 to sh - 1
            dim as ubyte ptr r = fbp + y * spitch
            for x as integer = 0 to sw - 1
                want = (want xor r[x]) * 1099511628211ull
            next
        next
#endif

        '' ---- B: libtkogfx, into our own 8bpp buffer ----
        dim as ubyte ptr mine = allocate( spitch * sh )
        dim as Surface s
        SurfaceInit( s, mine, sw, sh, spitch, 1 )
        '' same pre-fill
        for y as integer = 0 to sh - 1
            dim as ubyte ptr r = mine + y * spitch
            for x as integer = 0 to sw - 1
                r[x] = 3
            next
        next
        '' PRINT uses 0-based cells internally; LOCATE is 1-based
        '' On modes 7/8/9 COLOR routes the background into palette entry 0 and
        '' leaves bg_color at 0 -- so the glyph background is 0, not 5. See
        '' raster/color.bi. Using 5 here renders every cell wrong.
        dim as long usebg = iif( (mode = 7) orelse (mode = 8) orelse (mode = 9), 0, 5 )
        DrawText( s, ccol - 1, crow - 1, txt, fidx, 2, usebg )

        dim as ulongint got = 14695981039346656037ull
        for y as integer = 0 to sh - 1
            dim as ubyte ptr r = mine + y * spitch
            for x as integer = 0 to sw - 1
                got = (got xor r[x]) * 1099511628211ull
            next
        next

        Abtest.Case_( tag, want, got )
        deallocate( mine )
    next
#ifdef ABTEST_HAS_GFXLIB2
    screen 0
#endif
next

Abtest.Finish_( )
