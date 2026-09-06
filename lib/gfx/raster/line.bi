'' line.bi -- LINE at 8, 16 and 32 bpp, solid style.
''
'' Derived from: gfx_line.c (fb_GfxDrawLine). LGPL-2.1-or-later with the
'' static-linking exception.
''
'' PIXEL-EXACTNESS IS THE POINT. A Bresenham line has several defensible
'' formulations that differ by a pixel on ties, so this follows gfxlib2's own
'' one step for step rather than a textbook variant:
''
''   - three branches: vertical (dx=0), horizontal (dy=0), diagonal
''   - dx/dy are captured BEFORE clipping, so the gradient is the unclipped one
''   - d starts at  (dx >= dy) ? dy*2 - dx : dy - dx*2,  then dx and dy double
''   - the loop ends when x reaches x2+ax or y reaches y2+ay, not at x2/y2
''   - clipped starts re-enter the line with the `skip` correction, so a clipped
''     line draws the same pixels as the unclipped one would have
''
'' WHAT IS NOT DONE YET: the 16-bit line STYLE mask. gfxlib2 rotates a pattern
'' (RORW1) per pixel and reverses it when it swaps endpoints. Solid lines set
'' every bit, so the pixel sequence here is already correct for them; styled
'' lines are Phase 3 and will need the rot/reverse_mask machinery too.
''
'' ONE BODY, THREE INSTANCES. The Bresenham arithmetic does not depend on the
'' pixel width, only the STORE does, so the body is a #macro instantiated for
'' ubyte, ushort and ulong -- the same shape raster/pixelfmt.bi uses. Calling a
'' depth-dispatching PSetAny per pixel would have been three lines instead of
'' this, and would put a `select case` inside the inner loop of every line the
'' library draws; RFC-0001 section 7 is explicit that these loops are where the
'' only available vectorisation lives.
''
'' DrawLine32's generated code is textually what it was before the template, so
'' tools/abtest-line.bas gates it unchanged.
''
'' Types are LONG (32-bit) deliberately, matching the C `int`. The d accumulator
'' is scaled by 2 and by coordinate deltas, and matching C's width keeps the
'' arithmetic identical on the paths where it could ever wrap.

#pragma once

#include once "pixel.bi"
#include once "pixelfmt.bi"   '' PutPixel8 / PutPixel16
#include once "../core/dirty.bi"

namespace TkoGfx

private function LineMid( byval lo as long, byval v as long, byval hi as long ) as long
    if v < lo then return lo
    if v > hi then return hi
    return v
end function

#macro TKO_DEFINE_LINE( suffix, elem )

'' Solid line from (x1,y1) to (x2,y2), clipped to the surface's clip box.
private sub DrawLine##suffix( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong )

    if SurfaceClipEmpty( s ) then exit sub

    dim as long xmin = s.clip_x1, xmax = s.clip_x2
    dim as long ymin = s.clip_y1, ymax = s.clip_y2

    '' Entirely outside on one side? Cheap reject, same four tests as gfxlib2.
    if (x1 < xmin) andalso (x2 < xmin) then exit sub
    if (x1 > xmax) andalso (x2 > xmax) then exit sub
    if (y1 < ymin) andalso (y2 < ymin) then exit sub
    if (y1 > ymax) andalso (y2 > ymax) then exit sub

    '' Gradient is taken from the UNCLIPPED endpoints.
    dim as long dx = x2 - x1
    dim as long dy = y2 - y1

    x2 = LineMid( xmin, x2, xmax )
    y2 = LineMid( ymin, y2, ymax )

    dim as long x, y, d, ax, ay, skip

    if dx = 0 then
        '' ---- vertical ----
        y1 = LineMid( ymin, y1, ymax )
        if y1 > y2 then swap y1, y2
        y = y1
        while y <= y2
            PutPixel##suffix( s, x1, y, col )
            y += 1
        wend
        DirtyMarkSpan( s, y1, y2 )

    elseif dy = 0 then
        '' ---- horizontal ----
        x1 = LineMid( xmin, x1, xmax )
        if x1 > x2 then swap x1, x2
        '' gfxlib2 takes the pixel_set fast path when the style is solid; the
        '' pixel sequence is identical either way.
        dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y1 ) )
        x = x1
        while x <= x2
            row[x] = cast( elem, col )
            x += 1
        wend
        DirtyMark( s, y1, 1 )

    else
        '' ---- diagonal ----
        ax = 1 : ay = 1
        if dx < 0 then
            dx = -dx
            ax = -1
        end if
        if dy < 0 then
            dy = -dy
            ay = -1
        end if

        if dx >= dy then
            d = dy * 2 - dx
        else
            d = dy - dx * 2
        end if
        dx *= 2
        dy *= 2

        x = LineMid( xmin, x1, xmax )
        d += ax * (x - x1) * dy

        y = LineMid( ymin, y1, ymax )
        d -= ay * (y - y1) * dx

        '' The loop terminates one step PAST the endpoint.
        x2 += ax
        y2 += ay

        if dx >= dy then
            '' shallow: x advances every step
            if d >= dy then
                skip = (d - dy) \ dx + 1
                y += ay * skip
                d -= skip * dx
                if (y < ymin) orelse (y > ymax) then exit sub
            elseif d < (dy - dx) then
                skip = ((dy - dx) - d) \ dy + 1
                x += ax * skip
                d += skip * dy
                if (x < xmin) orelse (x > xmax) then exit sub
            end if

            dim as long fromy = y
            while (x <> x2) andalso (y <> y2)
                PutPixel##suffix( s, x, y, col )
                if d >= 0 then
                    y += ay
                    d -= dx
                end if
                d += dy
                x += ax
            wend
            DirtyMarkSpan( s, fromy, y2 - ay )
        else
            '' steep: y advances every step
            if d < -dx then
                skip = (-d - dx) \ dy + 1
                x += ax * skip
                d += skip * dy
                if (x < xmin) orelse (x > xmax) then exit sub
            elseif d > (dy - dx) then
                skip = (d - (dy - dx)) \ dx + 1
                y += ay * skip
                d -= skip * dx
                if (y < ymin) orelse (y > ymax) then exit sub
            end if

            dim as long fromy = y
            while (x <> x2) andalso (y <> y2)
                PutPixel##suffix( s, x, y, col )
                if d <= 0 then
                    x += ax
                    d += dy
                end if
                d -= dx
                y += ay
            wend
            DirtyMarkSpan( s, fromy, y2 - ay )
        end if
    end if
end sub

#endmacro

TKO_DEFINE_LINE( 8, ubyte )
TKO_DEFINE_LINE( 16, ushort )
TKO_DEFINE_LINE( 32, ulong )

'' Draw at whatever depth the surface is. The entry layer calls this; the
'' abtests call the suffixed instances directly, because a test that named the
'' dispatcher could not say which depth it had actually exercised.
private sub DrawLineAny( _
        byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval col as ulong )
    select case s.bpp
    case 1 : DrawLine8( s, x1, y1, x2, y2, col )
    case 2 : DrawLine16( s, x1, y1, x2, y2, col )
    case else : DrawLine32( s, x1, y1, x2, y2, col )
    end select
end sub

end namespace
