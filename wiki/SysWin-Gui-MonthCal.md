[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gui](SysWin-Gui) › **MonthCal**

# MonthCal

Reads and sets the selected date, range, today and colours of a month calendar control.

A month calendar control shows one or more months as a grid of days and lets the user pick a
date, or a run of dates with the `MCS_MULTISELECT` style. Create one with
`CWindow.AddControl( "MonthCal", ... )` (or `"MonthCalendar"`). Every function here takes the
control's handle first and is written with the namespace: `MonthCal.GetCurSel( hMonthCal )`.

Dates travel in `SYSTEMTIME` structures; the control ignores the time members. Functions that
take a range take an array of **two** `SYSTEMTIME`: element 0 is the earlier date, element 1
the later. When the user picks a date the parent receives `WM_NOTIFY` with `MCN_SELECT` (a
click) and `MCN_SELCHANGE` (any change). Points and rectangles are client coordinates of the
control.

[SizeRectToMin](#sizerecttomin) and the functions from
[GetCalendarGridInfo](#getcalendargridinfo) on in the table below need version 6 of the common
controls: call `EnableVisualStyles()` at start-up or give the program a manifest.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui
```

## Example

A calendar limited to this year and next, opened on 4 July of this year, sized to the space one
month needs; the caption shows each date the user picks.

```freebasic
#import "sys/win"
#import "sys/win/gui"
using win, gui

const IDC_CAL = 101

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    EnableVisualStyles()
    dim pWindow as CWindow = "MonthCalDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Pick a date", @WndProc )
    dim hCal as HWND = pWindow.AddControl( "MonthCal", hWin, IDC_CAL, "", 10, 10, 250, 200 )
    var (l, t, r, b) = MonthCal.GetMinReqRect( hCal )
    SetWindowPos( hCal, NULL, 0, 0, r, b, SWP_NOMOVE or SWP_NOZORDER )
    SetWindowClientSize( hWin, r + 20, b + 20 )
    pWindow.Center()
    dim today as SYSTEMTIME = MonthCal.GetToday( hCal )
    dim rg(1) as SYSTEMTIME
    rg(0).wYear = today.wYear : rg(0).wMonth = 1 : rg(0).wDay = 1
    rg(1).wYear = today.wYear + 1 : rg(1).wMonth = 12 : rg(1).wDay = 31
    MonthCal.SetRange( hCal, GDTR_MIN or GDTR_MAX, @rg(0) )
    dim st as SYSTEMTIME
    st.wYear = today.wYear : st.wMonth = 7 : st.wDay = 4
    MonthCal.SetCurSel( hCal, st )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_NOTIFY
            dim pnmh as NMHDR ptr = cast( NMHDR ptr, lParam )
            if pnmh->idFrom = IDC_CAL andalso pnmh->code = MCN_SELECT then
                dim st as SYSTEMTIME = MonthCal.GetCurSel( pnmh->hwndFrom )
                SetWindowText( hwnd, st.wDay & "/" & st.wMonth & "/" & st.wYear )
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
| [GetCurSel](#getcursel) | Returns or reads the selected date. |
| [SetCurSel](#setcursel) | Selects a date and brings it into view. |
| [GetSelRange](#getselrange) | Reads the selected run of dates. |
| [SetSelRange](#setselrange) | Selects a run of dates. |
| [GetMaxSelCount](#getmaxselcount) | Returns the most days that can be selected. |
| [SetMaxSelCount](#setmaxselcount) | Sets the most days that can be selected. |
| [GetRange](#getrange) | Reads the earliest and latest dates allowed. |
| [SetRange](#setrange) | Sets the earliest and latest dates allowed. |
| [GetToday](#gettoday) | Returns or reads the date the control treats as today. |
| [SetToday](#settoday) | Sets the date the control treats as today. |
| [GetMonthRange](#getmonthrange) | Reads the first and last dates on display. |
| [GetFirstDayOfWeek](#getfirstdayofweek) | Returns the day each week starts on. |
| [SetFirstDayOfWeek](#setfirstdayofweek) | Sets the day each week starts on. |
| [GetMonthDelta](#getmonthdelta) | Returns how many months a scroll button moves. |
| [SetMonthDelta](#setmonthdelta) | Sets how many months a scroll button moves. |
| [GetColor](#getcolor) | Returns the colour of a part of the control. |
| [SetColor](#setcolor) | Sets the colour of a part of the control. |
| [SetDayState](#setdaystate) | Sets which days are drawn bold. |
| [HitTest](#hittest) | Finds which part of the control is at a point. |
| [GetMinReqRect](#getminreqrect) | Returns the size one month needs. |
| [SizeRectToMin](#sizerecttomin) | Shrinks a rectangle to whole months. |
| [GetMaxTodayWidth](#getmaxtodaywidth) | Returns the width of the "Today" line. |
| [GetCalendarGridInfo](#getcalendargridinfo) | Reads the rectangle or dates of a part of the grid. |
| [GetCalendarBorder](#getcalendarborder) | Returns the border around each month. |
| [SetCalendarBorder](#setcalendarborder) | Sets the border around each month. |
| [GetCalendarCount](#getcalendarcount) | Returns the number of months on display. |
| [GetCurrentView](#getcurrentview) | Returns whether days, months, years or decades are shown. |
| [SetCurrentView](#setcurrentview) | Shows days, months, years or decades. |
| [GetCALID](#getcalid) | Returns the calendar system in use. |
| [SetCALID](#setcalid) | Sets the calendar system. |

## Reference

### GetCurSel

```freebasic
function GetCurSel overload( byval hMonthCal as HWND, byval pst as SYSTEMTIME ptr ) as boolean
function GetCurSel overload( byval hMonthCal as HWND, byref st as SYSTEMTIME ) as boolean
function GetCurSel overload( byval hMonthCal as HWND ) as SYSTEMTIME
```

Reads the selected date, with `wDayOfWeek` filled in (0 is Sunday). A control with the
`MCS_MULTISELECT` style has a run of dates instead: use [GetSelRange](#getselrange).

**Returns** `true` on success, or the date (third form; all zero on failure).

**Example**

```freebasic
dim st as SYSTEMTIME = MonthCal.GetCurSel( hCtrl )
print st.wDay; "/"; st.wMonth; "/"; st.wYear
```

Microsoft Learn: [MCM_GETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcursel)

### SetCurSel

```freebasic
function SetCurSel overload( byval hMonthCal as HWND, byval pst as SYSTEMTIME ptr ) as long
function SetCurSel overload( byval hMonthCal as HWND, byref st as SYSTEMTIME ) as long
```

Selects a date, scrolling it into view when it is not shown. It fails for a date outside the
allowed range and for a `MCS_MULTISELECT` control. No notification is sent.

**Returns** nonzero on success, 0 on failure.

**Example**

```freebasic
dim st as SYSTEMTIME
st.wYear = 2024 : st.wMonth = 2 : st.wDay = 29
MonthCal.SetCurSel( hCtrl, st )
```

Microsoft Learn: [MCM_SETCURSEL](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setcursel)

### GetSelRange

```freebasic
function GetSelRange( byval hMonthCal as HWND, byval rgst as SYSTEMTIME ptr ) as long
```

Reads the first and last selected dates of a `MCS_MULTISELECT` control into the two-element
array at `rgst`.

**Returns** nonzero on success; 0 for a control without `MCS_MULTISELECT`.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
if MonthCal.GetSelRange( hCtrl, @rg(0) ) then print "from"; rg(0).wDay; " to"; rg(1).wDay
```

Microsoft Learn: [MCM_GETSELRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getselrange)

### SetSelRange

```freebasic
function SetSelRange( byval hMonthCal as HWND, byval rgst as SYSTEMTIME ptr ) as boolean
```

Selects the run of dates from `rgst[0]` to `rgst[1]` in a `MCS_MULTISELECT` control. The run
may not be longer than [GetMaxSelCount](#getmaxselcount) days.

**Returns** `true` on success; `false` for a control without `MCS_MULTISELECT`.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
rg(0).wYear = 2025 : rg(0).wMonth = 8 : rg(0).wDay = 4
rg(1) = rg(0) : rg(1).wDay = 8
MonthCal.SetSelRange( hCtrl, @rg(0) )   ' a working week
```

Microsoft Learn: [MCM_SETSELRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setselrange)

### GetMaxSelCount

```freebasic
function GetMaxSelCount( byval hMonthCal as HWND ) as DWORD
```

**Returns** the most days the user can select at once: 1 for a control without
`MCS_MULTISELECT`.

**Example**

```freebasic
print "up to"; MonthCal.GetMaxSelCount( hCtrl ); " days"
```

Microsoft Learn: [MCM_GETMAXSELCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getmaxselcount)

### SetMaxSelCount

```freebasic
function SetMaxSelCount( byval hMonthCal as HWND, byval iMax as UINT ) as boolean
```

Sets the most days the user can select at once, in a `MCS_MULTISELECT` control.

**Returns** `true` on success; `false` for a control without `MCS_MULTISELECT`.

**Example**

```freebasic
MonthCal.SetMaxSelCount( hCtrl, 14 )
```

Microsoft Learn: [MCM_SETMAXSELCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setmaxselcount)

### GetRange

```freebasic
function GetRange( byval hMonthCal as HWND, byval rgst as SYSTEMTIME ptr ) as DWORD
```

Reads the earliest allowed date into `rgst[0]` and the latest into `rgst[1]`.

**Returns** which limits are set: `GDTR_MIN`, `GDTR_MAX`, both, or 0 for none.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
if MonthCal.GetRange( hCtrl, @rg(0) ) and GDTR_MAX then print "nothing after"; rg(1).wYear
```

Microsoft Learn: [MCM_GETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getrange)

### SetRange

```freebasic
function SetRange( byval hMonthCal as HWND, byval fWhichLimit as DWORD, byval rgst as SYSTEMTIME ptr ) as boolean
```

Sets the earliest (`rgst[0]`) and latest (`rgst[1]`) dates the user can reach. `fWhichLimit`
says which of the two are set: `GDTR_MIN`, `GDTR_MAX` or both; a limit left out is removed.

**Returns** `true` on success.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
rg(0).wYear = 2020 : rg(0).wMonth = 1 : rg(0).wDay = 1
rg(1).wYear = 2030 : rg(1).wMonth = 12 : rg(1).wDay = 31
MonthCal.SetRange( hCtrl, GDTR_MIN or GDTR_MAX, @rg(0) )
```

Microsoft Learn: [MCM_SETRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setrange)

### GetToday

```freebasic
function GetToday overload( byval hMonthCal as HWND, byval pst as SYSTEMTIME ptr ) as boolean
function GetToday overload( byval hMonthCal as HWND, byref st as SYSTEMTIME ) as boolean
function GetToday overload( byval hMonthCal as HWND ) as SYSTEMTIME
```

Reads the date the control circles as today: the system date, unless
[SetToday](#settoday) has changed it.

**Returns** `true` on success, or the date (third form).

**Example**

```freebasic
dim td as SYSTEMTIME = MonthCal.GetToday( hCtrl )
print "today is"; td.wDay; "/"; td.wMonth; "/"; td.wYear
```

Microsoft Learn: [MCM_GETTODAY](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-gettoday)

### SetToday

```freebasic
sub SetToday overload( byval hMonthCal as HWND, byval pst as SYSTEMTIME ptr )
sub SetToday overload( byval hMonthCal as HWND, byref st as SYSTEMTIME )
```

Makes the control treat another date as today. A `NULL` pointer goes back to the system date.

**Example**

```freebasic
dim st as SYSTEMTIME
st.wYear = 2025 : st.wMonth = 7 : st.wDay = 4
MonthCal.SetToday( hCtrl, st )
```

Microsoft Learn: [MCM_SETTODAY](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-settoday)

### GetMonthRange

```freebasic
function GetMonthRange( byval hMonthCal as HWND, byval gmr as DWORD, byval rgst as SYSTEMTIME ptr ) as long
```

Reads the first and last dates on display into the two-element array at `rgst`. With
`GMR_VISIBLE` only whole months count; with `GMR_DAYSTATE` the greyed days of the months before
and after count too, which is the span [SetDayState](#setdaystate) needs.

**Returns** the number of months the span covers: for one month on display, 1 with
`GMR_VISIBLE` and 3 with `GMR_DAYSTATE`.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME
print MonthCal.GetMonthRange( hCtrl, GMR_VISIBLE, @rg(0) ); " month(s) from"; rg(0).wMonth; " to"; rg(1).wMonth
```

Microsoft Learn: [MCM_GETMONTHRANGE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getmonthrange)

### GetFirstDayOfWeek

```freebasic
function GetFirstDayOfWeek( byval hMonthCal as HWND ) as DWORD
```

Returns the day shown in the first column, in the low word: 0 is Monday, 6 is Sunday. The high
word is nonzero when it differs from the user's locale setting.

**Returns** the day and the flag in one value.

**Example**

```freebasic
print "weeks start on day"; LOWORD( MonthCal.GetFirstDayOfWeek( hCtrl ) )
```

Microsoft Learn: [MCM_GETFIRSTDAYOFWEEK](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getfirstdayofweek)

### SetFirstDayOfWeek

```freebasic
function SetFirstDayOfWeek( byval hMonthCal as HWND, byval iDay as long ) as DWORD
```

Sets the day shown in the first column: 0 for Monday through 6 for Sunday, or -1 to follow the
locale.

**Returns** the previous day in the low word, and in the high word nonzero when that day
differed from the locale.

**Example**

```freebasic
MonthCal.SetFirstDayOfWeek( hCtrl, 0 )   ' Monday
```

Microsoft Learn: [MCM_SETFIRSTDAYOFWEEK](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setfirstdayofweek)

### GetMonthDelta

```freebasic
function GetMonthDelta( byval hMonthCal as HWND ) as long
```

**Returns** how many months the display moves when a scroll button is clicked; unless changed,
the number of months on display.

**Example**

```freebasic
print "scrolls by"; MonthCal.GetMonthDelta( hCtrl ); " month(s)"
```

Microsoft Learn: [MCM_GETMONTHDELTA](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getmonthdelta)

### SetMonthDelta

```freebasic
function SetMonthDelta( byval hMonthCal as HWND, byval iDelta as long ) as long
```

Sets how many months a scroll button moves the display; 0 goes back to the default.

**Returns** the previous setting, 0 when it was the default.

**Example**

```freebasic
MonthCal.SetMonthDelta( hCtrl, 3 )   ' a quarter at a time
```

Microsoft Learn: [MCM_SETMONTHDELTA](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setmonthdelta)

### GetColor

```freebasic
function GetColor( byval hMonthCal as HWND, byval iColor as long ) as COLORREF
```

Returns the colour of one part: `MCSC_BACKGROUND`, `MCSC_MONTHBK`, `MCSC_TEXT`,
`MCSC_TITLEBK`, `MCSC_TITLETEXT` or `MCSC_TRAILINGTEXT` (the days of the neighbouring months).

**Returns** the colour, or -1 on failure.

**Example**

```freebasic
print "title background: &h"; hex( MonthCal.GetColor( hCtrl, MCSC_TITLEBK ) )
```

Microsoft Learn: [MCM_GETCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcolor)

### SetColor

```freebasic
function SetColor( byval hMonthCal as HWND, byval iColor as long, byval clr as COLORREF ) as COLORREF
```

Sets the colour of one part, named as for [GetColor](#getcolor).

**Returns** the previous colour, or -1 on failure.

**Example**

```freebasic
MonthCal.SetColor( hCtrl, MCSC_MONTHBK, BGR( 255, 255, 224 ) )
```

Microsoft Learn: [MCM_SETCOLOR](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setcolor)

### SetDayState

```freebasic
function SetDayState( byval hMonthCal as HWND, byval cbds as long, byval rgds as MONTHDAYSTATE ptr ) as boolean
```

Sets which days are drawn bold, for a control with the `MCS_DAYSTATE` style. `rgds` is an array
of `cbds` `MONTHDAYSTATE` values, one per month of the `GMR_DAYSTATE` span of
[GetMonthRange](#getmonthrange); bit *n* of each value (bit 0 is day 1) makes that day bold.

**Returns** `true` on success; `false` for a control without `MCS_DAYSTATE`.

**Example**

```freebasic
dim rg(1) as SYSTEMTIME, ds(11) as MONTHDAYSTATE
dim n as long = MonthCal.GetMonthRange( hCtrl, GMR_DAYSTATE, @rg(0) )
ds(1) = ( 1 shl 0 ) or ( 1 shl 14 )   ' the 1st and 15th of the month on display
MonthCal.SetDayState( hCtrl, n, @ds(0) )
```

Microsoft Learn: [MCM_SETDAYSTATE](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setdaystate)

### HitTest

```freebasic
function HitTest overload( byval hMonthCal as HWND, byval pinfo as MCHITTESTINFO ptr ) as DWORD
function HitTest overload( byval hMonthCal as HWND, byref info as MCHITTESTINFO ) as DWORD
```

Finds which part of the control is at `pt`, in client coordinates. The function fills in
`cbSize`. When the point is on a day, `st` receives its date.

**Returns** an `MCHT_*` code, also stored in `uHit`: `MCHT_CALENDARDATE`, `MCHT_TITLEBTNNEXT`,
`MCHT_TODAYLINK`, `MCHT_NOWHERE` and so on.

**Example**

```freebasic
dim mhi as MCHITTESTINFO
GetCursorPos( @mhi.pt ) : ScreenToClient( hCtrl, @mhi.pt )
if MonthCal.HitTest( hCtrl, mhi ) = MCHT_CALENDARDATE then print "over day"; mhi.st.wDay
```

Microsoft Learn: [MCM_HITTEST](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-hittest)

### GetMinReqRect

```freebasic
function GetMinReqRect overload( byval hMonthCal as HWND, byval prc as RECT ptr ) as boolean
function GetMinReqRect overload( byval hMonthCal as HWND, byref rc as RECT ) as boolean
function GetMinReqRect overload( byval hMonthCal as HWND ) as ( long, long, long, long )
```

Reads the smallest rectangle that shows one whole month, "Today" line included; `left` and
`top` are 0, so `right` and `bottom` are the width and height. The size depends on the
control's font. The tuple form sets `GetLastError()` to 1 on success and 0 on failure.

**Returns** `true` on success, or the four edges.

**Example**

```freebasic
var (l, t, r, b) = MonthCal.GetMinReqRect( hCtrl )
SetWindowPos( hCtrl, NULL, 0, 0, r, b, SWP_NOMOVE or SWP_NOZORDER )
```

Microsoft Learn: [MCM_GETMINREQRECT](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getminreqrect)

### SizeRectToMin

```freebasic
function SizeRectToMin overload( byval hMonthCal as HWND, byval prc as RECT ptr ) as long
function SizeRectToMin overload( byval hMonthCal as HWND, byref rc as RECT ) as long
function SizeRectToMin overload( byval hMonthCal as HWND ) as ( long, long, long, long )
```

Works out how many whole months fit in the rectangle given and shrinks it, in place, to the
size those months need: a 600 × 220 rectangle becomes 457 × 172 (two months side by side) with
the default font. The tuple form starts from an empty rectangle and so returns the size of one
month; it sets `GetLastError()` to the control's reply.

**Returns** the control's reply; the result is the rectangle.

**Example**

```freebasic
dim rc as RECT
rc.right = 600 : rc.bottom = 220
MonthCal.SizeRectToMin( hCtrl, rc )
SetWindowPos( hCtrl, NULL, 0, 0, rc.right, rc.bottom, SWP_NOMOVE or SWP_NOZORDER )
```

Microsoft Learn: [MCM_SIZERECTTOMIN](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-sizerecttomin)

### GetMaxTodayWidth

```freebasic
function GetMaxTodayWidth( byval hMonthCal as HWND ) as DWORD
```

**Returns** the width in pixels of the "Today" line at the bottom of the control.

**Example**

```freebasic
print "today line:"; MonthCal.GetMaxTodayWidth( hCtrl ); " pixels"
```

Microsoft Learn: [MCM_GETMAXTODAYWIDTH](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getmaxtodaywidth)

### GetCalendarGridInfo

```freebasic
function GetCalendarGridInfo overload( byval hMonthCal as HWND, byval pInfo as MCGRIDINFO ptr ) as boolean
function GetCalendarGridInfo overload( byval hMonthCal as HWND, byref info as MCGRIDINFO ) as boolean
```

Reads the rectangle, dates or text of one part of the grid. Set `dwPart` (`MCGIP_CALENDAR`,
`MCGIP_CALENDARHEADER`, `MCGIP_CALENDARCELL`, `MCGIP_CALENDARCONTROL` …), `dwFlags`
(`MCGIF_RECT`, `MCGIF_DATE`, `MCGIF_NAME`) and, for a cell, `iCalendar`, `iRow` and `iCol`; the
function fills in `cbSize`.

**Returns** `true` on success.

**Example**

```freebasic
dim gi as MCGRIDINFO
gi.dwPart = MCGIP_CALENDARCONTROL : gi.dwFlags = MCGIF_RECT
if MonthCal.GetCalendarGridInfo( hCtrl, gi ) then print "grid:"; gi.rc.right; " x"; gi.rc.bottom
```

Microsoft Learn: [MCM_GETCALENDARGRIDINFO](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcalendargridinfo)

### GetCalendarBorder

```freebasic
function GetCalendarBorder( byval hMonthCal as HWND ) as DWORD
```

**Returns** the space around each month, in pixels; 4 unless changed.

**Example**

```freebasic
print "border:"; MonthCal.GetCalendarBorder( hCtrl )
```

Microsoft Learn: [MCM_GETCALENDARBORDER](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcalendarborder)

### SetCalendarBorder

```freebasic
sub SetCalendarBorder( byval hMonthCal as HWND, byval fset as boolean, byval xyborder as long )
```

With `fset` `true`, sets the space around each month to `xyborder` pixels; with `false`, goes
back to the default and ignores `xyborder`.

**Example**

```freebasic
MonthCal.SetCalendarBorder( hCtrl, true, 8 )
```

Microsoft Learn: [MCM_SETCALENDARBORDER](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setcalendarborder)

### GetCalendarCount

```freebasic
function GetCalendarCount( byval hMonthCal as HWND ) as DWORD
```

**Returns** the number of months on display, which grows when the control is made larger.

**Example**

```freebasic
print MonthCal.GetCalendarCount( hCtrl ); " month(s) shown"
```

Microsoft Learn: [MCM_GETCALENDARCOUNT](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcalendarcount)

### GetCurrentView

```freebasic
function GetCurrentView( byval hMonthCal as HWND ) as DWORD
```

**Returns** what the control shows: `MCMV_MONTH` (days, 0), `MCMV_YEAR` (months),
`MCMV_DECADE` (years) or `MCMV_CENTURY` (decades). Clicking the title moves up a level.

**Example**

```freebasic
if MonthCal.GetCurrentView( hCtrl ) <> MCMV_MONTH then MonthCal.SetCurrentView( hCtrl, MCMV_MONTH )
```

Microsoft Learn: [MCM_GETCURRENTVIEW](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcurrentview)

### SetCurrentView

```freebasic
function SetCurrentView( byval hMonthCal as HWND, byval dwNewView as DWORD ) as boolean
```

Switches the control to `MCMV_MONTH`, `MCMV_YEAR`, `MCMV_DECADE` or `MCMV_CENTURY`.

**Returns** `true` on success.

**Example**

```freebasic
MonthCal.SetCurrentView( hCtrl, MCMV_YEAR )   ' show the twelve months
```

Microsoft Learn: [MCM_SETCURRENTVIEW](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setcurrentview)

### GetCALID

```freebasic
function GetCALID( byval hMonthCal as HWND ) as CALID
```

**Returns** the calendar system the control uses, a `CAL_*` value: `CAL_GREGORIAN` (1) unless
changed.

**Example**

```freebasic
if MonthCal.GetCALID( hCtrl ) = CAL_GREGORIAN then print "Gregorian calendar"
```

Microsoft Learn: [MCM_GETCALID](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-getcalid)

### SetCALID

```freebasic
sub SetCALID( byval hMonthCal as HWND, byval calid as UINT )
```

Makes the control use another calendar system, a `CAL_*` value such as `CAL_JAPAN` or
`CAL_HIJRI`.

**Example**

```freebasic
MonthCal.SetCALID( hCtrl, CAL_GREGORIAN )
```

Microsoft Learn: [MCM_SETCALID](https://learn.microsoft.com/en-us/windows/win32/controls/mcm-setcalid)

## See also

- [sys/win/gui](SysWin-Gui)
- [DTP](SysWin-Gui-DTP), a date field that drops down a month calendar
- [CWindow](CWindow) for `AddControl( "MonthCal", ... )`
- [Window text and styles](SysWin-Window-Text-and-Styles) for `EnableVisualStyles`
- [gui macros and helpers](SysWin-Gui-Procedures) for reading `WM_NOTIFY`
