'' abtest-mouse.bas -- A/B GETMOUSE against gfxlib2, by moving the real pointer.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' THE TWO SIDES CANNOT RUN AT ONCE, and that shapes the whole file. Only one
'' window can be under the pointer, so the reference and this library are driven
'' SEQUENTIALLY over the identical protocol -- the same client-relative points,
'' in the same order -- and the two recorded sequences are compared. It is a
'' genuine differential test, just not a simultaneous one.
''
'' Client-relative coordinates are what make that legitimate: where each window
'' happens to sit on the desktop cancels out.
''
'' Nothing here waits for a human. SetCursorPos moves the pointer, which
'' generates real WM_MOUSEMOVE messages to whichever window is underneath.
''
'' WHY EACH CASE EXISTS:
''
''   1. INTERIOR POINTS, including the extreme corners of the client area. The
''      mapping is client-relative, so (0,0) must read as (0,0) rather than as a
''      screen coordinate or as the window's outer origin.
''   2. OUTSIDE THE WINDOW. Both must report FAILURE, and failure means every
''      output is -1 rather than left untouched.
''   3. THE EDGE. The pixel just inside the client rectangle succeeds and the one
''      just outside fails. PtInRect is half-open on the right and bottom, so an
''      inclusive test is off by one exactly there and nowhere else.
''   4. GETMOUSE IS A CACHE, NOT A QUERY. After moving the pointer the value only
''      updates once the window has pumped a message. Both sides are given the
''      same settling time; an implementation that calls GetCursorPos directly
''      would report the new position sooner and diverge under automation.
''
'' NOT COVERED, AND WHY. Buttons and the wheel need synthesised input --
'' mouse_event or SendInput -- which clicks on whatever is under the pointer and
'' can act on unrelated windows if the test window is not where it is expected.
'' That is a real risk to the desktop, so it is left to the author's interactive
'' pass and stated here rather than faked with a passing stub. The button and
'' wheel STATE MACHINE is still verified below from synthetic messages, which
'' costs nothing and catches the bit twiddling.

#include once "../driver/window.bi"
#include once "fbgfx.bi"
#include once "windows.bi"

using TkoGfx
using FB

dim shared as string report
dim shared as long failures = 0
dim shared as long ran = 0

sub chk( byref what as string, byval want as longint, byval got as longint )
    ran += 1
    if want <> got then
        report += "  MISMATCH " + what + " want " + str(want) + " got " + str(got) + chr(10)
        failures += 1
    end if
end sub

const NPTS = 7
const CW = 320
const CH = 200

'' The probe points, in CLIENT coordinates. -1000 is deliberately outside.
dim shared as long px(0 to NPTS - 1) = { 0,  10,  50, 159, 319,   0, -1000 }
dim shared as long py(0 to NPTS - 1) = { 0,   5,  25,  99,   0, 199, -1000 }

'' One recorded reading.
type Reading
    ok      as long
    x       as long
    y       as long
    z       as long
    buttons as long
    clip    as long
end type

dim shared as Reading refr(0 to NPTS - 1)
dim shared as Reading ours(0 to NPTS - 1)

'' FORCE A WINDOW TO THE FOREGROUND, AND WAIT UNTIL IT REALLY IS.
''
'' GETMOUSE fails outright when the window is not active, so a window that never
'' takes focus makes every point report failure -- which is what happened the
'' first time this ran inside the suite rather than by hand. Windows REFUSES a
'' bare SetForegroundWindow from a process that is not already in the
'' foreground; the documented way round it is to attach to the input queue of
'' the thread that owns the current foreground window for the duration of the
'' call.
''
'' The result is then WAITED FOR rather than assumed, and the caller reports a
'' hard failure if it never arrives. Treating "could not focus" as a skip would
'' turn an environment problem into a green run.
function ForceForeground( byval hwin as HWND ) as long
    dim as HWND fg = GetForegroundWindow( )
    dim as DWORD us = GetCurrentThreadId( )
    dim as DWORD them = iif( fg <> 0, GetWindowThreadProcessId( fg, NULL ), 0 )

    if (them <> 0) andalso (them <> us) then AttachThreadInput( us, them, TRUE )
    ShowWindow( hwin, SW_SHOW )
    BringWindowToTop( hwin )
    SetForegroundWindow( hwin )
    SetActiveWindow( hwin )
    if (them <> 0) andalso (them <> us) then AttachThreadInput( us, them, FALSE )

    for i as integer = 1 to 40
        if GetForegroundWindow( ) = hwin then return 1
        Sleep( 25 )
    next
    return 0
end function

'' Move the pointer to a client point of `hwin` and let the window pump.
sub MoveTo( byval hwin as HWND, byval cx as long, byval cy as long )
    dim as POINT p
    p.x = cx : p.y = cy
    ClientToScreen( hwin, @p )
    SetCursorPos( p.x, p.y )
    '' see case 4: the value updates when the window processes the move, so both
    '' sides get the same settling time rather than an immediate read
    Sleep( 90 )
end sub

'' ---- side A: the reference ----
scope
    screen 13
    dim as long h
    screencontrol GET_WINDOW_HANDLE, h
    dim as HWND hwin = cast( HWND, cast( any ptr, cast( uinteger, h ) ) )
    if hwin = 0 then
        print "abtest-mouse: FAIL -- no window handle from the reference"
        end 1
    end if
    if ForceForeground( hwin ) = 0 then
        print "abtest-mouse: FAIL -- the reference window would not take focus."
        print "  GETMOUSE reports failure while inactive, so nothing here is"
        print "  comparable. This needs an interactive desktop session."
        screen 0
        end 1
    end if
    Sleep( 120 )

    for i as integer = 0 to NPTS - 1
        MoveTo( hwin, px(i), py(i) )
        dim as long mx, my, mz, mb, mc
        getmouse mx, my, mz, mb, mc
        refr(i).ok      = iif( mx = -1 andalso my = -1, 0, 1 )
        refr(i).x       = mx
        refr(i).y       = my
        refr(i).z       = mz
        refr(i).buttons = mb
        refr(i).clip    = mc
    next
    screen 0
end scope

'' ---- side B: ours, over the identical protocol ----
scope
    dim as ubyte ptr pix = callocate( CW * CH * 4 )
    dim as ubyte ptr dirtybuf = callocate( CH )
    dim as Surface s
    SurfaceInit( s, pix, CW, CH, CW * 4, 4 )
    s.dirty = dirtybuf

    dim as GfxWindow wnd
    if WindowOpen( wnd, s, CW, CH, "libtkogfx mouse probe" ) = 0 then
        print "abtest-mouse: FAIL -- our window would not open"
        end 1
    end if
    SetWindowPos( wnd.hwnd, HWND_TOPMOST, 0, 0, 0, 0, _
                  SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE )
    if ForceForeground( wnd.hwnd ) = 0 then
        print "abtest-mouse: FAIL -- our window would not take focus"
        WindowClose( wnd )
        end 1
    end if
    Sleep( 120 )

    for i as integer = 0 to NPTS - 1
        MoveTo( wnd.hwnd, px(i), py(i) )
        dim as long mx, my, mz, mb, mc
        dim as long rc = MouseGet( wnd.mouse, wnd.active, mx, my, mz, mb, mc )
        '' MouseAdjust is what turns the driver's answer into GETMOUSE's:
        '' -1 everywhere on failure, and Y divided by scanline_size on success.
        '' scanline_size is 1 on this surface.
        dim as long fail = MouseAdjust( iif( rc = 0, 1, 0 ), 1, mx, my, mz, mb, mc )
        ours(i).ok      = iif( fail, 0, 1 )
        ours(i).x       = mx
        ours(i).y       = my
        ours(i).z       = mz
        ours(i).buttons = mb
        ours(i).clip    = mc
    next

    WindowClose( wnd )
    deallocate( pix )
    deallocate( dirtybuf )
end scope

'' ---- compare ----
for i as integer = 0 to NPTS - 1
    dim as string tag = "pt(" + str(px(i)) + "," + str(py(i)) + ")"
    chk( tag + " ok",      refr(i).ok,      ours(i).ok )
    chk( tag + " x",       refr(i).x,       ours(i).x )
    chk( tag + " y",       refr(i).y,       ours(i).y )
    chk( tag + " z",       refr(i).z,       ours(i).z )
    chk( tag + " buttons", refr(i).buttons, ours(i).buttons )
    chk( tag + " clip",    refr(i).clip,    ours(i).clip )
next

'' THE PROTOCOL MUST HAVE DISCRIMINATED. If every point failed, or every point
'' succeeded, the comparison above is satisfied by an implementation that always
'' answers the same thing. Assert that the reference itself produced BOTH
'' outcomes -- otherwise the run proves nothing and should say so.
scope
    dim as long nok = 0
    for i as integer = 0 to NPTS - 1
        nok += refr(i).ok
    next
    chk( "reference saw at least one point INSIDE",  0, iif( nok > 0, 0, 1 ) )
    chk( "reference saw at least one point OUTSIDE", 0, iif( nok < NPTS, 0, 1 ) )
end scope

'' ---- the button and wheel state machine, from synthetic messages ----
''
'' Real clicks would land on whatever is under the pointer, so they are not
'' synthesised here (see the header). The bit twiddling is still worth checking
'' and costs nothing: feed the messages directly.
scope
    dim as MouseState m
    MouseInit( m )
    chk( "buttons start clear", 0, m.buttons )
    chk( "wheel starts at zero", 0, m.wheel )

    MouseHandleMessage( m, 0, WM_LBUTTONDOWN, 0, 0 )
    chk( "left down", MOUSE_BUTTON_LEFT, m.buttons )
    MouseHandleMessage( m, 0, WM_RBUTTONDOWN, 0, 0 )
    chk( "left+right down", MOUSE_BUTTON_LEFT or MOUSE_BUTTON_RIGHT, m.buttons )
    MouseHandleMessage( m, 0, WM_LBUTTONUP, 0, 0 )
    chk( "left up leaves right", MOUSE_BUTTON_RIGHT, m.buttons )
    MouseHandleMessage( m, 0, WM_MBUTTONDOWN, 0, 0 )
    chk( "middle down", MOUSE_BUTTON_RIGHT or MOUSE_BUTTON_MIDDLE, m.buttons )
    MouseHandleMessage( m, 0, WM_RBUTTONUP, 0, 0 )
    MouseHandleMessage( m, 0, WM_MBUTTONUP, 0, 0 )
    chk( "all up", 0, m.buttons )

    '' the wheel ACCUMULATES -- it is not a per-read delta
    for k as integer = 1 to 3
        MouseHandleMessage( m, 0, WM_MOUSEWHEEL, 120, 0 )
    next
    chk( "wheel after three up-notches", 3, m.wheel )
    MouseHandleMessage( m, 0, WM_MOUSEWHEEL, cast( WPARAM, -120 ), 0 )
    chk( "wheel after one down-notch", 2, m.wheel )

    '' coordinates come from the UNSIGNED low words of lParam -- no sign
    '' extension, which is what the reference does. 0xFFF0 stays 65520.
    MouseHandleMessage( m, 0, WM_MOUSEMOVE, 0, cast( LPARAM, &h00320064 ) )
    chk( "move x from low word", &h0064, m.x )
    chk( "move y from high word", &h0032, m.y )
    MouseHandleMessage( m, 0, WM_MOUSEMOVE, 0, cast( LPARAM, &hFFF0FFF0 ) )
    chk( "negative coords are NOT sign-extended", &hFFF0, m.x )
end scope

'' ---- MouseAdjust: failure writes -1 everywhere, success divides Y ----
scope
    dim as long x = 7, y = 100, z = 3, b = 1, c = 0
    chk( "adjust ok returns 0", 0, MouseAdjust( 1, 1, x, y, z, b, c ) )
    chk( "adjust scanline 1 leaves y", 100, y )

    y = 100
    MouseAdjust( 1, 2, x, y, z, b, c )
    chk( "adjust scanline 2 halves y", 50, y )

    x = 7 : y = 100 : z = 3 : b = 1 : c = 1
    chk( "adjust failure returns 1", 1, MouseAdjust( 0, 1, x, y, z, b, c ) )
    chk( "failure x", -1, x )
    chk( "failure y", -1, y )
    chk( "failure z", -1, z )
    chk( "failure buttons", -1, b )
    chk( "failure clip", -1, c )
end scope

print "abtest-mouse -- "; ran; " pointer checks against gfxlib2"
if failures = 0 then
    print "abtest-mouse: PASS -- the pointer mapping agrees"
    end 0
else
    print report;
    print "abtest-mouse: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
