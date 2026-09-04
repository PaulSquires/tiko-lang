'' viewport.bi -- VIEW, WINDOW, and the coordinate transform.
''
'' Derived from: gfx_view.c, gfx_window.c, gfx_pmap.c, gfx_core.c
'' (fb_hTranslateCoord). LGPL-2.1-or-later with the static-linking exception.
''
'' VIEW sets a clipping rectangle and, unless SCREEN is given, moves the origin
'' to its top-left. WINDOW sets a logical coordinate space mapped onto that
'' rectangle, and unless SCREEN is given, flips y so that positive is up.
''
'' TRANSLATE SCALES BY (view_w - 1) BUT PMAP SCALES BY view_w.
''
'' That is not a transcription error here -- gfxlib2 really does use
'' `(view_w - 1)` in fb_hTranslateCoord and plain `view_w` in fb_GfxPMap, so
'' PMAP(x, 0) does NOT exactly invert what PSET does with the same coordinate.
'' The discrepancy grows with the window range: mapping a full window across a
'' 320-wide viewport puts PMAP about a third of a pixel off at the right edge.
''
'' Both are reproduced as-is. A library that "fixed" one of them would disagree
'' with gfxlib2 on whichever statement it fixed, and the two are observable
'' independently -- PMAP through its return value, the transform through where a
'' pixel lands.
''
'' ROUNDING IS CINT, HALF AWAY FROM ZERO -- the runtime macro again, not
'' FreeBASIC's cint(). Third distinct rounding rule in the library; see
'' raster/circle.bi and raster/draw.bi for the other two.

#pragma once

#include once "surface.bi"

namespace TkoGfx

const CTX_VIEW_SCREEN    = 1
const CTX_WINDOW_ACTIVE  = 2
const CTX_WINDOW_SCREEN  = 4
const CTX_VIEWPORT_SET   = 8

type Viewport
    view_x as long
    view_y as long
    view_w as long
    view_h as long

    win_x  as single
    win_y  as single
    win_w  as single
    win_h  as single

    flags  as long
end type

'' The runtime's CINT. Half away from zero, built from truncation.
private function VpCInt( byval v as single ) as long
    if v > 0.0 then return fix( v + 0.5 )
    return fix( v - 0.5 )
end function

'' No viewport, no window: the whole surface, origin at its top-left.
private sub ViewportInit( byref vp as Viewport, byval w as long, byval h as long )
    vp.view_x = 0
    vp.view_y = 0
    vp.view_w = w
    vp.view_h = h
    vp.win_x  = 0.0
    vp.win_y  = 0.0
    vp.win_w  = 0.0
    vp.win_h  = 0.0
    vp.flags  = 0
end sub

'' VIEW (x1,y1)-(x2,y2). Sets the clip box on `s` too, since the two always move
'' together. `screen_` keeps the origin at the surface's top-left instead of the
'' viewport's.
''
'' A viewport entirely off-surface is IGNORED rather than clamped -- clamping
'' would move the rectangle instead of clipping it, which gfxlib2 calls out in
'' its own source as the reason for the early return.
private sub ViewSet( _
        byref vp as Viewport, byref s as Surface, _
        byval x1 as long, byval y1 as long, _
        byval x2 as long, byval y2 as long, _
        byval screen_ as long )

    if x1 > x2 then swap x1, x2
    if y1 > y2 then swap y1, y2

    if (x1 >= s.w) orelse (y1 >= s.h) orelse (x2 < 0) orelse (y2 < 0) then exit sub

    vp.flags or= CTX_VIEWPORT_SET
    if screen_ then
        vp.flags or= CTX_VIEW_SCREEN
    else
        vp.flags and= not CTX_VIEW_SCREEN
    end if

    if x1 < 0 then x1 = 0
    if y1 < 0 then y1 = 0
    if x2 > s.w - 1 then x2 = s.w - 1
    if y2 > s.h - 1 then y2 = s.h - 1

    vp.view_x = x1
    vp.view_y = y1
    vp.view_w = x2 - x1 + 1
    vp.view_h = y2 - y1 + 1

    SurfaceSetClip( s, x1, y1, x2, y2 )
end sub

'' Reset to the whole surface.
private sub ViewReset( byref vp as Viewport, byref s as Surface )
    vp.view_x = 0
    vp.view_y = 0
    vp.view_w = s.w
    vp.view_h = s.h
    vp.flags and= not (CTX_VIEWPORT_SET or CTX_VIEW_SCREEN)
    SurfaceSetClip( s, 0, 0, s.w - 1, s.h - 1 )
end sub

'' WINDOW (x1,y1)-(x2,y2). All four zero turns the window off, which is how
'' `WINDOW` with no arguments is spelled.
private sub WindowSet( _
        byref vp as Viewport, _
        byval x1 as single, byval y1 as single, _
        byval x2 as single, byval y2 as single, _
        byval screen_ as long )

    if (x1 <> 0.0) orelse (y1 <> 0.0) orelse (x2 <> 0.0) orelse (y2 <> 0.0) then
        if x2 < x1 then swap x1, x2
        if y2 < y1 then swap y1, y2
        vp.win_x = x1
        vp.win_w = x2 - x1
        vp.win_y = y1
        vp.win_h = y2 - y1
        vp.flags or= CTX_WINDOW_ACTIVE
        if screen_ then vp.flags or= CTX_WINDOW_SCREEN
    else
        vp.flags and= not (CTX_WINDOW_ACTIVE or CTX_WINDOW_SCREEN)
    end if
end sub

'' Logical coordinates to physical pixels.
private sub TranslateCoord( _
        byref vp as Viewport, _
        byval fx as single, byval fy as single, _
        byref x as long, byref y as long )

    if vp.flags and CTX_WINDOW_ACTIVE then
        '' (view_w - 1), NOT view_w. See the header.
        fx = ((fx - vp.win_x) * (vp.view_w - 1)) / vp.win_w
        fy = ((fy - vp.win_y) * (vp.view_h - 1)) / vp.win_h
    end if

    x = VpCInt( fx )
    y = VpCInt( fy )

    if (vp.flags and (CTX_WINDOW_ACTIVE or CTX_WINDOW_SCREEN)) = CTX_WINDOW_ACTIVE then
        y = vp.view_h - 1 - y
    end if

    if (vp.flags and CTX_VIEW_SCREEN) = 0 then
        x += vp.view_x
        y += vp.view_y
    end if
end sub

'' PMAP. func 0/1 map logical to physical, 2/3 map back. Note the view_w here
'' against (view_w - 1) above -- reproduced, not reconciled.
private function PMap32( _
        byref vp as Viewport, byval coord as single, byval func_ as long ) as single

    dim as long active = vp.flags and CTX_WINDOW_ACTIVE

    '' EVERY INTERMEDIATE IS A SINGLE. C evaluates these entirely in float, and
    '' FreeBASIC promotes to double if you write them as one expression -- which
    '' produced results differing in the last digit (9.722222 against C's
    '' 9.722221) on 30 of 369 probes. PMAP returns the value directly, so unlike
    '' the transform there is no CINT rounding downstream to absorb it.
    dim as single t
    select case func_
    case 0
        if active then
            t = coord - vp.win_x
            t = t * vp.view_w
            coord = t / vp.win_w
        end if
    case 1
        if active then
            t = coord - vp.win_y
            t = t * vp.view_h
            coord = t / vp.win_h
            if (vp.flags and CTX_WINDOW_SCREEN) = 0 then
                t = vp.view_h - 1
                coord = t - coord
            end if
        end if
    case 2
        if active then
            t = coord * vp.win_w
            t = t / vp.view_w
            coord = t + vp.win_x
        end if
    case 3
        if active then
            if (vp.flags and CTX_WINDOW_SCREEN) = 0 then
                t = vp.view_h - 1
                coord = t - coord
            end if
            t = coord * vp.win_h
            t = t / vp.view_h
            coord = t + vp.win_y
        end if
    case else
        coord = 0.0
    end select

    return coord
end function

end namespace
