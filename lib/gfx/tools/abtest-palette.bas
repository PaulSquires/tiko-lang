'' abtest-palette.bas -- A/B for PALETTE and PALETTE GET against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' GfxPalette entries are never observed as pixels here -- they are observed through
'' PALETTE GET, which is the only way to see what was stored. That makes the two
'' GET forms the whole surface, and they disagree with each other by design:
''
''   PALETTE GET i, r, g, b   full 8-bit channels, RED FROM THE LOW BYTE
''   PALETTE GET i, v         three 6-BIT channels packed, (c and FCFCFC) shr 2
''
'' Cases cover: every channel in isolation (which catches an r/b swap, the most
'' likely mistake), values whose low two bits are lost by the 6-bit form,
'' out-of-range indices (masked, never an error), and several modes so the mask
'' width changes.
''
'' Only modes with a palette are tested -- PALETTE is a no-op above 8bpp.

#include once "../core/palette.bi"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

'' The reference seam. PALETTE and PALETTE GET are statements, so they cannot go
'' through REF(); these evaporate in the subject role instead, and the reads
'' answer zero -- which Case_ discards, comparing against the recording.
#ifdef ABTEST_HAS_GFXLIB2
#macro REFPAL4( i_, r_, g_, b_ )
    palette i_, r_, g_, b_
#endmacro
#macro REFPAL2( a_, v_ )
    palette a_, v_
#endmacro
#macro REFSCREEN( m_ )
    screen m_
#endmacro
#else
#macro REFPAL4( i_, r_, g_, b_ )
#endmacro
#macro REFPAL2( a_, v_ )
#endmacro
#macro REFSCREEN( m_ )
#endmacro
#endif

sub RefPaletteGet( byval idx as long, byref r as long, byref g as long, byref b as long )
#ifdef ABTEST_HAS_GFXLIB2
    palette get idx, r, g, b
#else
    r = 0 : g = 0 : b = 0
#endif
end sub

function RefPaletteGetPacked( byval idx as long ) as long
#ifdef ABTEST_HAS_GFXLIB2
    dim as long v
    palette get idx, v
    return v
#else
    return 0
#endif
end function

'' Three channels in one number, so a colour is one recordable value.
function Rgb3( byval r as long, byval g as long, byval b as long ) as ulongint
    return (cast( ulongint, r ) shl 16) or (cast( ulongint, g ) shl 8) or cast( ulongint, b )
end function

sub chkrgb( byref what as string, byval wr as long, byval wg as long, byval wb as long, _
        byval gr as long, byval gg as long, byval gb as long )
    Abtest.Case_( what, Rgb3( wr, wg, wb ), Rgb3( gr, gg, gb ), _
                  "tko=(" + str(gr) + "," + str(gg) + "," + str(gb) + ")" )
end sub

Abtest.Begin( "abtest-palette", "every case is identical" )

'' mode, and the palette size the table says it has
dim as long modes(...) = { 13, 1, 7, 9, 11, 18 }

dim as long rs(...) = { 0, 63, 255, 1, 2, 3, 128, 170, 85, 254, 7, 200 }
dim as long gs(...) = { 0, 255, 63, 2, 3, 1, 64, 85, 170, 253, 8, 100 }
dim as long bs(...) = { 0, 128, 31, 3, 1, 2, 32, 51, 204, 252, 9, 50 }


'' ---- every supported mode's generated defaults, not just the sampled ones ----
''
'' This is what keeps core/palette-data.bi honest: 2692 entries extracted from
'' gfxlib2 rather than transcribed, re-read from the reference every run.
''
'' It covers ALL 17 supported modes deliberately. An earlier version checked only
'' the six modes sampled below, and a deliberately corrupted entry in mode 16
'' went UNDETECTED -- 11 of 17 modes' data was unverified while the suite
'' reported green.
'' ONE case per mode over the WHOLE table, rather than one per entry. The
'' per-entry form only ever printed the first two differences anyway, and a
'' recording with 2692 lines in it is not something anyone reads; a digest over
'' the whole table discriminates exactly as well, and the first differing entry
'' still goes in the detail line.
for mode as integer = 1 to NUM_MODES - 1
    if ModeSupported( mode ) = 0 then continue for
    REFSCREEN( mode )
    dim as GfxPalette defs
    if PaletteLoadDefaults( defs, mode ) = 0 then
        Abtest.Fail_( "mode " + str(mode) + " defaults", "MISSING generated defaults" )
    else
        dim as long n = ModePaletteColors( mode )
        dim as ulongint wacc = 14695981039346656037ull
        dim as ulongint gacc = 14695981039346656037ull
        dim as long firstbad = -1
        for i as integer = 0 to n - 1
            dim as long wr, wg, wb
            RefPaletteGet( i, wr, wg, wb )
            dim as long gr, gg, gb
            PaletteGetRgb( defs, i, gr, gg, gb )
            wacc = (wacc xor Rgb3( wr, wg, wb )) * 1099511628211ull
            gacc = (gacc xor Rgb3( gr, gg, gb )) * 1099511628211ull
            if (firstbad < 0) andalso (wacc <> gacc) then firstbad = i
        next
        Abtest.Case_( "mode " + str(mode) + " generated defaults (" + str(n) + " entries)", _
                      wacc, gacc, _
                      iif( firstbad >= 0, "first differing entry " + str(firstbad), "" ) )
    end if
    REFSCREEN( 0 )
next

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for

    REFSCREEN( mode )

    dim as GfxPalette p
    PaletteInit( p, ModePaletteColors( mode ) )

    '' ---- set, then read back both ways ----
    for i as integer = 0 to ubound( rs )
        dim as long idx = i
        REFPAL4( idx, rs(i), gs(i), bs(i) )
        PaletteSetRgb( p, idx, rs(i), gs(i), bs(i) )

        dim as long wr, wg, wb
        RefPaletteGet( idx, wr, wg, wb )
        dim as long gr, gg, gb
        PaletteGetRgb( p, idx, gr, gg, gb )
        chkrgb( "mode " + str(mode) + " idx " + str(idx) + " rgb", wr, wg, wb, gr, gg, gb )

        '' the packed one-argument form
        Abtest.Case_( "mode " + str(mode) + " idx " + str(idx) + " packed", _
                      RefPaletteGetPacked( idx ), PaletteGetPacked( p, idx ) )
    next

    '' ---- out-of-range indices are MASKED, not errors ----
    dim as long size = ModePaletteColors( mode )
    dim as long probes(...) = { size, size + 1, size * 2 + 3, 255, 300, 1000 }
    for k as integer = 0 to ubound( probes )
        REFPAL4( probes(k), 11, 22, 33 )
        PaletteSetRgb( p, probes(k), 11, 22, 33 )

        dim as long wr, wg, wb
        RefPaletteGet( probes(k), wr, wg, wb )
        dim as long gr, gg, gb
        PaletteGetRgb( p, probes(k), gr, gg, gb )
        chkrgb( "mode " + str(mode) + " wrapped idx " + str(probes(k)), wr, wg, wb, gr, gg, gb )
    next

    REFSCREEN( 0 )
next


'' ---- PALETTE index, VALUE: the two-argument form ----
''
'' This form was UNCOVERED until the VGA port work forced a read of the C. Every
'' case above uses the four-argument `PALETTE i, r, g, b`, which is a completely
'' different code path. The two-argument form is two statements wearing one
'' syntax -- a 6-bit packed colour on 256-colour modes, a REGISTER NUMBER on the
'' low-colour modes -- and neither was implemented.
''
'' The 6-bit scale is (v * 255) \ 63, not v shl 2. Both round-trip losslessly
'' through PALETTE GET, so a round-trip test passes either way; only comparing
'' the RGB discriminates. That is what these cases do.
'' both saturation ends plus the midpoint, where a shl-2 scale first diverges
dim as long c6(0 to 6) = { 0, 1, 2, 31, 32, 62, 63 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for
    dim as long colors = ModePaletteColors( mode )
    '' PALETTE is a no-op above 8bpp and those modes report no palette --
    '' `mod colors` would be a division by zero, which is how this first
    '' presented (a segfault, not a failed case)
    if colors <= 0 then continue for

    '' ATTRIBUTES ARE BOUNDED TO (1 shl depth), NOT TO `colors`, AND THAT IS A
    '' BUG IN THE REFERENCE, NOT A CONSERVATIVE CHOICE HERE.
    ''
    '' gfx_screen.c allocates `color_association = malloc(16)` -- sixteen bytes
    '' -- while fb_hSetPaletteColor masks the attribute to
    '' `default_palette->colors - 1`, which is 63 on the EGA modes. So
    '' `PALETTE 35, 25` on SCREEN 9 writes well past that allocation.
    ''
    '' It does not fault where it happens. The corrupted heap is only touched at
    '' the next mode change, so a loop of SCREEN 9 / PALETTE / SCREEN 0 dies
    '' after four to ten iterations with the fault nowhere near the write.
    ''
    '' The default-restore path in fb_GfxPalette guards the same array with
    '' `if (i < (1 shl depth))`. Only the explicit two-argument form is
    '' unguarded.
    ''
    '' We do not reproduce it -- our assoc() is a fixed 256 entries, so the write
    '' lands where gfxlib2 INTENDED it to. The visible palette result agrees for
    '' the high attributes too; it was compared up to the point the reference
    '' took the process down. The suite stays inside the domain where the
    '' reference is trustworthy.
    dim as long attrs = ModeAttributeCount( mode )
    if attrs > colors then attrs = colors

    for k as integer = 0 to 23
        REFSCREEN( mode )
        '' PaletteLoadDefaults RETURNS 0 and leaves `p` UNTOUCHED for a mode
        '' with no default table. Using it then reads an uninitialised colour
        '' count and indexes the entry array out of range -- which is a
        '' segfault, not a reported mismatch. Check the result.
        dim as GfxPalette p
        if PaletteLoadDefaults( p, mode ) = 0 then
            REFSCREEN( 0 )
            continue for
        end if

        dim as long attr = (k * 7) mod attrs
        dim as long val_
        if colors >= 256 then
            '' three 6-bit channels, including both saturation ends
            val_ = c6(k mod 7) or (c6((k + 2) mod 7) shl 8) or (c6((k + 4) mod 7) shl 16)
        else
            val_ = (k * 5) mod colors
        end if

        REFPAL2( attr, val_ )
        dim as long wr, wg, wb
        RefPaletteGet( attr, wr, wg, wb )

        PaletteSetPacked( p, attr, cast( ulong, val_ ) )
        dim as long gr, gg, gb
        PaletteGetRgb( p, attr, gr, gg, gb )

        chkrgb( "mode " + str(mode) + " PALETTE " + str(attr) + ", " + str(val_), _
                wr, wg, wb, gr, gg, gb )
        REFSCREEN( 0 )
    next
next

Abtest.Finish_( )
