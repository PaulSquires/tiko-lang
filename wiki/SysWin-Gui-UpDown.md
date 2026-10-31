[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **UpDown**

# UpDown

Reads and sets an up-down control's position, range, base, buddy window and acceleration.

An up-down control (a spin button) is a pair of arrows that step a number up or down within a
range. It is nearly always paired with a **buddy** window, an edit control beside it: with the
`UDS_SETBUDDYINT` style the control writes its position into the buddy's text, and reads the
position back from it. Create one with `CWindow.AddControl( "UpDown", ... )`, which gives it
`UDS_WRAP`, `UDS_ARROWKEYS`, `UDS_ALIGNRIGHT` and `UDS_SETBUDDYINT`, base 10 and position 0.
Every function here takes the control's handle first and is written with the namespace:
`UpDown.GetPos32( hUpDown )`.

`AddControl` leaves the range as the control's own default: **100 as the minimum and 0 as the
maximum**, so the up arrow makes the number smaller. Call [SetRange32](#setrange32) with the
range you want, `UpDown.SetRange32( h, 0, 100 )`.

Each click sends the parent a `WM_NOTIFY` with `UDN_DELTAPOS` before the position changes; the
`NMUPDOWN` it carries has the current position and the proposed change, and returning nonzero
cancels it. Then the parent receives `WM_VSCROLL` (or `WM_HSCROLL` for `UDS_HORZ`).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

An edit control with an up-down control attached, counting from 1 to 50 in steps that grow
from 1 to 5 while an arrow is held down; the caption follows the value.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_EDIT = 101
const IDC_UPDOWN = 102

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "UpDownDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Copies: 1", @WndProc )
    pWindow.SetClientSize( 300, 100 )
    pWindow.Center()
    pWindow.AddControl( "Label", hWin, -1, "Copies:", 40, 40, 70, 22 )
    dim hEdit as HWND = pWindow.AddControl( "Edit", hWin, IDC_EDIT, "", 120, 38, 70, 24, _
                                            WS_VISIBLE or WS_TABSTOP or ES_NUMBER or ES_RIGHT )
    dim hUpDown as HWND = pWindow.AddControl( "UpDown", hWin, IDC_UPDOWN )
    UpDown.SetBuddy( hUpDown, hEdit )
    UpDown.SetRange32( hUpDown, 1, 50 )
    UpDown.SetPos32( hUpDown, 1 )
    dim acc(1) as UDACCEL
    acc(0).nSec = 0 : acc(0).nInc = 1
    acc(1).nSec = 2 : acc(1).nInc = 5
    UpDown.SetAccel( hUpDown, 2, @acc(0) )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_VSCROLL
            dim hUpDown as HWND = cast( HWND, lParam )
            if hUpDown = GetDlgItem( hwnd, IDC_UPDOWN ) then
                SetWindowText( hwnd, "Copies: " & UpDown.GetPos32( hUpDown ) )
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
| [GetPos32](#getpos32) | Returns the position as a 32-bit value. |
| [SetPos32](#setpos32) | Sets the position as a 32-bit value. |
| [GetPos](#getpos) | Returns the 16-bit position and an error flag in one value. |
| [SetPos](#setpos) | Sets the position as a 16-bit value. |
| [GetRange32](#getrange32) | Reads the minimum and maximum, 32 bits each. |
| [SetRange32](#setrange32) | Sets the minimum and maximum, 32 bits each. |
| [GetRange](#getrange) | Returns the 16-bit maximum and minimum in one value. |
| [SetRange](#setrange) | Sets the maximum and minimum, 16 bits each. |
| [GetBuddy](#getbuddy) | Returns the buddy window. |
| [SetBuddy](#setbuddy) | Sets the buddy window. |
| [GetBase](#getbase) | Returns whether the buddy shows decimal or hexadecimal. |
| [SetBase](#setbase) | Makes the buddy show decimal or hexadecimal. |
| [GetAccel](#getaccel) | Reads how the step grows while an arrow is held. |
| [SetAccel](#setaccel) | Sets how the step grows while an arrow is held. |

## Reference

### GetPos32

```freebasic
function GetPos32( byval hUpDown as HWND, byval pfError as long ptr = NULL ) as long
```

Returns the position. When the control has a buddy with `UDS_SETBUDDYINT`, the position is
first read back from the buddy's text, so it includes what the user typed.

| Parameter | Meaning |
| --- | --- |
| `pfError` | Optional; receives 0 when the position is good and nonzero when it is not, for instance when the buddy's text is not a number. It is also nonzero for a control that has no buddy. |

**Returns** the position.

**Example**

```freebasic
dim nErr as long
dim n as long = UpDown.GetPos32( hCtrl, @nErr )
if nErr = 0 then print "value:"; n
```

Microsoft Learn: [UDM_GETPOS32](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getpos32)

### SetPos32

```freebasic
function SetPos32( byval hUpDown as HWND, byval nPos as long ) as long
```

Sets the position, and with `UDS_SETBUDDYINT` the buddy's text. A value outside the range is
moved to the nearer end.

**Returns** the previous position.

**Example**

```freebasic
UpDown.SetPos32( hCtrl, 10 )
```

Microsoft Learn: [UDM_SETPOS32](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setpos32)

### GetPos

```freebasic
function GetPos( byval hUpDown as HWND ) as long
```

The 16-bit form of [GetPos32](#getpos32). The value carries two things: the position in the low
word and an error flag in the high word, nonzero when the position is not good (and for a
control without a buddy). With position 42 and a good buddy it is 42; with position 300 and no
buddy it is `&h1012C`.

**Returns** the position in the low word and the error flag in the high word.

**Example**

```freebasic
dim r as long = UpDown.GetPos( hCtrl )
if HIWORD( r ) = 0 then print "value:"; cast( short, LOWORD( r ) )
```

Microsoft Learn: [UDM_GETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getpos)

### SetPos

```freebasic
function SetPos( byval hUpDown as HWND, byval nPos as short ) as long
```

The 16-bit form of [SetPos32](#setpos32).

**Returns** the previous position.

**Example**

```freebasic
UpDown.SetPos( hCtrl, 5 )
```

Microsoft Learn: [UDM_SETPOS](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setpos)

### GetRange32

```freebasic
sub GetRange32( byval hUpDown as HWND, byval pLow as long ptr, byval pHigh as long ptr )
```

Reads the range: `*pLow` receives the minimum, `*pHigh` the maximum. Either pointer may be
`NULL`. Straight after `AddControl` they are 100 and 0.

**Example**

```freebasic
dim as long lo, hi
UpDown.GetRange32( hCtrl, @lo, @hi )
print "from"; lo; " to"; hi
```

Microsoft Learn: [UDM_GETRANGE32](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getrange32)

### SetRange32

```freebasic
sub SetRange32( byval hUpDown as HWND, byval iLow as long, byval iHigh as long )
```

Sets the range, as 32-bit values. The up arrow moves towards `iHigh`; a minimum larger than the
maximum makes the up arrow count down.

**Example**

```freebasic
UpDown.SetRange32( hCtrl, 0, 1000 )
```

Microsoft Learn: [UDM_SETRANGE32](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setrange32)

### GetRange

```freebasic
function GetRange( byval hUpDown as HWND ) as long
```

The 16-bit form of [GetRange32](#getrange32): the **maximum** in the low word and the
**minimum** in the high word. After `AddControl` it is `&h640000` (maximum 0, minimum 100).

**Returns** the packed range.

**Example**

```freebasic
dim r as long = UpDown.GetRange( hCtrl )
print "minimum"; cast( short, HIWORD( r ) ); " maximum"; cast( short, LOWORD( r ) )
```

Microsoft Learn: [UDM_GETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getrange)

### SetRange

```freebasic
sub SetRange( byval hUpDown as HWND, byval nUpper as short, byval nLower as short )
```

The 16-bit form of [SetRange32](#setrange32), with the **maximum first**: `nUpper` is the
maximum and `nLower` the minimum, so `SetRange( h, 10, 1 )` gives 1 to 10. Neither may be
farther than 32767 from the other.

**Example**

```freebasic
UpDown.SetRange( hCtrl, 10, 1 )   ' 1 to 10
```

Microsoft Learn: [UDM_SETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setrange)

### GetBuddy

```freebasic
function GetBuddy( byval hUpDown as HWND ) as HWND
```

**Returns** the buddy window, or `NULL` when there is none.

**Example**

```freebasic
dim hBuddy as HWND = UpDown.GetBuddy( hCtrl )
if hBuddy then print "buddy text: "; GetWindowText( hBuddy )
```

Microsoft Learn: [UDM_GETBUDDY](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getbuddy)

### SetBuddy

```freebasic
function SetBuddy( byval hUpDown as HWND, byval hwndBuddy as HWND ) as HWND
```

Makes `hwndBuddy` the buddy. With `UDS_ALIGNRIGHT` or `UDS_ALIGNLEFT` the up-down control moves
itself to that edge of the buddy, which is narrowed to make room, so
`AddControl( "UpDown", ... )` needs no position or size.

**Returns** the previous buddy, or `NULL`.

**Example**

```freebasic
dim pWindow as CWindow ptr = CWindowPtr( hwnd )
UpDown.SetBuddy( hCtrl, pWindow->AddControl( "Edit", hwnd, 200, "0", 20, 20, 60, 22 ) )
```

Microsoft Learn: [UDM_SETBUDDY](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setbuddy)

### GetBase

```freebasic
function GetBase( byval hUpDown as HWND ) as long
```

**Returns** 10 when the buddy shows the position in decimal, 16 when in hexadecimal.

**Example**

```freebasic
print "base"; UpDown.GetBase( hCtrl )
```

Microsoft Learn: [UDM_GETBASE](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getbase)

### SetBase

```freebasic
function SetBase( byval hUpDown as HWND, byval nBase as long ) as long
```

Makes the buddy show the position in decimal (`nBase` 10) or hexadecimal (16). Hexadecimal
numbers are shown without a sign. Any other base is refused.

**Returns** the previous base, or 0 when `nBase` is neither 10 nor 16.

**Example**

```freebasic
UpDown.SetBase( hCtrl, 16 )
```

Microsoft Learn: [UDM_SETBASE](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setbase)

### GetAccel

```freebasic
function GetAccel( byval hUpDown as HWND, byval cAccels as DWORD, byval pAccels as UDACCEL ptr ) as long
```

Copies up to `cAccels` acceleration steps into the array at `pAccels`. Each `UDACCEL` says
that after `nSec` seconds of holding an arrow the position moves by `nInc` per step.

**Returns** the number of acceleration steps the control has, which can be more than were
copied.

**Example**

```freebasic
dim acc(7) as UDACCEL
dim n as long = UpDown.GetAccel( hCtrl, 8, @acc(0) )
for i as long = 0 to n - 1 : print acc(i).nSec; "s:"; acc(i).nInc : next
```

Microsoft Learn: [UDM_GETACCEL](https://learn.microsoft.com/en-us/windows/win32/controls/udm-getaccel)

### SetAccel

```freebasic
function SetAccel( byval hUpDown as HWND, byval cAccels as DWORD, byval pAccels as UDACCEL ptr ) as boolean
```

Replaces the acceleration steps with the `cAccels` entries of the array at `pAccels`, in order
of increasing `nSec`. The control copies them, so the array need not outlive the call.

**Returns** `true` on success.

**Example**

```freebasic
dim acc(2) as UDACCEL
acc(0).nSec = 0 : acc(0).nInc = 1
acc(1).nSec = 2 : acc(1).nInc = 10
acc(2).nSec = 4 : acc(2).nInc = 100
UpDown.SetAccel( hCtrl, 3, @acc(0) )
```

Microsoft Learn: [UDM_SETACCEL](https://learn.microsoft.com/en-us/windows/win32/controls/udm-setaccel)

## See also

- [sys/win/gui](SysWin-Gui)
- [CWindow](CWindow) for `AddControl( "UpDown", ... )`
- [Edit](SysWin-Gui-Edit) for the buddy
- [TrackBar](SysWin-Gui-TrackBar)
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_NOTIFY`
