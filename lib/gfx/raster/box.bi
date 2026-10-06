'' box.bi -- LINE ... B and BF, with the 16-bit style mask.
''
'' Derived from: gfx_box.c (fb_hGfxBox), gfx_line.c (the B/BF entry).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' Shared by LINE B/BF and by VIEW, exactly as in gfxlib2.
''
'' TWO THINGS THE OUTLINE CASE GETS RIGHT THAT AN OBVIOUS IMPLEMENTATION DOES NOT
''
'' 1. EACH EDGE IS GATED ON ITS OWN COORDINATE, not on the clipped box. A box
''    whose bottom edge is below the viewport draws its top and sides but no
''    bottom -- the bottom is simply absent, not clamped up to the viewport edge.
''    gfxlib2 tests `y2 < view_y + view_h` before drawing the bottom, and the
''    same for each of the other three. Clamping instead would draw a spurious
''    line along the clip boundary.
''
'' 2. THE EDGES SPAN THE CLIPPED RANGE AND OVERLAP AT THE CORNERS. Horizontal
''    edges run clipped_x1..clipped_x2 and vertical ones clipped_y1..clipped_y2,
''    so each corner pixel is written twice. Harmless for a solid colour, and it
''    is what keeps the corners present when only some edges are in view.
''
'' fb_hGfxBox ASSUMES ORDERED COORDINATES (upper-left, lower-right) and a colour
'' already masked for the target depth. DrawBox32 keeps that contract; LineBox32
'' is the statement-level entry that orders first, which is what LINE does via
'' fb_hFixCoordsOrder.
''
'' THE 16-BIT STYLE MASK threads ONE rotation through all four edges in gfxlib2's
'' order -- bottom, top, right, left -- with a fixup between each for the pixels
'' clipped away, so a dashed box comes out exactly as fb_hGfxBox draws it. A
'' solid style takes the old row-store path.

#pragma once

#include once "pixel.bi"
#include once "pixelfmt.bi"   '' PutPixel8 / PutPixel16
#include once "../core/dirty.bi"
#include once "line.bi"       '' LineRorW

namespace TkoGfx

'' Ordered corners assumed: x1 <= x2, y1 <= y2.
''
'' ONE BODY, THREE INSTANCES. Only the STORE depends on the pixel width, so the
'' body below is a #macro instantiated for ubyte, ushort and ulong -- the shape
'' raster/pixelfmt.bi already uses. Calling a depth-dispatching PSetAny per
'' pixel would have been shorter and would put a `select case` inside the inner
'' loop of every fill this library does; RFC-0001 section 7 is explicit that
'' these loops are where the only available vectorisation lives.
''
'' The 32bpp instance generates textually what was here before the template, so
'' the abtests gate it unchanged.
#macro TKO_DEFINE_BOX( suffix, elem )

private sub DrawBox##suffix( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong, _
        byval full as long, _
        byval style_ as ulong = &hFFFF )

    if SurfaceClipEmpty( s ) then exit sub
    dim as long style = cast( long, style_ and &hFFFF )

    dim as long vx1 = s.clip_x1, vx2 = s.clip_x2
    dim as long vy1 = s.clip_y1, vy2 = s.clip_y2

    '' Entirely outside?
    if (x2 < vx1) orelse (y2 < vy1) orelse (x1 > vx2) orelse (y1 > vy2) then exit sub

    dim as long cx1 = iif( x1 > vx1, x1, vx1 )
    dim as long cy1 = iif( y1 > vy1, y1, vy1 )
    dim as long cx2 = iif( x2 < vx2, x2, vx2 )
    dim as long cy2 = iif( y2 < vy2, y2, vy2 )

    dim as integer x, y

    '' gfxlib2 marks the whole clipped box height for BOTH cases -- the outline
    '' case included, even though only its edges were drawn. Over-marking costs
    '' a slightly larger blit; under-marking loses pixels on screen.
    DirtyMark( s, cy1, cy2 - cy1 + 1 )

    if full then
        y = cy1
        while y <= cy2
            dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y ) )
            x = cx1
            while x <= cx2
                row[x] = cast( elem, col )
                x += 1
            wend
            y += 1
        wend
    elseif style <> &hFFFF then
        '' ---- styled outline: fb_hGfxBox, step for step ----
        dim as long bit_ = LineRorW( &h8000, cx1 - x1 )
        if y2 <= vy2 then
            for x = cx1 to cx2
                if (style and bit_) <> 0 then PutPixel##suffix( s, x, y2, col )
                bit_ = LineRorW( bit_, 1 )
            next
        else
            bit_ = LineRorW( bit_, cx2 - cx1 + 1 )
        end if
        bit_ = LineRorW( bit_, (x2 - cx2) + (cx1 - x1) )
        if y1 >= vy1 then
            for x = cx1 to cx2
                if (style and bit_) <> 0 then PutPixel##suffix( s, x, y1, col )
                bit_ = LineRorW( bit_, 1 )
            next
        else
            bit_ = LineRorW( bit_, cx2 - cx1 + 1 )
        end if
        bit_ = LineRorW( bit_, (x2 - cx2) + (cy1 - y1) )
        if x2 <= vx2 then
            for y = cy1 to cy2
                if (style and bit_) <> 0 then PutPixel##suffix( s, x2, y, col )
                bit_ = LineRorW( bit_, 1 )
            next
        else
            bit_ = LineRorW( bit_, cy2 - cy1 + 1 )
        end if
        bit_ = LineRorW( bit_, (y2 - cy2) + (cy1 - y1) )
        if x1 >= vx1 then
            for y = cy1 to cy2
                if (style and bit_) <> 0 then PutPixel##suffix( s, x1, y, col )
                bit_ = LineRorW( bit_, 1 )
            next
        end if
    else
        '' bottom edge -- only if y2 itself is in view
        if y2 <= vy2 then
            dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y2 ) )
            x = cx1
            while x <= cx2
                row[x] = cast( elem, col )
                x += 1
            wend
        end if

        '' top edge
        if y1 >= vy1 then
            dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y1 ) )
            x = cx1
            while x <= cx2
                row[x] = cast( elem, col )
                x += 1
            wend
        end if

        '' right edge
        if x2 <= vx2 then
            y = cy1
            while y <= cy2
                PutPixel##suffix( s, x2, y, col )
                y += 1
            wend
        end if

        '' left edge
        if x1 >= vx1 then
            y = cy1
            while y <= cy2
                PutPixel##suffix( s, x1, y, col )
                y += 1
            wend
        end if
    end if
end sub

'' Statement-level entry: order the corners, then draw. This is what LINE B/BF
'' does before reaching fb_hGfxBox.
private sub LineBox##suffix( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong, _
        byval full as long, _
        byval style as ulong = &hFFFF )

    if x1 > x2 then swap x1, x2
    if y1 > y2 then swap y1, y2
    DrawBox##suffix( s, x1, y1, x2, y2, col, full, style )
end sub

#endmacro

TKO_DEFINE_BOX( 8, ubyte )
TKO_DEFINE_BOX( 16, ushort )
TKO_DEFINE_BOX( 32, ulong )

'' Draw at whatever depth the surface is. The entry layer calls this; the
'' abtests call the suffixed instances, because a test naming the dispatcher
'' could not say which depth it had exercised.
private sub LineBoxAny( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong, _
        byval full as long, _
        byval style as ulong = &hFFFF )
    select case s.bpp
    case 1 : LineBox8( s, x1, y1, x2, y2, col, full, style )
    case 2 : LineBox16( s, x1, y1, x2, y2, col, full, style )
    case else : LineBox32( s, x1, y1, x2, y2, col, full, style )
    end select
end sub

end namespace
