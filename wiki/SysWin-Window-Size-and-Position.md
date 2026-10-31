[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Window size and position**

# Window size and position

Reads and sets a window's position and size in pixels, and centres windows and controls.

Every function here takes a window handle: a top-level window, a dialog or a control. Sizes are
in physical pixels unless the name ends in `ForDpi`, in which case the values you pass are
**96-DPI units** and are multiplied by the desktop's scaling ratio first, so `400` becomes `600`
on a display set to 150 %.

Three rectangles describe a window:

| Rectangle | Covers | Coordinates | Read it with |
| --- | --- | --- | --- |
| Window | the whole window: caption, borders, menu and, for a shown top-level window, the invisible resize border and drop shadow | screen | [GetWindowRect](#getwindowrect) |
| Bounds | the visible frame only, without the drop shadow | screen | [GetWindowBounds](#getwindowbounds) |
| Client | the area inside the borders that the window paints itself | client: the top-left corner is always (0, 0) | [GetWindowClientRect](#getwindowclientrect) |

The location of a child window or control is relative to its parent's client area; the location
of a top-level window is relative to the screen.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A window whose client area is 400 × 220 at 96 DPI on any display, centred in the work area, with
a button that reports the three sizes in the caption:

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "SizeDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Window size and position", @WndProc )
    SetWindowClientSizeForDpi( hWin, 400, 220 )
    CenterWindow( hWin )
    dim hButton as HWND = pWindow.AddControl( "Button", hWin, 100, "&Measure", 150, 90, 100, 30 )
    CenterControlH( hButton )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_COMMAND
            if CBCTL( wParam, lParam ) = 100 andalso CBCTLMSG( wParam, lParam ) = BN_CLICKED then
                var (l, t, r, b) = GetWindowBounds( hwnd )
                SetWindowText( hwnd, "window " & GetWindowWidth( hwnd ) & " x " & GetWindowHeight( hwnd ) & _
                                     ", frame " & ( r - l ) & " x " & ( b - t ) & _
                                     ", client " & GetWindowClientWidth( hwnd ) & " x " & GetWindowClientHeight( hwnd ) )
            end if
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

On a typical Windows 11 display the window rectangle is 14 pixels wider than the visible frame:
the difference is the invisible resize border.

## Functions

| Function | Does |
| --- | --- |
| [GetWindowRect](#getwindowrect) | Returns the window rectangle in screen coordinates. |
| [GetWindowBounds](#getwindowbounds) | Returns the visible frame of a window, without its drop shadow. |
| [GetWindowWidth](#getwindowwidth) | Returns the width of the window rectangle. |
| [GetWindowHeight](#getwindowheight) | Returns the height of the window rectangle. |
| [GetWindowSize](#getwindowsize) | Reads the width and height of the window rectangle into two variables. |
| [SetWindowSize](#setwindowsize) | Resizes a window without moving it. |
| [SetWindowSizeForDpi](#setwindowsizefordpi) | Resizes a window to a size given in 96-DPI units. |
| [GetWindowClientRect](#getwindowclientrect) | Returns the client rectangle. |
| [GetWindowClientWidth](#getwindowclientwidth) | Returns the width of the client area. |
| [GetWindowClientHeight](#getwindowclientheight) | Returns the height of the client area. |
| [SetWindowClientSize](#setwindowclientsize) | Resizes a window so that its client area has a given size. |
| [SetWindowClientSizeForDpi](#setwindowclientsizefordpi) | Resizes a window so that its client area has a size given in 96-DPI units. |
| [GetWindowLocation](#getwindowlocation) | Reads the top-left corner of a window, relative to its parent. |
| [SetWindowLocation](#setwindowlocation) | Moves a window without resizing it. |
| [SetWindowLocationForDpi](#setwindowlocationfordpi) | Moves a window to a position given in 96-DPI units. |
| [SetWindowPosForDPI](#setwindowposfordpi) | Moves, resizes and reorders a window, with position and size in 96-DPI units. |
| [MoveWindowForDPI](#movewindowfordpi) | Moves and resizes a window, with position and size in 96-DPI units. |
| [CenterWindow](#centerwindow) | Centres a window over its parent or in the work area. |
| [CenterControlH](#centercontrolh) | Centres a control horizontally in its parent. |
| [CenterControlV](#centercontrolv) | Centres a control vertically in its parent. |
| [ForceVisibleDisplay](#forcevisibledisplay) | Moves a window that is off every screen back onto the nearest one. |

## Reference

### GetWindowRect

```freebasic
function GetWindowRect( byval hWin as HWND ) as ( long, long, long, long )
```

Returns the window rectangle as `( left, top, right, bottom )`, in screen coordinates. `right`
and `bottom` are one past the last pixel, so `right - left` is the width.

The rectangle includes the caption, borders and menu. Once a top-level window has been shown it
also includes the invisible resize border and the drop shadow; use
[GetWindowBounds](#getwindowbounds) for the frame the user sees. For the whole desktop pass
`GetDesktopWindow()`.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |

**Returns** the four edges. `GetLastError()` is nonzero afterwards when the call succeeded and
0 when it failed (an invalid handle gives four zeros).

The one-argument form belongs to `win`; the Windows function of the same name, which fills a
`RECT`, is still there with two arguments.

**Example**

```freebasic
var (l, t, r, b) = GetWindowRect( hwnd )
if GetLastError() then print "left"; l; " top"; t; " width"; r - l; " height"; b - t
```

Microsoft Learn: [GetWindowRect](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowrect)

### GetWindowBounds

```freebasic
function GetWindowBounds( byval hWin as HWND ) as ( long, long, long, long )
```

Returns the visible frame of a window as `( left, top, right, bottom )`, in screen coordinates:
the window rectangle without the invisible resize border and the drop shadow. The values are
physical pixels, not adjusted for DPI virtualisation.

The frame is only known once the window has been shown; before that the call fails.

| Parameter | Meaning |
| --- | --- |
| `hWin` | A top-level window. |

**Returns** the four edges. `GetLastError()` is `S_OK` (0) afterwards when the call succeeded,
otherwise the failing `HRESULT`.

**Example**

```freebasic
var (l, t, r, b) = GetWindowBounds( hwnd )
if GetLastError() = S_OK then print "visible frame:"; r - l; " x"; b - t
```

Microsoft Learn: [DwmGetWindowAttribute](https://learn.microsoft.com/en-us/windows/win32/api/dwmapi/nf-dwmapi-dwmgetwindowattribute) with `DWMWA_EXTENDED_FRAME_BOUNDS`

### GetWindowWidth

```freebasic
function GetWindowWidth( byval hWin as HWND ) as long
```

Returns the width of the window rectangle in pixels, borders included. Pass `GetDesktopWindow()`
for the width of the primary screen.

**Returns** the width, or 0 for an invalid handle.

**Example**

```freebasic
print "desktop width:"; GetWindowWidth( GetDesktopWindow() )
```

### GetWindowHeight

```freebasic
function GetWindowHeight( byval hWin as HWND ) as long
```

Returns the height of the window rectangle in pixels, caption and borders included. Pass
`GetDesktopWindow()` for the height of the primary screen.

**Returns** the height, or 0 for an invalid handle.

**Example**

```freebasic
print "window height:"; GetWindowHeight( hwnd )
```

### GetWindowSize

```freebasic
function GetWindowSize( byval hWin as HWND, byref nWidth as long, byref nHeight as long ) as boolean
```

Reads the width and height of the window rectangle into `nWidth` and `nHeight`, in one call.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |
| `nWidth` | Receives the width in pixels. |
| `nHeight` | Receives the height in pixels. |

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
dim as long w, h
if GetWindowSize( hwnd, w, h ) then print w; " x"; h
```

### SetWindowSize

```freebasic
function SetWindowSize( byval hWin as HWND, byval nWidth as long, byval nHeight as long ) as boolean
```

Resizes a window to `nWidth` × `nHeight` pixels, borders included. Its position and its place in
the Z order stay as they are.

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
SetWindowSize( hwnd, 640, 480 )
```

Microsoft Learn: [SetWindowPos](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowpos)

### SetWindowSizeForDpi

```freebasic
function SetWindowSizeForDpi( byval hWin as HWND, byval nWidth as long, byval nHeight as long ) as boolean
```

Resizes a window like [SetWindowSize](#setwindowsize), but `nWidth` and `nHeight` are 96-DPI
units: each is multiplied by the desktop's scaling ratio (`GetLogPixelsX() / 96` and
`GetLogPixelsY() / 96`) first.

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
SetWindowSizeForDpi( hwnd, 640, 480 )   ' 960 x 720 at 150 %
```

### GetWindowClientRect

```freebasic
function GetWindowClientRect( byval hWin as HWND ) as ( long, long, long, long )
```

Returns the client rectangle as `( left, top, right, bottom )`. Client coordinates start at the
top-left corner of the client area, so `left` and `top` are always 0 and `right` and `bottom` are
the width and height.

**Returns** the four edges. `GetLastError()` is nonzero afterwards when the call succeeded and
0 when it failed.

**Example**

```freebasic
var (l, t, r, b) = GetWindowClientRect( hwnd )
if GetLastError() then print "client area:"; r; " x"; b
```

Microsoft Learn: [GetClientRect](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclientrect)

### GetWindowClientWidth

```freebasic
function GetWindowClientWidth( byval hWin as HWND ) as long
```

Returns the width of the client area in pixels: the window's width less its borders and, if it
has one, its vertical scroll bar.

**Returns** the width, or 0 for an invalid handle.

**Example**

```freebasic
print "client width:"; GetWindowClientWidth( hwnd )
```

### GetWindowClientHeight

```freebasic
function GetWindowClientHeight( byval hWin as HWND ) as long
```

Returns the height of the client area in pixels: the window's height less its caption, menu,
borders and, if it has one, its horizontal scroll bar.

**Returns** the height, or 0 for an invalid handle.

**Example**

```freebasic
print "client height:"; GetWindowClientHeight( hwnd )
```

### SetWindowClientSize

```freebasic
sub SetWindowClientSize( byval hWin as HWND, byval nWidth as long, byval nHeight as long, byval rxRatio as single = 1, byval ryRatio as single = 1 )
```

Resizes a window so that its **client area** is `nWidth` × `nHeight` pixels, working out the
borders, caption and menu from the window's own styles. A menu bar that wraps onto a second line
and a horizontal or vertical scroll bar are allowed for. The window does not move or activate.

| Parameter | Meaning |
| --- | --- |
| `hWin` | A window. |
| `nWidth`, `nHeight` | The client size wanted. |
| `rxRatio`, `ryRatio` | Optional factors each size is multiplied by first; 1 leaves it as given. |

**Example**

```freebasic
SetWindowClientSize( hwnd, 400, 300 )
```

Microsoft Learn: [AdjustWindowRectEx](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-adjustwindowrectex)

### SetWindowClientSizeForDpi

```freebasic
sub SetWindowClientSizeForDpi( byval hWin as HWND, byval nWidth as long, byval nHeight as long )
```

Resizes a window so that its client area is `nWidth` × `nHeight` **96-DPI units**: the same as
[SetWindowClientSize](#setwindowclientsize) with the desktop's horizontal and vertical scaling
ratios passed as `rxRatio` and `ryRatio`. Use it to lay out a window once, at 96 DPI, and have it
come out the same physical size on every display.

**Example**

```freebasic
SetWindowClientSizeForDpi( hwnd, 400, 300 )   ' 600 x 450 pixels at 150 %
```

### GetWindowLocation

```freebasic
sub GetWindowLocation( byval hWin as HWND, byref nLeft as long, byref nTop as long )
```

Reads the top-left corner of a window, in pixels. For a control or child window the point is
relative to the parent's client area; for a top-level window it is in screen coordinates.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window or control. |
| `nLeft` | Receives the x coordinate. |
| `nTop` | Receives the y coordinate. |

**Example**

```freebasic
dim as long x, y
GetWindowLocation( hCtrl, x, y )
print "the control is at"; x; ","; y
```

Microsoft Learn: [MapWindowPoints](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mapwindowpoints)

### SetWindowLocation

```freebasic
function SetWindowLocation( byval hWin as HWND, byval nLeft as long, byval nTop as long ) as boolean
```

Moves a window so that its top-left corner is at (`nLeft`, `nTop`), in the same coordinates as
[GetWindowLocation](#getwindowlocation). Its size and place in the Z order stay as they are.

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
SetWindowLocation( hCtrl, 10, 10 )
```

### SetWindowLocationForDpi

```freebasic
function SetWindowLocationForDpi( byval hWin as HWND, byval nLeft as long, byval nTop as long ) as boolean
```

Moves a window like [SetWindowLocation](#setwindowlocation), but `nLeft` and `nTop` are 96-DPI
units and are scaled by the desktop's ratios first.

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
SetWindowLocationForDpi( hCtrl, 10, 40 )   ' 15, 60 at 150 %
```

### SetWindowPosForDPI

```freebasic
function SetWindowPosForDPI( byval hwnd as HWND, byval hWndInsertAfter as HWND, byval x as long, byval y as long, byval cx as long, byval cy as long, byval uFlags as UINT = SWP_NOZORDER ) as boolean
```

Calls Windows' `SetWindowPos` with `x`, `y`, `cx` and `cy` multiplied by the desktop's scaling
ratios first, so they are given in 96-DPI units.

| Parameter | Meaning |
| --- | --- |
| `hwnd` | The window. |
| `hWndInsertAfter` | The window to place it after in the Z order, or `HWND_TOP`, `HWND_BOTTOM`, `HWND_TOPMOST`, `HWND_NOTOPMOST`. Ignored with `SWP_NOZORDER`. |
| `x`, `y` | The new position. |
| `cx`, `cy` | The new size. |
| `uFlags` | `SWP_*` flags; the default keeps the Z order. Add `SWP_NOMOVE` or `SWP_NOSIZE` to keep the position or the size. |

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
SetWindowPosForDPI( hCtrl, NULL, 20, 20, 120, 28 )
```

Microsoft Learn: [SetWindowPos](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowpos)

### MoveWindowForDPI

```freebasic
function MoveWindowForDPI( byval hwnd as HWND, byval x as long, byval y as long, byval nWidth as long, byval nHeight as long, byval bRepaint as boolean = true ) as boolean
```

Calls Windows' `MoveWindow` with the position and size multiplied by the desktop's scaling ratios
first, so they are given in 96-DPI units.

| Parameter | Meaning |
| --- | --- |
| `hwnd` | The window. |
| `x`, `y` | The new position. |
| `nWidth`, `nHeight` | The new size. |
| `bRepaint` | `true` (the default) repaints the window after the move. |

**Returns** `true` on success; on failure `false`, and `GetLastError()` says why.

**Example**

```freebasic
MoveWindowForDPI( hCtrl, 20, 60, 200, 24 )
```

Microsoft Learn: [MoveWindow](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-movewindow)

### CenterWindow

```freebasic
sub CenterWindow( byval hWin as HWND = NULL, byval hwndParent as HWND = NULL )
```

Centres a window over `hwndParent`, or in the work area of the primary display when
`hwndParent` is `NULL`. The result is kept inside the work area (the screen less the taskbar), so
a window centred over a parent near the edge stops at the edge. The size and Z order do not
change.

To centre a child window, pass its parent as `hwndParent`.

| Parameter | Meaning |
| --- | --- |
| `hWin` | The window to move. |
| `hwndParent` | The window to centre over, or `NULL` for the work area. |

**Example**

```freebasic
CenterWindow( hwnd )                    ' in the work area
CenterWindow( hDlg, hwnd )              ' over its owner
```

Microsoft Learn: [SystemParametersInfoW](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfow) with `SPI_GETWORKAREA`

### CenterControlH

```freebasic
sub CenterControlH( byval hCtrl as HWND )
```

Moves a control so that it is centred horizontally in its parent's client area. Its vertical
position and its size stay as they are.

**Example**

```freebasic
CenterControlH( hCtrl )
```

### CenterControlV

```freebasic
sub CenterControlV( byval hCtrl as HWND )
```

Moves a control so that it is centred vertically in its parent's client area.

**Example**

```freebasic
CenterControlV( hCtrl )
```

### ForceVisibleDisplay

```freebasic
sub ForceVisibleDisplay( byval hWin as HWND )
```

Brings back a window that is on no display at all, by centring it in the work area of the
display nearest to where it was. A window that is at least partly on some display is left
alone.

A program that restores its last position at start-up can open off-screen after the user
unplugs or rearranges a monitor. Call this once the window has been created and placed.

**Example**

```freebasic
SetWindowLocation( hwnd, 5000, 5000 )   ' a saved position, now off every screen
ForceVisibleDisplay( hwnd )
```

Microsoft Learn: [MonitorFromRect](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-monitorfromrect)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Display, screen and DPI](SysWin-Display-and-DPI) for the scaling ratios the `ForDpi` functions use
