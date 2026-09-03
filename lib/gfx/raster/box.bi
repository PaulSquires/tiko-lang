'' box.bi -- LINE ... B and BF for 32bpp, solid style.
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
'' Solid style only. The 16-bit style mask threads a rotation through all four
'' edges in a specific order (bottom, top, right, left, with a rot fixup between
'' each) -- that is Phase 3, and the order matters there even though it does not
'' here.

#pragma once

#include once "pixel.bi"
#include once "../core/dirty.bi"

namespace TkoGfx

'' Ordered corners assumed: x1 <= x2, y1 <= y2.
private sub DrawBox32( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong, _
        byval full as long )

    if SurfaceClipEmpty( s ) then exit sub

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
            dim as ulong ptr row = cptr( ulong ptr, SurfaceRowAddr( s, y ) )
            x = cx1
            while x <= cx2
                row[x] = col
                x += 1
            wend
            y += 1
        wend
    else
        '' bottom edge -- only if y2 itself is in view
        if y2 <= vy2 then
            dim as ulong ptr row = cptr( ulong ptr, SurfaceRowAddr( s, y2 ) )
            x = cx1
            while x <= cx2
                row[x] = col
                x += 1
            wend
        end if

        '' top edge
        if y1 >= vy1 then
            dim as ulong ptr row = cptr( ulong ptr, SurfaceRowAddr( s, y1 ) )
            x = cx1
            while x <= cx2
                row[x] = col
                x += 1
            wend
        end if

        '' right edge
        if x2 <= vx2 then
            y = cy1
            while y <= cy2
                PutPixel32( s, x2, y, col )
                y += 1
            wend
        end if

        '' left edge
        if x1 >= vx1 then
            y = cy1
            while y <= cy2
                PutPixel32( s, x1, y, col )
                y += 1
            wend
        end if
    end if
end sub

'' Statement-level entry: order the corners, then draw. This is what LINE B/BF
'' does before reaching fb_hGfxBox.
private sub LineBox32( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong, _
        byval full as long )

    if x1 > x2 then swap x1, x2
    if y1 > y2 then swap y1, y2
    DrawBox32( s, x1, y1, x2, y2, col, full )
end sub

end namespace
