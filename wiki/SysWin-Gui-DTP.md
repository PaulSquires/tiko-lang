[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **DTP**

# DTP

Reads and sets the date and time, range, format and drop-down calendar of a date picker.

A date and time picker is a one-line field showing a date or a time, with a button that drops
down a month calendar (or, with `DTS_UPDOWN` or `DTS_TIMEFORMAT`, arrows instead). Create one
with `CWindow.AddControl( "DateTimePicker", ... )`, which gives it the `DTS_SHORTDATEFORMAT`
style and the window's font for the drop-down calendar too. Every function here takes the
control's handle first and is written with the namespace: `DTP.GetSystemtime( hDtp )`.

Values travel in `SYSTEMTIME` structures. A control with the `DTS_SHOWNONE` style has a check
box and can hold **no date**: [GetSystemtime](#getsystemtime) then returns `GDT_NONE`. Ranges are
arrays of two `SYSTEMTIME`, the earlier first. The drop-down calendar exists only while it is
open; its colours, font and style are kept by the picker and given to it each time. When the
value changes the parent receives `WM_NOTIFY` with `DTN_DATETIMECHANGE`.

[CloseMonthCal](#closemonthcal), [GetDateTimePickerInfo](#getdatetimepickerinfo),
[GetIdealSize](#getidealsize) and the month-calendar style functions need version 6 of the
common controls: call `EnableVisualStyles()` at start-up or give the program a manifest.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A date field showing dates as "29 Feb 2024", limited to this year, and sized to fit its text;
the caption follows every change.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_DTP = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "DtpDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Pick a date", @WndProc )
    pWindow.SetClientSize( 300, 100 )
    pWindow.Center()
    dim hDtp as HWND = pWindow.AddControl( "DateTimePicker", hWin, IDC_DTP, "", 40, 35, 200, 26 )
    DTP.SetFormat( hDtp, "dd MMM yyyy" )
    dim today as SYSTEMTIME = DTP.GetSystemtime( hDtp )
    dim rg(1) as SYSTEMTIME
    rg(0).wYear = today.wYear : rg(0).wMonth = 1 : rg(0).wDay = 1
    rg(1).wYear = today.wYear : rg(1).wMonth = 12 : rg(1).wDay = 31
    DTP.SetRange( hDtp, GDTR_MIN or GDTR_MAX, @rg(0) )
    var (cx, cy) = DTP.GetIdealSize( hDtp )
    if GetLastError() then SetWindowPos( hDtp, NULL, 0, 0, cx, cy, SWP_NOMOVE or SWP_NOZORDER )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = cast( NMHDR ptr, lParam )
            if pnmh->idFrom = IDC_DTP andalso pnmh->code = DTN_DATETIMECHANGE then
                SetWindowText( hwnd, "Chosen: " & GetWindowText( pnmh->hwndFrom ) )
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
| [GetSystemtime](#getsystemtime) | Returns or reads the date and time shown. |
| [SetSystemtime](#setsystemtime) | Sets the date and time, or no date. |
| [GetRange](#getrange) | Reads the earliest and latest values allowed. |
| [SetRange](#setrange) | Sets the earliest and latest values allowed. |
| [SetFormat](#setformat) | Sets how the value is written in the field. |
| [GetMonthCal](#getmonthcal) | Returns the drop-down calendar while it is open. |
| [CloseMonthCal](#closemonthcal) | Closes the drop-down calendar. |
| [GetMonthCalColor](#getmonthcalcolor) | Returns a colour of the drop-down calendar. |
| [SetMonthCalColor](#setmonthcalcolor) | Sets a colour of the drop-down calendar. |
| [GetMonthCalFont](#getmonthcalfont) | Returns the font of the drop-down calendar. |
| [SetMonthCalFont](#setmonthcalfont) | Sets the font of the drop-down calendar. |
| [GetMonthCalStyle](#getmonthcalstyle) | Returns the style of the drop-down calendar. |
| [SetMonthCalStyle](#setmonthcalstyle) | Sets the style of the drop-down calendar. |
| [GetDateTimePickerInfo](#getdatetimepickerinfo) | Reads the rectangles, states and windows of the control's parts. |
| [GetIdealSize](#getidealsize) | Returns the size that shows the value without clipping. |

## Reference

### GetSystemtime

```freebasic
function GetSystemtime overload( byval hDtp as HWND, byval pst as SYSTEMTIME ptr ) as DWORD
function GetSystemtime overload( byval hDtp as HWND, byref st as SYSTEMTIME ) as DWORD
function GetSystemtime overload( byval hDtp as HWND ) as SYSTEMTIME
```

Reads the date and time the control shows. A new control shows the current date and time.

**Returns** `GDT_VALID` (0) when the structure holds the value, `GDT_NONE` when a
`DTS_SHOWNONE` control's box is unchecked, `GDT_ERROR` on failure; the third form returns the
structure (all zero unless `GDT_VALID`).

**Example**

```freebasic
dim st as SYSTEMTIME
if DTP.GetSystemtime( hCtrl, st ) = GDT_VALID then print st.wDay; "/"; st.wMonth; "/"; st.wYear
```

Microsoft Learn: [DTM_GETSYSTEMTIME](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getsystemtime)

### SetSystemtime

```freebasic
function SetSystemtime overload( byval hDtp as HWND, byval gd as DWORD, byval pst as SYSTEMTIME ptr ) as DWORD
function SetSystemtime overload( byval hDtp as HWND, byval gd as DWORD, byref st as SYSTEMTIME ) as DWORD
```

With `gd` `GDT_VALID`, shows the date and time in the structure. With `GDT_NONE`, unchecks the
box of a `DTS_SHOWNONE` control and the structure is not read (pass `NULL`); without that style
it fails. No `DTN_DATETIMECHANGE` is sent.

**Returns** nonzero on success, 0 on failure.

**Example**

```freebasic
dim st as SYSTEMTIME
st.wYear = 2024 : st.wMonth = 2 : st.wDay = 29
DTP.SetSystemtime( hCtrl, GDT_VALID, st )
```

Microsoft Learn: [DTM_SETSYSTEMTIME](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setsystemtime)

### GetRange

```freebasic
function GetRange( byval hDtp as HWND, byval rgst as SYSTEMTIME ptr ) as DWORD
```

Reads the earliest allowed value into `rgst[0]` and the latest into `rgst[1]`.

**Returns** which limits are set: `GDTR_MIN`, `GDTR_MAX`, both, or 0 for none.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
if DTP.GetRange( hCtrl, @rg(0) ) and GDTR_MIN then print "nothing before"; rg(0).wYear
```

Microsoft Learn: [DTM_GETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getrange)

### SetRange

```freebasic
function SetRange( byval hDtp as HWND, byval gd as DWORD, byval rgst as SYSTEMTIME ptr ) as DWORD
```

Sets the earliest (`rgst[0]`) and latest (`rgst[1]`) values the user can choose. `gd` says
which of the two are set: `GDTR_MIN`, `GDTR_MAX` or both; a limit left out is removed.

**Returns** nonzero on success, 0 on failure.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
rg(0).wYear = 2020 : rg(0).wMonth = 1 : rg(0).wDay = 1
rg(1).wYear = 2030 : rg(1).wMonth = 12 : rg(1).wDay = 31
DTP.SetRange( hCtrl, GDTR_MIN or GDTR_MAX, @rg(0) )
```

Microsoft Learn: [DTM_SETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setrange)

### SetFormat

```freebasic
sub SetFormat( byval hDtp as HWND, byval pwsz as wstring ptr ) as boolean
```

Sets how the field writes the value, with a format string built from `d`, `dd`, `ddd`, `dddd`,
`M`, `MM`, `MMM`, `MMMM`, `y`, `yy`, `yyyy`, `h`, `hh`, `H`, `HH`, `m`, `mm`, `s`, `ss`, `t`,
`tt`; other text goes between single quotes. `"dd'/'MM'/'yyyy"` shows 29 February 2024 as
`29/02/2024`. `NULL` goes back to the format of the control's style.

It is declared as a `sub` with a result type, and is a `sub`: it gives no value, so it cannot be
used in an expression.

**Example**

```freebasic
DTP.SetFormat( hCtrl, "dddd, d MMMM yyyy" )
```

Microsoft Learn: [DTM_SETFORMAT](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setformat)

### GetMonthCal

```freebasic
function GetMonthCal( byval hDtp as HWND ) as HWND
```

Returns the drop-down month calendar. It exists only while it is open, so call this from the
`DTN_DROPDOWN` notification; the [MonthCal](SysWin-Gui-MonthCal) functions work on it.

**Returns** the calendar's handle, or `NULL` when it is closed.

**Example**

```freebasic
dim hCal as HWND = DTP.GetMonthCal( hCtrl )
if hCal then MonthCal.SetCurrentView( hCal, MCMV_YEAR )
```

Microsoft Learn: [DTM_GETMONTHCAL](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getmonthcal)

### CloseMonthCal

```freebasic
sub CloseMonthCal( byval hDtp as HWND )
```

Closes the drop-down calendar if it is open.

**Example**

```freebasic
DTP.CloseMonthCal( hCtrl )
```

Microsoft Learn: [DTM_CLOSEMONTHCAL](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-closemonthcal)

### GetMonthCalColor

```freebasic
function GetMonthCalColor( byval hDtp as HWND, byval iColor as long ) as COLORREF
```

Returns a colour the drop-down calendar is given: `iColor` is `MCSC_BACKGROUND`,
`MCSC_MONTHBK`, `MCSC_TEXT`, `MCSC_TITLEBK`, `MCSC_TITLETEXT` or `MCSC_TRAILINGTEXT`.

**Returns** the colour, or -1 on failure.

**Example**

```freebasic
print "calendar text: &h"; hex( DTP.GetMonthCalColor( hCtrl, MCSC_TEXT ) )
```

Microsoft Learn: [DTM_GETMCCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getmccolor)

### SetMonthCalColor

```freebasic
function SetMonthCalColor( byval hDtp as HWND, byval iColor as long, byval clr as COLORREF ) as COLORREF
```

Sets a colour the drop-down calendar is given, named as for
[GetMonthCalColor](#getmonthcalcolor).

**Returns** the previous colour, or -1 on failure.

**Example**

```freebasic
DTP.SetMonthCalColor( hCtrl, MCSC_TITLEBK, BGR( 0, 0, 128 ) )
```

Microsoft Learn: [DTM_SETMCCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setmccolor)

### GetMonthCalFont

```freebasic
function GetMonthCalFont( byval hDtp as HWND ) as HFONT
```

**Returns** the font the drop-down calendar is given. After `AddControl` it is the window's
font.

**Example**

```freebasic
dim hFont as HFONT = DTP.GetMonthCalFont( hCtrl )
```

Microsoft Learn: [DTM_GETMCFONT](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getmcfont)

### SetMonthCalFont

```freebasic
sub SetMonthCalFont( byval hDtp as HWND, byval hfont as HFONT, byval fRedraw as boolean )
```

Sets the font the drop-down calendar is given; `fRedraw` `true` redraws an open calendar. The
picker does not take ownership: keep the font until the control is gone, then delete it.

**Example**

```freebasic
DTP.SetMonthCalFont( hCtrl, GetStockObject( DEFAULT_GUI_FONT ), true )
```

Microsoft Learn: [DTM_SETMCFONT](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setmcfont)

### GetMonthCalStyle

```freebasic
function GetMonthCalStyle( byval hDtp as HWND ) as LRESULT
```

**Returns** the window style the drop-down calendar is created with, its `MCS_*` bits included.

**Example**

```freebasic
if DTP.GetMonthCalStyle( hCtrl ) and MCS_WEEKNUMBERS then print "shows week numbers"
```

Microsoft Learn: [DTM_GETMCSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getmcstyle)

### SetMonthCalStyle

```freebasic
function SetMonthCalStyle( byval hDtp as HWND, byval dwStyle as DWORD ) as LRESULT
```

Replaces the style the drop-down calendar is created with by `dwStyle`, for example
`MCS_WEEKNUMBERS or MCS_NOTODAY`; [GetMonthCalStyle](#getmonthcalstyle) then returns exactly
`dwStyle`. To add a style, combine it with the old one.

**Returns** the previous style.

**Example**

```freebasic
DTP.SetMonthCalStyle( hCtrl, DTP.GetMonthCalStyle( hCtrl ) or MCS_WEEKNUMBERS )
```

Microsoft Learn: [DTM_SETMCSTYLE](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-setmcstyle)

### GetDateTimePickerInfo

```freebasic
sub GetDateTimePickerInfo overload( byval hDtp as HWND, byval pdtpi as DATETIMEPICKERINFO ptr )
sub GetDateTimePickerInfo overload( byval hDtp as HWND, byref dtpi as DATETIMEPICKERINFO )
function GetDateTimePickerInfo overload( byval hDtp as HWND ) as DATETIMEPICKERINFO
```

Fills a `DATETIMEPICKERINFO` (the function sets `cbSize`): the rectangles of the check box and
the drop-down button, their states, and the edit and up-down windows (`NULL` when the control
has none). The pointer form does nothing for `NULL`.

**Returns** the structure (third form).

**Example**

```freebasic
dim dtpi as DATETIMEPICKERINFO = DTP.GetDateTimePickerInfo( hCtrl )
print "button from x ="; dtpi.rcButton.left; " to"; dtpi.rcButton.right
```

Microsoft Learn: [DTM_GETDATETIMEPICKERINFO](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getdatetimepickerinfo)

### GetIdealSize

```freebasic
function GetIdealSize overload( byval hDtp as HWND, byval psize as SIZE ptr ) as boolean
function GetIdealSize overload( byval hDtp as HWND, byref sz as SIZE ) as boolean
function GetIdealSize overload( byval hDtp as HWND ) as ( long, long )
```

Reads the width and height that show the current value in the current format without
clipping. The tuple form returns `( cx, cy )` and sets `GetLastError()` to 1 on success and 0 on
failure.

**Returns** `true` on success, or the size.

**Example**

```freebasic
var (cx, cy) = DTP.GetIdealSize( hCtrl )
if GetLastError() then SetWindowPos( hCtrl, NULL, 0, 0, cx, cy, SWP_NOMOVE or SWP_NOZORDER )
```

Microsoft Learn: [DTM_GETIDEALSIZE](https://learn.microsoft.com/en-us/windows/win32/controls/dtm-getidealsize)

## See also

- [sys/win/gui](SysWin-Gui)
- [MonthCal](SysWin-Gui-MonthCal) for the drop-down calendar
- [CWindow](CWindow) for `AddControl( "DateTimePicker", ... )`
- [Window text and styles](SysWin-Window-Text-and-Styles) for `EnableVisualStyles`
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_NOTIFY`
