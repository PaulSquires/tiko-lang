'' probe-window.bas -- the Win32 window and its presenter thread, verified by
'' reading pixels back off the real window.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' THIS IS NOT AN A/B TEST, AND THE REASON MATTERS. gfxlib2's window cannot be
'' driven and inspected in the same process as ours -- both would want the same
'' framebuffer and the same input focus -- so there is nothing to compare
'' against. What can be checked is stronger than "it did not crash": the window
'' really exists, its CLIENT area is exactly the requested size, and the pixels
'' that come back off it are the pixels we put in the surface.
''
'' It is a real window on a real desktop. It appears for about a second and
'' closes itself. Nothing here waits for a human.
''
'' WHAT EACH CHECK IS FOR:
''
''   1. The open handshake succeeds and yields a window handle.
''   2. The CLIENT rectangle is exactly what was asked for. Passing the wanted
''      size straight to CreateWindowEx gives a client area smaller by the frame
''      and caption, so this is what catches a missing AdjustWindowRect -- and it
''      is invisible in a screenshot, because the image simply looks cropped.
''   3. The pump thread actually ran a frame. A pump that never loops leaves
''      everything else in this file passing by accident on the WM_PAINT path.
''   4. PIXELS ROUND-TRIP. Draw a pattern, mark it dirty, wait for a present,
''      then BitBlt the window's client area into a memory DC and compare. This
''      is the end-to-end check: surface -> dirty -> thread -> SetDIBitsToDevice
''      -> window.
''   5. The image is not vertically mirrored. The pattern is deliberately
''      ASYMMETRIC top-to-bottom, because a bottom-up DIB -- the Windows default,
''      and what you get by omitting the negative biHeight -- produces a
''      perfectly plausible image that is upside down. A symmetric test pattern
''      passes happily.
''   6. Only DIRTY rows are presented. A row changed without being marked must
''      NOT appear, or the dirty-tracking the whole design rests on is a no-op.
''   7. Teardown joins the thread and leaves no window behind.
''
'' READBACK IS FRAGILE BY NATURE. BitBlt from a window DC captures whatever is
'' composited there, so another window on top would be captured instead. The
'' window is made topmost and foreground, and the readback is retried; if it
'' still cannot get a clean frame the checks are reported as SKIPPED rather than
'' passed, because a green run that silently verified nothing is worse than a
'' loud gap.

#include once "../driver/window.ti"
#include once "../raster/box.ti"
#include once "../raster/pixel.ti"
#include once "windows.bi"

using TkoGfx

dim shared as string report
dim shared as long failures = 0
dim shared as long ran = 0
dim shared as long skipped = 0

sub chk( byref what as string, byval want as longint, byval got as longint )
    ran += 1
    if want <> got then
        report += "  FAIL " + what + " want " + str(want) + " got " + str(got) + chr(10)
        failures += 1
    end if
end sub

sub skip( byref what as string, byref why as string )
    skipped += 1
    report += "  SKIP " + what + " -- " + why + chr(10)
end sub

const W = 320
const H = 200

'' ---- a surface, and an asymmetric pattern ----
dim as ubyte ptr pix = callocate( W * H * 4 )
dim as Surface s
SurfaceInit( s, pix, W, H, W * 4, 4 )

'' ATTACH A DIRTY ARRAY. SurfaceInit deliberately leaves `dirty` null -- an
'' offscreen image tracks nothing -- so a screen surface has to be given one.
'' Omitting it does not fail loudly: DirtyMark becomes a no-op, DirtySpan
'' reports nothing changed, the presenter thread never blits, and the window
'' still shows the right picture because WM_PAINT paints the whole surface.
'' Every pixel check here passed in that state. What caught it was the frame
'' counter staying at zero and the POSITIVE half of the dirty test -- "a marked
'' row IS presented" -- failing. The negative half, "an unmarked row is NOT
'' presented", passed for the wrong reason: nothing was ever presented at all.
'' A negative check needs its positive twin or it asserts nothing.
dim as ubyte ptr dirtybuf = callocate( H )
s.dirty = dirtybuf

'' Deliberately asymmetric top-to-bottom: the top quarter is a bright band, and
'' each row carries its own index in the low byte. A flipped image fails, and so
'' does an image offset by any number of rows.
sub PaintPattern( byref s as Surface )
    for y as integer = 0 to s.h - 1
        dim as ulong c
        if y < s.h \ 4 then
            c = &hFFE04020 or cast( ulong, y )
        else
            c = &hFF204060 or (cast( ulong, y ) shl 8)
        end if
        for x as integer = 0 to s.w - 1
            PSet32( s, x, y, c xor (cast( ulong, x and 7 ) shl 16) )
        next
    next
end sub

PaintPattern( s )

dim as GfxWindow wnd
dim as long opened = WindowOpen( wnd, s, W, H, "libtkogfx window probe" )
chk( "WindowOpen succeeded", 1, opened )

if opened = 0 then
    print report;
    print "probe-window: FAIL -- the window would not open"
    end 1
end if

chk( "has an HWND", 0, iif( wnd.hwnd <> 0, 0, 1 ) )

'' keep it on top so the readback captures OUR pixels
SetWindowPos( wnd.hwnd, HWND_TOPMOST, 0, 0, 0, 0, _
              SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE )

'' ---- 2. the CLIENT area is exactly what was asked for ----
dim as RECT rc
GetClientRect( wnd.hwnd, @rc )
chk( "client width", W, rc.right - rc.left )
chk( "client height", H, rc.bottom - rc.top )

'' ---- 3. the pump ran ----
DirtyMarkSpan( s, 0, s.h - 1 )
dim as long spun = 0
for i as integer = 1 to 200
    if (wnd.started <> 0) andalso (wnd.frames > 0) then spun = 1 : exit for
    Sleep( 10 )
next
chk( "pump presented a frame", 1, spun )

'' ---- 4 + 5. pixels round-trip, right way up ----
''
'' Read the client area back through a memory DC. Retried, because a transient
'' overlap makes the capture someone else's pixels rather than ours.
'' NOTE the parameter names: not `w` and `h`. FreeBASIC identifiers are
'' CASE-INSENSITIVE, so a parameter `w` collides with the module-level `const W`
'' -- a duplicated-definition error, not a shadow. Worse, an earlier pass here
'' renamed only the SIGNATURE: the body kept saying `w` and `h`, which compiled
'' cleanly because they bound to the CONSTANTS and happened to hold the same
'' values. The parameters were dead and nothing said so.
function ReadBack( byval hwnd as HWND, byval cw as long, byval chh as long, _
                   byval outbuf as ulong ptr ) as long
    dim as HDC src = GetDC( hwnd )
    if src = 0 then return 0
    dim as HDC mem = CreateCompatibleDC( src )
    dim as HBITMAP bmp = CreateCompatibleBitmap( src, cw, chh )
    dim as long ok = 0
    if (mem <> 0) andalso (bmp <> 0) then
        dim as HGDIOBJ old = SelectObject( mem, bmp )
        if BitBlt( mem, 0, 0, cw, chh, src, 0, 0, SRCCOPY ) <> 0 then
            dim as BITMAPINFO bi
            bi.bmiHeader.biSize     = sizeof( BITMAPINFOHEADER )
            bi.bmiHeader.biWidth    = cw
            bi.bmiHeader.biHeight   = -chh     '' top-down, as everywhere else
            bi.bmiHeader.biPlanes   = 1
            bi.bmiHeader.biBitCount = 32
            bi.bmiHeader.biCompression = BI_RGB
            if GetDIBits( mem, bmp, 0, chh, outbuf, @bi, DIB_RGB_COLORS ) = chh then ok = 1
        end if
        SelectObject( mem, old )
    end if
    if bmp <> 0 then DeleteObject( bmp )
    if mem <> 0 then DeleteDC( mem )
    ReleaseDC( hwnd, src )
    return ok
end function

'' Compare ignoring the alpha byte: GDI does not carry it through a BitBlt.
function SameRow( byval a as ulong ptr, byval b as ulong ptr, byval n as long ) as long
    for i as integer = 0 to n - 1
        if (a[i] and &hFFFFFF) <> (b[i] and &hFFFFFF) then return 0
    next
    return 1
end function

'' A CAPTURE THAT SUCCEEDS BUT DISAGREES IS A FAILURE, NOT A SKIP.
''
'' The first version of this loop retried until the captured first row matched
'' the surface, and skipped everything if it never did. That is a FALSE PASS
'' path, and it hid a real bug: with a bottom-up DIB the image comes back
'' upside down, row 0 never matches, so every pixel check was skipped and the
'' probe reported PASS. The negative test for the DIB orientation passed
'' happily -- exactly the defect this file exists to catch.
''
'' So the two outcomes are now separated. `ReadBack` failing is a capture
'' problem and skips. `ReadBack` SUCCEEDING is a usable frame, and its contents
'' are compared and can fail. The retry only buys a stable frame; it can no
'' longer swallow a wrong one.
dim as ulong ptr shot = callocate( W * H * 4 )
dim as long got_shot = 0
for attempt as integer = 1 to 10
    DirtyMarkSpan( s, 0, s.h - 1 )
    Sleep( 60 )
    if ReadBack( wnd.hwnd, W, H, shot ) then
        got_shot = 1
        '' a matching first row means the frame has settled; otherwise keep
        '' retrying, but KEEP this capture and compare it if none ever settles
        if SameRow( shot, cast( ulong ptr, s.pixels ), W ) then exit for
    end if
next

if got_shot = 0 then
    skip( "pixel round-trip", "ReadBack never succeeded -- no frame to compare" )
    skip( "vertical orientation", "no capture" )
    skip( "dirty rows only", "no capture" )
else
    dim as long bad_rows = 0
    for y as integer = 0 to H - 1
        dim as ulong ptr want = cast( ulong ptr, s.pixels + y * s.pitch )
        dim as ulong ptr got  = shot + y * W
        if SameRow( got, want, W ) = 0 then bad_rows += 1
    next
    chk( "pixel round-trip: differing rows", 0, bad_rows )

    '' 5. a flipped image would match row 0 against row H-1. Assert the top
    '' band is at the TOP of what came back.
    dim as ulong top_px    = shot[0]
    dim as ulong bottom_px = shot[(H - 1) * W]
    dim as ulong want_top    = (cast( ulong ptr, s.pixels ))[0]
    dim as ulong want_bottom = (cast( ulong ptr, s.pixels + (H - 1) * s.pitch ))[0]
    chk( "top row is the top row", want_top and &hFFFFFF, top_px and &hFFFFFF )
    chk( "bottom row is the bottom row", want_bottom and &hFFFFFF, bottom_px and &hFFFFFF )
    chk( "the pattern is not symmetric (the test would be vacuous)", _
         0, iif( (want_top and &hFFFFFF) <> (want_bottom and &hFFFFFF), 0, 1 ) )

    '' ---- 6. only DIRTY rows are presented ----
    ''
    '' Change a row WITHOUT marking it. It must not reach the window; if it
    '' does, dirty tracking is decorative.
    DirtyClear( s )
    dim as long probe_y = H \ 2
    dim as ulong ptr row = cast( ulong ptr, s.pixels + probe_y * s.pitch )
    dim as ulong saved = row[0]
    for x as integer = 0 to W - 1
        row[x] = &hFF00FF00
    next
    Sleep( 80 )

    dim as ulong ptr shot2 = callocate( W * H * 4 )
    if ReadBack( wnd.hwnd, W, H, shot2 ) then
        chk( "an unmarked row is NOT presented", _
             saved and &hFFFFFF, shot2[probe_y * W] and &hFFFFFF )
        '' and once marked, it IS
        DirtyMark( s, probe_y, 1 )
        Sleep( 80 )
        if ReadBack( wnd.hwnd, W, H, shot2 ) then
            chk( "a marked row IS presented", _
                 &h00FF00, shot2[probe_y * W] and &hFFFFFF )
        else
            skip( "a marked row IS presented", "capture failed" )
        end if
    else
        skip( "dirty rows only", "capture failed" )
    end if
    deallocate( shot2 )
end if

'' ---- 7. teardown ----
dim as HWND was = wnd.hwnd
WindowClose( wnd )
chk( "thread handle released", 0, iif( wnd.thread = 0, 0, 1 ) )
chk( "window destroyed", 0, iif( IsWindow( was ) = 0, 0, 1 ) )

deallocate( shot )
deallocate( pix )

print "probe-window -- "; ran; " checks, "; skipped; " skipped"
if failures = 0 then
    if skipped > 0 then print report;
    print "probe-window: PASS -- real window, exact client size, pixels round-trip"
    end 0
else
    print report;
    print "probe-window: FAIL -- "; failures; " of"; ran
    end 1
end if
