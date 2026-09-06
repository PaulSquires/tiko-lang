'' text.bi -- console text on a graphics screen.
''
'' Derived from: gfx_print.c (the glyph loop in fb_GfxPrintBufferEx).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' THREE THINGS THE GLYPH LOOP DOES THAT ARE EASY TO GET BACKWARDS
''
'' 1. BIT 0 IS THE LEFTMOST PIXEL. The loop starts with `char_bit_mask = 1` and
''    shifts LEFT as x increases, so the low bit of each font byte is the left
''    edge. Most bitmap fonts are MSB-first; packing this one that way mirrors
''    every glyph horizontally, which reads as a broken font rather than a
''    reversed bit order.
''
'' 2. PRINT IS OPAQUE. A clear bit draws the BACKGROUND colour, it is not
''    skipped. So printing over existing graphics erases a full character cell,
''    and printing a space is not a no-op. Treating 0 bits as transparent looks
''    correct on a black screen and wrong everywhere else.
''
'' 3. THE CELL IS THE FONT'S FULL BOX. Advance is `font->w` per character and
''    `font->h` per row, with no kerning and no inter-character gap -- the gap is
''    inside the glyph.
''
'' All three fonts are 8 pixels wide; only the height varies (8, 14, 16), which
'' is why a row is exactly one byte and `char_row_byte_count` is always 1 in
'' practice. The general form is kept anyway, since it is what the C computes.

#pragma once

#include once "pixel.bi"
#include once "pixelfmt.bi"
#include once "../core/font-data.bi"
#include once "../core/mode.bi"
#include once "../core/dirty.bi"

namespace TkoGfx

const FONT_WIDTH = 8

'' Font index for a mode's font height. -1 if the mode has no font.
private function FontIndexForMode( byval mode as long ) as long
    select case ModeFontHeight( mode )
    case 8  : return 0
    case 14 : return 1
    case 16 : return 2
    end select
    return -1
end function

'' Draw one character at a PIXEL position. Opaque: clear bits get `bg`.
private sub DrawGlyph( _
        byref s as Surface, _
        byval px as long, byval py as long, _
        byval ch as long, byval fidx as long, _
        byval fg as ulong, byval bg as ulong )

    if (fidx < 0) orelse (fidx > 2) then exit sub
    dim as long fh = FontHeight(fidx)
    dim as ubyte ptr glyph = @FontData( FontDataOfs(fidx) + (ch and &hFF) * fh )

    dim as integer row = 0
    while row < fh
        dim as ubyte bits = glyph[row]
        dim as integer col = 0
        while col < FONT_WIDTH
            '' bit 0 is the LEFTMOST pixel -- see the header
            dim as ulong c = iif( (bits and (1 shl col)) <> 0, fg, bg )
            '' PSetAny, NOT PSet32. Console text is normally drawn on an 8bpp
            '' legacy mode, and PSet32 there writes four bytes per pixel -- the
            '' glyph comes out with its columns four bytes apart and gaps
            '' between, which reads as a corrupt font rather than a wrong
            '' pixel width.
            PSetAny( s, px + col, py + row, c )
            col += 1
        wend
        row += 1
    wend
end sub

'' The same glyph, TRANSPARENT: clear bits are left alone rather than painted
'' with a background colour.
''
'' UNGATED. tools/abtest-print.bas compares the OPAQUE path, because that is
'' what PRINT uses -- gfxlib2's PRINT repaints the whole cell. Nothing compares
'' this one: its only caller is DRAW STRING, whose default mode is TRANS, and
'' that entry point has no A/B test yet. It is a five-line variant of a routine
'' that is measured, which is a reason to believe it and not a reason to say it
'' is checked.
private sub DrawGlyphTrans( _
        byref s as Surface, _
        byval px as long, byval py as long, _
        byval ch as long, byval fidx as long, _
        byval fg as ulong )

    if (fidx < 0) orelse (fidx > 2) then exit sub
    dim as long fh = FontHeight(fidx)
    dim as ubyte ptr glyph = @FontData( FontDataOfs(fidx) + (ch and &hFF) * fh )

    dim as integer row = 0
    while row < fh
        dim as ubyte bits = glyph[row]
        dim as integer col = 0
        while col < FONT_WIDTH
            '' bit 0 is the LEFTMOST pixel -- see the header
            if (bits and (1 shl col)) <> 0 then
                '' PSetAny, NOT PSet32 -- the reason is at DrawGlyph above.
                PSetAny( s, px + col, py + row, fg )
            end if
            col += 1
        wend
        row += 1
    wend
end sub

'' Draw a string starting at a CHARACTER CELL. Cells are 1-based in the
'' statement (LOCATE 1,1 is the top-left) and 0-based here.
private sub DrawText( _
        byref s as Surface, _
        byval col0 as long, byval row0 as long, _
        byref text as string, _
        byval fidx as long, _
        byval fg as ulong, byval bg as ulong )

    if (fidx < 0) orelse (fidx > 2) then exit sub
    dim as long fh = FontHeight(fidx)
    dim as long px = col0 * FONT_WIDTH
    dim as long py = row0 * fh

    for i as integer = 1 to len( text )
        DrawGlyph( s, px, py, text[i - 1], fidx, fg, bg )
        px += FONT_WIDTH
    next
end sub

end namespace
