'' window.bi -- the Win32 window, its background thread, and the message pump.
''
'' Derived from: win32/gfx_win32.c (fb_hWin32Init, fb_hInitWindow,
'' fb_hHandleMessages, fb_hWin32Exit, the lock), win32/gfx_driver_gdi.c
'' (gdi_init's sizing and gdi_thread's frame loop).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' FIVE THINGS HERE ARE LOAD-BEARING, AND FOUR OF THEM FAIL AS A HANG RATHER
'' THAN AS AN ERROR.
''
'' 1. THE WINDOW IS CREATED ON THE THREAD THAT PUMPS IT. A window's messages are
''    delivered to the queue of the thread that CREATED it, so creating it on the
''    caller and pumping it on the worker means the pump drains an empty queue
''    forever while the window never repaints and never closes. Hence WindowOpen
''    hands the parameters to the thread and waits, rather than creating first.
''
'' 2. THE READY HANDSHAKE WAITS ON THE THREAD HANDLE TOO. The wait is on BOTH the
''    ready event and the thread handle, and only the event means success. If it
''    waited on the event alone, a thread that died inside CreateWindowEx would
''    leave the caller blocked forever -- the failure mode of a window that
''    cannot be created is then indistinguishable from a machine that has hung.
''    gfxlib2 uses WaitForMultipleObjects for exactly this, and so do we.
''
'' 3. TEARDOWN JOINS THE THREAD, AND MUST NOT RUN UNDER THE LOADER LOCK. The
''    pump thread has to finish before the module unloads, but joining a thread
''    from DllMain or a static destructor deadlocks: the loader lock is held and
''    the exiting thread needs it. This is why gfxlib2 tears down from fb_End and
''    not from atexit, and why nothing in this library runs at module level.
''
'' 4. THE FRAME AND THE MESSAGE DISPATCH SHARE ONE LOCK. Present, input poll and
''    DispatchMessage all happen inside the update lock, so SCREENLOCK from the
''    main thread genuinely freezes presentation. Taking the lock only around the
''    blit lets a window resize or palette change land mid-frame.
''
'' 5. THE CLIENT AREA IS THE REQUESTED SIZE, NOT THE WINDOW. AdjustWindowRect
''    converts the wanted client rectangle into an outer one; passing w and h
''    straight to CreateWindowEx yields a client area smaller by the frame and
''    caption, so every present is clipped and the bottom rows never appear.
''
'' DPI IS DELIBERATELY NOT HANDLED. gfxlib2 never marks the process DPI-aware, so
'' on a scaled display Windows stretches its window and ours must stretch
'' identically -- a DPI-aware window here would be a different physical size from
'' the reference and would break the drop-in claim. Improving this belongs with
'' the modern surface API, not with parity.

#pragma once

#include once "driver.bi"
#include once "gdi.bi"
#include once "mouse.bi"
#include once "../core/keyboard.bi"   '' KeyRing / KeyTable, filled from WM_CHAR
#include once "windows.bi"

namespace TkoGfx

const WINDOW_CLASS_NAME = "TKOGFX_WINDOW"

'' Poll period of the presenter thread, matching gfxlib2's fixed Sleep(10).
'' NOT vsync -- the GDI path never waits for one.
const WINDOW_FRAME_MS = 10

type GfxWindow
    hwnd        as HWND
    hinst       as HINSTANCE
    thread      as HANDLE
    ready       as HANDLE
    running     as long           '' read by the thread every frame
    active      as long           '' has focus
    closed      as long           '' the user clicked the close box
    started     as long           '' the pump reached its loop at least once
    frames      as long           '' presented frames, for tests
    w           as long
    h           as long
    surf        as Surface ptr

    '' PALETTED PRESENTATION. When surf is 8bpp it cannot go to GDI directly
    '' (see GdiExpand8), so it is expanded into `mirror` first and THAT is what
    '' is blitted. Both are zero for a 32bpp surface and the whole path is
    '' skipped. `lut` is 256 packed 0x00BBGGRR values owned by the caller --
    '' this layer does not know what a palette is.
    mirror      as Surface
    mirrorpx    as any ptr
    lut         as ulong ptr
    lock_       as CRITICAL_SECTION
    lock_ready  as long
    mouse       as MouseState

    '' KEYBOARD. Filled on the WINDOW THREAD from WM_CHAR and WM_KEYDOWN, read
    '' on the caller's thread by the INKEY/GETKEY hooks, so both ends go through
    '' WindowLock. core/keyboard.bi owns the ring's behaviour and
    '' tools/abtest-keyboard.bas compares it against gfxlib2; what is new here is
    '' only where the codes come from.
    keys        as KeyRing
    ktab        as KeyTable
    title       as zstring * 256
end type

private sub WindowLock( byref wnd as GfxWindow )
    if wnd.lock_ready then EnterCriticalSection( @wnd.lock_ )
end sub

private sub WindowUnlock( byref wnd as GfxWindow )
    if wnd.lock_ready then LeaveCriticalSection( @wnd.lock_ )
end sub

'' The per-window state lives in the HWND's user data, set from the CREATESTRUCT
'' the moment WM_NCCREATE arrives. Nothing here is a process global.
'' The OUTER size CreateWindowEx is about to ask for, so WM_GETMINMAXINFO can
'' answer before the window has a GfxWindow attached. See that case.
dim shared as long PendingMinW, PendingMinH

private function WindowProc cdecl ( _
        byval hwnd as HWND, byval msg as UINT, _
        byval wp as WPARAM, byval lp as LPARAM ) as LRESULT

    dim as GfxWindow ptr w

    if msg = WM_NCCREATE then
        dim as CREATESTRUCT ptr cs = cast( CREATESTRUCT ptr, lp )
        w = cast( GfxWindow ptr, cs->lpCreateParams )
        SetWindowLongPtr( hwnd, GWLP_USERDATA, cast( LONG_PTR, w ) )
    else
        w = cast( GfxWindow ptr, GetWindowLongPtr( hwnd, GWLP_USERDATA ) )
    end if

    '' ANSWERED BEFORE THE `w <> 0` GUARD, and that is the whole point.
    ''
    '' WM_GETMINMAXINFO arrives while CreateWindowEx is deciding the size --
    '' BEFORE WM_NCCREATE -- so GWLP_USERDATA is still empty and the select
    '' below never runs for it. Putting the case in there looked right and did
    '' nothing: measured, the client stayed clamped at 120 pixels wide.
    ''
    '' Windows clamps a captioned window to whatever its caption buttons need.
    '' SCREENRES 64, 48 asked for a 64-pixel client and got 120; gfxlib2's comes
    '' back at exactly 64. tools/probe-window.bas opens 320x200, far above the
    '' clamp, which is why nothing saw this until a gate read pixels off a small
    '' window. WindowOpen leaves the wanted OUTER size in PendingMin*; one window
    '' exists at a time, which is what makes a shared safe here.
    if msg = WM_GETMINMAXINFO then
        if PendingMinW > 0 then
            dim as MINMAXINFO ptr mmi = cast( MINMAXINFO ptr, lp )
            mmi->ptMinTrackSize.x = PendingMinW
            mmi->ptMinTrackSize.y = PendingMinH
        end if
        return 0
    end if

    if w <> 0 then
        '' The pointer state is fed EVERY message, not just mouse ones -- the
        '' reference recomputes "is the cursor inside" at the top of its window
        '' procedure regardless of what arrived. See driver/mouse.bi note 2.
        MouseHandleMessage( w->mouse, hwnd, msg, wp, lp )

        '' WHOSE CURSOR IT IS. SetCursor sets state for the thread that owns the
        '' window, which is THIS one -- SETMOUSE runs on the caller's thread and
        '' can only post here. Answering TRUE claims the message so DefWindowProc
        '' does not put the arrow back.
        if msg = WM_SETCURSOR then
            if (w->mouse.on_ <> 0) andalso (w->mouse.shown = 0) then
                SetCursor( NULL )
            else
                SetCursor( LoadCursor( NULL, IDC_ARROW ) )
            end if
            return TRUE
        end if

        select case msg
        case WM_CLOSE
            '' Record it and stop the pump. NOT DestroyWindow here: the surface
            '' may still be presented by this frame, and the thread owns the
            '' window's lifetime.
            w->closed = 1
            w->running = 0
            return 0

        '' WM_CHAR IS THE ASCII PATH, and it is the one INPUT needs: Windows has
        '' already applied the keyboard layout, the shift state and the dead-key
        '' composition, so what arrives is the character the user meant. Enter is
        '' 13 and Backspace is 8, which is exactly what the editing loop reads.
        ''
        '' THE EXTENDED-KEY ENCODING IS NOT DONE HERE. gfxlib2 posts arrows and
        '' function keys as (scancode shl 8) or 255, and this posts nothing for
        '' them -- so INKEY returns the characters and not the specials. Stated
        '' rather than half-implemented: a wrong scancode is worse than an
        '' absent one, and nothing gates the mapping yet.
        case WM_CHAR
            WindowLock( *w )
            KeyPost( w->keys, cast( long, wp ) )
            WindowUnlock( *w )
            return 0

        '' The MULTIKEY table is a snapshot of what is HELD, which is a different
        '' question from what was typed -- a key held down produces one WM_KEYDOWN
        '' and many auto-repeats, and MULTIKEY has to answer true throughout.
        case WM_KEYDOWN, WM_SYSKEYDOWN
            WindowLock( *w )
            KeyTableSet( w->ktab, cast( long, (lp shr 16) and &hFF ), 1 )

            '' EXTENDED KEYS, the ones that never become a WM_CHAR. gfxlib2
            '' encodes them as (scancode shl 8) or 255, and core/keyboard.bi's
            '' KeyInkeyStr turns that into the two-byte INKEY string --
            '' tools/abtest-keyboard.bas compares that encoding against gfxlib2
            '' for codes posted directly, so what is new here is only the source.
            ''
            '' THE SCANCODE COMES STRAIGHT OUT OF lParam, and that works because
            '' FreeBASIC's SC_* ARE the PC set-1 scancodes: fbgfx.bi has
            '' SC_ESCAPE = &h01 and SC_LEFT = &h4B, which is what bits 16..23 of
            '' a WM_KEYDOWN carry. No translation table is needed and none is
            '' written, because one would be a second place to be wrong.
            ''
            '' THE LIST IS EXPLICIT rather than "whatever produces no character".
            '' Backspace, Tab, Enter and Escape all reach WM_CHAR as well, so
            '' posting them here too would deliver every one of them twice.
            select case cast( long, wp )
            case VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, _
                 VK_HOME, VK_END, VK_PRIOR, VK_NEXT, _
                 VK_INSERT, VK_DELETE, _
                 VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, _
                 VK_F7, VK_F8, VK_F9, VK_F10, VK_F11, VK_F12
                KeyPost( w->keys, (cast( long, (lp shr 16) and &hFF ) shl 8) or 255 )
            end select

            WindowUnlock( *w )

        case WM_KEYUP, WM_SYSKEYUP
            WindowLock( *w )
            KeyTableSet( w->ktab, cast( long, (lp shr 16) and &hFF ), 0 )
            WindowUnlock( *w )

        case WM_SETFOCUS
            w->active = 1
        case WM_KILLFOCUS
            w->active = 0

        case WM_ERASEBKGND
            '' Every pixel is overwritten by the presenter, so erasing first is
            '' pure flicker.
            return 1

        case WM_PAINT
            '' Repaint from the surface rather than validating an empty region,
            '' otherwise an uncovered window stays blank until something else
            '' marks a scanline dirty.
            dim as PAINTSTRUCT ps
            dim as HDC hdc = BeginPaint( hwnd, @ps )
            if (hdc <> 0) andalso (w->surf <> 0) then
                if w->mirrorpx <> 0 then
                    GdiExpand8( w->mirror, *w->surf, w->lut, 0, w->surf->h - 1 )
                    GdiBlitSpan( hdc, w->mirror, 0, w->surf->h - 1 )
                else
                    GdiBlitSpan( hdc, *w->surf, 0, w->surf->h - 1 )
                end if
            end if
            EndPaint( hwnd, @ps )
            return 0
        end select
    end if

    return DefWindowProc( hwnd, msg, wp, lp )
end function

'' Drain the queue. NULL as the HWND on purpose -- thread messages are not
'' associated with any window and would otherwise never get their default
'' handling, which delays things like the shell's own hotkeys.
private sub WindowPumpMessages( )
    dim as MSG m
    while PeekMessage( @m, NULL, 0, 0, PM_REMOVE ) <> 0
        TranslateMessage( @m )
        DispatchMessage( @m )
    wend
end sub

'' Create the window. Runs ON THE PUMP THREAD -- see note 1.
private function WindowCreate( byref w as GfxWindow ) as long
    dim as WNDCLASS wc
    wc.style         = CS_DBLCLKS or CS_VREDRAW or CS_HREDRAW
    wc.lpfnWndProc   = @WindowProc
    wc.hInstance     = w.hinst
    wc.hCursor       = LoadCursor( NULL, cast( zstring ptr, IDC_ARROW ) )
    wc.hIcon         = LoadIcon( NULL, cast( zstring ptr, IDI_APPLICATION ) )
    wc.lpszClassName = @WINDOW_CLASS_NAME

    '' A duplicate class registration is not an error -- a second SCREEN in the
    '' same process re-registers. Only a genuine failure matters, and
    '' ERROR_CLASS_ALREADY_EXISTS is not one.
    if RegisterClass( @wc ) = 0 then
        if GetLastError( ) <> ERROR_CLASS_ALREADY_EXISTS then return 0
    end if

    dim as DWORD style = WS_OVERLAPPEDWINDOW and (not WS_THICKFRAME)

    '' the REQUESTED size is the client area -- see note 5
    dim as RECT r
    r.left = 0 : r.top = 0 : r.right = w.w : r.bottom = w.h
    AdjustWindowRect( @r, style, 0 )
    dim as long outer_w = r.right - r.left
    dim as long outer_h = r.bottom - r.top

    dim as long x = (GetSystemMetrics( SM_CXSCREEN ) - outer_w) \ 2
    dim as long y = (GetSystemMetrics( SM_CYSCREEN ) - outer_h) \ 2

    '' Windows clamps a captioned window to whatever its buttons need -- measured
    '' at 120 pixels for a 64-pixel client -- and does it silently. Telling
    '' WM_GETMINMAXINFO the size we want is the documented way out.
    PendingMinW = outer_w
    PendingMinH = outer_h

    w.hwnd = CreateWindowEx( 0, @WINDOW_CLASS_NAME, @w.title, style, _
                             x, y, outer_w, outer_h, _
                             HWND_DESKTOP, NULL, w.hinst, @w )
    if w.hwnd = 0 then return 0

    ShowWindow( w.hwnd, SW_SHOW )
    SetForegroundWindow( w.hwnd )
    return 1
end function

'' The presenter thread: create, signal ready, then one frame every 10ms until
'' asked to stop.
private function WindowThread cdecl ( byval param as any ptr ) as DWORD
    dim as GfxWindow ptr w = cast( GfxWindow ptr, param )

    if WindowCreate( *w ) = 0 then
        '' Return WITHOUT signalling. The waiter is watching this thread's
        '' handle as well, so it learns of the failure rather than hanging.
        return 1
    end if

    w->active = 1
    SetEvent( w->ready )

    while w->running <> 0
        WindowLock( *w )

        if w->surf <> 0 then
            dim as HDC hdc = GetDC( w->hwnd )
            if hdc <> 0 then
                if w->mirrorpx <> 0 then
                    '' Expand the WHOLE surface rather than the dirty span:
                    '' GdiPresentDirty finds the span itself and clears the
                    '' marks as it goes, so there is no span to read here yet.
                    GdiExpand8( w->mirror, *w->surf, w->lut, 0, w->surf->h - 1 )
                    w->mirror.dirty = w->surf->dirty
                    if GdiPresentDirty( hdc, w->mirror ) > 0 then w->frames += 1
                else
                    if GdiPresentDirty( hdc, *w->surf ) > 0 then w->frames += 1
                end if
                ReleaseDC( w->hwnd, hdc )
            end if
        end if

        WindowPumpMessages( )
        w->started = 1

        WindowUnlock( *w )
        Sleep( WINDOW_FRAME_MS )
    wend

    '' Destroy from the owning thread. DestroyWindow from another thread is
    '' silently ignored by Windows and the window would outlive the pump.
    if w->hwnd <> 0 then
        DestroyWindow( w->hwnd )
        w->hwnd = 0
    end if
    return 0
end function

'' Open a window of `cw` x `ch` CLIENT pixels presenting `s`.
'' Returns 1 on success, 0 on failure. Safe to call WindowClose either way.
private function WindowOpen( _
        byref w as GfxWindow, byref s as Surface, _
        byval cw as long, byval ch as long, byref caption as string ) as long

    w.hwnd = 0 : w.thread = 0 : w.ready = 0
    w.running = 1 : w.active = 0 : w.closed = 0 : w.started = 0 : w.frames = 0
    w.w = cw : w.h = ch
    w.surf = @s

    '' A paletted surface needs a 32bpp mirror to present through. Allocated
    '' here rather than lazily so a failure is reported by WindowOpen, which the
    '' caller already checks, instead of by a silent blank window later.
    w.mirrorpx = 0
    w.lut = 0
    if s.bpp = 1 then
        w.mirrorpx = callocate( cast( integer, cw ) * 4 * ch )
        if w.mirrorpx = 0 then return 0
        SurfaceInit( w.mirror, w.mirrorpx, cw, ch, cw * 4, 4 )
    end if
    w.title = left( caption, 255 )
    MouseInit( w.mouse )
    KeyRingInit( w.keys )
    KeyTableClear( w.ktab )
    w.hinst = GetModuleHandle( NULL )

    InitializeCriticalSection( @w.lock_ )
    w.lock_ready = 1

    w.ready = CreateEvent( NULL, FALSE, FALSE, NULL )
    if w.ready = 0 then
        w.running = 0
        return 0
    end if

    dim as DWORD tid
    w.thread = CreateThread( NULL, 0, cast( any ptr, @WindowThread ), @w, 0, @tid )
    if w.thread = 0 then
        w.running = 0
        return 0
    end if

    '' Ready OR dead -- see note 2. Waiting on the event alone hangs forever
    '' when the window cannot be created.
    dim as HANDLE h(0 to 1) = { w.ready, w.thread }
    dim as DWORD rc = WaitForMultipleObjects( 2, @h(0), FALSE, INFINITE )
    if rc <> WAIT_OBJECT_0 then
        w.running = 0
        return 0
    end if
    return 1
end function

'' Stop the pump and JOIN the thread. Must not be called from a static
'' destructor or DllMain -- see note 3.
private sub WindowClose( byref w as GfxWindow )
    w.running = 0

    if w.thread <> 0 then
        '' A bounded wait, not INFINITE. gfxlib2 waits forever, which turns a
        '' wedged pump into a process that will not exit; the frame period is
        '' 10ms, so anything beyond a couple of seconds is already broken.
        WaitForSingleObject( w.thread, 5000 )
        CloseHandle( w.thread )
        w.thread = 0
    end if

    if w.ready <> 0 then
        CloseHandle( w.ready )
        w.ready = 0
    end if

    if w.lock_ready then
        DeleteCriticalSection( @w.lock_ )
        w.lock_ready = 0
    end if

    w.surf = 0
    if w.mirrorpx <> 0 then
        deallocate( w.mirrorpx )
        w.mirrorpx = 0
    end if
end sub

'' Has the user closed the window? This is what SCREENEVENT and the WM_CLOSE
'' half of INKEY are built on.
private function WindowWasClosed( byref w as GfxWindow ) as long
    return w.closed
end function

end namespace
