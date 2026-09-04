'' mouse.bi -- the pointer state behind GETMOUSE and SETMOUSE.
''
'' Derived from: win32/gfx_win32.c (fb_hWin32WinProc's mouse messages,
'' fb_hWin32GetMouse, fb_hWin32SetMouse), gfx_getmouse.c.
'' LGPL-2.1-or-later with the static-linking exception.
''
'' GETMOUSE IS NOT A QUERY. It reports state the WINDOW PROCEDURE cached the last
'' time a message arrived -- it never calls GetCursorPos itself. So a program
'' that moves the pointer and immediately reads it back sees the OLD position
'' until the window has pumped a WM_MOUSEMOVE. Implementing it as a live query
'' looks identical in a slow interactive test and differs under automation,
'' which is exactly where it gets used.
''
'' FIVE DETAILS, EACH OF WHICH IS EASY TO GET WRONG:
''
'' 1. THE COORDINATES ARE THE UNSIGNED LOW WORDS OF lParam.
''    `mouse_x = lParam and &hFFFF`, with no sign extension. Windows' own
''    GET_X_LPARAM sign-extends, because a captured drag reports NEGATIVE
''    coordinates once the pointer leaves the window to the left or above. The
''    reference does not, so those become ~65535 instead. Reproduced.
''
'' 2. mouse_on IS RECOMPUTED ON EVERY MESSAGE, not tracked by enter/leave. The
''    window procedure calls GetCursorPos and PtInRect against the client
''    rectangle mapped to screen coordinates, at the TOP, before the switch. So
''    it is only as fresh as the last message of any kind.
''
'' 3. THE WHEEL IS A RUNNING TOTAL, not a per-read delta. It increments or
''    decrements per notch and is only reset when the mode is set. A caller that
''    treats it as a delta sees it grow without bound.
''
'' 4. FAILURE WRITES -1 TO EVERY OUTPUT. Not "leaves them alone" -- see
''    core/events.bi's MouseAdjust. Failure means the window is inactive or the
''    pointer is outside it.
''
'' 5. Y IS DIVIDED BY scanline_size ON THE WAY OUT, so a doubled-scanline mode
''    reports mode coordinates rather than device ones. That division lives in
''    gfx_getmouse.c, above the driver, and is applied to the driver's answer.

#pragma once

#include once "../core/events.bi"
#include once "windows.bi"

namespace TkoGfx

'' fbgfx.bi's BUTTON_* bits.
const MOUSE_BUTTON_LEFT   = 1
const MOUSE_BUTTON_RIGHT  = 2
const MOUSE_BUTTON_MIDDLE = 4
const MOUSE_BUTTON_X1     = 8
const MOUSE_BUTTON_X2     = 16

type MouseState
    x        as long
    y        as long
    wheel    as long        '' a RUNNING TOTAL -- see note 3
    hwheel   as long
    buttons  as long
    on_      as long        '' pointer inside the client rectangle
    tracking as long        '' TrackMouseEvent armed for WM_MOUSELEAVE
    clip     as long
    shown    as long
end type

private sub MouseInit( byref m as MouseState )
    m.x = 0 : m.y = 0
    m.wheel = 0 : m.hwheel = 0
    m.buttons = 0
    m.on_ = 0
    m.tracking = 0
    m.clip = 0
    m.shown = 1
end sub

'' Recompute whether the pointer is inside the window, exactly as the reference
'' does at the top of its window procedure: client rectangle mapped to SCREEN
'' coordinates, tested against the live cursor position.
private sub MouseUpdateOn( byref m as MouseState, byval hwnd as HWND )
    if hwnd = 0 then
        m.on_ = 0
        exit sub
    end if
    dim as RECT r
    GetClientRect( hwnd, @r )
    '' MapWindowPoints over the two corners -- the same call the reference makes.
    MapWindowPoints( hwnd, NULL, cast( LPPOINT, @r ), 2 )
    dim as POINT p
    GetCursorPos( @p )
    m.on_ = iif( PtInRect( @r, p ) <> 0, 1, 0 )
end sub

'' Feed one window message. Returns 1 if it was a mouse message we consumed for
'' state purposes (the caller still passes it on).
private function MouseHandleMessage( _
        byref m as MouseState, byval hwnd as HWND, _
        byval msg as UINT, byval wp as WPARAM, byval lp as LPARAM ) as long

    '' note 2: refreshed on EVERY message, not just mouse ones
    MouseUpdateOn( m, hwnd )

    select case msg
    case WM_MOUSEMOVE
        '' ARM THE LEAVE NOTIFICATION. Without it the window receives NO message
        '' once the pointer leaves, so `on_` keeps whatever it had when the
        '' pointer was last inside and GETMOUSE goes on reporting success from
        '' outside the window. The reference arms it for the same reason.
        ''
        '' Measured: with this missing, moving the pointer far outside left our
        '' side answering (0,199) and "ok" where the reference answered -1.
        '' It is re-armed after every leave, because the notification is
        '' one-shot.
        if (m.tracking = 0) andalso (hwnd <> 0) then
            dim as TRACKMOUSEEVENT tme
            tme.cbSize      = sizeof( TRACKMOUSEEVENT )
            tme.dwFlags     = TME_LEAVE
            tme.hwndTrack   = hwnd
            tme.dwHoverTime = 0
            if TrackMouseEvent( @tme ) <> 0 then m.tracking = 1
        end if
        '' note 1: UNSIGNED low words, no sign extension
        m.x = cast( long, lp ) and &hFFFF
        m.y = (cast( long, lp ) shr 16) and &hFFFF
        return 1

    case WM_MOUSELEAVE
        '' one-shot: it must be re-armed on the next move
        m.tracking = 0
        m.on_ = 0
        return 1

    case WM_LBUTTONDOWN
        m.buttons or= MOUSE_BUTTON_LEFT   : return 1
    case WM_LBUTTONUP
        m.buttons and= not MOUSE_BUTTON_LEFT : return 1
    case WM_RBUTTONDOWN
        m.buttons or= MOUSE_BUTTON_RIGHT  : return 1
    case WM_RBUTTONUP
        m.buttons and= not MOUSE_BUTTON_RIGHT : return 1
    case WM_MBUTTONDOWN
        m.buttons or= MOUSE_BUTTON_MIDDLE : return 1
    case WM_MBUTTONUP
        m.buttons and= not MOUSE_BUTTON_MIDDLE : return 1

    case WM_MOUSEWHEEL
        '' note 3: a running total, one step per notch, sign from the high word
        if cast( integer, wp ) > 0 then
            m.wheel += 1
        else
            m.wheel -= 1
        end if
        return 1
    end select

    return 0
end function

'' The driver half of GETMOUSE. Returns 0 on success, -1 when the window is
'' inactive or the pointer is outside it -- the caller then applies MouseAdjust,
'' which is what writes -1 everywhere and divides Y.
private function MouseGet( _
        byref m as MouseState, byval is_active as long, _
        byref x as long, byref y as long, byref z as long, _
        byref buttons as long, byref clip as long ) as long

    if (is_active = 0) orelse (m.on_ = 0) then return -1
    x = m.x
    y = m.y
    z = m.wheel
    buttons = m.buttons
    clip = m.clip
    return 0
end function

'' SETMOUSE x, y, cursor, clip. A negative argument means "leave alone", which is
'' how the statement's omitted arguments arrive.
private sub MouseSet( _
        byref m as MouseState, byval hwnd as HWND, _
        byval x as long, byval y as long, _
        byval cursor as long, byval clip as long )

    if hwnd = 0 then exit sub

    if (x >= 0) orelse (y >= 0) then
        dim as POINT p
        p.x = iif( x >= 0, x, m.x )
        p.y = iif( y >= 0, y, m.y )
        '' the arguments are CLIENT coordinates; SetCursorPos takes screen ones
        ClientToScreen( hwnd, @p )
        SetCursorPos( p.x, p.y )
    end if

    if cursor >= 0 then m.shown = iif( cursor <> 0, 1, 0 )

    if clip >= 0 then
        m.clip = iif( clip <> 0, 1, 0 )
        if m.clip then
            dim as RECT r
            GetClientRect( hwnd, @r )
            MapWindowPoints( hwnd, NULL, cast( LPPOINT, @r ), 2 )
            ClipCursor( @r )
        else
            ClipCursor( NULL )
        end if
    end if
end sub

end namespace
