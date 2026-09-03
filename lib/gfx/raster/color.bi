'' color.bi -- COLOR: set the drawing colours, return the previous pair.
''
'' Derived from: gfx_color.c (fb_GfxColor), gfx_palette.c (fb_hMakeColor).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' THE RETURN VALUE IS DEPTH-DEPENDENT, AND 16BPP IS NOT A SIMPLE UNPACK.
''
''   depth <= 8   fg or (bg shl 16)      -- both palette indices, packed
''   depth == 16  the stored RGB565 fg EXPANDED back to RGB888, with the low
''                bits replicated from the high ones, plus opaque alpha
''   depth == 32  the stored fg, unchanged
''
'' The 16bpp expansion is the interesting one. Storing a colour loses bits --
'' 8:8:8 becomes 5:6:5 -- and `COLOR` has to hand something back. gfxlib2 does
'' not return the truncated value shifted up, which would make white read as
'' &hF8FCF8; it replicates each channel's top bits into the vacated low bits so
'' that full-scale stays full-scale:
''
''     ((c and 001F) shl 3) or ((c shr  2) and 0007)      blue
''     ((c and 07E0) shl 5) or ((c shr  1) and 0300)      green
''     ((c and F800) shl 8) or ((c shl  3) and 70000)     red
''     or &hFF000000                                       alpha
''
'' A COLOR/COLOR round trip at 16bpp is therefore NOT the identity, and is not
'' meant to be. Anything that assumes it is will drift.
''
'' THE LEGACY MODES DO NOT STORE A BACKGROUND COLOUR AT ALL.
''
''   SCREEN 1        BOTH fg and bg go to the PALETTE. fg_color and bg_color are
''                   untouched, so the drawing colours never change -- CGA's four
''                   colours are selected by repainting the palette.
''   SCREEN 7, 8, 9  fg_color = fg and &hF, but the background sets PALETTE ENTRY
''                   0 rather than bg_color. bg_color stays whatever it was.
''   everything else fg_color and bg_color both set, through FixColor
''
'' The consequence is visible immediately in PRINT: on mode 9, `COLOR 2, 5` then
'' printing draws the glyph on background **0**, not 5, because 5 went into the
'' palette. An implementation that stored bg_color on those modes renders every
'' character cell in the wrong colour -- which is how this was found.

#pragma once

#include once "pixelfmt.bi"
#include once "../core/palette.bi"

namespace TkoGfx

const FB_COLOR_FG_DEFAULT = 1
const FB_COLOR_BG_DEFAULT = 2

'' The drawing colours, and the graphics cursor. gfxlib2 keeps these in
'' FB_GFXCTX; here they are explicit so nothing depends on a hidden context.
type DrawState
    fg_color as ulong
    bg_color as ulong
    last_x   as single
    last_y   as single
end type

private sub DrawStateInit( byref d as DrawState, byval depth as long )
    '' gfxlib2 starts white on black at every depth; at 8bpp that is index 15.
    if depth <= 8 then
        d.fg_color = 15
        d.bg_color = 0
    else
        d.fg_color = FixColor( iif( depth = 16, 2, 4 ), &hFFFFFF )
        d.bg_color = 0
    end if
    d.last_x = 0
    d.last_y = 0
end sub

'' COLOR. Returns the PREVIOUS colour pair, in the depth-dependent form above.
'' `flags` suppresses either assignment, which is how an omitted argument is
'' spelled -- `COLOR , 2` leaves the foreground alone.
private function Color32( _
        byref d as DrawState, _
        byval depth as long, _
        byval fg as ulong, byval bg as ulong, _
        byval flags as long, _
        byval mode as long = 0, _
        byval pal as GfxPalette ptr = 0 ) as ulong

    dim as ulong cur

    if depth <= 8 then
        cur = d.fg_color or (d.bg_color shl 16)
    elseif depth = 16 then
        dim as ulong c = d.fg_color
        cur = ((c and &h001F) shl 3) or ((c shr 2) and &h7) or _
              ((c and &h07E0) shl 5) or ((c shr 1) and &h300) or _
              ((c and &hF800) shl 8) or ((c shl 3) and &h70000) or _
              &hFF000000
    else
        cur = d.fg_color
    end if

    dim as long bpp = iif( depth <= 8, 1, iif( depth = 16, 2, 4 ) )

    '' ---- the legacy branches ----
    select case mode
    case 1
        '' Both colours are palette operations; neither drawing colour changes.
        if pal <> 0 then
            if (flags and FB_COLOR_BG_DEFAULT) = 0 then
                PaletteSetPacked( *pal, -(4 - (cast( long, bg ) and 3)), 0 )
            end if
            if (flags and FB_COLOR_FG_DEFAULT) = 0 then
                PaletteSetPacked( *pal, 0, fg )
            end if
        end if
        return cur

    case 7, 8, 9
        if (flags and FB_COLOR_FG_DEFAULT) = 0 then
            d.fg_color = fg and &hF
        end if
        if (flags and FB_COLOR_BG_DEFAULT) = 0 then
            '' the background goes to palette entry 0, NOT to bg_color
            if pal <> 0 then PaletteSetPacked( *pal, 0, bg )
        end if
        return cur
    end select

    if (flags and FB_COLOR_FG_DEFAULT) = 0 then
        if depth > 8 then
            d.fg_color = FixColor( bpp, fg )
        else
            d.fg_color = fg and &hFF
        end if
    end if

    if (flags and FB_COLOR_BG_DEFAULT) = 0 then
        if depth > 8 then
            d.bg_color = FixColor( bpp, bg )
        else
            d.bg_color = bg and &hFF
        end if
    end if

    return cur
end function

end namespace
