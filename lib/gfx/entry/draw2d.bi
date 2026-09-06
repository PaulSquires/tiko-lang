'' entry/draw2d.bi -- LINE, PSET/PRESET, CIRCLE, PAINT, POINT, VIEW, WINDOW.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' Each of these is thin by design: resolve the context, decode the coordinate
'' convention, resolve a defaulted colour, call the raster routine that
'' tools/abtest-*.bas already compares against gfxlib2. The argument orders and
'' every default are docs/language/graphics-abi.md, read out of the C that
'' `fbc -r -gen gcc` emits.
''
'' WHAT IS NEW HERE AND THEREFORE UNGATED: the decoding. The rasterizers below
'' are measured; the translation from (target, flags, defaulted colour) into
'' their arguments is not, because no test drives an entry point yet. That is
'' the honest boundary of this file.

#pragma once

extern "c"

'' ---------------------------------------------------------------------- LINE
''
'' (target, x1, y1, x2, y2, colour, boxflag, style, coordflags)
''
'' B AND BF ARE A SEPARATE INTEGER, NOT A BITMASK: 0 plain, 1 B, 2 BF. Reading
'' them as bits makes BF draw an outline.
''
'' THE STYLE MASK IS NOT IMPLEMENTED. `style` is a 16-bit pattern rotated along
'' the line, defaulting to 65535 (solid). raster/line.bi draws solid only, so a
'' styled line comes out solid rather than wrong-looking -- recorded here rather
'' than silently accepted, because it is the one argument this file takes and
'' discards.
sub TkoGfxLine alias "fb_GfxLine" ( _
        byval target as any ptr, _
        byval fx1 as single, byval fy1 as single, _
        byval fx2 as single, byval fy2 as single, _
        byval colour as ulong, _
        byval boxflag as long, _
        byval style as ulong, _
        byval flags as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then exit sub
    scope : dim as ulong ignored = style : end scope

    dim as long x1, y1, x2, y2
    TkoGfx.CoordA( *c, fx1, fy1, fx2, fy2, flags, x1, y1, x2, y2 )
    dim as ulong col = TkoGfx.ResolveColor( *c, colour, flags )

    select case boxflag
    case 1 : TkoGfx.LineBoxAny( c->surf, x1, y1, x2, y2, col, 0 )
    case 2 : TkoGfx.LineBoxAny( c->surf, x1, y1, x2, y2, col, 1 )
    case else : TkoGfx.DrawLineAny( c->surf, x1, y1, x2, y2, col )
    end select
end sub

'' -------------------------------------------------------------- PSET / PRESET
''
'' (target, x, y, colour, flags, isPreset)
''
'' PRESET IS THE SAME FUNCTION with a trailing -1: it means "use the BACKGROUND
'' colour when none was written", not "invert". A defaulted colour therefore
'' resolves differently for the two, and nothing else does.
sub TkoGfxPset alias "fb_GfxPset" ( _
        byval target as any ptr, _
        byval fx as single, byval fy as single, _
        byval colour as ulong, _
        byval flags as long, _
        byval ispreset as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then exit sub

    dim as long x, y
    TkoGfx.CoordB( *c, fx, fy, flags, x, y )

    dim as ulong col
    if (flags and TkoGfx.COORD_COLOR_DEF) <> 0 then
        col = iif( ispreset <> 0, c->draw.bg_color, c->draw.fg_color )
    else
        col = colour
    end if

    TkoGfx.PSetAny( c->surf, x, y, col )
end sub

'' -------------------------------------------------------------------- CIRCLE
''
'' (target, x, y, radius, colour, aspect, start, end, fill, flags)
''
'' THE ASPECT COMES BEFORE START AND END IN THE CALL, the reverse of the BASIC
'' syntax order. Reading them positionally as written gets an ellipse where an
'' arc was asked for.
''
'' Defaults: aspect 0 (auto), start 0, end 2pi, fill 0, F -> -1.
''
'' ASPECT 0 MEANS "SCREEN ASPECT". For an image target gfxlib2 uses
'' __fb_gfx->aspect, which is 1.0 for a square-pixel mode -- which is every mode
'' this library opens, since the framebuffer is 32bpp at the mode's own
'' geometry. So 0 becomes 1.0 here, and that is the same substitution
'' tools/abtest-circle.bas makes on the libtkogfx side.
sub TkoGfxEllipse alias "fb_GfxEllipse" ( _
        byval target as any ptr, _
        byval fx as single, byval fy as single, _
        byval radius as single, _
        byval colour as ulong, _
        byval aspect as single, _
        byval start_ as single, byval end_ as single, _
        byval fill as long, _
        byval flags as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then exit sub

    dim as long x, y
    TkoGfx.CoordB( *c, fx, fy, flags, x, y )
    dim as ulong col = TkoGfx.ResolveColor( *c, colour, flags )

    dim as single asp = aspect
    if asp <= 0.0 then asp = 1.0

    TkoGfx.CircleAny( c->surf, x, y, radius, col, asp, _
                     iif( fill <> 0, 1, 0 ), start_, end_ )
end sub

'' --------------------------------------------------------------------- PAINT
''
'' (target, x, y, colour, bordercolour, pattern, isPattern, flags)
''
'' THE PATTERN DESCRIPTOR IS ALWAYS PASSED, NEVER NULL: with no pattern fbc
'' allocates an empty temporary and passes isPattern = 0. So the pattern
'' argument is not the test -- isPattern is.
''
'' A PATTERN FORCES THE COLOUR ARGUMENT TO &hFFFF0000, discarding whatever
'' colour was written. Measured. raster/paint.bi takes the tile instead of a
'' colour in that case, so the forced value is simply not used.
''
'' The tile is read from the FBSTRING's data as 8x8 32-bit pixels -- 256 bytes.
'' A shorter string is a caller error in fbc too; it is refused here rather than
'' read past, which is the one place this differs from "whatever the C does".
sub TkoGfxPaint alias "fb_GfxPaint" ( _
        byval target as any ptr, _
        byval fx as single, byval fy as single, _
        byval colour as ulong, _
        byval bordercolour as ulong, _
        byval pattern as any ptr, _
        byval ispattern as long, _
        byval flags as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then exit sub

    dim as long x, y
    TkoGfx.CoordB( *c, fx, fy, flags, x, y )

    dim as ulong border = bordercolour
    if (flags and TkoGfx.COORD_BORDER_DEF) <> 0 then border = c->draw.fg_color

    if ispattern = 0 then
        TkoGfx.PaintAny( c->surf, x, y, TkoGfx.ResolveColor( *c, colour, flags ), border )
        exit sub
    end if

    dim as TkoAbi.FBSTRING ptr ps = cptr( TkoAbi.FBSTRING ptr, pattern )
    if ps = 0 then exit sub

    '' THE LENGTH CARRIES THE TEMP BIT IN ITS SIGN BIT and must be masked before
    '' it is compared -- an fbc temporary descriptor has a NEGATIVE len, so a
    '' bare `< 256` accepts every temporary and reads past a short one.
    dim as integer n = ps->len
    if n < 0 then n and= not (cast( integer, 1 ) shl (sizeof( integer ) * 8 - 1))

    dim as ubyte ptr pdata = cptr( ubyte ptr, ps->dat )
    if (pdata = 0) orelse (n < 64 * 4) then exit sub

    TkoGfx.PaintAny( c->surf, x, y, 0, border, cptr( ulong ptr, pdata ) )
end sub

'' --------------------------------------------------------------------- POINT
''
'' (target, x, y) -> the pixel, or -1 outside the clip box.
''
'' POINT(n) -- THE ONE-ARGUMENT FORM -- IS THE SAME ENTRY POINT: the axis
'' selector goes in x and y carries the sentinel -8388607.0. Measured. The
'' selectors are 0 physical x, 1 physical y, 2 logical x, 3 logical y, which is
'' PMAP's numbering read the other way round, so PMap32 answers all four.
function TkoGfxPoint alias "fb_GfxPoint" ( _
        byval target as any ptr, _
        byval fx as single, byval fy as single ) as long

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( target )
    if c = 0 then return -1

    if fy = TkoGfx.POINT_AXIS_SENTINEL then
        '' the axis-query form: report where the cursor is, in the space asked
        select case cast( long, fx )
        case 0 : return TkoGfx.VpCInt( TkoGfx.PMap32( c->vp, c->draw.last_x, 0 ) )
        case 1 : return TkoGfx.VpCInt( TkoGfx.PMap32( c->vp, c->draw.last_y, 1 ) )
        case 2 : return TkoGfx.VpCInt( c->draw.last_x )
        case 3 : return TkoGfx.VpCInt( c->draw.last_y )
        case else : return -1
        end select
    end if

    dim as long x, y
    TkoGfx.TranslateCoord( c->vp, fx, fy, x, y )
    return TkoGfx.PointAny( c->surf, x, y )
end function

'' ---------------------------------------------------------------------- VIEW
''
'' (x1, y1, x2, y2, fillcolour, bordercolour, flags)
''
'' VIEW HAS NO TARGET ARGUMENT: it is the screen's viewport and nothing else's.
'' Its flag convention is its own -- bit 0 is SCREEN, bit 30 the border colour
'' defaulted, bit 31 the fill colour defaulted, base 0.
''
'' `VIEW` WITH NO ARGUMENTS IS ALL FOUR AT -32768, the full-screen sentinel, and
'' that is a RESET rather than a viewport covering the screen: it clears
'' CTX_VIEWPORT_SET, which is what CLS and the cursor rules read.
''
'' THE FILL AND BORDER COLOURS ARE NOT DRAWN. `VIEW (a,b)-(c,d), fill, border`
'' paints the new viewport and outlines it in fbc. Not done here, and it is a
'' real gap rather than a defaulting question: the viewport is set correctly and
'' nothing is painted.
sub TkoGfxView alias "fb_GfxView" ( _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval fillcolour as ulong, _
        byval bordercolour as ulong, _
        byval flags as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( 0 )
    if c = 0 then exit sub
    scope : dim as ulong ignored = fillcolour or bordercolour : end scope

    if (x1 = TkoGfx.VIEW_FULLSCREEN) andalso (y1 = TkoGfx.VIEW_FULLSCREEN) andalso _
       (x2 = TkoGfx.VIEW_FULLSCREEN) andalso (y2 = TkoGfx.VIEW_FULLSCREEN) then
        TkoGfx.ViewReset( c->vp, c->surf )
        exit sub
    end if

    TkoGfx.ViewSet( c->vp, c->surf, x1, y1, x2, y2, _
                    iif( (flags and TkoGfx.VIEW_SCREEN) <> 0, 1, 0 ) )
end sub

'' -------------------------------------------------------------------- WINDOW
''
'' (x1, y1, x2, y2, flags)
''
'' WINDOW'S COORDINATES ARE FLOATS WHERE VIEW'S ARE INT32. Same statement
'' family, different argument types, and conflating them truncates the logical
'' space to integers.
''
'' All four zero turns the window off, which is how a bare `WINDOW` is spelled.
'' graphics-abi.md records that the generated C cannot distinguish that from an
'' explicit `WINDOW (0,0)-(0,0)`; core/viewport.bi takes the same view.
sub TkoGfxWindow alias "fb_GfxWindow" ( _
        byval x1 as single, byval y1 as single, _
        byval x2 as single, byval y2 as single, _
        byval flags as long )

    dim as TkoGfx.GfxContext ptr c = TkoGfx.ContextFor( 0 )
    if c = 0 then exit sub

    TkoGfx.WindowSet( c->vp, x1, y1, x2, y2, _
                      iif( (flags and TkoGfx.VIEW_SCREEN) <> 0, 1, 0 ) )
end sub

end extern
