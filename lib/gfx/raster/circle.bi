'' circle.bi -- CIRCLE for 32bpp: ellipse, aspect, fill.
''
'' Derived from: gfx_circle.c (draw_ellipse, draw_scanline, fb_GfxEllipse).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' THE FLOAT-TO-INT TRAP. C truncates toward zero when a float is assigned to an
'' int; FreeBASIC ROUNDS TO NEAREST. Every such conversion here is wrapped in
'' fix(), which truncates toward zero and so matches. Miss one and the ellipse is
'' a pixel out on one side only, at some radii and not others -- which reads as a
'' Bresenham bug and is not one.
''
'' THE ACCUMULATORS ARE 64-BIT, THE INPUTS ARE SINGLE. gfxlib2 declares
'' `long long dx, dy, aq, bq, r, rx, ry` but computes `aq = a * a` and
'' `r = a * bq` in FLOAT, truncating on assignment. `a * bq` in particular
'' converts the 64-bit bq back to single precision first. That is lossy, and it
'' is the behaviour we have to match rather than the behaviour we would choose --
'' csng() makes it explicit instead of accidental.
''
'' FILL IS ONCE PER SCANLINE. The `filled` array stops a row being filled twice
'' as the two halves of the ellipse converge. It is indexed relative to the top
'' of the clip box, not the surface.
''
'' NOT COVERED BY THE A/B, AND MEASURED TO BE LIVE. Removing the guard changes
'' no pixel, because filling a row twice with a SOLID colour is idempotent and
'' the digest cannot see it. It is not dead code either: instrumenting the loop
'' counts 356 duplicate scanline attempts across radii 1..30. So it is doing
'' real work (avoiding redundant writes) and will become correctness-critical --
'' and testable -- the moment a non-idempotent fill exists: PAINT patterns, or
'' alpha. Kept deliberately, and flagged as unverified rather than assumed.
''
'' ARCS USE A THIRD ROUNDING RULE. get_arc_point rounds through the runtime's
'' CINT macro, which is `(x > 0) ? (int)(x + 0.5) : (int)(x - 0.5)` -- round half
'' AWAY FROM ZERO, built out of truncation. FreeBASIC's own cint() is round half
'' to EVEN, so calling it here would be wrong for exactly the half-way cases.
'' CIntC() below reproduces the macro. That makes three distinct conversion rules
'' in one file -- implicit truncation, fix(), and this -- which is why each one
'' is spelled out at its use site.

#pragma once

#include once "pixel.bi"
#include once "pixelfmt.bi"   '' PutPixel8 / PutPixel16
#include once "line.bi"
#include once "../core/dirty.bi"

namespace TkoGfx

'' The runtime's CINT macro, NOT FreeBASIC's cint(). See the header.
private function CIntC( byval v as single ) as long
    if v > 0.0 then return fix( v + 0.5 )
    return fix( v - 0.5 )
end function

'' A point on the ellipse at `angle`, relative to the centre. y comes back in
'' MATHEMATICAL orientation (up positive); the caller subtracts it.
private sub ArcPoint( _
        byval angle as single, byval a as single, byval b as single, _
        byref ax as long, byref ay as long )
    ax = CIntC( cos( angle ) * a )
    ay = CIntC( sin( angle ) * b )
end sub

'' One scanline of the ellipse. Outline mode plots the two endpoints; fill mode
'' spans between them, once.
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
#macro TKO_DEFINE_CIRCLE( suffix, elem )

private sub CircScanline##suffix( _
        byref s as Surface, _
        byval y as long, byval x1 as long, byval x2 as long, _
        byval col as ulong, byval fill as long, byval filled as ubyte ptr )

    if (y < s.clip_y1) orelse (y > s.clip_y2) then exit sub

    if fill then
        if (x2 < s.clip_x1) orelse (x1 > s.clip_x2) then exit sub
        if filled[y - s.clip_y1] then exit sub
        filled[y - s.clip_y1] = 1
        if x1 < s.clip_x1 then x1 = s.clip_x1
        if x2 > s.clip_x2 then x2 = s.clip_x2
        dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y ) )
        dim as integer x = x1
        while x <= x2
            row[x] = cast( elem, col )
            x += 1
        wend
    else
        if (x1 >= s.clip_x1) andalso (x1 <= s.clip_x2) then PutPixel##suffix( s, x1, y, col )
        if (x2 >= s.clip_x1) andalso (x2 <= s.clip_x2) then PutPixel##suffix( s, x2, y, col )
    end if
end sub

'' The ellipse itself. top/bottom come back as the rows actually drawn, which is
'' what the dirty span is built from.
private sub DrawEllipse##suffix( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval a as single, byval b as single, _
        byval col as ulong, byval fill as long, _
        byref top as long, byref bottom as long )

    dim as long clip_h = s.clip_y2 - s.clip_y1 + 1
    if clip_h <= 0 then exit sub

    dim as ubyte ptr filled = callocate( clip_h )
    if filled = 0 then exit sub

    '' fix(), not an implicit cast: C truncates here.
    dim as long x1 = fix( x - a )
    dim as long x2 = fix( x + a )
    dim as long y1 = y
    dim as long y2 = y

    if b = 0.0 then
        CircScanline##suffix( s, y, x1, x2, col, 1, filled )
        top = y : bottom = y
        deallocate( filled )
        exit sub
    end if

    CircScanline##suffix( s, y, x1, x2, col, fill, filled )

    '' Float arithmetic truncated into 64-bit accumulators -- see the header.
    dim as longint aq = fix( a * a )
    dim as longint bq = fix( b * b )
    dim as longint dx = aq shl 1
    dim as longint dy = bq shl 1
    dim as longint r  = fix( a * csng( bq ) )
    dim as longint rx = r shl 1
    dim as longint ry = 0
    dim as long    d  = fix( a )

    while d > 0
        if r > 0 then
            y1 += 1
            y2 -= 1
            ry += dx
            r -= ry
        end if
        if r <= 0 then
            d -= 1
            x1 += 1
            x2 -= 1
            rx -= dy
            r += rx
        end if
        CircScanline##suffix( s, y1, x1, x2, col, fill, filled )
        CircScanline##suffix( s, y2, x1, x2, col, fill, filled )
    wend

    top = y2
    bottom = y1
    deallocate( filled )
end sub

'' Statement-level CIRCLE, full ellipse only (no arcs yet).
''
'' aspect > 1 makes the ellipse taller than wide by shrinking the horizontal
'' radius; otherwise the vertical radius shrinks. An aspect of 0 means "use the
'' screen's own", which the caller supplies.
private sub Circle##suffix( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval radius as single, _
        byval col as ulong, _
        byval aspect as single, _
        byval fill as long, _
        byval start_ as single = 0.0, _
        byval end_ as single = 3.141593f * 2.0 )

    if radius <= 0.0 then exit sub

    dim as single a, b
    if aspect > 1.0 then
        a = radius / aspect
        b = radius
    else
        a = radius
        b = radius * aspect
    end if

    dim as long top, bottom
    top = y : bottom = y

    '' gfxlib2 takes the arc path unless start is 0 AND end is exactly the float
    '' literal 3.141593f * 2.0 -- not 2*PI computed in double. Reproduced rather
    '' than tidied: a caller passing 6.283186 gets the full-circle path and one
    '' passing 6.2831853 does not.
    const FULL_TURN as single = 3.141593f * 2.0

    if (start_ = 0.0) andalso (end_ = FULL_TURN) then
        DrawEllipse##suffix( s, x, y, a, b, col, fill, top, bottom )
    else
        dim as long ax, ay

        '' A NEGATIVE angle also draws a radius line to that point.
        if start_ < 0.0 then
            start_ = -start_
            ArcPoint( start_, a, b, ax, ay )
            DrawLine##suffix( s, x, y, x + ax, y - ay, col )
        end if
        if end_ < 0.0 then
            end_ = -end_
            ArcPoint( end_, a, b, ax, ay )
            DrawLine##suffix( s, x, y, x + ax, y - ay, col )
        end if

        while end_ < start_
            end_ += 2.0 * PI_
        wend
        while end_ - start_ > 2.0 * PI_
            start_ += 2.0 * PI_
        wend

        '' PRECISION MUST MATCH C, NOT BE BETTER THAN IT.
        ''
        '' C computes `1 / (sqrt(a) * sqrt(b) * 1.5)` where sqrt() returns
        '' DOUBLE, then truncates the result into a float. And the loop bound
        '' `end + (increment / 2)` is entirely FLOAT, because 2 is an int that
        '' converts to float.
        ''
        '' Writing `increment / 2.0` in FreeBASIC promotes to double -- 2.0 is a
        '' double literal -- which makes the bound very slightly larger and runs
        '' ONE EXTRA ITERATION. Measured: arc 0..0.5 at r=22 drew 15 points
        '' instead of 14, a single stray pixel at (59,21). The `!` suffix and the
        '' explicit single-typed bound keep the arithmetic where C has it.
        dim as single increment = csng( 1.0 / (sqr( cdbl( a ) ) * sqr( cdbl( b ) ) * 1.5) )
        dim as single bound = end_ + increment / 2.0!

        '' The half-step is what includes the final point; dropping it leaves a
        '' gap at the arc's end.
        while start_ < bound
            ArcPoint( start_, a, b, ax, ay )
            dim as long px = x + ax
            dim as long py = y - ay
            if (px >= s.clip_x1) andalso (px <= s.clip_x2) andalso _
               (py >= s.clip_y1) andalso (py <= s.clip_y2) then
                PutPixel##suffix( s, px, py, col )
                if py > bottom then bottom = py
                if py < top then top = py
            end if
            start_ += increment
        wend
    end if

    if top < s.clip_y1 then top = s.clip_y1
    if top > s.clip_y2 then top = s.clip_y2
    if bottom < s.clip_y1 then bottom = s.clip_y1
    if bottom > s.clip_y2 then bottom = s.clip_y2
    if top > bottom then swap top, bottom
    DirtyMark( s, top, bottom - top + 1 )
end sub

#endmacro

TKO_DEFINE_CIRCLE( 8, ubyte )
TKO_DEFINE_CIRCLE( 16, ushort )
TKO_DEFINE_CIRCLE( 32, ulong )

'' Draw at whatever depth the surface is.
private sub CircleAny( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval radius as single, _
        byval col as ulong, _
        byval aspect as single, _
        byval fill as long, _
        byval start_ as single = 0.0, _
        byval end_ as single = 3.141593f * 2.0 )
    select case s.bpp
    case 1 : Circle8( s, x, y, radius, col, aspect, fill, start_, end_ )
    case 2 : Circle16( s, x, y, radius, col, aspect, fill, start_, end_ )
    case else : Circle32( s, x, y, radius, col, aspect, fill, start_, end_ )
    end select
end sub

end namespace
