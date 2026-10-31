[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **TrackBar**

# TrackBar

Reads and sets a trackbar's position, range, tick marks, selection and buddy windows.

A trackbar (a slider) is a thumb the user drags along a channel to pick a whole number between a
minimum and a maximum: the **logical positions**. Create one with
`CWindow.AddControl( "TrackBar", ... )`, which gives it the styles `TBS_AUTOTICKS`, `TBS_HORZ`,
`TBS_BOTTOM` and `TBS_TOOLTIPS`, a range of 0 to 100 and a page size of 10 (the alias
`"Slider"` creates the same control but leaves the range and page size at the control's own
defaults). Every function here takes the control's handle first and is written with the
namespace: `TrackBar.GetPos( hTrackbar )`.

When the user moves the thumb the trackbar sends `WM_HSCROLL` (or `WM_VSCROLL` for `TBS_VERT`)
to its parent, with the trackbar's handle in `lParam`. Setting the position from the program
sends nothing. Rectangles are client coordinates of the trackbar.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A volume slider from 0 to 100 with a tick every 10 and a selected band from 40 to 80; moving it
puts the value in the caption.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_TRACKBAR = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "TrackBarDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Volume: 50", @WndProc )
    pWindow.SetClientSize( 360, 100 )
    pWindow.Center()
    dim hTrack as HWND = pWindow.AddControl( "TrackBar", hWin, IDC_TRACKBAR, "", 20, 30, 320, 40, _
                                             WS_VISIBLE or WS_TABSTOP or TBS_AUTOTICKS or TBS_ENABLESELRANGE or TBS_TOOLTIPS )
    TrackBar.SetTicFreq( hTrack, 10 )
    TrackBar.SetSel( hTrack, 40, 80, true )
    TrackBar.SetPos( hTrack, true, 50 )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_HSCROLL
            dim hTrack as HWND = cast( HWND, lParam )
            if hTrack = GetDlgItem( hwnd, IDC_TRACKBAR ) then
                SetWindowText( hwnd, "Volume: " & TrackBar.GetPos( hTrack ) )
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

## Functions

| Function | Does |
| --- | --- |
| [GetPos](#getpos) | Returns the thumb's position. |
| [SetPos](#setpos) | Moves the thumb. |
| [GetRangeMin](#getrangemin) | Returns the minimum position. |
| [GetRangeMax](#getrangemax) | Returns the maximum position. |
| [SetRange](#setrange) | Sets the minimum and maximum, 16 bits each. |
| [SetRangeMin](#setrangemin) | Sets the minimum position. |
| [SetRangeMax](#setrangemax) | Sets the maximum position. |
| [GetLineSize](#getlinesize) | Returns how far an arrow key moves the thumb. |
| [SetLineSize](#setlinesize) | Sets how far an arrow key moves the thumb. |
| [GetPageSize](#getpagesize) | Returns how far Page Up, Page Down or a click in the channel moves it. |
| [SetPageSize](#setpagesize) | Sets how far Page Up, Page Down or a click in the channel moves it. |
| [GetNumTics](#getnumtics) | Returns the number of tick marks. |
| [GetTic](#gettic) | Returns the position of a tick mark. |
| [GetTicPos](#getticpos) | Returns where a tick mark is drawn, in pixels. |
| [GetPTics](#getptics) | Returns the address of the tick positions, cut to 32 bits. |
| [SetTic](#settic) | Adds a tick mark at a position. |
| [SetTicFreq](#setticfreq) | Draws a tick mark every so many positions. |
| [ClearTics](#cleartics) | Removes the tick marks between the ends. |
| [GetSelStart](#getselstart) | Returns where the selection starts. |
| [GetSelEnd](#getselend) | Returns where the selection ends. |
| [SetSel](#setsel) | Sets the selection, 16 bits each end. |
| [SetSelStart](#setselstart) | Sets where the selection starts. |
| [SetSelEnd](#setselend) | Sets where the selection ends. |
| [ClearSel](#clearsel) | Removes the selection. |
| [GetChannelRect](#getchannelrect) | Returns the channel's rectangle. |
| [GetThumbRect](#getthumbrect) | Returns the thumb's rectangle. |
| [GetThumbLength](#getthumblength) | Returns the thumb's length. |
| [SetThumbLength](#setthumblength) | Sets the thumb's length. |
| [GetBuddy](#getbuddy) | Returns a buddy window. |
| [SetBuddy](#setbuddy) | Places a window at one end of the trackbar. |
| [GetTooltips](#gettooltips) | Returns the tooltip control. |
| [SetToolTips](#settooltips) | Assigns a tooltip control. |
| [SetTipSide](#settipside) | Says on which side the position tooltip appears. |

## Reference

### GetPos

```freebasic
function GetPos( byval hTrackbar as HWND ) as long
```

**Returns** the thumb's logical position.

**Example**

```freebasic
print "position:"; TrackBar.GetPos( hCtrl )
```

Microsoft Learn: [TBM_GETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getpos)

### SetPos

```freebasic
sub SetPos( byval hTrackbar as HWND, byval fPosition as boolean, byval lPosition as long )
```

Moves the thumb to `lPosition`; a value outside the range is moved to the nearer end. Note the
order of the arguments: the second one, `fPosition`, is the redraw flag, `true` to redraw the
control at once. No `WM_HSCROLL` or `WM_VSCROLL` is sent.

**Example**

```freebasic
TrackBar.SetPos( hCtrl, true, 75 )
```

Microsoft Learn: [TBM_SETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setpos)

### GetRangeMin

```freebasic
function GetRangeMin( byval hTrackbar as HWND ) as long
```

**Returns** the smallest position the thumb can have.

**Example**

```freebasic
print "from"; TrackBar.GetRangeMin( hCtrl ); " to"; TrackBar.GetRangeMax( hCtrl )
```

Microsoft Learn: [TBM_GETRANGEMIN](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getrangemin)

### GetRangeMax

```freebasic
function GetRangeMax( byval hTrackbar as HWND ) as long
```

**Returns** the largest position the thumb can have.

**Example**

```freebasic
TrackBar.SetPos( hCtrl, true, TrackBar.GetRangeMax( hCtrl ) )   ' to the end
```

Microsoft Learn: [TBM_GETRANGEMAX](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getrangemax)

### SetRange

```freebasic
sub SetRange( byval hTrackbar as HWND, byval lMinimum as long, byval lMaximum as long, byval fRedraw as boolean = false )
```

Sets the minimum and maximum positions in one call. Both travel as 16-bit halves of one value,
so each must lie between -32768 and 32767: a maximum of 70000 arrives as 4464. For a wider
range use [SetRangeMin](#setrangemin) and [SetRangeMax](#setrangemax), which take 32 bits.

| Parameter | Meaning |
| --- | --- |
| `lMinimum`, `lMaximum` | The new range. |
| `fRedraw` | `true` redraws the control after the change. |

**Example**

```freebasic
TrackBar.SetRange( hCtrl, 0, 255, true )
```

Microsoft Learn: [TBM_SETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setrange)

### SetRangeMin

```freebasic
sub SetRangeMin( byval hTrackbar as HWND, byval lMinimum as long, byval fRedraw as boolean = false )
```

Sets the smallest position, as a full 32-bit value. `fRedraw` `true` redraws the control.

**Example**

```freebasic
TrackBar.SetRangeMin( hCtrl, -100000, true )
```

Microsoft Learn: [TBM_SETRANGEMIN](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setrangemin)

### SetRangeMax

```freebasic
sub SetRangeMax( byval hTrackbar as HWND, byval lMaximum as long, byval fRedraw as boolean = false )
```

Sets the largest position, as a full 32-bit value. `fRedraw` `true` redraws the control.

**Example**

```freebasic
TrackBar.SetRangeMax( hCtrl, 100000, true )
```

Microsoft Learn: [TBM_SETRANGEMAX](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setrangemax)

### GetLineSize

```freebasic
function GetLineSize( byval hTrackbar as HWND ) as long
```

**Returns** how many positions an arrow key moves the thumb; 1 unless changed.

**Example**

```freebasic
print "arrow step:"; TrackBar.GetLineSize( hCtrl )
```

Microsoft Learn: [TBM_GETLINESIZE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getlinesize)

### SetLineSize

```freebasic
function SetLineSize( byval hTrackbar as HWND, byval lLineSize as long ) as long
```

Sets how many positions an arrow key moves the thumb.

**Returns** the previous line size.

**Example**

```freebasic
TrackBar.SetLineSize( hCtrl, 5 )
```

Microsoft Learn: [TBM_SETLINESIZE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setlinesize)

### GetPageSize

```freebasic
function GetPageSize( byval hTrackbar as HWND ) as long
```

**Returns** how many positions Page Up, Page Down or a click in the channel moves the thumb
(10 after `AddControl`).

**Example**

```freebasic
print "page step:"; TrackBar.GetPageSize( hCtrl )
```

Microsoft Learn: [TBM_GETPAGESIZE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getpagesize)

### SetPageSize

```freebasic
function SetPageSize( byval hTrackbar as HWND, byval lPageSize as long ) as long
```

Sets how many positions Page Up, Page Down or a click in the channel moves the thumb.

**Returns** the previous page size.

**Example**

```freebasic
TrackBar.SetPageSize( hCtrl, 25 )
```

Microsoft Learn: [TBM_SETPAGESIZE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setpagesize)

### GetNumTics

```freebasic
function GetNumTics( byval hTrackbar as HWND ) as long
```

**Returns** the number of tick marks, the two at the ends included; 0 for a control with the
`TBS_NOTICKS` style. A control from `AddControl`, range 0 to 100 with a tick at every
position, has 101; after `SetTicFreq( h, 10 )` it has 11.

**Example**

```freebasic
print TrackBar.GetNumTics( hCtrl ); " tick marks"
```

Microsoft Learn: [TBM_GETNUMTICS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getnumtics)

### GetTic

```freebasic
function GetTic( byval hTrackbar as HWND, byval iTic as DWORD ) as long
```

Returns the logical position of a tick mark. `iTic` counts the tick marks between the two ends
from 0, so it runs to `GetNumTics( h ) - 3`; the end marks are not counted.

**Returns** the position, or -1 when there is no such tick mark.

**Example**

```freebasic
for i as long = 0 to TrackBar.GetNumTics( hCtrl ) - 3
    print TrackBar.GetTic( hCtrl, i );
next
```

Microsoft Learn: [TBM_GETTIC](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-gettic)

### GetTicPos

```freebasic
function GetTicPos( byval hTrackbar as HWND, byval iTic as DWORD ) as long
```

Returns where a tick mark is drawn: its x coordinate (y for a vertical trackbar) in client
coordinates. `iTic` counts as for [GetTic](#gettic).

**Returns** the coordinate, or -1 when there is no such tick mark.

**Example**

```freebasic
print "first inner tick at x ="; TrackBar.GetTicPos( hCtrl, 0 )
```

Microsoft Learn: [TBM_GETTICPOS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getticpos)

### GetPTics

```freebasic
function GetPTics( byval hTrackbar as HWND ) as DWORD
```

The control replies with the address of its array of tick positions (the marks between the
ends). The function returns that address as a `DWORD`, so in a 64-bit program the upper half is
lost and the value cannot be used as a pointer. Read the positions with [GetTic](#gettic), or
send the message yourself.

**Returns** the low 32 bits of the address.

**Example**

```freebasic
dim pTics as DWORD ptr = cast( DWORD ptr, SendMessageW( hCtrl, TBM_GETPTICS, 0, 0 ) )
if pTics then print "first inner tick:"; pTics[0]
print "as returned here: &h"; hex( TrackBar.GetPTics( hCtrl ) )
```

Microsoft Learn: [TBM_GETPTICS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getptics)

### SetTic

```freebasic
function SetTic( byval hTrackbar as HWND, byval lPosition as long ) as boolean
```

Adds a tick mark at logical position `lPosition`. The ends always have one.

**Returns** `true` on success.

**Example**

```freebasic
TrackBar.SetTic( hCtrl, 33 )
TrackBar.SetTic( hCtrl, 66 )
```

Microsoft Learn: [TBM_SETTIC](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-settic)

### SetTicFreq

```freebasic
sub SetTicFreq( byval hTrackbar as HWND, byval wFreq as WORD )
```

Draws a tick mark every `wFreq` positions. It applies to a control with the `TBS_AUTOTICKS`
style, which `AddControl` gives it.

**Example**

```freebasic
TrackBar.SetTicFreq( hCtrl, 10 )
```

Microsoft Learn: [TBM_SETTICFREQ](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setticfreq)

### ClearTics

```freebasic
sub ClearTics( byval hTrackbar as HWND, byval fRedraw as boolean = false )
```

Removes the tick marks between the ends; the two end marks stay, so
[GetNumTics](#getnumtics) returns 2 afterwards. `fRedraw` `true` redraws the control.

**Example**

```freebasic
TrackBar.ClearTics( hCtrl, true )
```

Microsoft Learn: [TBM_CLEARTICS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-cleartics)

### GetSelStart

```freebasic
function GetSelStart( byval hTrackbar as HWND ) as long
```

**Returns** the logical position where the selection starts. The selection is a highlighted band
of the channel, shown by a control with the `TBS_ENABLESELRANGE` style.

**Example**

```freebasic
print "selected"; TrackBar.GetSelStart( hCtrl ); " to"; TrackBar.GetSelEnd( hCtrl )
```

Microsoft Learn: [TBM_GETSELSTART](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getselstart)

### GetSelEnd

```freebasic
function GetSelEnd( byval hTrackbar as HWND ) as long
```

**Returns** the logical position where the selection ends.

**Example**

```freebasic
dim nWidth as long = TrackBar.GetSelEnd( hCtrl ) - TrackBar.GetSelStart( hCtrl )
```

Microsoft Learn: [TBM_GETSELEND](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getselend)

### SetSel

```freebasic
sub SetSel( byval hTrackbar as HWND, byval iStart as short, byval iEnd as short, byval fRedraw as boolean = false )
```

Sets both ends of the selection, each a 16-bit value. A control without the
`TBS_ENABLESELRANGE` style ignores it: both ends stay 0. `fRedraw` `true` redraws the control.

**Example**

```freebasic
TrackBar.SetSel( hCtrl, 20, 60, true )
```

Microsoft Learn: [TBM_SETSEL](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setsel)

### SetSelStart

```freebasic
sub SetSelStart( byval hTrackbar as HWND, byval lStart as long, byval fRedraw as boolean = false )
```

Sets where the selection starts, as a 32-bit value. Ignored without `TBS_ENABLESELRANGE`.

**Example**

```freebasic
TrackBar.SetSelStart( hCtrl, 10, true )
```

Microsoft Learn: [TBM_SETSELSTART](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setselstart)

### SetSelEnd

```freebasic
sub SetSelEnd( byval hTrackbar as HWND, byval lEnd as long, byval fRedraw as boolean = false )
```

Sets where the selection ends, as a 32-bit value. Ignored without `TBS_ENABLESELRANGE`.

**Example**

```freebasic
TrackBar.SetSelEnd( hCtrl, 90, true )
```

Microsoft Learn: [TBM_SETSELEND](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setselend)

### ClearSel

```freebasic
sub ClearSel( byval hTrackbar as HWND, byval fRedraw as boolean = false )
```

Removes the selection. `fRedraw` `true` redraws the control.

**Example**

```freebasic
TrackBar.ClearSel( hCtrl, true )
```

Microsoft Learn: [TBM_CLEARSEL](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-clearsel)

### GetChannelRect

```freebasic
sub GetChannelRect overload( byval hTrackbar as HWND, byval prc as RECT ptr )
sub GetChannelRect overload( byval hTrackbar as HWND, byref rc as RECT )
function GetChannelRect overload( byval hTrackbar as HWND ) as ( long, long, long, long )
```

Reads the rectangle of the channel, the groove the thumb slides in, in client coordinates. The
tuple form returns it as `( left, top, right, bottom )`. For a vertical trackbar the control
reports it as if it were horizontal: swap x and y.

**Returns** the four edges (third form).

**Example**

```freebasic
var (l, t, r, b) = TrackBar.GetChannelRect( hCtrl )
print "channel from x ="; l; " to"; r
```

Microsoft Learn: [TBM_GETCHANNELRECT](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getchannelrect)

### GetThumbRect

```freebasic
sub GetThumbRect overload( byval hTrackbar as HWND, byval prc as RECT ptr )
sub GetThumbRect overload( byval hTrackbar as HWND, byref rc as RECT )
function GetThumbRect overload( byval hTrackbar as HWND ) as ( long, long, long, long )
```

Reads the rectangle of the thumb, in client coordinates. The tuple form returns it as
`( left, top, right, bottom )`.

**Returns** the four edges (third form).

**Example**

```freebasic
var (l, t, r, b) = TrackBar.GetThumbRect( hCtrl )
print "thumb:"; r - l; " x"; b - t
```

Microsoft Learn: [TBM_GETTHUMBRECT](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getthumbrect)

### GetThumbLength

```freebasic
function GetThumbLength( byval hTrackbar as HWND ) as long
```

**Returns** the length of the thumb in pixels: its height for a horizontal trackbar, its width
for a vertical one.

**Example**

```freebasic
print "thumb length:"; TrackBar.GetThumbLength( hCtrl )
```

Microsoft Learn: [TBM_GETTHUMBLENGTH](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getthumblength)

### SetThumbLength

```freebasic
sub SetThumbLength( byval hTrackbar as HWND, byval iLength as long )
```

Sets the length of the thumb in pixels. Only a control with the `TBS_FIXEDLENGTH` style takes
it.

**Example**

```freebasic
TrackBar.SetThumbLength( hCtrl, 24 )
```

Microsoft Learn: [TBM_SETTHUMBLENGTH](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setthumblength)

### GetBuddy

```freebasic
function GetBuddy( byval hTrackbar as HWND, byval fLocation as boolean ) as HWND
```

Returns a buddy window: with `fLocation` `true` the one to the left (above, for `TBS_VERT`),
with `false` the one to the right (below).

**Returns** the buddy, or `NULL` when there is none at that end.

**Example**

```freebasic
dim hLeft as HWND = TrackBar.GetBuddy( hCtrl, true )
if hLeft then print "left buddy says: "; GetWindowText( hLeft )
```

Microsoft Learn: [TBM_GETBUDDY](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-getbuddy)

### SetBuddy

```freebasic
function SetBuddy( byval hTrackbar as HWND, byval fLocation as boolean, byval hwndBuddy as HWND ) as HWND
```

Makes `hwndBuddy` a buddy window and moves it next to one end of the trackbar: the left (top)
end with `fLocation` `true`, the right (bottom) end with `false`. A label at each end is the
usual use.

**Returns** the buddy that was at that end before, or `NULL`.

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
TrackBar.SetBuddy( hCtrl, true, pWindow->AddControl( "Label", hwnd, -1, "Low", 0, 0, 40, 20 ) )
TrackBar.SetBuddy( hCtrl, false, pWindow->AddControl( "Label", hwnd, -1, "High", 0, 0, 40, 20 ) )
```

Microsoft Learn: [TBM_SETBUDDY](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-setbuddy)

### GetTooltips

```freebasic
function GetTooltips( byval hTrackbar as HWND ) as HWND
```

**Returns** the tooltip control that shows the position while the thumb is dragged (a control
with the `TBS_TOOLTIPS` style has one), or `NULL`.

**Example**

```freebasic
if TrackBar.GetTooltips( hCtrl ) then print "shows its value while dragged"
```

Microsoft Learn: [TBM_GETTOOLTIPS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-gettooltips)

### SetToolTips

```freebasic
sub SetToolTips( byval hTrackbar as HWND, byval hwndTT as HWND )
```

Makes `hwndTT` the trackbar's tooltip control.

**Example**

```freebasic
TrackBar.SetToolTips( hCtrl, CreateWindowExW( 0, TOOLTIPS_CLASSW, NULL, TTS_ALWAYSTIP, 0, 0, 0, 0, hwnd, NULL, NULL, NULL ) )
```

Microsoft Learn: [TBM_SETTOOLTIPS](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-settooltips)

### SetTipSide

```freebasic
function SetTipSide( byval hTrackbar as HWND, byval fLocation as long ) as long
```

Says where the position tooltip appears: `TBTS_TOP`, `TBTS_BOTTOM` (horizontal trackbars),
`TBTS_LEFT` or `TBTS_RIGHT` (vertical ones).

**Returns** the previous side.

**Example**

```freebasic
TrackBar.SetTipSide( hCtrl, TBTS_BOTTOM )
```

Microsoft Learn: [TBM_SETTIPSIDE](https://learn.microsoft.com/en-us/windows/win32/controls/tbm-settipside)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "TrackBar", ... )`
- [UpDown](SysWin-Gui-UpDown) for picking a number with arrow buttons
- [ScrollBar](SysWin-Gui-ScrollBar)
- [ProgBar](SysWin-Gui-ProgBar)
