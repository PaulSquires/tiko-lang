'' entry/drawstr.bi -- DRAW and DRAW STRING.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' Both take an FBSTRING rather than a zstring, and both are measured:
'' graphics-abi.md records DRAW STRING's eleven arguments and DRAW's two.

#pragma once

namespace TkoGfx

'' An FBSTRING's length carries the TEMP BIT in its sign bit -- an fbc
'' temporary descriptor has a negative len. Masking it off is not optional: a
'' bare read gives a huge or negative length for exactly the descriptors these
'' two entry points are most often handed, because `DRAW "R10"` is a temporary.
private function StrFromDescriptor( byval p as any ptr ) as string
    dim as TkoAbi.FBSTRING ptr s = cptr( TkoAbi.FBSTRING ptr, p )
    if s = 0 then return ""
    if s->dat = 0 then return ""
    dim as integer n = s->len
    if n < 0 then n and= not (cast( integer, 1 ) shl (sizeof( integer ) * 8 - 1))
    if n <= 0 then return ""
    dim as string out_ = space( n )
    memcpy( strptr( out_ ), s->dat, n )
    return out_
end function

end namespace

extern "c"

'' DRAW [target,] commandstring
''
'' The scale, the angle and the cursor PERSIST between calls on the same target
'' -- "S8" in one statement sets the scale "R10" uses in the next. That is why
'' entry/context.bi caches a context per target rather than rebuilding one:
'' tools/abtest-draw.bas pins the behaviour directly.
sub TkoGfxDraw alias "fb_GfxDraw" ( _
        byval target as any ptr, byval cmd as any ptr )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then exit sub

    dim as string text = TkoGfx.StrFromDescriptor( cmd )
    if len( text ) = 0 then exit sub

    TkoGfx.Draw32( c->surf, text, c->draw.last_x, c->draw.last_y, _
                   c->draw.fg_color, c->surf.bpp * 8 )
end sub

'' DRAW STRING [target,] (x,y), text [, colour [, font [, mode ]]]
''
'' (target, x, y, flags, text, colour, font, mode, blender, customproc,
''  customparam)
''
'' Flags are convention B. The return is int64 on win64 and int32 on win32; it
'' is the error number, and 0 here.
''
'' TWO MEASURED TRAPS, both of which make a correct-looking implementation wrong:
''
''   THE DEFAULT MODE IS 0 (TRANS), not PUT's XOR. Same numbering, different
''   default, and taking PUT's default here makes every string invert.
''
''   `ALPHA, n` OVERWRITES THE COLOUR ARGUMENT with the alpha value, silently
''   discarding a colour that was written. So in mode 9 the colour slot is not a
''   colour -- reading it as one draws in whatever the alpha happened to be.
''
'' NOT IMPLEMENTED, and each is a real gap rather than a default:
''
''   A CUSTOM FONT IMAGE. `font` is an image whose glyphs replace the built-in
''   set; only the built-in 8x8/8x14/8x16 fonts are drawn. A caller passing one
''   gets the built-in font rather than an error, which is the wrong picture --
''   but refusing would break the common case of passing nothing.
''   The blender slot is filled only when a custom font is supplied, so it is
''   unreachable for the same reason.
''
''   THE BLEND MODES. Only TRANS and PSET are honoured; the bitwise and alpha
''   modes fall back to TRANS. raster/text.bi draws glyph-by-glyph rather than
''   through a putter, so routing them needs the glyph rendered to a scratch
''   surface first -- which is work, not a line.
function TkoGfxDrawString alias "fb_GfxDrawString" ( _
        byval target as any ptr, _
        byval fx as single, byval fy as single, _
        byval flags as long, _
        byval text as any ptr, _
        byval colour as ulong, _
        byval font_ as any ptr, _
        byval mode as long, _
        byval blender as any ptr, _
        byval customproc as any ptr, _
        byval customparam as any ptr ) as longint

    scope
        dim as any ptr ignored = blender
        ignored = customproc
        ignored = customparam
    end scope

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then return FB_RTERROR_ILLEGALFUNCTIONCALL

    dim as string s = TkoGfx.StrFromDescriptor( text )
    if len( s ) = 0 then return 0

    dim as long x, y
    TkoGfx.CoordB( *c, fx, fy, flags, x, y )

    '' In mode 9 the colour slot holds the ALPHA, not a colour, so a defaulted
    '' or overwritten colour both come from the context.
    dim as ulong col
    if (mode = TkoGfx.PUTMODE_BLEND) orelse ((flags and TkoGfx.COORD_COLOR_DEF) <> 0) then
        col = c->draw.fg_color
    else
        col = colour
    end if

    '' The font is the one the SCREEN MODE selects. A custom font image is not
    '' drawn -- see the header.
    dim as long fidx = TkoGfx.FontIndexForMode( TkoGfx.TheScreen.mode )
    if fidx < 0 then fidx = 0
    '' font_ is named and NOT honoured -- see the header.
    if font_ = 0 then : end if

    '' PSET is opaque, everything else is drawn transparent. TRANS is the
    '' default and the fallback, which is stated in the header rather than left
    '' to be inferred from this select.
    dim as long isopaque = iif( mode = TkoGfx.PUTMODE_PSET, 1, 0 )

    for i as integer = 0 to len( s ) - 1
        dim as long px = x + i * TkoGfx.FONT_WIDTH
        if isopaque then
            TkoGfx.DrawGlyph( c->surf, px, y, s[i], fidx, col, c->draw.bg_color )
        else
            TkoGfx.DrawGlyphTrans( c->surf, px, y, s[i], fidx, col )
        end if
    next

    return 0
end function

end extern
